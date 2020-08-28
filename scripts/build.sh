#!/bin/bash

set -eu

executable=MyCloudFunction

echo -e "\ndeploying $executable"

echo "-------------------------------------------------------------------------"
echo "Preparing docker build image"
echo "-------------------------------------------------------------------------"
docker build . -t builder
echo "done"

echo "-------------------------------------------------------------------------"
echo "Building \"$executable\" SCF"
echo "-------------------------------------------------------------------------"
docker run --rm -v `pwd`/..:/workspace -w /workspace/swift-scf-test builder \
       bash -cl "swift build --product $executable -c release"
echo "done"

echo "-------------------------------------------------------------------------"
echo "Packaging \"$executable\" SCF"
echo "-------------------------------------------------------------------------"
docker run --rm -v `pwd`:/workspace -w /workspace builder \
       bash -cl "./scripts/package.sh $executable"
echo "done"
