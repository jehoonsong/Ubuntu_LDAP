#!/bin/bash 
source $(dirname $0)/argparse.bash || exit 1
argparse "$@" <<EOF || exit 1
parser.add_argument('exec_mode', type=str, 
    help='build|start|stop|shell|update'
    )
parser.add_argument('-d', '--daemon', action='store_true',
    help='run with daemon mode? [default %(default)s]', 
    default=False
    )
EOF
if [[ $DAEMON ]]; then
	opt_start="-d"
fi
image=ubuntu_ldap:latest
me=$(basename ${HOME})
container=ubuntu_ldap-${me}
docker_home=/root
port_maps="-p 10022:22"
opt_build=". -t ${image}"
opt_start="$opt_start --name ${container} ${port_maps} --env-file env-file ${image}"

_build(){
    docker build ${opt_build} 
}

_login(){
    docker exec -it ${container} login
}

_shell(){
    docker exec -it ${container} bash 
}

_start(){
    docker run -it --rm ${opt_start} 
}

_stop(){
    docker stop ${container}
}

case "${EXEC_MODE}" in
    shell)
        _shell 
        ;; 
    login)
        _login 
        ;; 
    build)
        _build 
        ;;
    start)
        _start $DAEMON
        ;;
    stop)
        _stop
        ;;
    update)
        _build 
        if [ $? -eq 0 ] 
        then  
            echo "wait stoping ..."
            stop 
        wait 
            _start $DAEMON
        else 
            echo "build failed"
        fi 
        ;; 
    *)
        echo "what do you want?"
esac
