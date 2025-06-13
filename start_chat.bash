#!/bin/bash

echo ""
echo "######## This start the bash gpt project :) ... "


echo ""
echo "######## Getting information "
whoami
echo ""
pwd

echo ""
echo "######## Getting Ubuntu version "
cat /etc/os-release

echo ""
echo "######## Reading environment variables  "
env

echo "######## Listing local files  "
ls -la

echo "######## Running required tools  "
jq --version


bash ./scripts/api_v1_responses_01.sh 



echo "Ending..."