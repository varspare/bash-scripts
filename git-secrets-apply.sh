#!/bin/bash
# Script to implement awslabs/git-secrets in all repos in a directory
# First install as per instructions here: https://github.com/awslabs/git-secrets
for i in $(find ./ -maxdepth 1 -type d | grep -v "^./$")
  do
    if [[ -d "${i}/.git" ]]
      then
         echo "${i}"
         cd "${i}"
         echo "${PWD}"
         git secrets --install
         git secrets --register-aws
         cd ../
      else
        echo "${i} is not a git repo"
    fi
  done
