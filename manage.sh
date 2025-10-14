#!/bin/bash

set -euo pipefail

NODES=(
"node0"
"node1"
"node2"
)

DOCKERSS=("${NODES[@]}" "my-jenkins")
REGISTRY_ADDR="registry:5000"

function main() {
    case ${1:-} in
        help | --help) help;;
        loginreg) login_registry;;
        joinsw) join_swarm;;
    esac
}

function commander() {
    docker compose -f docker-compose.yml exec -it "$@"
}

function login_registry() {
    local $(cat ./.env | grep -v "^#" | grep "^.*=" | xargs)
    local LOGIN_COMMAND="echo $REG_PASS | docker login $REGISTRY_ADDR --username $REG_USER --password-stdin"
    for DOCKERS in ${DOCKERSS[@]}; do
        commander $DOCKERS sh -c "$LOGIN_COMMAND"
    done
}

function join_swarm() {
    local COMMAND
    for NODE in ${NODES[@]}; do
        if [[ $NODE == ${NODES[0]} ]]; then
            commander $NODE "docker swarm init"     
            TOKEN=$(commander $NODE docker swarm join-token -q worker)      
        else
            commander $NODE docker swarm join --token $TOKEN ${NODES[0]}:2377
        fi
    done
}


function help() {
    printf "Usage manage.sh [COMMAND]\n\n"
    printf "  %-12s %s\n" "--help, help" "print this help"
    printf "  %-12s %s\n" "loginreg" "all nodes login to the local registry"
    printf "  %-12s %s\n" "joinsw" "init swarm and join all nodes"
}

main $@