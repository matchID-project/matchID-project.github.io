---
layout: default
permalink: datasets
description: from csv to elasticsearch
title: Datasets
image: Database.svg
width: is-10
---

<div markdown="1">
## Connectors
Connectors are a declaration to a filesystem or database.

Supported connectors are:

- filesystem
- Elasticsearch
- PostGreSQL

SQLAlchemy is used for PostGreSQL and should could be any SQL connexion, but only PostGreSQL has at been tested yet.
See the [connectors roadmap](/roadmap#connectors) for support of other databases in the future.

Default connectors are included in the initial configuration (and can me modified or removed):

- `upload`: filesystem `upload/`, which is connected to the upload api
- `referential_data`: filesystem `referential_data/`, used for referential data like french citycodes, countries, ...
- `models`: filesystem `models/`, used for storing machine learning kernels
- `elasticsearch`: connector to the elasticsearch provided with docker
- `postgres`: connector to the PostGreSQL provided with docker (you have to run `make postgres` from commandline to start the docker database)

To create other connectors, we haven't provided an online editor for now, your have to add it manually in the `conf/connectors/connectors.yml`:
</div>
<div class="rf-highlight" markdown="1">
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
</div>
<div markdown="1">

## Datasets

Datasets are a file, a set of files, a table or an index within a connector.
</div>
<div class="rf-highlight" markdown="1">
```
datasets:
  my_dataset:
    connector: upload         # <===== upload, referential_datal, elasticsearch, postgres or any custom connector
    table: my_dataset
    chunk:                    # <===== override connector's default chunk
```
</div>
<div markdown="1">


### filesystem datasets

#### NO EXCEL NOR OPENDOCUMENT HERE !

Note that we'll probably never make the effort of dealing with excel (xls, xlsx) and opendocument (odt) formats as they are too rich to be processed efficiently and with stability. Even if formatting is cute, it is meaning-less in an automation world, where formatting has to be carried by metadatas, which have to be data by themselves.

If you want to be serious about re-producing data transformation you have to forget about editing manually data without making it auditable, and self-certification is a wrong security pattern in a globally connected world.

So you'll have to meet us half way and export your excel files in csv, and know what is your business process to version your data.

#### CSV

Comma-separated files have been the classical I/O in opendata for many years. Even if it's quite a mess for data types, it is a go-between, between strongly structured format like XML for IT specialists and the mainstream office excel-style.

If you're familiar with using many sources you know CSV is not standard and that most guesser can't guess all : separator, encoding, escaping, etc. We didn't have time to build a top-of `Pandas` for guessing, and prefered to enable you to set manual options to handle all the cases.

>For robust and stable processing, we desactivated every guessing of types, so every cell is string or unicode in input: casting data types will be possible next within recipes. For the same reason, we didn't deal here with the `na_values` and keep_default_na is forced to `False`.

</div>
<div style="width:calc(100vw - 2rem);overflow-x:scroll">
<div class="rf-table rf-table--scroll" markdown="1">

| option     |  default   |  other        |  objective                          |
|:-----------|:-----------|:--------------|:------------------------------------|
| sep        | ;          | *any regex*   | specify columns separator           |
| header     | infer      |false          | use included head                   |
| encoding   | utf8       | latin1 ...    | specify the encoding if not ascii   |
| names      |            |[col, names]   | replace header (column) names       |
| compression| infer      | None, gzip ...| specify if compressed               |
| skiprows   | 0          | *any number*  | skip n rows before processing       |

</div>
</div>
<div markdown="1">

#### Fwf

This is the old brother of the CSV, the fixed-width tabular is a variant, but in some cases this will be more stable to parse your tabular files as fixed width. Often Oracle or PostGreSQL exports are to be parsed like that.

Like in csv, for robust and stable processing, we desactivated every guessing of types, so that every cell is string or unicode in input: casting data types will be possible next within recipes. For the same reason, we didn't deal here with the `na_values` and keep_default_na is forced to `False`.

</div>
<div style="width:calc(100vw - 2rem);overflow-x:scroll">
<div class="rf-table rf-table--scroll" markdown="1">

| option     |  default   |  other        |  objective                          |
|:-----------|:-----------|:--------------|:------------------------------------|
| encoding   | utf8       | latin1 ...    | specify the encoding if not ascii   |
| names      |            |[col, names]   | replace header (column) names       |
| width      | [1000]     |[2, 5, 1, ...] | columns width for the fixed format  |
| compression| infer      | None, gzip ...| specify if compressed               |
| skiprows   | 0          | *any number*  | skip n rows before processing     |

</div>
</div>
<div markdown="1">
#### msgpack

Well you may not be familiar with that format. This is a simple and quite robust format for backing up data when the data is typed. We could have chosen HDFS (strong, but boring for integration, and ageing), json/bson (quite slow), or pickle (too much instability between versions), or parquet (seducing, but the pandas library doesn't deal well with chunks).

#### other formats

Check the [roadmap](/roadmap#files) about future support for json, xml or any other type.

### (PostGre)SQL

There is no specific option when using a (PostGre)SQL dataset at the moment.

### elasticsearch

</div>

<div style="width:calc(100vw - 2rem);overflow-x:scroll!important">
<div class="rf-table rf-table--scroll" markdown="1">

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

</div>
</div>

<div markdown="1">
#### index settings, mapping

The big challenge with elasticsearch datasets and scaling is the tuning possibilities. The `body` value is the equivalent of the `body` value when creating the index with curl, except it is written in `yaml` instead of `json`, which makes it easier to read.

Here is an example of configuration :
</div>
<div class="rf-highlight" markdown="1">
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
</div>
<div markdown="1">
For large clusters, you have to choose between low and large `number_of_replicas` for more robust indices.
The body setting can be used for specific indexing and parsing, like `ngrams` and phonetics.

#### Validations options

Elasticsearch can be used to validate matches (as seen in [tutorial])(/tutorial#step-3-validate-matches-and-train-rescoring-with-machine-learning).

The validation option is activated by adding the `validation: true` option :
</div>
<div class="rf-highlight" markdown="1">
```
datasets:
  clients_x_deaths:
    connector: elasticsearch
    table: clients_x_deaths
    validation: true
```
</div>
<div markdown="1">
Validation mode is configured with the `conf/matchID_validation.conf` file for default behaviour. They can be overriden for each validation dataset like this :
</div>
<div class="rf-highlight" markdown="1">
```
    [...]
    validation:
      actions:
        display: true
        action:
          label: Results
          indecision_display: true   # if you don't want to use indecision
        done:
          label: Status
      elasticsearch:
        size: 200                    # number of search
      columns:                       # colum specific action
        - field: matchid_id
          label: Id
          display: false                 # some fields can be used for selection but not being displayed
          searchable: true
        - field:                         # array gathers two fields in one column
            - matchid_name_last_src
            - hit_matchid_name_last_src
          label: last name               #
          display: true
          searchable: true
          callBack: formatDiff           # this callback highlights the differents between the two first elements of an array
        - field:
            - matchid_name_first_src
            - hit_matchid_name_first_src
          label: first name
          display: true
          searchable: true
          callBack: formatDiff
        - field:
            - matchid_sex
            - hit_matchid_sex
          label: sex
          display: true
          searchable: true
          callBack: formatSex
          appliedClass:
            head: head-centered
            body: has-text-centered
        - field:
            - matchid_date_birth_str
            - hit_matchid_date_birth_str
          label: birth date
          display: true
          searchable: true
          callBack: formatDate
          appliedClass:
            head: head-centered
            body: has-text-centered
        - field:
            - matchid_location_city
            - hit_matchid_location_city
          label: birth city
          display: true
          searchable: true
          callBack: coloredDiff
        - field: matchid_hit_distance
          label: Distance
          display: true
          searchable: false
          callBack: formatDistance
          appliedClass:
            head: head-centered
            body: has-text-centered
        - field: matchid_clique_size    # example of an added field
          label: Group size
          display: true
          searchable: false
          callBack: formatNumber
          appliedClass:
            head: head-centered
            body: has-text-centered
        - field: matchid_clique_id
          label: Group id
          display: true
          searchable: true
          callBack: formatNumber
          appliedClass:
            head: head-centered
            body: has-text-centered
        - field: confiance
          label: Score
          display: true
          searchable: false
          type: score
          callBack: formatNumber
          appliedClass:
            head: head-centered
            body: has-text-centered min-column-width-100
        - field: matchid_hit_score
          label: Pre_Score
          display: true
          searchable: false
          type: score
          callBack: formatNumber
          appliedClass:
            head: head-centered
            body: has-text-centered min-column-width-100
      view:
        display: true
        column_name: view
        fields:
          operation: excluded
          names:
            - none
      scores:
        column: confiance
        range:                # if you have a specific range for scoring
          - 0
          - 100
        colors:                # color depending coloring customization
          success: 80
          info: 60
          warning: 30
          danger: 0
        statisticsInterval: 5
        preComputed:           #  if you want to change the "pre-decision" thresholds
          decision: 55
          indecision:
            - 40
            - 65
```
