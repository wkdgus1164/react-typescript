#!/bin/bash

if [ -d /home/ec2-user/react ]; then
  rm -rf /home/ec2-user/react
fi

mkdir -vp /home/ec2-user/react
