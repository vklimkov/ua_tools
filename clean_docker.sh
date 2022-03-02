args="$(docker ps -a -q)"
if [ ! -z "$args" ]; then
    docker stop $args
    docker rm $args
fi
