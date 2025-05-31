# PgRandomizer

Simple generator of random data for Postgres database. Currently supports only random integer and strings.

## How to use

There are two methods that can be invoked: `generate` and `generate_with_connection`. Both accept number of
queries to generate and tables options (see [example script](./example.exs) for more info). The latter method
accepts map for database connection (again see [example](./example.exs)).

In the root of the repository you can find [docker compose](./docker-compose.yml) file that create Postgres
database and initializes tables. When the Postgres instance is running, the [example](./example.exs) will
populate both tables with 10 random columns.
