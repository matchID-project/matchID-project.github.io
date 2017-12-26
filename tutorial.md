---
layout: default
permalink: tutorial
description: Understanding when to use it
title: Step-by-step tutorial
width: is-10
---

# Tutorial
This tutorial will deal with tree use-cases :
- find common identities between two big datasets
- find doubles within a dataset
- build a search api against a dataset ("top of elasticsearch" API)


## Overview of matching steps
This is our usecase : we have to remove dead people, as registered in dataset "deaths", from a client file, "clients".
We'll follow four steps :

- 1: prepare deaths dataset
- 2: prepare clients dataset, match it against dataset 1 & score the matches
- 3: validate matches and train rescoring with machine learning
- 4: rescore with the machine learning kernel

<img src="assets/images/workflow.png" alt="matching workflow">


## Overview through frontend

So, the final goal is the match but we have first to deal with the way, which mainly is data preparation. So we'll learn here how to cook your data with recipes.

We propose a 4-step iterated method :
- upload raw data and configuration files
- edit yaml configuration files
- test recipes
- run recipes

Depending on your usecsae, if the goal is to develop a search api, you can have a fifth step:
- upload & apply recipe live

Iterating through theses steps will allow you to create recipes and datasets for two purposes:
- prepare your datasets (upload, map names/dates/locations)
- search matches and score them 

3 further steps will enable machine learning capability:
- validate the matches (through the [matchID-validation]() UI cf below)
- train machine learning models (using yaml edition and recipe testing again)
- apply for rescoring (idem)

In the final round, matching a dataset of people, `clients`, against another already index-one, `death`  will look like this recipe :
```
recipes:
  clients_deaths_matching:
    apply: True
    input: clients_csv
    output: clients_x_deaths
    steps:
      - dataprep_clients:
      - deaths_matching:
      - diff:
      - rescoring_clients_x_deaths:
```

This lead to have a new API endpoint, http://{{server}}/matchID/api/v0/recipes/clients_deaths_matching/apply where you'll just have to post every new month of your csv raw data, to get the json of ml-rescored potential candidates to remove.

This quite simple overview, relies in fact relying on more than 50 steps of treatments, so you'll have to work a bit more to adapt it to your case.
This recipes, against a some-millions `death` reference dataset, should gives about 10 matches/seconds on a up-to-date laptop, and around, 150 matches/second on a good 1U server.


### Starting matchID

Automatization (and thus documentation) is for now a future achievement

First clone the project
```
git clone https://github.com/matchID-project/backend
```

You have to clone matchID-frontend project to enable annotation for machine learning capabilities:
```
git clone https://github.com/matchID-project/frontend
```

And create and empty directory for the configuration :

```
mkdir -p tutorial/data tutorial/models
```

Note that machine learning is not mandatory (you can have a real serious matching only based on rules) but seriously recommended for reduction development time.

Simply run it with Docker (a >8Go configuration is recommended)
```
cd -backend
export FRONTEND=../frontend    # path to GitHub clone of matchID-frontend
export PROJECTS=../tutorial/projects       # path to projects
export UPLOAD=../tutorial/data/       # path to upload
export MODELS=../tutorial/models       # path to upload

docker-compose -f docker-compose-dev.yml up --build
```

Which launches four containers :
- nginx (for static web files to test the backend)
- matchid-frontend (vuejs frontend)
- matchid-backend (python backend)
- elasticsearch (the database)

So you can go to your server : [matchID](http://localhost)

