#Clacks-Ohana API

Clacks-Ohana API is based on [Ohana API](http://github.com/codeforamerica/ohana-api), a Ruby on Rails application that makes it easy for communities to publish and maintain a database of social services, and allows developers to build impactful applications that serve underprivileged residents.

## Stack Overview

* Ruby version 2.1.2
* Rails version 4.1.6
* Postgres
* Testing Frameworks: RSpec, Factory Girl, Capybara

## Client libraries

The Code for America team have created the following client library which is compatible with the

- Ruby: [Ohanakapa][ohanakapa] (our official wrapper)

[ohanakapa]: https://github.com/codeforamerica/ohanakapa

## Deploying

### On Centos 6

See the [Wiki](https://github.com/digitalWestie/ohana-api/wiki/How-to-install-and-deploy-on-Centos-6).

### To Heroku

See the [Wiki](https://github.com/digitalWestie/ohana-api/wiki/How-to-deploy-the-Ohana-API-to-your-Heroku-account).

## Running the tests

Run tests locally with this simple command:

    script/test

To see the actual tests, browse through the [spec](https://github.com/digitalWestie/ohana-api/tree/master/spec) directory.

## Attribution
Ohana-API was created by Code for America. This repository is a fork of the [following.](http://github.com/codeforamerica/ohana-api)