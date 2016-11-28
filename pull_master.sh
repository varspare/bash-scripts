#!/bin/bash
# Author MD
#script to iterate over all your local git repos and pull the latest master
#tested on ubuntu 16.04 nothing else not even a mac... at least not yet.
#
#set some temp vars
basec=''
findcmd=''
whereami="${PWD}"
function usage () {
  cat <<EOF
Usage: $0 [-d <PATH>] optional directory to work from,
      otherwise the current directory is assumed.
EOF
  exit 0
}

while getopts "d:h" opt; do
  case $opt in
    d) searchloc=${OPTARG};;
    h) usage ;;
    \?) usage ;;
  esac
done

if [[ -z "${searchloc}" || "${searchloc}" == '' ]];then
  searchloc='.'
fi

#determine the system and command style
systype="$(uname)"
 case $systype in
  Linux)
    function findcmd {
    find . -maxdepth 2 -name '.git' -type d #ubuntu
  }
  ;;
  Darwin)
    function findcmd {
   find . -name '.git' -depth 2 -type d #osx
  }
  ;;
  *)
    printf "I can't find my machine type.\n"
    exit 1
  ;;
esac

#dance around the dirs"
if [[ ! "${searchloc}" == '.' ]];then
   cd "${searchloc}"
   if [[ "${?}" -gt 0 ]];then
      printf "unable to relocate, aborting...\n"
      exit 1
   fi
   basec='1'
fi

#find stuff and run git
for dir in $(findcmd | sed s'/\/.git//g')
  do
    printf "${dir}\n"
    cd "${dir}"
    git checkout master
    git pull 
    cd ..
  done

#go back to where we started
if [[ "${basec}" -eq '1' ]];then
   cd "${whereami}"
fi
exit 0
