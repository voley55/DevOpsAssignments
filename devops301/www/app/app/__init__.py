from flask import Flask
import json
import memcache

app = Flask(__name__)

host = '127.0.0.1'
port = '11211'

def get_percentage(num, den):
    try:
        ans  = float(num)/float(den)*100
    except ZeroDivisionError:
        ans = 0.0
    return ans

@app.route('/app')
def index():
    client = memcache.telnet_memcached(host, port)
    response = memcache.stats(client)
    output = {}
    metric_list = [ 'pid', 'uptime', 'rusage_user', 'rusage_system', 'curr_connections', 'total_connections', 'cmd_get', 'cmd_set', 'get_hits', 'get_misses', 'bytes_read', 'bytes_written', 'limit_maxbytes', 'accepting_conns', 'listen_disabled_num', 'threads', 'conn_yields', 'hash_bytes', 'bytes', 'curr_items', 'total_items']
    for key, value in response.items():
        if key in metric_list:
            output[key] = value

    hit_rate = get_percentage(response.get('get_hits',0),response.get('cmd_get',1))
    memory_usage = get_percentage(response.get('bytes',0),response.get('limit_maxbytes',1))
    output['memory_percentage_used'] = str(memory_usage) + "%"
    output['memcache_hit_rate'] = str(hit_rate) + "%"
    return json.dumps(output)


def main():
    app.run(host="0.0.0.0", port = 5000, debug = True)

if __name__=="__main__":
    main()
