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

The Hydra part of valhal has the same basic software requisites as the Hydra-Head component (Ruby, Rails, etc.).
  - The software requisites for the Hydra-Head can be found here: https://github.com/projecthydra/hydra-head/wiki/Installation-Prerequisites
  - A set of step-by-step instructions for installing Ruby, Rails, and other useful tools,
    on a selection of operation systems, can be found here: http://installfest.railsbridge.org/installfest/

RabbitMQ. Note that RabbitMQ depends on Erlang.

ImageMagick-devel (on RHEL6 run ’yum install ImageMagick-devel’ with repo ’rhel-x86_64-server-optional-6’)
(on Ubuntu run ’apt-get install libmagickwand-dev’).

File Information Tool Set (FITS), http://projects.iq.harvard.edu/fits/downloads.
Set environment variable FITS_HOME to the fully qualified file name of the FITS script.
We have tested with FITS 0.6.2

RubyMine setup for developers
===
In RubyMine chose File->Open Directory and select the valhal directory.
RubyMine should automatically integrate with the valhal Git repository.

Run
===

In the config directory, create an application.local.yml file based on the application.local.template.yml file.

Run RabbitMQ on default port - 5672 (on RHEL6 there might be a Qpid daemon running on port 5672 already)

$ bundle install

$ rake db:migrate

$ rake jetty:clean

$ rake hydra:jetty:config

$ rake jetty:start

The tests can be run by:

$ rake

The interface can be started on localhost:3000 by:

$ rails server


Stopping valhal
===================

use "ctrl-c" for stopping the rails server
then stop the jetty application with "rake jetty:stop"


