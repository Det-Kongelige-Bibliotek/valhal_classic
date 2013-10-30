[![Build Status](https://travis-ci.org/Det-Kongelige-Bibliotek/valhal.png?branch=master)](https://travis-ci.org/Det-Kongelige-Bibliotek/valhal)

Valhal
===

SIFD forvaltning


Run
===

to run on a local development machine:

Install ruby (with rvm, bundler, etc.), git and RabbitMQ (should be possible to install all from default rpm provider, e.g. yum)
Also requires to have ImageMagick-devel installed (on RHEL6 run ’yum install ImageMagick-devel’ with repo ’rhel-x86_64-server-optional-6’)
Start RabbitMQ on default ports - 5672 (on RHEL6 there might be a Qpid daemon running on port 5672 already)

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