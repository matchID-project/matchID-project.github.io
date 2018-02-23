---
layout: default
permalink: datasets
description: from csv to elasticsearch
title: Datasets
width: is-10
---

# Connector
Connectors are a declaration to a filesystem or database.

Supported connectors are:
- filesystem
- Elasticsearch
- PostGreSQL

SQLAlchemy is used for PostGreSQL and should could be any SQL connexion, but only PostGreSQL has at thebeen tested yet. 
Next SQL databases to be tested: Vertica, MySQL.

Default connectors are included in the initial configuration (and can me modified or removed):
- `upload`: filesystem `upload/`, which is moreover connected to the upload api
- `referential_data`: filesystem `referential_data/`, used for referential data like french citycodes, countries, ...
- `models`: filesystem `models/`, used for storing machine learning kernels
- `elasticsearch`: connector to the elasticsearch provided with docker
- `postgres`: connector to the PostGreSQL provided with docker (you have to run `make postgres` from commandline to start the docker database)

To create other connectors, we didn't provide online editor for now, your have to add it manually in the `conf/connectors/connectors.yml`:
```
connectors:
  upload:
    type: filesystem
    database: upload/
    chunk: 2000                 # <==== default chunks size (number of rows) for reading and writing the datasets 
  referential_data:
    type: filesystem
    database: referential_data/
    chunk: 10000
  models:
    type: filesystem
    database: models/
  elasticsearch:
    type: elasticsearch
    host: elasticsearch        # <===== hostname of an elasticsearch node, can be an array for multiple data nodes for better performance
    port: 9200                 # <===== port of elasticsearch
    thread_count: 3            # <===== default number of threads for injecting data
    chunk: 500                 # <===== default number of row for read and write
    chunk_search: 20           # <===== default number of rows for bulk search
  postgres:
    type: sql    
    uri: postgres://user:password@postgres:5432 # <==== URI for SQL Alchemy 
    chunk: 2000
```


# Dataset



