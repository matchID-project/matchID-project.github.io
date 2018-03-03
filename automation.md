---
layout: default
permalink: automation
description: "understanding and troubleshooting"
title:  Automation
width: is-10
---

# architecture

## what does `make start` do? 

`make start` may take some time, because it handles multiple actions : 

- building
  - downloading docker images of all bundled components (`node`,`nginx`,`python`,`elasticsearch`,`kibana`)
  - compiling the `Vue.js` frontend with `node` into static `html/css/js` files
  - building the `python` backend, with all `pandas` and `scikit-learn` dependencies
- running
  - `python` backend
  - a 3-node `elasticsearch` cluster (if you need less, just edit `Makefile` and set `ES_NODE` to 1)
  -  `kibana` (required for launching it for now)
  - `nginx` for serving stating compile frontend, and reverse proxy of the backend, `elasticsearch` and `kibana`

Here is the architecture overview :

<div class="columns is-centered">
<figure class="image alpha-png-background">
<img class="column is-half is-narrow" src="assets/images/matchid_architecture.png" alt="matchID architecture">  
</figure>
</div>

## troubleshooting

All commands here have to be executed from the machine where `docker` runs `matchID` (local or remote).

### stopping everything

To stop all components

```
make stop
```
### backend

- stop the backend : `make backend-stop`
- start the backend : `make backend`
- restart the backend : `make backend-stop backend`
- get the logs : `docker logs -f matchid-backend`

### frontend

- build only the frontend : `make docker-build`
- stop the frontend : `make frontend-stop`
- start the frontend : `make frontend`
- restart the frontend : `make frontend-stop frontend` 
- get the logs : `docker logs -f matchid-backend`


### elasticsearch

Elasticsearch is useful for powerfull fuzzy matching with levenshtein distance (but could be replaced with a phonetic or ngram indexation with postgres) and is required for now by the validation module.

- stop elasticsearch : `make elasticsearch-stop`
- start elasticsearch : `make elasticsearch`
- restart elasticsearch : `make elasticsearch-stop elasticsearch`
- check if you elasticsearch nodes containers are up : `docker ps | egrep 'matchid-(elasticsearch|esnode)'`, you should have a line for every container
- get the logs of a node : `docker logs -f matchid-elasticsearch`, you may replace `elasticsearch` with `esnode2`, `esnode3`, depending of the number of nodes you have

See [avanced elasticsearch troubleshooting](#advanced-elasticsearch-troubleshooting) for configuring your cluster and more about elasticsearch and docker.


## postgres

Postgres is not mandatory, so it is not `up` when you start. Postgres can be useful for a more reliable storage than elasticsearch, or to replace elasticsearch for quicker `ngram` matching.

- start postgres : `make postgres`
- stop postgres : `make postgres-stop`
- restart postgres : `make postgres-stop postgres`

### kibana

Kibana has to be started on start (for a dependency of the nginx configuration). It can be useful to analyse your elasticsearch data, but is absolutely not mandatory (it will next not be a requirement).

- stop kibana : `make kibana-stop`
- start kibana : `make kibana`
- restart kibana : `make kibana-stop kibana`

## docker troubleshooting

Some useful commands : 

- `docker stats` shows all containers running, like a `top`

## developpement mode

You can switch to developpement mode without stopping the whole sevices : `make frontend-stop frontend-dev`

Please consult [contributing to developement](/dev).

## Advanced elasticsearch troubleshooting
### docker and elasticsearch

When your run make start or make elasticsearch, the configuration of elasticsearch is created in docker-components/docker-compose-elasticsearch-huge.yml with one master and ES_NODES-1 nodes.

To change the configuration :

- to change the number of nodes: edit Makefile and change the number of nodes in `ES_NODES` (default to 3, tested up to 20).
- to change the amount of memory of each node : change `ES_MEM` (java memory).

We've encountered stability problems with elasticsearch, docker and memory limitation (`mem_limit`). Elasticsearch recommends twice the memory of the `jvm` for the virtual machine memory. But setting hard memory limit with `mem_limit` seems to be a wrong with the docker virtualisation. So we supressed this limiation, which may lead to performance problem when strong sollicitation. This problem will be followed in the matchID project, as elasticsearch is an essential component.

### bulk indexing & matching : optmization

*to be completed*

### heath check from your server

- to check the status of the elasticsearch cluster : `docker exec -it matchid-elasticsearch curl -XGET localhost:9200/_cluster/health?pretty`,  the `status` should be `green` and `number_of_nodes` to the `ES_NODES` value (default : 3)
- to check the status of your indices : `docker exec -it matchid-elasticsearch curl -XGET localhost:9200/_cat/indices`, each indice should be green.

### health check from your computer

Note that the API point of elasticsearch is accessible from any client (unless you protect this API with the nginx configuration) : `http://${matchID-host}/matchID/elastiscearch` is the same as `localhost:9200/` within `docker`. For example, if you run `matchID` on your host :

- cluster health : `curl -XGET http://localhost/matchID/elasticsearch/_cluster/health?pretty`
- indices : `curl -XGET http://localhost/matchID/elasticsearch/_cat/indices`

### my cluster is red

If you have large indices and multiples nodes, the coherence of your cluster may take some time when you just started the cluster. You can then check the health indices.

If your cluster is red for some time (more than one minute) you should `make elasticsearch restart`.

If it is still red, check the `docker logs -f` of each node.

Many problems can occure :

- rights on the volume are not correct
- the volume space is over 85% full
- every indices are red because too much operations were driven in an inconsistant state of the cluster. This is the drama situation where you'll have to clear all your indices with a `curl -XDELETE http://localhost/matchID/elasticsearch/*` and **lose all indexed data**

### my cluster is yellow

It may be that one or many indices are red or at least one yellow. It may take some time but usually, elasticsearch self repairs.

With a persistent yellow state of an indice and the right amount of documents, you will still be able to access your data so that you may backup. You should do that with a recipe doing nothing from the dataset of your index to a `msgpack` dataset. Then try to restore it on another index, then delete the index.

You may have to delete every red and yellow indices.







