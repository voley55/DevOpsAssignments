import re, telnetlib

_stat_regex = re.compile(ur"STAT (.*) (.*)\r")

def command(client, cmd):
    ' Write a command to telnet and return the response '
    client.write("%s\n" % cmd)
    return client.read_until('END')


def stats(client):
    ' Return a dict containing memcached stats '
    return dict(_stat_regex.findall(command(client, 'stats')))


def telnet_memcached(host, port):
    '''Telnet connection on memcached service port '''
    telnet_client = telnetlib.Telnet(host = host, port = port)
    return telnet_client

if __name__ == '__main__':
    host = '127.0.0.1'
    port = '11211'
    client = telnet_memcached(host, port)
    print stats(client)
