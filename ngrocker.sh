#!/bin/bash

ENV_FILE=".env"
BIN_PATH=$(cd ~ && pwd)/bin/
ORIGINAL_SCRIPT=$(pwd)/ngrocker.sh
SYMBOLIC_SCRIPT=$BIN_PATH/ngrocker

PRIMARY_HTTP_TUNNEL_PORT=80
SECONDARY_HTTP_TUNNEL_PORT=81

ENV_S_HTTP="NGROK_HTTP_PORT"
ENV_N_NAME="NGROK_NETWORK_NAME"
ENV_T_ADDR="NGROK_TARGET_ADDRESS"
ENV_U_ADDR="NGROK_TUNNEL_ADDRESS"

CLIENT_NETWORK_NAME=ngrok-client

TUNNEL_PORT=$PRIMARY_HTTP_TUNNEL_PORT
TUNNEL_ADDRESS="localhost"

C_GREEN='\033[32m'
C_YELLOW='\033[33m'
C_RED='\033[31m'
C_CYAN='\033[36m'
C_NULL='\033[0m'

function println
{
	local COLOR=$1
	local TEXT=${@:2}
	echo -e "${COLOR}${TEXT}${C_NULL}"
}

function set-env {
    sed -i "s|$1=[^\n]*|$1=$2|g" $ENV_FILE
}

function configure-help {
    echo "NOTHING"
    exit -1
}

function config-container {
    set-env "NGROK_TARGET_ADDRESS" "$1:$2"
    set-env "NGROK_NETWORK_NAME" $CLIENT_NETWORK_NAME
    docker network create $CLIENT_NETWORK_NAME
    docker network connect $CLIENT_NETWORK_NAME $1
}

function get-ip {
    host $1 | awk '/has address/ { print $4 }'
}

function config-host {
    ip=$(get-ip $1)
    [ ! $ip ] && ip=$1
    set-env "NGROK_TARGET_ADDRESS" $ip:$2
}

function config-tunnel {
    set-env "NGROK_TUNNEL_ADDRESS" $1
    set-env "NGROK_HTTP_PORT" $2
}

function main {
    [ $# = 0 ] && configure-help

    local C_OPTION=false # CONTAINER
    local H_OPTION=false # HOST
    local T_OPTION=false # TUNNEL ADDRESS
    local F_OPTION=false # FORCE TUNNEL PORT
    local P_OPTION=80    # TARGET PORT

    while getopts c:h:p:t:f:s OPTION; do
		case "${OPTION}" in
			c) 
                C_OPTION=$OPTARG
                ;;
            h) 
                H_OPTION=$OPTARG
                ;;
            p)
                P_OPTION=$OPTARG
                ;;
            t) 
                TUNNEL_ADDRESS=$OPTARG
                ;;
            f)
                F_OPTION=$OPTARG
                ;;
            s) 
                mkdir -p $BIN_PATH
                ln -s $ORIGINAL_SCRIPT $SYMBOLIC_SCRIPT
                exit 0
                ;;
			*) configure-help
		esac
	done

    [ $C_OPTION != false ] && config-container $C_OPTION $P_OPTION    
    [ $H_OPTION != false ] && config-host $H_OPTION $P_OPTION

    [ $P_OPTION == 80 ] && TUNNEL_PORT=$SECONDARY_HTTP_TUNNEL_PORT

    [ $F_OPTION != false ] && TUNNEL_PORT=$F_OPTION

    config-tunnel $TUNNEL_ADDRESS $TUNNEL_PORT

    docker-compose up -d
    echo
    echo
    println $C_YELLOW "Tunnel Address:"
    println $C_GREEN "\t$TUNNEL_ADDRESS:$TUNNEL_PORT"
    echo
    println $C_YELLOW "Inspector Address:"
    println $C_GREEN "\t$TUNNEL_ADDRESS:4040"
    echo
    echo
}

main $*