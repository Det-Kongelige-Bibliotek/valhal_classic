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

$ rake jetty:clean

(In the current edition of 'jetty', the start.ini file has to be fixed, according to https://github.com/projecthydra/hydra-jetty/commit/b49c04a0dcf7e3ee5be97f697a3fcce922ec86ff)

$ rake hydra:jetty:config 

$ rake jetty:start

The tests can be run by:

$ rake

The interface can be started on localhost:3000 by:

$ rails server