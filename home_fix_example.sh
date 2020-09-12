#!/bin/bash
for line in $(cat /etc/passwd)
do
  user=$(echo $line | cut -d: -f1)
  dir=$(echo $line | cut -d: -f6)
  if [[ "${dir}" ]]; then
    test="$(dirname ${dir})"
    if [[ "${test}" == '/home' ]]
      then
        echo "chown -R ${user} ${dir}"
    fi
  fi
done
