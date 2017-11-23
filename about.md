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

Basic `SQL` allowed 70+ % of matching between deaths' database and drivers' database.
But to reach higher levels of matching (**recall** and **precision**), we needed better *data cleansing*, *fuzzy matching* and *matching learning*.

# First tries and refactoring
----

Our first attempts to get high results were successful thanks to *Data Science Studio* from the company *Dataiku*.

But, as we were talking about our solution to match people's identities inside the French administration, many people asked if they could use it on their own datasets. For many administrations, licenced software are strictly controled.

>  So we decided to rewrite our project totally and to create an universal solution for matching people's identities. You get it now, it's **matchID**.

# Why open sourcing ?
----

A project cannot easily live inside an administration without being open-sourced.

So we open-sourced it. No risk of divulging secret defense stuff and so, you will not have all of our [recipes](/recipes) - only the best algorithms.
