---
layout: default
permalink: starting
description: "run it with docker"
title: Starting matchID
width: is-10
---

# Starting a developpement matchID server

A laptop with >8Go configuration is recommended to have a first look at `matchID`. Good performance needs higher computation resources (the higher the better : 16-cores + 128Go will be 15x faster than a laptop, we tested up-scaling to 40-cores getting to 40x faster).

`matchID` uses `make` and `Docker` to accelerate the installation of dependencies. You'll first have to install Docker and `docker-compose`.

Then clone the project : 
```
git clone https://github.com/matchID-project/backend
```

If your host is not has not Docker on it, your should install it first (only tested with Ubuntu 16.04) :

```
make install-prerequisites
```

If you're running on other system (like MacOS) you should go to the official [Docker install page](https://docs.docker.com/install/), and don't forger to install [docker-compose](https://docs.docker.com/compose/install/) too. 

Now you can start the tutorial mode, which downloads, compiles necessary stuff, and launches the backend, frontend as well as elasticsearch :

```
make start
```

This may take some time, as this handles many actions :

- installing a 3-node elasticsearch cluster (if you need less, just edit `Makefile` and set `ES_NODE` to 1)
- installing `kibana` (optional, but can be useful)
- building the `python` backend, with all `pandas` and `scikit-learn` dependencies
- compiling the `Vue.js` frontend with `node` into static `html/css/js` files
- presenting all the stuff with `nginx`

Any problems ? Check the [troubleshooting](https://github.com/matchID-project/backend#frequent-running-problems) section.

Note that machine learning is not mandatory (you can have a real serious matching only based on rules) but recommended for reducing development time.

Now, you can go to your `matchID` server : 

- [http://localhost/matchID/](http://localhost/matchID/)

<img src="assets/images/frontend-start.png" alt="matchID projects view">
