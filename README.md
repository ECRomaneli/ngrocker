# ngrocker - The simplest way to run ngrok locally

The ngrocker, is a docker project using docker-compose and [source code of ngrok 1.x](https://github.com/magicred7/ngrok/) to easily run the ngrok-server and ngrok-client. <br/>
The images of this project together has less of **35 MB**.

<strong style="color: orange">The focus of this project is the ngrok sniffer tool with locally HTTP tunnels.</strong>

## Features
- **Small**, it uses alpine image and multi-stage build;
- **Simple**, this project was made to be easy as the original ngrok server;
- **Sniffer**, the focus of this project is the ngrok sniffer tool, so the updates will focus on improving it. Some improvements are already available, like requests search and colored methods and status.

## How to use
First, you need clone this repository on your machine:

    git clone https://github.com/magicred7/ngrocker.git

Now, go into you repository folder and create a `.env` file. If you want, you can just clone the `.env-example` file and change the name: <br/>

    $ cd ngrocker
    $ mv .env-example .env

Now, just run your docker-compose:

    $ docker-compose up -d

If you want run just the ngrok server, execute:

    $ docker-compose up -d ngrok-server

Now you have the ngrok-server and ngrok-client (if you want), running into your machine!

## Configuration

Exists two ways to use the ngrocker.

### The first way,
is making a tunnel of other container. To make this, you need define a docker network (or using a pre-defined network) and use the container hostname or your ip, to make an internal tunnel. After this, the defined http port going show the container content. The tunnel will be working.<br/>

### Very difficult? No!<br/>
You just need create a docker network (or use one) and configure the other container to use them. On the ngrok, you just modify your .env file like this:

    NGROK_NETWORK_NAME= <shared_network_name>
    NGROK_TARGET_ADDRESS= <container_hostname>:<container_port>
    NGROK_TUNNEL_ADDRESS= <tunnel_address>

Example:<br/>
If you want create a [Laradock](https://github.com/laradock/laradock) Nginx's tunnel, the [Laradock Project](https://github.com/laradock/laradock), already make a network called laradock_frontend. Just use it, the hostname of the nginx (called nginx too) and the http port:

    NGROK_HTTP_PORT=81

    NGROK_NETWORK_NAME=laradock_frontend
    NGROK_TARGET_ADDRESS=nginx:80
    NGROK_TUNNEL_ADDRESS=localhost

I changed the ngrok's http port to 81, because the nginx are running into this port too.
The tunnel address can be other address configured into nginx too.

Now you can access then, into your host machine with address `localhost:81`.

### The second way,
is configuring the client to make a host tunnel. The configuration is the same, but where you set the hostname of the docker container, you will put the IP address of your host.<br/>
Example, if your IP is `172.26.0.2`:

    NGROK_HTTP_PORT=81

    NGROK_TARGET_ADDRESS=172.26.0.2:80
    NGROK_TUNNEL_ADDRESS=localhost

But, if you want use modified names, then use the DNS to define the server will resolve this names:

    NGROK_HTTP_PORT=80

    NGROK_NETWORK_DNS=172.26.0.1
    NGROK_TARGET_ADDRESS=my-resolved-name.com:80
    NGROK_TUNNEL_ADDRESS=localhost

Now you can access then, into your host machine with address `localhost:80`.

**IMPORTANT:** If you change the `.env` file, you must restart the containers for the new settings to work.

## Nginx Configured Names

If you want use nginx, just set the name of website into `NGROK_TUNNEL_ADDRESS`:

    NGROK_TUNNEL_ADDRESS=my-local-website.com

After this, access this site with the ngrok's http port, like `my-local-website.com:81`.

## Default Ports
- **4443**, to ngrok server;
- **443**, to https tunnel (disabled, still does not work);
- **80**, to http tunnel;
- **4040**, to ngrok inspector;

## Related

- [ngrok 1.x fork](https://github.com/magicred7/ngrok) The images of this project uses this. All updates focus improvements on sniffer tool;
- [ngrok 1.x original](https://github.com/inconshreveable/ngrok) The original repository.

## Author

- Created and maintained by [Emerson C. Romaneli](https://github.com/magicred7) (@magicred7).

## Special thanks

- [@mateusvtt](https://github.com/mateusvtt) For helping with docker;
- [@inconshreveable](https://github.com/inconshreveable) For sharing the code of ngrok 1.x.

## Helpful pages

- [Developer's guide to ngrok](https://github.com/magicred7/ngrok/blob/master/docs/DEVELOPMENT.md)
- [Install Docker Compose](https://docs.docker.com/compose/install/)
- [Docker container networking](https://docs.docker.com/engine/userguide/networking/#default-networks)

## Cautions

This project (ngrocker) **dont** focus security, please dont use this for this purpose.

ngrok's original repository message:

**DO NOT RUN THIS VERSION OF NGROK (1.X) IN PRODUCTION**. Both the client and server are known to have serious reliability issues including memory and file descriptor leaks as well as crashes. There is also no HA story as the server is a SPOF. You are advised to run 2.0 for any production quality system. 

## License

[MIT License](https://github.com/laradock/laradock/blob/master/LICENSE)