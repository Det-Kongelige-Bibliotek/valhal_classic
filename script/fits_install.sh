#!/bin/sh
wget http://fits.googlecode.com/files/fits-0.6.2.zip
unzip fits-0.6.2.zip
export FITS_HOME=./fits-0.6.2
echo 'FITS_HOME='${FITS_HOME}
rm fits-0.6.2.zip
