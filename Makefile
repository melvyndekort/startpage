DEFAULT: run

image:
	@docker image build -t melvyndekort/github-pages .

run: image
	@docker container run --rm -it -p 4000:4000 -v $(CURDIR):/usr/src/app melvyndekort/github-pages
