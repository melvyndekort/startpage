.DEFAULT_GOAL := server
.PHONY: clean_secrets clean build server update decrypt encrypt init plan apply

ifndef AWS_SESSION_TOKEN
  $(error Not logged in, please run 'awsume')
endif

clean_secrets:
	@rm -f terraform/secrets.yaml

clean: clean_secrets
	@rm -rf src/node_modules src/public src/.hugo_build.lock

build: clean
	@cd src; npm install
	@cd src; hugo --gc --minify

server:
	@cd src; npm install
	@cd src; HUGO_MODULE_REPLACEMENTS="github.com/melvyndekort/dracula-hugo-theme -> ../../../dracula-hugo-theme" hugo server -D

update: clean
	@cd src; npm update
	@cd src; hugo mod get -u github.com/melvyndekort/dracula-hugo-theme

decrypt: clean_secrets
	@aws kms decrypt \
		--ciphertext-blob $$(cat terraform/secrets.yaml.encrypted) \
		--output text \
		--query Plaintext \
		--encryption-context target=startpage | base64 -d > terraform/secrets.yaml

encrypt:
	@aws kms encrypt \
		--key-id alias/generic \
		--plaintext fileb://terraform/secrets.yaml \
		--encryption-context target=startpage \
		--output text \
		--query CiphertextBlob > terraform/secrets.yaml.encrypted
	@rm -f terraform/secrets.yaml

init: clean_secrets
	@cd terraform && terraform init -upgrade

plan: init
	@cd terraform && terraform plan

apply: init
	@cd terraform && terraform apply
