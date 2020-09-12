#!/bin/bash
# Script to generate integrity SHA for use in HTTP body or Content-Security-Policy HTTP header
# Output is currently just in HTTP Body format
filename="${1}"

g256=$(cat "${filename}" | /usr/bin/openssl dgst -sha256 -binary | /usr/bin/openssl enc -base64 | tr -d '\n')
g384=$(cat "${filename}" | /usr/bin/openssl dgst -sha384 -binary | /usr/bin/openssl enc -base64 | tr -d '\n')
g512=$(cat "${filename}" | /usr/bin/openssl dgst -sha512 -binary | /usr/bin/openssl enc -base64 | tr -d '\n')

u256="sha256-${g256}"
u384="sha384-${g384}"
u512="sha512-${g512}"

printf '<script type="text/javascript" src="'
printf "${filename}"
printf '" integrity="'
printf "${u256}"
printf " ${u384}"
printf " ${u512}"
printf '" crossorigin="anonymous"></script>\n'
