#!/bin/bash 
# server address: 
# IP_ADDR=`dig +short myip.opendns.com @resolver1.opendns.com`
IMAGE=jhsong/ldap_client:latest
ME=$(basename ${HOME})
CONTAINER=ldap_client-${ME}
DOCKER_HOME=/root
HOST_SCRATCH_DIR=${HOME}/.scratch
DOCKER_SCRATCH_DIR=${DOCKER_HOME}/.scratch
VOLUMNE_MAPS="-v ${HOST_SCRATCH_DIR}:${DOCKER_SCRATCH_DIR} -v `pwd`/share:${DOCKER_HOME}/share"
PORT_MAPS=-P 
OPT_BUILD=". -t ${IMAGE}"
OPT_START="--rm --name ${CONTAINER} ${PORT_MAPS} ${VOLUMNE_MAPS} ${IMAGE}"

build(){
    docker build ${OPT_BUILD} 
}

login(){
    docker exec -it ${CONTAINER} login
}

shell(){
    docker exec -it ${CONTAINER} bash 
}

jup(){
    if [ -e "host.txt" ]
    then
        hostipaddr=$(cat host.txt)
    else 
        hostipaddr="localhost"
    fi 
    jupaddr=$(cat share/logs/jupyterlab.log | grep -o http://.*:8888/?token=[a-z0-9]* | \
		head -1 | sed "s/0.0.0.0/${hostipaddr}/g")
    jupport=$(docker ps | grep --color ${CONTAINER} | \
		grep -o --color "[0-9]\+->8888\+" | sed "s/->8888//g") 
    addrport="$hostipaddr:$jupport"
    echo $jupaddr | sed "s/http.*8888\//http:\/\/${addrport}\/lab/"
}

start(){
    # mkdir -p ${HOST_SCRATCH_DIR}
    # exec docker run ${OPT_START} 
	docker run --env-file ./env-file -it --rm --name ${CONTAINER} ${IMAGE}
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
    jup) 
        jup 
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
			if [ $? -eq 0 ] 
			then 
				# rmc
				echo 		 
			fi 
        wait 
            start $FOREGROUND
        else 
            echo "build failed"
        fi 
        ;; 
    *)
        echo 
esac
