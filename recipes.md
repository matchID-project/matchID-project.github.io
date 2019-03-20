---
layout: default
permalink: recipes
description: How matchID supercharges your powers with recipes
title: Recipes
width: is-10
---

> **A recipe consist of steps of treatments made on rows and colums.**  
The dataset is scanned by chunks, which are loaded into a Pandas dataframe.  
So a recipe is basically a treatment on a chunk from a dataframe, resulting into a transformed dataframe.

A recipe can call :

- another recipe (and so one, recursively)
- generic recipes (included in the core configuration, but constructed as recipes)
- internals (map, join, eval, replace, keep, delete...) : included in the core code or can also be extended
- the internal "eval" function gives access to create/modify columns based on a row function (e.g col1+col2) into recipes


# Quick access to recipes and functions
----


Summary:

 - [map](#map)
 - [keep](#keep)
 - [rename](#rename)
 - [delete](#delete)
 - [eval](#eval)
 - [exec](#exec)
 - [replace](#replace)
 - [normalize](#normalize)
 - [pause](#pause)
 - [to_integer](#to_integer)
 - [to_float](#to_float)
 - [list_to_tuple](#list_to_tuple)
 - [tuple_to_list](#tuple_to_list)
 - [ngram](#ngram)
 - [parsedate](#parsedate)
 - [join](#join)
 - [unfold](#unfold)
 - [unnest](#unnest)
 - [nest](#nest)
 - [groupby](#groupby)
 - [build_model](#build_model-no-chunks)
 - [apply_model](#apply_model)
	 
 - [`geopoint("POINT(lon, lat")`](#geopointpointlon-lat)
 - [`distance((lat a,lon a), (lat b, lon b))`](#distancelat-alon-a-lat-b-lon-b)
 - [`replace_dict(object,dic)`](#replace_dictobjectdic)
 - [`replace_regex(object,dic)`](#replace_regexobjectdic)
 - [`normalize(object)`](#normalizeobject)
 - [`tokenize(object)`](#tokenizeobject)
 - [`flatten(list)`](#flattenlist)
 - [`sha1(object)`](#sha1object)
 - [`levenshtein(str a, str b)`](#levenshteinstr-a-str-b)
 - [`levenshtein_norm(str a, str b)`](#levenshtein_normstr-a-str-b)

 - [SQL recipes](#sqlrecipes)


# Internals recipes
----

### map

This recipe creates new columns to the dataframe, simply based on others.

```
      - map:
          matchid_date_birth_src: datasetAlpha_DATE_NAISSANCE
          matchid_date_death_src: datasetAlpha_DATE_DECES
          #location
          matchid_location:                      # in this mapping,
            - datasetAlpha_COMMUNE_NAISSANCE              # ther result will be an array
            - datasetAlpha_CODE_INSEE_NAISSANCE           # [ datasetAlpha_COMMUNE_NAISSANCE, datasetAlpha_CODE_INSEE_NAISSANCE ]
```

### keep

This recipe keeps only columns matching a regex, with an optional `where` condition :

```
      - keep:
          select: matchid_.*   # selection with a regexp
          where : matchid_score>0.2             #eval-like python base expression
```
or in an explicit list :

```
      - keep:
          select:              # selection by list
            - matchid_name_first
            - matchid_name_last
```

### delete

This recipe deletes columns matching a regex :

```
      - delete:
          select: datasetAlpha.*    # selection with a regexp
```
or in an explicit list :
```
      - delete:
          select:              # selection by list
            - datasetAlpha_NOM_PRENOMS
            - datasetAlpha_DATE_NAISSANCE
```

### rename

Renames columns of a dataframe :

```
      - rename:
          source_column1: target_column1
          source_column2: target_column2

```

### eval

This is the swiss-knife recipe which evaluates a treatment row by row.
A new column value will have a cell value computed with a python expression.

The values of the dataframe are accessible within the `row` array.
A particular `column` value is available in `row['column']` as in `column`.

Here's an example:

```
      - eval:
        - matchid_name_first: matchid_name_first_src if (type(matchid_name_first_src)==list) else [matchid_name_first_src]
        - matchid_name_last: matchid_name_last_src if (type(matchid_name_last_src)==list) else [matchid_name_last_src]
```

[Here](#eval-functions) are some of the implemented functions.

*WARNING*: the eval function uses `pd.Dataframe.apply` row-by-row which is easy but sub-optimal for large datasets. You should consider to optimize your `eval` draft with an `exec` as soon as possible. Using vectorized function can lead to 100x accelerations. 

### exec

Every dataengineer or datascientist wants to optimize the algorithm knowing what it does.

This method execute pure python code, given that the data in input is the `df` dataframe processed by the recipes above. You should use this method everytime you process large volumes, because the `apply` method

The values of the dataframe are accessible within the `row` array.
A particular `column` value is available in `row['column']` as in `column`.

Here's an example:

```
      - exec:
        - df['matchid_name_match'] = df['matchid_name_last']+ np.where(df['matchid_name_first']!=""," " + df['matchid_name_first'], "")
        - df['matchid_name_last'] = df['matchid_name_last'].split(" ")
```

You can even have a multiline code:
```
      - exec: >
          df['matchid_location_depcode'] = np.where(
            (df['matchid_location_depcode'] == "") & (df['lieu_nais'].str.contains("99")),
            "99",
            df['matchid_location_depcode'])
```

### replace

This methods applies regex on a selection of fields (matching itself a regex), in python style:

```
     - replace:
          select: matchid_location_city.*         # regex for selection
          regex:                                  # ordered list of regex
            - ^\s*(lyon|marseille|paris)\s.*$: '\1'
            - montreuil s.* bois: montreuil
            - (^|\s)ste(\s|$): '\1sainte\2'
            - (^|\s)st(\s|$): '\1saint\2'
            - ^aix pce$: aix provence
```

### normalize

This method transforms a text to lowercase, removes accent and special characters on selected-by-regex fields :

```
      - normalize:
          select: matchid_location_city.*
```

### pause

This recipe is an helper for debugging a recipe. It ends prematurely the recipe, not excecuting following steps.

Complement helpers are a selection of fields (like keep) and of top rows (head) to limit the size of the treatment.

```
      - pause:
          select: matchid_location_city.*
          head: 50
```

### shuffle

Fully shuffles the data (each column independtly) using `np.random.permutation`. Used for anonymization.

### to_integer

This recipe converts a selection-by-regex of columns from string to integers, fills not available value with NaN or a specified value.

```
     - to_integer:
          select: ^.*(population|surface).*
          fillna: 0
```

### to_float

This recipe converts a selection-by-regex of columns from string to floats, fills not available value with NaN or specified value.

```
     - to_float:
          select: ^.*(frequency|).*
          fillna: 0
```

### list\_to\_tuple

Converts a list to tuple, which can be used for indexing in a dataframe (e.g. groupby, etc.) for example.

### tuple\_to\_list

Converts a tuple to a list.

### ngram

Computes n-grams of selected columns

```
     - ngram:
          select: .*name.*
          n: [2, 3, 4] # computes 2-grams, 3-grams and 4-grams
```

### parsedate

This recipe converts a selection-by-regex of columns from string to a date/time type :

```
      - parsedate :
          select: matchid_date_.*
          format: "%Y%m%d"               # standard python datetime format for parsing   
```

### join

This recipes acts like a SQL join, executed by chunks (so slower), tolerating fuzziness (so better).

This fuzzy join is either in-memory (to match to small referential datasets; ie <500k) or based on elasticsearch (for > 500k to > 100M).

** fuzzy, in-memory **

In the following example we try to match both city label (fuzzily), departement code (strictly) and country iso code (strictly) to recover citycode history of a city :

```
      - join:
          type : in_memory
          dataset: french_citycodes_fuzzy    # referential dataset to match with
          fuzzy:
            matchid_location_city_norm: norm_name
          strict:
            matchid_location_depcode: dep_code
            matchid_location_countrycode: CODEISO3
          select: # selected columns from outer dataset (right) mapped to current dataframe
            matchid_location_citycode_history: insee_code_history
            matchid_location_city: name
            matchid_location_city_geopoint_2d: geopoint_2d

```

** simple join, in-memory **

This example is more frequent and easier but useful when you have multiple referential datasets (slower than a SQL join but
can help to limit the number of in-between datasets) :

```
      - join:
          dataset: french_citycodes
          type: in_memory
          strict:
            matchid_location_citycode: insee_code
          select:
            matchid_location_citycode_history: insee_code_history
```

** large fuzzy match with elasticsearch **

This last example deals with the problem of big fuzzy match (up to millions against millions).

Of course you'll need a big cluster if you want to deal with many millions of matches in less than a week!

The fuzzy match just relies on pure elasticsearch queries transformed from json to yaml :

```
      - join:
          type: elasticsearch
          dataset: matchid
          query:
            size: 10
            query:    # the uggly raw elasticsearch query
              bool:
                must:
                  - bool:
                      should:
                        - bool:
                            must:
                              - match:
                                  matchid_name_match:
                                    query: matchid_name_last_match
                                    fuzziness: auto
                              - match:
                                  matchid_date_birth_str: matchid_date_birth_str
                        - bool:
                            must:
                              - match:
                                  matchid_name_match: matchid_name_last_match
                              - match:
                                  matchid_date_birth_str:
                                    query: matchid_date_birth_str
                                    fuzziness: 1
                      minimum_should_match: 1


```

The elasticsearch join can accept some configurations :

- `unfold: False` (default `True`): each row return a bucket of potential matches.`unfold` splits this buckets into rows, like in a SQL-join operation. If `unfold` is `False`, buckets are returned raw to enable custom operations.
- `keep_unmatched: True` (default: `False`) - if `unfold` is `True`, keep rows without a match (if `unfold` is `False`, no analysis of the bucket is done so all rows are kept).
- `unnest: False`(default: `True`) - by default, the elasticsearch values are splitted into columns. If `False`, the raw elasticsearch hits are returned one by row but in a column 'hit' which contains the json.
- `prefix: myprefix_` (default: `hit_`) - customize prefix of the keys from the elasticsearch hits.

### unfold

This recipe splits a selection-by-regex columns of arrays in to multiple rows, copying the content of the other columns :

```
     - unfold:
          select: ^hits        
```

### unnest

This recipe splits a selection-by-regex columns of jsons to multiple columns, one by key value of the JSON and delete previous columns :

```
     - unnest:
          select: ^hits
          prefix: hit_ #prefix with 'hit_' the keys for name the columns, default prefix is empty

```

### nest

Gathers the selected columns and values into a json in the target column :

```
     - nest:
          select: .*location.*
          target: location
```

### groupby (no chunks)

This computes a groupby and redispatchzq value across the group :

```
     - groupby:
          select: matchid_id
          transform:
            - score: max
            - score: min
          rank:
            - score
```

This method should be used without chunks unless you're sure each member of groups fit in same chunk.

### build_model (no chunks)

This methods applies only on a full dataset an should have the flag `chunked: False` in the input dataset, e.g :

```
  train_rescoring_model:
    input:
      dataset: rnipp_agrippa
      chunked: False    # <== this is the option to unckunk your dataset
```

To build a model, here's the way:

```
      - build_model:
          model:
            name: rnipp_agrippa_ml         # the name as it will be stored in models/ et callable with "apply_model"
            library: sklearn.ensemble      # library of ml (scikit learn)
            method: RandomForestRegressor  # method of ml
            parameters:                    # kwargs of the methods
              n_estimators: 20
              max_depth: 4
              min_samples_leaf: 5
            test_size: 0.33                # split size for train and test (here 67% for training and 33% for testing)
            tries: 3                       # numbers of tries for this splitting (here 3 random splits) to test stability
          numerical: .*(hit_score.*|population|surface|matchid_hit_distance)$
          categorical: .*(matchid_location_countrycode)$
          target: validation_decision      # name of the column to predict
```


### apply_model

To apply a model, you need to [build one first](#build_model) or use a pre-trained one.

Models can only be applied to same data as in training aka same columns in the same order.

```
      - apply_model:
          name: rnipp_agrippa_ml                                              # name of the model to be applied
          numerical: .*(hit_score.*|population|surface|matchid_hit_distance)$ # selection-by-regex of numerical columns
          categorical: .*(matchid_location_countrycode)$                      # selection-by-regex of categorical columns
          target: matchid_hit_score_ml                                        # name of the column to save prediction

```

# Eval functions
----

### `geopoint("POINT(lon, lat")`
Maps a string `POINT(lon, lat)` to a numerical tuple `(lat,lon)`.

### `distance((lat a, lon a), (lat b, lon b))`
Calculates vincenty (from geopy.distance) distance between two wgs84 (lat,lon) tuples.

### `replace_dict(object, dic)`
Replaces all values by key from dictionnary `dic` like `{"key1": "value1", "key2": "value2"}` into `object` which can be a string, an array or a dictionnary (replace into values which strictly match).

### `replace_regex(object, dic)`
Replaces all values by regex from dictionnary `dic` like `{"regex1": "value1", "regex2": "value2"}` into `object` which can be a string, a array or a dictionnary.

### `normalize(object)`
`object` may be either a string (or unicode) or an array of strings. For each string value, lower-cases the value, removes accents and special characters.

### `tokenize(object)`
`object` may be either a string (or unicode) or an array of strings. For each string value, split with `\s+ separator`.
nltk tokenizers could be integrated here later.

### `flatten(list)`
flattens the list, ie `[[a,b],[c]]` returns `[a,b,c]`.

### `sha1(object)`
Computes the sha1 hash key of `str(object)`.

### `levenshtein(str a, str b)`
Computes levenshtein distance between string a and string b. Current version is just a wrapping.

### `levenshtein_norm(obj a, obj b)`
Computes normalized levenshtein distance between string a and string b, or minimum of levenshtein_norm between list of strings a and list of strings b.

### `jw(obj a, obj b)`
Compute minimum jaro-winkler distance between strings of list a and strings of list b.

### `ngrams(object a, n=[2,3])`
Computes n-grams of string a (with n in a int list here [2,3]) or n-grams of strings in list a.


# SQL Recipes

SQL often performs better dans Python as soon as you don't need long code implementations.
We recommand to use it when performin join operations or simple tranformations.

matchID now includes a Postgres database, but could be used with other SQL alchemy compatible database. If it doesn't work please report an [issue on Github](https://github.com/matchID-project/backend/issues).

Note that before to perform a SQL join operation you should have declared to datasets in the same database. Be careful about the tables names which may differ between the dataset and the tables. 

Let's say that `clients` and `deaths` are our two datasets using the same connector (with the same name for the table). Suppose we also previously declared `clients_x_deaths` as a dataset using the same connector.

Here's a simple example of SQL recipe :

```
recipes:
  sql_matching:
    test_chunk_size: 100
    input: 
      dataset: clients
      chunk: 1000
      select: >
        select 
          clients.*,
          -- you must be careful about columns names potential collisions
          deaths.matchid_id as hit_matchid_id,
          deaths.matchid_name_last as hit_matchid_name_last,
          deaths.matchid_name_first as hit_matchid_name_first,
          deaths.matchid_location_city as hit_matchide_location_city,
          deaths.matchid_location_depcode as hit_matchid_location_depcode,
          deaths.matchid_date_birth as hit_matchid_date_birth,

        from clients, deaths
          where
            (
              levenshtein(clients.matchid_name_last, deaths.matchid_name_last)<3 
              and levenshtein(clients.matchid_name_first, deaths.matchid_name_first)<3
              and clients.matchid_location_depcode = deaths.matchid_location_depcode
              and clients.matchid_birth_date = deaths.matchid_birth_date
            )
          
    output: clients_x_deaths
    steps:

```

Note that:
  - `test_chunk_size` (default 30) will apply as a 'LIMIT' on the input dataset (clients) and to the output result while you test the recipe. This is usefull to force to have a response in a decent time, but on the other way you may have
  an empty result due to this. This is a classical SQL developpement problem and we'll be happy if you suggest other way to do this properly
  - If you want only to execute SQL efficiently and store it in the same database you have to leave the 'steps' empty
  - You can still use recipes after the request within the steps, the result of the request will be executed in the Python processor
  - The output dataset can be in a onther connector, so the SQL will be executed in the database of the input connector, then simply casted in the other connector
  - Types are preserved if you cast in another dataset, with classical problem using SQL types, then Pandas, then the output connector (for example Elasticsearch). There is no universal translator for that, it will be your pain.
  - If you want a fast copy you can specify the `mode: expert` in the input datasource, only for Postgres. This is usually a bit faster as it uses the `copy_expert` method. the other hand, all types will be casted into string. 


