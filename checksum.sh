#!/bin/bash
##############################
#
# Author Mark Davison
# Last revision 2018/08/10
#
# run command first parameter is the filepath
#
# e.g ./checksum.sh /opt/myfiles/myfile.txt
#
#############################'
file="${1}"
cmd=''
check=''
lencheck=0
stype=''
sum=''
if [[ ! -f "${file}" ]]
then
  printf "Error: Unable to reach file, please check the path\n"
  exit 1
fi

printf "Enter the file's checksum: "
read check

#get length of check
lencheck="$(echo $check | wc -c)"
if [[ "${lencheck}" -eq 65 ]];then
  stype='sha256'
elif [[ "${lencheck}" -eq 41 ]];then
  stype='sha1'
elif [[ "${lencheck}" -eq 33 ]];then
  stype='md5'
elif [[ "${lencheck}" -eq 57 ]];then
  stype='sha224'
elif [[ "${lencheck}" -eq 97 ]];then
  stype='sha384'
elif [[ "${lencheck}" -eq 129 ]];then
  stype='sha512'
#Note: the following aren't cryptographic hashes so shouldn't be used for real files
elif [[ "${lencheck}" -eq 11 ]];then
  stype='ck' #CRC
elif [[ "${lencheck}" -eq 6 ]];then
  stype='' #BSD sum command
else
  printf "Unable to determine hash type\nPlease enter hash type manually: "
  read stype
fi

cmd=$(which "${stype}sum")

if [[ -z "${cmd}" ]]
then
  printf "Error: command not found for hash type: ${stype}\n"
  exit 1
fi

sum="$($cmd $file| cut -d' ' -f1)"

if [[ "$sum" == "${check}" ]]
  then
    printf 'match\n'
  else
    printf 'fail\n'
fi

exit "${?}"
