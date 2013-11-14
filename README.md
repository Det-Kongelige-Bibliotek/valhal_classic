[![Build Status](https://travis-ci.org/Det-Kongelige-Bibliotek/valhal.png?branch=master)](https://travis-ci.org/Det-Kongelige-Bibliotek/valhal)

Valhal
===

Valhal - SIFD management


GIT checkout of repository
===

git clone https://gitusername@github.com/Det-Kongelige-Bibliotek/valhal.git

Replace 'gitusername' with your own gitusername.
This is necessary, if you want to push commits back to master branch.

Software requisites
===

The Hydra part of valhal has the same software requisites as the Hydra-Head component (Ruby, Rails, etc.).
  - The software requisites for the Hydra-head can be found here: https://github.com/projecthydra/hydra-head/wiki/Installation-Prerequisites
  - A set of step-by-step instructions for installing Ruby, Rails, and other useful tools can be found here: http://installfest.railsbridge.org/installfest/

RabbitMQ comes as a package for most operating systems.

ImageMagick-devel (on RHEL6 run ’yum install ImageMagick-devel’ with repo ’rhel-x86_64-server-optional-6’).

RubyMine setup for developers
===
In RubyMine chose File->Open Directory and select the valhal directory.
RubyMine should automatically integrate with the valhal Git repository.

Run
===

Start RabbitMQ on default ports - 5672 (on RHEL6 there might be a Qpid daemon running on port 5672 already)

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

