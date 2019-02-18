FROM ruby:2.6

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -y nodejs

COPY ./app /usr/src/app

WORKDIR /usr/src/app
RUN bundle install

VOLUME /usr/src/app

CMD ["bundle", "exec", "rails", "s"]
