#!/bin/bash
PUBLISH_PORT='-p 6801:6801 -p 8000:8000 -p 5001:5001 -p 5011:5011 -p 5021:5021 -p 5031:5031 -p 5041:5041 -p 5051:5051'
BIND_VOLUME='-v /opt/aelf-node:/opt/aelf-node -v /opt/aelf-node/keys:/root/.local/share/aelf/keys'
CONfIGURE_PATH='/opt/aelf-node'
CONfIGURE_DUMP='--ulimit core=-1 --security-opt seccomp=unconfined --privileged=true'

IMAGE=$2
if [ -z $2 ]; then
    IMAGE='aelf/node:testnet-v1.0.0'
fi
set -e
start() {
    docker run --name aelf-node --restart=always -itd $PUBLISH_PORT $BIND_VOLUME -w $CONfIGURE_PATH $CONfIGURE_DUMP $IMAGE dotnet /app/AElf.Launcher.dll
    [ $? -eq 0 ] && echo "start successful "
}
stop() {
    p=$(docker ps -a -q| wc -l)
    [ $p -ge 1 ] && docker rm -f aelf-node || echo "Node not started";exit 1
    [ $? -eq 0 ] && echo "stop successful "
}
case "$1" in
    start)
        start
    ;;
    stop)
        stop
    ;;
    restart)
        stop
    start
    ;;
    *)
    echo $"Usage: $0 {start|stop|restart}"
    ;;
esac
exit 0