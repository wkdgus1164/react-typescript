 #!/bin/bash 

echo "    > AWS CodeDeploy 배포"
echo "    > application-name : ${CodeDeployApplication}"
echo "    > deployment-group-name : ${CodeDeployGroup}"
aws deploy create-deployment \
--application-name ${CodeDeployApplication} \
--deployment-config-name CodeDeployDefault.OneAtATime \
--deployment-group-name ${CodeDeployGroup} \
--region ap-northeast-2 \
--s3-location bucket=${S3Bucket},bundleType=zip,key=${react}/${react}.zip
