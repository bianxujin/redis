#!/bin/bash


DIR=$(cd "$(dirname "$0")";pwd)

. $DIR/base_info.sh



REDIS_INST=""
REDIS_CLI="$REDIS_HOME/src/redis-cli"
#Redis 5.0以下的版本是用的ruby
#REDIS_CLI="$REDIS_HOME/redis-3.2.9/src/redis-trib.rb" 


for HOST in `cat $HOST_FILE`
do
        for ((i=0; i<NUM_OF_NODES; i++))
        do
                if [ "$i" -eq "0" ]; then
                firt_port=$((START_PORT + i))
                fi
                CUR_PORT=$((START_PORT + i))
                REDIS_INST=$REDIS_INST" $HOST:$CUR_PORT"
        done

done
echo "join node...." $REDIS_INST
echo "yes" |  $REDIS_CLI -c -h ${LOCAL_IP} -p ${firt_port}  -a ${AUTH} --cluster create $REDIS_INST --cluster-replicas 1 
#redis 3.x版本，通过redis-trib.rb工具创建集群
# echo "yes" |  $REDIS_CLI   -c -h ${LOCAL_IP} -p ${firt_port}    create  --replicas 1  $REDIS_INST 
echo "Cluster started"
