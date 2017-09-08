#!/bin/bash
# Check if AWS Root account has access keys enabled.
# Note: This script requires jq (https://stedolan.github.io/jq/download/)
#Also as a security all commands should go to hardcoded paths but it needs to 
if [[ -z "${1}" ]]; then /bin/echo "Please specify an aws profile on the command line.";exit 1;fi
profile="${1}"

testp="$(grep -q ${profile}] ~/.aws/credentials;/bin/echo ${?})"
if [[ "${testp}" -gt 0 ]];then /bin/echo "Unable to find credentials for ${profile}";exit 1;fi

aws --profile "${profile}" iam generate-credential-report >> /dev/null 2>&1
if [[ "${?}" -gt 0 ]];then /bin/echo "Error: Unable to generate credential report"; exit 1;fi

sleep 3 #Wait to give generate a chance to run, this should be replaced with something which checks generate finished.
case $(uname) in
Darwin) base64='/usr/bin/base64 -D'
;;
*) base64='/usr/bin/base64 -d'
;;
esac

declare -a my_array=( $(/usr/local/bin/aws --profile "${profile}" iam get-credential-report | /usr/bin/jq .Content | /usr/bin/tr -d \" | ${base64} | /usr/bin/awk -F',' '/<root_account>/ { print $9,$14 '}) )

echo "${profile}"
if [[ "${my_array[0]}" == 'false' || "${my_array[0]}" == 'N/A' ]];then
  /bin/echo "Success - Access Key 1 is disabled"
  status='0'
else
  /bin/echo "Fail - Access Key 1 is enabled"
  status='1'
fi
if [[ "${my_array[1]}" == 'false' || "${my_array[1]}" == 'N/A' ]];then
  /bin/echo "Success - Access Key 2 is disabled"
  #don't set status in case it's bad
else
  /bin/echo "Fail - Access Key 2 is enabled"
  status='1'
fi

if [[ ${status} -gt 0 ]];then /bin/echo "Please remove Root user Access Keys in ${profile}";fi
exit "${status}"
