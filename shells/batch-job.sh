#!/bin/bash
dir=$1

for filename in $dir/**/deploy/deploy.js; do
    len=`expr ${#filename} - 9`
    targetDir=${filename:0:$len}
    # echo "$filename $targetDir"
    ./deploy-to-db.sh $filename $targetDir
done