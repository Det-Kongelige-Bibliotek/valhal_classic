[![Build Status](https://travis-ci.org/Det-Kongelige-Bibliotek/valhal.png?branch=master)](https://travis-ci.org/Det-Kongelige-Bibliotek/valhal)

Valhal
===

SIFD forvaltning


Run
===

to run on a local development machine:

Install ruby, git and rabbitmq (start rabbitmq on default ports).

$ git clone https://github.com/Det-Kongelige-Bibliotek/valhal.git

$ bundle install

$ rake db:migrate

$ rails generate hydra:jetty

$ rake hydra:jetty:config 

$ rake jetty:start

The tests can be run by:

$ rake

The interface can be started on localhost:3000 by:

$ rails server