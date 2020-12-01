#!/bin/bash

BUILD_PATH=/home/ec2-user/react

echo "> 현재 실행중인 애플리케이션 pid 확인"
CURRENT_PID=$(pgrep -f node)

if [ -z $CURRENT_PID ]
then
  echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
else
  echo "> kill -15 $CURRENT_PID"
  kill -15 $CURRENT_PID
  sleep 5
fi


cd /home/ec2-user/react

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

NPM_PATH=$(which npm)

echo $NPM_PATH

echo "> npm install"
$NPM_PATH install

echo "> npm run build"
$NPM_PATH run build

echo "> react 배포"
nohup $NPM_PATH start $BUILD_PATH > /dev/null 2> /dev/null < /dev/null &
