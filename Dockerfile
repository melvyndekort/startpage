FROM ruby:alpine

ENV GITHUB_GEM_VERSION 226

RUN apk add --update --no-cache build-base ruby-dev \
 && gem install --verbose --no-document webrick github-pages:${GITHUB_GEM_VERSION} \
 && rm -rf /usr/lib/ruby/gems/*/cache/*.gem \
 && apk del build-base ruby-dev

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

EXPOSE 4000
CMD ["jekyll", "serve", "-d", "/_site", "--watch", "--force_polling", "-H", "0.0.0.0", "-P", "4000"]
