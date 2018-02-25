---
layout: default
permalink: datasets
description: from csv to elasticsearch
title: Datasets
width: is-10
---

# Connectors
Connectors are a declaration to a filesystem or database.

Supported connectors are:
- filesystem
- Elasticsearch
- PostGreSQL

SQLAlchemy is used for PostGreSQL and should could be any SQL connexion, but only PostGreSQL has at thebeen tested yet. 
See the [connectors roadmap](/roadmap#connectors) for support of other databases in the future.

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


# Datasets
Datasets are a file, a set of files, a table or an index within a connector.
```
datasets:
  my_dataset:
    connector: upload         # <===== upload, referential_datal, elasticsearch, postgres or any custom connector
    table: my_dataset
    chunk:                    # <===== override connector's default chunk
```



## filesystem datasets

### NO EXCEL NOR OPENDOCUMENT HERE ! 
Note that we'll probably never make the effort of dealing with excel (xls, xlsx) and opendocument (odt) formats, are too rich to be processed efficiently and stability. Even if formatting is cute, it is meaning-less in an automation world, where formatting has to be carried by metadatas, which have to be a data by themselves.

If you want to be serious about re-producing data transformation you have to forget about editing manually data without making it auditable, and self-certification is a wrong security pattern in a globally connected world.

So you'll have to make the half way to export your excel in csv, and know what's your business process to version your data. 

### CSV
Comma-separated files have been the classical I/O in opendata for many years. Even if it's quite a mess for data types, it is a go-between, between strongly structurated format like XML for IT specialists and the office excel-style.

If you're familiar with using many sources you now CSV is not standard and that most guesser can't guess all : spearator, encoding, escaping, etc. We didn't have time to build a top-of Pandas for guessing, and prefered to enable you to set manual options to handle all the cases.
>For robust and stable processing, we desactivated every guessing of types, so that every cell is string or unicode in input: type will be possible next within recipes. For the same reason, we didn't deal here with the `na_values` and keep_default_na is forced to `False`.

| option     |  default   |  other        |  objective                          |
|:-----------|:-----------|:--------------|:------------------------------------|
| sep        | ;          | *any regex*     | specify columns separator           |
| header     | infer      |false          | use included head                   |
| encoding   | utf8       | latin1 ...    | specify the encoding if not ascii   |
| names      |            |[col, names]   | replace header (column) names       |
| compression| infer      | None, gzip ...| specify if compressed               |
| skiprows   | 0          | *any number*    | skip n rows before processing       |

### Fwf
This is the old brother of the CSV, the fixed-width tabular is a variant, but in some cases this will be more stable to parse your tabular files as fixed width. Often Oracle or PostGreSQL exports are to be parsed like that.
> Like in csv, for robust and stable processing, we desactivated every guessing of types, so that every cell is string or unicode in input: type will be possible next within recipes. For the same reason, we didn't deal here with the `na_values` and keep_default_na is forced to `False`.

| option     |  default   |  other        |  objective                          |
|:-----------|:-----------|:--------------|:------------------------------------|
| encoding   | utf8       | latin1 ...    | specify the encoding if not ascii   |
| names      |            |[col, names]   | replace header (column) names       |
| width      | [1000]     |[2, 5, 1, ...] | columns width for the fixed format  |
| compression| infer      | None, gzip ...| specify if compressed               |
| skiprows   | 0          | *any number*    | skip n rows before processing       |

### msgpack
Well you may not be familiar with that format. This is a simple and quite robust format for backing up data when the data is typed. We could have choose HDFS (strong, but boring for integration, and being old), json/bson (quite slow), or pickle (too much instability with versions), or parquet (seducing, but the pandas library doesn't deal well with chunks).

### other formats
Please consult the [roadmap](/roadmap#files) to check future support for json, xml or any other type.

## elasticsearch datasets

| option     |  default   |  other        |  objective                          |
|:-----------|:-----------|:--------------|:------------------------------------|
| random_view| True       | False         | display random sample by default    |
| select     | {"query": {"match_all": ""} } | any es query | query for filtering index |
| doc_type   |*table name*| any string    | change document type name           |
| body       | {}         |*cf infra*     | settings and mappings               |
| max_tries  | 3          | *any integer*   | number of retries (with exponential backoff)             |
| thread_count|*connector value*| *any integer*  | number of threads for inserting       |
| timeout    | 10         | *time in seconds* | timeout for bulk indexing & reading |
| safe       | True       | False         | doesn't use `_id` field to index, which can lead to doubles when retrying |
| chunk_search|*connector value* | *any number*  | number of row for search queries when using fuzzy join |

The big challenge with elasticsearch datasets with scaling is the possibility of tunning. The `body` value is the equivalent of the `body` value when creating the index with curl, except it is written in `yaml` instead of `json`, which makes it easier to read.

Here is an example of configuration :
```
datasets:
  my_dataset:
    connector: elasticsearch
    table: my_dataset
    body: 
      settings:
        index.refresh_interval: 30s     # <==== disable the "instant" indexing, which speed up indexing
        index.number_of_replicas: 0     # <==== disable replicas, which speeds up indexing
        index.number_of_shards: 9       # <==== should be a multiple of your nodes number, and increased if large datasets
                                        #       a shard should have less that 1M docs
      mappings:
        agrippa:
          _all:                         # <==== disable "_all" fileds indexing, for speeding up
            enabled: False
          dynamic: False
          properties:                   # <==== specify here the fields only needed for fuzzy join 
            matchid_id:
              type: keyword
            matchid_name_match:
              type: text
            matchid_date_birth_str:
              type: keyword
            matchid_location_city:
              type: keyword
            matchid_location_country:
              type: keyword
```

For large clusters, you have to choose between low and large `number_of_replicas` for more robust indices.

## PostGreSQL

There is for now no specific option when using a PostGreSQL dataset.
