#!/bin/bash

CONFIG_PATH=$1

SRC_DIR=/src
OUTPUT_DIR=/output
TMP_DIR=/tmp/magentotartoconnect

mkdir -p $TMP_DIR

TMP_TAR_PATH=$TMP_DIR/package-files.tar
TMP_TARGZ_PATH=$TMP_TAR_PATH.gz

if [ ! -f $CONFIG_PATH ]; then echo "Provided config path does not exist"; exit 1; fi
if [ ! -d $SRC_DIR ]; then echo "/src does not exist"; exit 1; fi
if [ ! -d $OUTPUT_DIR ]; then echo "/output does not exist"; exit 1; fi

cd $SRC_DIR

echo "Create intermediate package archive : $TMP_TAR_PATH"
tar -cvf $TMP_TAR_PATH ./* > /dev/null

if [ ! -f $TMP_TAR_PATH ]; then echo "Could not generate intermediate package archive"; exit 1; fi

find $OUTPUT_DIR -maxdepth 1 -name "*.tgz" -exec rm -f {} \;

echo "Generate final package file"
php ~/MagentoTarToConnect/magento-tar-to-connect.phar $CONFIG_PATH > /dev/null

echo "Move final package file to output directory"
find $TMP_DIR -maxdepth 1 -name "*.tgz" -exec mv {} $OUTPUT_DIR \;

find $OUTPUT_DIR -maxdepth 1 -name "*.tgz" -exec echo "Package successfully generated : {}" \;
