# Rails with Docker

Rails and docker is a little tricky, because the Rails generator needs to run beforehand.
So I'm doing a two step process.

1. Use an interactive session to generate the rails app

    ```
    docker run --rm -it -v ${PWD}/app:/usr/src/app ruby:2.6 /bin/bash
    cd /usr/src/app
    gem install rails
    rails new . -d postgresql -T --skip-turbolinks --skip-coffee
    exit
    ```

2. Build the image

        docker build . --tag=railsx

Once built, you can run the Rails server with:

    docker run -d -p 3000:3000 -v ${PWD}/app:/usr/src/app rails1

To connect to PostgreSQL on a separate container, use `docker network inspect bridge` and then put the IP address in `database.yml` (unless you figure out a better way to network external services... possibly user defined network works better thaan `bridge`?)

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: 172.17.0.4
  username: postgres
  password: pgpass

development:
  <<: *default
  database: app_development
test:
  <<: *default
  database: app_test
production:
  <<: *default
  database: app_production
```

The database was started with:

```
docker run -d --hostname my-psql --name some-psql -v psql:/var/lib/postgresql/data `
--restart unless-stopped -p 5432:5432 -e POSTGRES_PASSWORD=pgpass postgres:alpine
```
