build:
	docker run --rm -v $(PWD):/srv/jekyll -p 4000:4000 -it jekyll/builder:4.2.0 jekyll build
up:
	docker run -d --rm -v $(PWD):/srv/jekyll -p 4000:4000 -it jekyll/builder:4.2.0 jekyll serve
