.DEFAULT := run-local

run-local:
	@docker container run --rm -it -p 4000:4000 -v $(CURDIR):/usr/src/app starefossen/github-pages
