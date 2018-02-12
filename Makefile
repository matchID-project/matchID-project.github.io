build:
	docker-compose -f docker-compose-build.yml up --build
serve:
	docker-compose -f docker-compose-serve.yml up
