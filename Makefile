build:
	docker run --rm -v /home/antoinefa/src/matchID/matchID-project.github.io:/srv/jekyll -p 4000:4000 -it jekyll/builder jekyll build
up:
	docker run -d --rm -v /home/antoinefa/src/matchID/matchID-project.github.io:/srv/jekyll -p 4000:4000 -it jekyll/builder jekyll serve
