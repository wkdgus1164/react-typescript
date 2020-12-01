#!/bin/bash

React_PATH=${react}
BUCKET=${S3Bucket}

cd ../

if [ -d ./${React_PATH} ]; then
  rm -rf ./${React_PATH}
fi

mkdir -vp ./${React_PATH}

cp -r ../src ./${React_PATH}
cp -r ../public ./${React_PATH}
cp ../package* ./${React_PATH}

cp ./codeDeploy/* ./${React_PATH}

cp ../appspec.yml ./${React_PATH}

cd ./${React_PATH}

zip -r ${React_PATH}.zip * -x ${React_PATH}*.sh 

find ./ ! -name *.zip -exec rm {} \; 

echo "${React_PATH} / ${BUCKET}"

SHELL_PATH=`pwd -P`
echo $SHELL_PATH

aws s3 sync ../${React_PATH} s3://${BUCKET}/${React_PATH}

echo "s3 upload ReactSever"
