#!/bin/sh
wget http://fits.googlecode.com/files/fits-0.6.2.zip
unzip fits-0.6.2.zip
chmod +x ./fits-0.6.2/fits.sh
export FITS_HOME=`readlink -f fits-0.6.2/fits.sh`
echo 'FITS_HOME='${FITS_HOME}
rm fits-0.6.2.zip
