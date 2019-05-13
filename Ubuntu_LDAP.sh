#!/bin/bash 
IMAGE=ubuntu_ldap:latest
ME=$(basename ${HOME})
CONTAINER=ubuntu_ldap-${ME}
DOCKER_HOME=/root
HOST_SCRATCH_DIR=${HOME}/.scratch
DOCKER_SCRATCH_DIR=${DOCKER_HOME}/.scratch

VOLUMNE_MAPS="-v ${HOST_SCRATCH_DIR}:${DOCKER_SCRATCH_DIR} \
	-v `pwd`/share:${DOCKER_HOME}/share"

PORT_MAPS="-p 2202:22"
OPT_BUILD=". -t ${IMAGE}"

OPT_START="-it --rm --name ${CONTAINER} ${PORT_MAPS} \
	${VOLUMNE_MAPS} ${IMAGE}"

build(){
    docker build ${OPT_BUILD} 
}

login(){
    docker exec -it ${CONTAINER} login
}

shell(){
    docker exec -it ${CONTAINER} bash 
}

start(){
    docker run --env-file ./env-file ${OPT_START} 
}

stop(){
    docker stop ${CONTAINER}
}

rmc(){
    docker rm ${CONTAINER}
}

source $(dirname $0)/argparse.bash || exit 1
argparse "$@" <<EOF || exit 1
parser.add_argument('exec_mode', type=str, 
    help='build|start|stop|shell|update'
    )
parser.add_argument('-f', '--foreground', 
    action='store_true',
    help='run with foreground mode? [default %(default)s]', 
    default=False
    )
EOF

case "${EXEC_MODE}" in

    shell)
        shell 
        ;; 
    login)
        login 
        ;; 
    build)
        build 
        ;;
    start)
        start $FOREGROUND
        ;;
    stop)
        stop
        ;;
    update)
        build 
        if [ $? -eq 0 ] 
        then  
            echo "wait stoping ..."
            stop 
        wait 
            start $FOREGROUND
        else 
            echo "build failed"
        fi 
        ;; 
    *)
        echo 
esac

