## Requirement:
- docker (brew install docker)
- docker-compose (brew install docker-compose)

## Aim :
To understand the operational issues related to redis and troubleshoot them.

## Problem statement 1:  
You are a DevOps Ninja of your team. One fine day, when you were busy 
automating some cool stuff, a developer from your team turns up complaining about writes failing on his redis 
instance. Help him fix the issue quickly, so that you can get going with your work.  

**Setup**:  
Run the following command to get the infra up and running:  
`cd  redis101 && sudo docker-compose -f ./docker-compose.yaml up -d slave`  
Above command creates a master-slave topology of redis running on port 6379 and 6380, respectively.  

**Hint 1**: Set a temporary key on master and read the same from slave, to ensure redis topology is working fine.  
Example: redis-cli -p 6379 set ping pong and redis-cli get ping  

**Hint 2**: Follow redis logs to find the issue  

**Hint 3**: `stop-writes-on-bgsave-error` is not suppose to be disabled, read it's definition carefully to find a 
substitute solution.  


## Problem statement 2:     
Impressive !! But this doesn't end here, the same guy comes back and this time his application is failing to find
the keys on the slave which are present on the master. Help him debug the issue.  

**Setup:**  
Run the following commands to get the app up and running:  
`sudo docker-compose -f ./docker-compose.yaml up -d app`  
Above command starts the app. App simply sets a key on master, and look for the same key on slave. App's writer 
and reader function logs to /code/redis_writer.log and /code/redis_reader.log  

**Hint**: See the reader function logs for the error.  

## Important docker-compose commands:  

1.  To execute a command inside docker container:    
`$ docker-compose exec <service_name> <command>`  
Example: `$ docker-compose exec master tail -f /data/redis/redis_6379.log`   
2. To stop a service  
`$ docker-compose stop <service_name>`  
3. To remove containers of a service      
`$ docker-compose rm <service_name>`  
