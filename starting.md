---
layout: default
permalink: starting
description: "run it with docker"
title: Starting matchID
width: is-10
---

# Starting a development matchID server

A laptop with >8Go configuration is recommended to have a first look at `matchID`. Good performance needs higher computational resources (the higher the better : 16-cores + 128Go will be 15x faster than a laptop, we tested up-scaling to 40-cores getting to 40x faster).

`matchID` uses `make` and `Docker` to accelerate the installation of dependencies. You'll first have to install `Docker` and `docker-compose`.

Clone the project : 

```
git clone https://github.com/matchID-project/backend
```

If your host does not have Docker on it yet, your should install it first (only tested with Ubuntu 16.04) :

```
make install-prerequisites
```

If you're running on other systems (like MacOS) you should go to the official [Docker install page](https://docs.docker.com/install/), and don't forget to install [`docker-compose`](https://docs.docker.com/compose/install/) too. 

Note: when working in a private network you'll have to pass proxies. If you're behind a reverse proxy, you may have to declare them in your `ENV`:  

```
export http_proxy=http://10.23.15.33:3128
export https_proxy=https://10.23.15.33:3128
```

Don't forget to configure your host technologies (`apt | apk | yum & docker`). 

Now you can start the tutorial mode which downloads, compiles necessary stuff, and launches the backend, frontend as well as elasticsearch :

```
make start
```

This may take some time as this handles multiple actions. See the [architecture](troubleshooting#architecture) to discover more about the components.

Any problems ? Check the [troubleshooting](troubleshooting) section.

Now, you can go to your `matchID` server : 

- [http://localhost/matchID/](http://localhost/matchID/)

<img src="assets/images/frontend-start.png" alt="matchID projects view">

