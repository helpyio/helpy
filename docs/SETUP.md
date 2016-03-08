# Dev Environment Setup Guide

## Ruby on Rails Basic Setup

* Get Ruby ([rbenv](https://github.com/rbenv/rbenv) or [rvm](https://rvm.io/) recommended.

* Install PostgreSQL (eg. `brew install postgres` or via [PostgreSQL.org](http://www.postgresql.org/download/)).

* Run `bin/setup` to setup [Bundler](http://bundler.io/), install gem dependencies and configure the databases.

* Run `rake test` to execute the test suite.

* Run `rails server` to begin the server at [localhost:3000](http://localhost:3000/)!

* Configure your copy of Helpy in `config/settings/<your-environment>.yml`.
