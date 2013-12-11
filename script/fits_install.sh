#!/bin/sh
version=0.6.2
wget http://fits.googlecode.com/files/fits-${version}.zip
unzip fits-${version}.zip
chmod +x ./fits-${version}/fits.sh
export FITS_HOME=$(readlink -f fits-${version}/fits.sh)
echo 'FITS_HOME='${FITS_HOME}
rm fits-${version}.zip
