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

# First Use case : find common identities between two big datasets

## Cooking recipes with matchID 

### Global method used for matching
This is our first usecase : we have to remove dead people, as registered in dataset "deaths", from a client file, "clients".
We'll follow four steps, in the first usecase (finding common identities between two datasets)

- [Step 1: prepare deaths dataset](#step-1---dataprep--normalizing-the-identity-records-deaths-dataset)
- [Step 2: prepare clients dataset, match it against dataset 1 & score the matches](#step-2---dataprep-of-clients-and-matching)
- [Step 3: validate matches and train rescoring with machine learning](#step-3-validate-matches-and-train-rescoring-with-machine-learning)
- Step 4: rescore with the machine learning kernel

<img src="assets/images/workflow.png" alt="matching workflow">

### the philosophy of iterative cooking

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

This lead to have a new API endpoint, http://localhost/matchID/api/v0/recipes/clients_deaths_matching/apply where you'll just have to post every new month of your csv raw data, to get the json of ml-rescored potential candidates to remove.

This quite simple overview, relies in fact relying on more than 50 steps of treatments, so you'll have to work a bit more to adapt it to your case.
This recipes, against a some-millions `death` reference dataset, should gives about 10 matches/seconds on a up-to-date laptop, and around, 150 matches/second on a good 1U server.


## starting a developpement matchID server

A laptop with >8Go configuration is recommended to have a first look on matchID. Good performance with need higher computation resources (the higher the better : 16-cores + 128Go will be 15x faster than a laptop, we tested up-scaling to 40-cores for 40x faster).

matchID uses make and Docker to accelerate installation of dependencies. You'll first have to install Docker and docker-compose.

Then clone the project : 
```
git clone https://github.com/matchID-project/backend
```
If your host is not has not Docker on it, your should install it first (only tested with Ubuntu 16.04) :
```
make install-prerequisites
```
If you're running on other system (like MacOS) you should go to the official [Docker install page](https://docs.docker.com/install/), and don't forger to install [docker-compose](https://docs.docker.com/compose/install/) too. 

Now you should start the tutorial mode, which download, compiles necessary stuff, and launch the backend, frontend and elasticsearch :
```
make tuto
```

This may take some times, as this handles many actions :
- installing a 3-node elasticsearch (need less, just edit Make file and set `ES_NODE` to 1)
- installing kibana (optional, but can be useful)
- building the python backend, with all pandas and scikit dependencies
- compiling the Vue.js frontend with node into static html/css/js files
- presenting the all stuff with nginx

Any problems ? See the [troubleshooting](https://github.com/matchID-project/backend#frequent-running-problems) section.

Note that machine learning is not mandatory (you can have a real serious matching only based on rules) but recommended for reducting development time.

So you can go to your matchID server : [http://localhost/matchID/](http://localhost/matchID/)

<img src="assets/images/frontend-start.png" alt="matchID projects view">

## first project, first dataset, first recipe

### project
We'll first have to create a project. This will basically be a folder, containing datasets and recipes (data transformation). A good segmentation is to build a project for each goal : our use case is to match deaths within a client file, so we basically chose to have two projects: deaths, and clients. Just clic on `new project` and name the first one `deaths`:

<img src="assets/images/frontend-new-project.png" alt="matchID new project">

Which leads to:
<img src="assets/images/frontend-project-view-empty.png" alt="matchID projects view">

*Note :
- The segmentation of the projects are very easy to do server-side, as it only conains two sub-folders, datasets and recipes. We didn't implement method for splitting or reorganising project at this step of the dev, as the ratio of benefit/cost of folder management is very low.
- There is not versionning of the projects : you have to do your own version - at this step we do it by gitting them server side, so be careful in any change you make - git may be supported in a potential theorical future*

### dataset
Repeat clicking on `import dataset`, and just drag-n-drop (thx to [Dropzone](http://www.dropzonejs.com/)) the [`death.txt.gz`](https://github.com/matchID-project/examples/raw/master/data/deaths.txt.gz) you just downloaded from the [examples matchID repo](https://github.com/matchID-project/examples).

<img src="assets/images/frontend-import-dataset.png" alt="matchID import dataset">

Now you have your first dataset:
<img src="assets/images/frontend-dataset-deaths-ko.png" alt="matchID dataset first view">

We have many observation.
First the screen composition :
- left: yaml coding part (thx to [codemirror](https://codemirror.net/)) which is the declaration of the dataset
- right: the view of the dataset, as declared in the yaml

Secondly the data:
- the data seem real : well no, this data is quite realistic but synthetic data of french civil states. The statistics of the columns of the first, last names, and birth places are realistic, but not the association of the three.
- the columns doesn't seem ok, names and columns are not correct : that file is a realistic example of a fixed width file format, and matches the INSEE Rnipp official format

Take a look in a terminal of your gzipped fwf data :
```
$ zcat death.txt.gz | head -5
CZAJA*ROLAND BERNARD/                                                           11933052479048BRELOUX-LA-CRECHE                                           199209257904812143     
TRAZIC*JULIE CONSTANCE/                                                         21937111376134BOURVILLE                                                   200402217613414800     
ARMAND*EUGENE ROBERT GEORGES/                                                   11912051180342FRAMERVILLE-RAINECOURT                                      20130406803429904      
ALLAIRE*ANATOLE CAMILLE/                                                        11920071193049NEUILLY-PLAISANCE                                           201103189304911821     
JEAUNEAU*RAYMONDE JULIETTE ARLETTE/                                             21945100482043COMBEROUGER                                                 201105208204312208   
```

Well, it's quite boring do decrypt it so here is the solution, just copy-paste it on the dataset yaml code (each important line is commented) :
```
datasets:
  deaths_txt_gz:
    connector: upload             # the filesystem connector name, where drag'n dropped files are put
    table: deaths.txt.gz          # filename - could be a regex if multiple files
    encoding: latin1              # the encoding of the file, often utf8 for recent files
    type: fwf                     # type of the file : could be csv (tabular text), fwf (fixed with) or hdf5 (binary format)
    widths:                       # widths of the successive columns, as it is a fwf 
      - 80
      - 1
      - 8
      - 5
      - 30
      - 30
      - 8
      - 5
      - 10
    names:                       # names of the successive columns, that you can customize
      - DCD_NOM_PRENOMS
      - DCD_SEXE
      - DCD_DATE_NAISSANCE
      - DCD_CODE_INSEE_NAISSANCE
      - DCD_COMMUNE_NAISSANCE
      - DCD_PAYS_NAISSANCE
      - DCD_DATE_DECES
      - DCD_CODE_INSEE_DECES
      - DCD_NUM_DECES
```

Now you save that with `Ctrl+S` or the `Save` button.

**Warning : mind any change you make to your code. Any change is definitive, and you may loose your code if you change the two first lines of the yaml code.**

 *if you're lost you can go to the `tutorial` folder to `rm -f tutorial/projects/deaths/datasets/deaths_txt_gz.yml` and try it again. You can even `rm -rf tutorial/projects/deaths` and give a new birth to your project*

Here you are:
<img src="assets/images/frontend-dataset-deaths-ok.png" alt="matchID dataset correct view">

### first recipe

Create a new recipe :
<img src="assets/images/frontend-new-recipe.png" alt="matchID projects view">

A default recipe is created with no valid dataset, just replace it with the uploaded dataset, `deaths_txt_gz` - as this can be done now, we already figure out we have a `death` dataset we'll configure after finishing the recipe.
```
recipes:
  dataprep_deaths:
    input: deaths_txt_gz      # <==== necessary to change to continue
                              # there are advanced usage of dataset, such as filtered dataset
                              # which can be useful especially if you want more representative data
                              # for example:
                              # input:
                              #   dataset: deaths_txt_gz
                              #   filter: filtering_recipe # where filtering_recipe could be for example a random filtering
    output: deaths            # to be configured after the recipe
    test_chunk_size: 100      # optional : by default, the data display is only a chunk of 30 rows; 
                              # the more you get, the longer you'll wait, but more data will me more representative for building the recipe
    threads: 3                # optional, default: 2 - numbers of threads to proceed when running the recipe (not applied while testing)                          
    steps:                    # this is the beginning of the recipe
      - eval:
          - new_col: sha1(row)
```
Save it (button or `Ctrl+S`), tt should display the first imported dataset, but with an additionnal column, `new_col` which is basically a hash of the row:

<img src="assets/images/frontend-recipe-deaths-1.png" alt="matchID projects view">

So you have now an interactive way to deal with your data. Every new step of the recipe will add a new transformation on you data. You can have the exhaustive list of [recipes here](recipes.md).

## Step 1 - dataprep : normalizing the identity records (deaths dataset)

We'll stay here in editing our first recipe, `dataprep_deaths`.

Our goal is to make our data matchable with another dataset, and requires normalization. We'll do that in four steps:
- normalize **column names** (makes easier display and reuse of recieps), by mapping them
- normalize first and last **names** format
- normalize **birth location** (helping precise matching)
- parse **birth date**

When crossing large French names datasets, we showed that only about 33% of matches are perfect matches with no difference on any bit, 66% are fitting with few tolerance (removing special chars, keeping the first first name), and you reach more than 90 of matching (recall) with more accurate normalization (such as identifying the real city).

### columns names
So we add the following steps (removing the `new_col` one) :
```
      - eval:
        #tag dataset and records with uniq id
          - matchid_id: sha1(row)
          - matchid_src: str("deaths")
      - map: # create columns with normalized names
             # the names are quite strict, to enable easy filtering and reuse of recipes
             # you are free to change the whole process, which a bit of method and patience
          #date
          matchid_date_birth_src: DCD_DATE_NAISSANCE
          matchid_date_death_src: DCD_DATE_DECES
          #name
          matchid_name_src: DCD_NOM_PRENOMS
          matchid_name_last_src: DCD_NOM_PRENOMS
          matchid_name_first_src: DCD_NOM_PRENOMS
          #location
          matchid_location_city_src: DCD_COMMUNE_NAISSANCE
          matchid_location_citycode_src: DCD_CODE_INSEE_NAISSANCE
          matchid_location_country_src: DCD_PAYS_NAISSANCE
          matchid_location_citycode: DCD_CODE_INSEE_NAISSANCE
          matchid_location_countrycode_src: DCD_CODE_INSEE_NAISSANCE
          #sex
          matchid_sex_src: DCD_SEXE
          matchid_sex: DCD_SEXE
      - keep: # remove old columns
          select: matchid_.*
```

<img src="assets/images/frontend-recipe-deaths-columns.png" alt="matchID projects view">

### preparing the names

Just filter the names setting `matchid_name` in the column filter. This filter uses regex so you can use complex filtering for easy navigation in your data:
<img src="assets/images/frontend-recipe-names-filter.png" alt="matchID projects view">

Now you see the names won't matching with this format which is quite special.
We propose those normalizations. Just paste and save it step by step.
```
      #name
      - replace: # parses the last name with a regex
          select: matchid_name_last_src$
          regex:
            - ^(.*)\*.*/$: '\1'     
      - replace: # parses the first name with another regex
          select: matchid_name_first_src$
          regex:
            - ^.*\*(.*)/$: '\1'
      - eval: # builds an array from the names
          - matchid_name_first_src: matchid_name_first_src.split(" ")
      - french_name_normalize: # applies standard normalization, removings accents, special chars, bringing to lower case
      - french_name_frequency: # uses names frequencies to join compound names
```

<img src="assets/images/frontend-recipe-names.png" alt="matchID projects view">

Note that both `french_name_normalize` and `french_name_frequency` recipes are available in the `conf` project.

If you just want to see the process at one step without deleting the following ones, you just have to use the 'pause' recipe :
<img src="assets/images/frontend-recipe-pause.png" alt="matchID projects view">

In this case we just put the `pause` step before the name normalization section. We remove it then to have the whole process.

### location normalization
We now apply the column filtering on `matchid_location` to work on city names normalization. The goal is to make each location reliable, so we use external INSEE dataset (COG) to achieve this. This mean : this treatment is focused on the french population.
```
      #location
      - country_code_cog: # expand countries against INSEE code
      - french_citycode:  # adds city code history and normalize name (works on 99,9% as based on INSEE code)
      - algeria_city:     # experimental, which is the second-order country of birth for France residents (~ 5 to 8%)
                          # works only on 60% of the cases as the referential is less reliable than the INSEE one 
```
All the recipes are coded in the `conf` project so you can open them to have more details. 

The french history codes are very important, as among the history city names changed a lot, and especially birth location of old people. So the name may have change depending of the reference file. This treatment bring about 15% to 30% bonus in matching, and have to be performed on both datasets to be matched.

<img src="assets/images/frontend-recipe-location.png" alt="matchID projects view">

### birth date parsing
This is now the easier part, it just constists in parsing dates, so with columns filtering to `matchid_date`, and just adding :
```
    # dates
      - ymd_date: # parses dates in year month day format (19580123)
```
`ymd_date` is, again, available in the `conf` project.

So this is the final preview :
<img src="assets/images/frontend-recipe-dates.png" alt="matchID projects view">

### configure the output elasticsearch dataset

Don't forget to save your recipe. We'll then create the `deaths` dataset as formerly pointed as the output dataset of the recipe. Just create it from the menu and paste this content :
```
datasets:
  deaths:
    connector: elasticsearch # this is the predeclared connector to the dockerized elasticsearch
    table: deaths            # name of the index
```

Note that you can configure many options of an elasticsearch dataset :
- `body`: **raw elasticsearch configuration** contains alls options such as mappings, the number of replicas and shards, tokenizers as in elasticsearch doc. You just have to convert you json mappings into yaml.
- `chunks`, `thread_count`, `timeout̀`, `max_tries`, `safe` for elasticsearch optimization

### run the recipe !
So once evrything is configure you can run the recipe with the green button : 

<img src="assets/images/frontend-recipe-run.png" alt="matchID projects view">

This run is needed to index the deaths with elasticearch, which will enable a match of up to 98% (recall).

You can follow the job either directly in the bottom in the 'Real logs':
<img src="assets/images/frontend-recipe-log.png" alt="matchID projects view">

Or choose to see the "jobs" in the menu:
<img src="assets/images/frontend-jobs.png" alt="matchID projects view">

This should take about 30 minutes on a reasonable big computer (35 min using 10 threads = 10vCPU).

The job log last line should summarize the time and bugs for the recipe :
```
2018-02-20 05:31:45.788016 - 0:35:00.826869 - end : run - Recipe dataprep_deaths finished with errors on 46 chunks (i.e. max 92000 errors out of 1355745) - 1355745 lines written
```
If you take a look a the detailed logs, you'll the that the bugs are only mix encoding problems, due to a bad formatted file. There is not 92000 errors, but only 46 encoding errors included in 46 chunks of 2000 rows. For now, the automation doesn't scrutate as deep as you'd like, you'll have to take a look by yourselve in the logs.


## Step 2 - dataprep of clients and matching

### dataprep
You should be able to follow the former steps on the new file, `clients`
First create the project: `clients`.

Then imports two datasets : [`clients.csv.gz`](https://github.com/matchID-project/examples/raw/master/data/clients.csv.gz) and [`clients_pays.csv`](https://raw.githubusercontent.com/matchID-project/examples/master/data/clients_pays.csv) (this second one is a custom country mapping corresponding to client.csv.gz).
The data declaration helps can be found in [`clients_csv.yml`](https://github.com/matchID-project/examples/blob/master/projects/clients/datasets/clients_csv.yml)  and [`client_pays.yml`](https://github.com/matchID-project/examples/blob/master/projects/clients/datasets/clients_pays.yml).

You'll need a custom recipe for preparation of country codes : [`country_code_clients.yml`](https://github.com/matchID-project/examples/blob/master/projects/clients/recipes/country_code_clients.yml).

Then you'll be able to prepare the clients data : [`dataprep_clients.yml`](https://github.com/matchID-project/examples/blob/master/projects/clients/recipes/dataprep_clients.yml).

Mind that the datasets in the matchID example project doesn't exactly the same names : so you'll have to change them, which should lead you to dead with the debug interface.

Note that the preparation differs only a few from the `deaths.txt.gz` file :
- names parsing is more simple
- cities mappings relies on a internal fuzzy match, as cities are not coded but only described literally. On french cities the mapping occures to be around 98% on a not-to-dirty dataset

You should quickly have this final view of dataprep :

<img src="assets/images/frontend-recipe-clients.png" alt="matchID projects view">

We won't have to run this one.

### matching !
Here comes the tricky part : the fuzzy match with elastic search. 
What kind of matching do you need ? This first steps uses indexation to maximize recall while narrowing the huge cardinality of matching millions records to millions records, leading to a reasonable bucket to score, hoping begin less than 10th the size of the smaller dataset. Three kind of indexation can be done :
- ngram (any SQL or search can do this)
- phonetic (any SQL or search can do this)
- string distance tolerating indexing, levenshtein (only search like SolR or Elasticsearch).
The two first will lead to huge buckets and search will be a bit more precies.

SO, now you have to match every client against the already-indexed-in-step-1 deaths. 

*to be modified : begin with a simple elasticsearch request instead the hard one*

First create a generic `deaths_matching` in the death project from [`deaths_matching.yml`](https://github.com/matchID-project/examples/blob/master/projects/deaths/recipes/deaths_matching.yml). This one performs a self match from `deaths` to `deaths`, this isn't the aim here.

This recipe essentially contains a complex elasticsearch query, translated from json to yaml and templated. Here's the explanation of the query.
- the client name must match fuzzily (levenshtein max 2) on of the names (first and last) of the death, and stricly on the birth date
- or the client name must match strictly on of the names and fuzilly (levenshtein max 1) on the birth date
- more over, if possible :
  - the last name should be the last name
  - the first name should be in the deaths names
  - the city should match
  - the country should match

Many specificities of your dataset should lead you to customize the search query : should you have poor data with no birth date, or would you have wife names, the query has to match your need.

All those conditions make a large recall without bringing too much candidates.

Now we create a combo recipe, `clients_deaths_matching` in the `clients` project, calling the last two ones, plus a special one, `diff` :
```
recipes:
  clients_deaths_matching:
    apply: true
    threads: 1
    test_chunk_size: 50
    input: clients_csv_gz
    output: clients_x_deaths
    steps:
      - dataprep_clients:
      - deaths_matching:
      - diff:
```      

then you should have your first sampling results (screenshot obtain using a regex filter: `diff(?!_id)|confiance|number`):

<img src="assets/images/frontend-recipe-matching.png" alt="matchID projects view">

Before running there recipe, don't forger to create the `client_x_deaths` dataset in elasticsearch :
```
datasets:
  clients_x_deaths:
    connector: elasticsearch
    table: clients_x_deaths
    validation: true        # <=== this is mandatory to go to step 3
```
Now run the recipe. It should take about 2h to run it for 1M x 1M with a 16vCPUx32Go and 3 ES nodes.

## Step 3: validate matches and train rescoring with machine learning
You don't have to wait the full run to examinate your matching results : go to the `client_x_deaths` dataset.

The `vadliation: true` option activates this button : 

<img src="assets/images/frontend-validation-button.png" alt="matchID projects view">

Click on it to access to the validation mode, which enables the possibility to annotate your results :

<img src="assets/images/frontend-validation.png" alt="matchID projects view">

