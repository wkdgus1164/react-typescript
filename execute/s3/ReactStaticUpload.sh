#!/bin/bash

Static_PATH=${StaticBuild}
BUCKET=${S3Cloudfront}

cd ../

if [ -d ./${Static_PATH} ]; then
  rm -rf ./${Static_PATH}
fi

echo "  > ${Static_PATH} 폴더 생성"
echo "  >>>> ${pwd}"
mkdir -vp ./${Static_PATH}

echo "  >  정적 파일 복사"
cp ../dist/* ./${Static_PATH}

cd ./${Static_PATH}

echo "${Static_PATH} / ${BUCKET}"

SHELL_PATH=`pwd -P`
echo $SHELL_PATH

echo "    >   S3 ${BUCKET} 버킷의 업로드"
aws s3 sync ../${Static_PATH} s3://${BUCKET}/

echo "s3 upload ReactStaticUpload"
