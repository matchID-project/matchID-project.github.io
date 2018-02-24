---
layout: default
permalink: architecture
description: "understanding and troubleshooting"
title:  architecture
width: is-10
---

# architecture
## what does `make start` does
The `make start` may take some time, because handles many actions : 

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
<img class="column is-half is-narrow" src="assets/images/matchid_architecture.png" alt="matchID architecture">                                                                                                                             </div>

## troubleshooting
All commands here are to be executed from the machine where `docker` runs `matchID` (local or remote).

### stopping everything
To stop all components
```
make stop
```
### backend
- to stop the backend : `make backend-stop`
- to start the backend : `make backend`
- to restart the backend : `make backend-stop backend`
- to get the log : `docker logs -f matchid-backend`

### frontend
- to build only the frontend : `make docker-build`
- to stop the frontend : `make frontend-stop`
- to start the frontend : `make frontend`
- to restart the frontend : `make frontend-stop frontend` 
- to get the log : `docker logs -f matchid-backend`


### elasticsearch
Elasticsearch is useful for powerfull fuzzy match with levenshtein distance (but could be replace with a phonetic or ngram indexation with postgres) and required for now by the validation module.
- to stop elasticsearch : `make elasticsearch-stop`
- to start elasticsearch : `make elasticsearch`
- to restart elasticsearch : `make elasticsearch-stop elasticsearch`
- to check if you elasticsearch nodes containers are up : `docker ps | egrep 'matchid-(elasticsearch|esnode)'` - you should have a line for every container
- to get the log of a node : `docker logs -f matchid-elasticsearch` - you may replace `elasticsearch` with `esnode2`, `esnode3`, depending of the number of nodes you have
See [avanced elasticsearch troubleshooting](#avanced-elasticearch-troubleshooting)

To change the number of nodes: edit `Makefile` and change the number of nodes in `ES_NODES` (default to 3, tested up to 20)
To change the amount of memory of each node : change both `ES_MEM` (java memory) and `ES_MEMM` (docker memory, which should be twice the first)

## postgres
Postgres is not mandatory, so is not up on start. Postgres can be useful for a more reliable storage than elasticsearch, or to replace elasticsearch for quicker `ngram` matching.
- to start postgres : `make postgres`
- to stop postgres : `make postgres-stop`
- to restart postgres : `make postgres-stop postgres`

### kibana
Kibana has to be started on start (for a dependency of the nginx configuration). It can be useful to analyse your elasticsearch data, but is absolutely not mandatory (it will next not be a requirement).
- to stop kibana : `make kibana-stop`
- to start kibana : `make kibana`
- to restart kibana : `make kibana-stop kibana`

## docker troubleshooting
Some useful commands : 
- `docker stats` show all containers running, like a `top`

## developpement mode
You can switch to developpement mode without stopping the whole sevices : `make frontend-stop frontend-dev`
Your

## Advanced elasticsearch troubleshooting

### heath check from your server
- to check the status of the elasticsearch cluster : `docker exec -it matchid-elasticsearch curl -XGET localhost:9200/_cluster/health?pretty` - the `status` should be `green` and `number_of_nodes` to the `ES_NODES` value (default : 3)
- to check the status of your indices : `docker exec -it matchid-elasticsearch curl -XGET localhost:9200/_cat/indices` - each indice should be green.

### health check from your computer
Note that the API point of elasticsearch is accessible from any client (unless you protect this API with the nginx configuration) : `http://${matchID-host}/matchID/elastiscearch` is the same as `localhost:9200/` within `docker`. For example, if you run `matchID` on your host :
- cluster health : `curl -XGET http://localhost/matchID/elasticsearch/_cluster/health?pretty`
- indices : `curl -XGET http://localhost/matchID/elasticsearch/_cat/indices`

### my cluster is red
If you have large indices and multiples nodes, the coherence of cluster may take some time when you just started the cluster.
You can then check the indices health.
You should `make elasticsearch restart` if you



