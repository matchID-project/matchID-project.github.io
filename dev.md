---
layout: default
permalink: dev
description: "how to contribute"
title:  developping matchID
width: is-10
---

# Developing `matchID`

You should first `make stop` matchID and have a clean docker environnement, if you first ran matchID with `make start`.
Then :
```
make dev
```
The interest of using `docker` for developping or debugging is that you are near to production architecture. You should consult the [automation](/automation#architecture) corner to understand the components of matchID.

## frontend
the frontend code should be in `../frontend/src`, it's in Vue.js.
When you start developping you still can go to `http://localhost/matchID`.
The only difference is that your changes in the code will appear live, with the `node.js` server.
Any error will appear live in your browser navigation

## backend
Any change on the code in `code/*.py` will have a live effect, thanx to the `werkzeug` which checks any changes.
When you have a bug in your python code (and python can't compile), you'll have to correct it and `docker` will restart quickly (but you may wait 30 seconds).
When debugging the backend you should try :
`docker logs -f matchid-backend`
Then any error or dirty `print` will be prompted here. 
For logs and print, the `werkzeug` has a buffer of 100 lines, to you have to flush it or wait for faster debug.

### changing `yaml` configurations
Every change of the `yaml`configuration is read whenever an api call is done. So, if you change `conf.yml` or `connectors.yml`, or `matchID_validation.yml`,
or any recipe or dataset if you reordered your projects configuration from server side, you should just make an api call :
```
curl -XGET http://localhost/api/v0/conf/
```
This will moreover a useful way to check if your changes have been read, as it return the configuration of all the projects.

## Pull requests
We use the GitHub code pipeline, so you have any contribution you should fork the project and then use the pull request method.





