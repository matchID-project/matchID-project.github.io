---
layout: default
permalink: roadmap
description: "the future of matchID"
title: Roadmap
width: is-10
---

<div class="tile is-ancestor">

<div class="tile is-parent is-vertical is-4">
<div class="tile">
<div class="tile is-child notification is-light"  markdown="1">
  
# **Consolidation**

## Method
- recipes.py refactoring (split datasets, ...)
- git tag for versionning
- build library
- unitary testing

## monitoring api
- restart
- jobs supervision

## code
- migrate to python 3

## automation / integration
- CI testing
- nginx path of dataviz (Kibana/Superset)
- nginx modularity (remove Kibana)
- adds superset support

</div>
</div>
</div>

<div class="tile is-parent is-vertical is-4">
<div class="tile">
<div class="tile is-child notification is-success"  markdown="1">
  
# **Evolutions**
## Documentation
- tutorial for doubles detection
- tutorial for data API-fication

## Examples
- sample for doubles detection

## Frontend
- cliques validation for doubles detection
- cost matrix charts
- data loading helpers (e.g csv type pseudo-guessing)
- data type display
- transformation helpers (e.g. parsing dates, etc.)
- editing data (and converting edits into recipes)


## Backend
- join with SQL
- triggering recipes

</div>
</div>
</div>

<div class="tile is-parent is-vertical is-4">
<div class="tile">
<div class="tile is-child notification is-info"  markdown="1">
  
# **Interoperability**

## Files
- json
- xml

## Databases
- Vertica
- MySQL
- MongoDB

## Hadoop support
- Spark
- HDFS

## Languages
- SQL
- R
- pySpark

## other softs 
- Dataiku/DSS
- Luigi

</div>
</div>
</div>

</div>
