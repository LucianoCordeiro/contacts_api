# Contacts API

## Setup

To build the docker image and create the application container, run:

```bash
docker build .
docker-compose up
```

Open a new terminal window to create the database and run the migrations:

```bash
docker-compose run web rails db:create
docker-compose run web rails db:migrate
```

Connect to ``localhost:3000`` in the browser to see the application running

To run unit tests:

```bash
docker-compose run web bundle exec rspec spec
```
