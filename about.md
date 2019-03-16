---
layout: default
permalink: about
description: The story behind matchID
title: About
width: is-8
---

# Entrepreneur d'Intérêt Général (EIG)
----

At the end of 2016, the French President launched a new program largely inspired by Barack Obama's Presidential Innovation Fellows (PIF).

This program was called [Entrepreneur d'Intérêt Général](https://entrepreneur-interet-general.etalab.gouv.fr/) and the first session took place from January 2017 to October 2017.

Martin was picked for one of the challenge inside French Ministry of Interior, under the supervision of Daniel ANSELLEM and Fabien ANTOINE.
That is there that Fabien and Martin met and decided to launch matchID as an open-source project.

# The challenge
----

**The challenge consisted in suppressing all the deaths from French Driving Licenses database.**

Basic `SQL` without fuzziness allowed 70+ % of matching between deaths' database and drivers' database.
But to reach higher levels of matching (**recall** and **precision**), we needed better *data cleansing*, *fuzzy matching* and *matching learning*.

# First tries and refactoring
----

Our first attempts to get high results were successful thanks to *Data Science Studio* from the company *Dataiku*.

But, as we were talking about our solution to match people's identities inside the French administration, many people asked if they could use it on their own datasets. For many administrations, licenced software are strictly controled.

>  So we decided to rewrite our project totally and to create adaptative solution for record linkage with a focus on performance evaluation. You get it now, it's **matchID**.

# Use cases

There is a large variety on record linkage use cases. Here is a non-exhaustive list of use cases which justify an adaptative solution :

  * completion or search
  * statistics reliability
  * duplicates and data quality
  * crossing datasources for creating new value
  * screening or fraud detection

Some questions to ask :
  * which are the identifiers : first and last names, birth date and location, address, ...
  * what's the reliability of your data sources (duplicates, )
  * what part of the population do you cover ? the more you have the more ambiguity your have - cf the <a href="https://en.wikipedia.org/wiki/Birthday_problem"> birthday problem)
  * do you try to match all people of one of your datasets ?
  * where are you data sources ?

Depending on all of these question, the solution can be very different. All use cases should be implemented whith matchID, but we only implemented a dozen of use cases and each needed specific piplines. We do our best to pulish every code but every use case has to be anonymized and publishing is a work by itself, we do it regularily.

# Iterate, evaluate - organization

We had some fails in methodolgy. Depending of your time, organisation and compuation power you can have various approaches. 

You should first ask how to iterate quick and evaluate as soon as possible your results. And add consuming algorithms depending of your first results. 

Evaluation should drive every decision, and thus annotation is necessary. Annoating a hundred and progressively more depending of your use case should be a focus of your organisation. If you plan to have a precision of 99.99% you will have to do more than 10k annotation. It's time consuming but depends of what you want.

# Advantages of matchID
----

  * Annotation tool for evaluation
  * Free and open source
  * Easy access to standard and custom algorithms with Python (even machine learning) 
  * Can handle most sources (csv, SQL, elasticsearch)
  * Algorithm automation
  * Implement your algorithm as an api with no effort
  * Easy deployment and scalability (with docker)

# Data flow
----
<figure class="image is-8">
 <img src="assets/images/workflow.png">
</figure>

# Technical stack
----

  * Python
  * Elasticsearch
  * Docker
  * VueJs



# Why open sourcing ?
----

A project cannot easily live inside an administration without being open-sourced.

So we open-sourced it. No risk of divulging secret defense stuff and so, you will not have all of our [recipes](/recipes) - only the best algorithms.
