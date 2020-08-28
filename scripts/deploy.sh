#!/bin/bash

set -eu

function_name=swift-sample
scf_region=ap-beijing
cos_bucket=swift-scf-test-1250000000
cos_region=ap-beijing

source build.sh

echo "-------------------------------------------------------------------------"
echo "Uploading \"$executable\" function to COS"
echo "-------------------------------------------------------------------------"
coscmd -b "$cos_bucket" -r "$cos_region" upload ".build/scf/$executable/cloud-function.zip" "$executable.zip"

echo "-------------------------------------------------------------------------"
echo "Updating \"$function_name\" to the latest \"$executable\""
echo "-------------------------------------------------------------------------"
tccli scf UpdateFunctionCode --region "$scf_region" \
    --FunctionName "$function_name" --Handler "swift.main" \
    --CodeSource "Cos" --CosBucketName "$cos_bucket" --CosBucketRegion "$cos_region" --CosObjectName "$executable.zip"
