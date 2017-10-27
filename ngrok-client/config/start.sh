#!/bin/sh

if [ "${NGROK_HTTP_PORT}" == "80" ]; then
    ./ngrok -config=config.yml -hostname=${NGROK_TUNNEL_ADDRESS} ${NGROK_TARGET_ADDRESS}
else
    ./ngrok -config=config.yml -hostname=${NGROK_TUNNEL_ADDRESS}:${NGROK_HTTP_PORT} ${NGROK_TARGET_ADDRESS}
fi