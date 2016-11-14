#!/bin/bash
#this convertor converts pkcs7 to pem format
#Variable
IN=$1
#echo "IN: $IN"
TRANSFORM=`echo $IN | awk -F"." {' print "."$NF'}`
#echo "TRANSFORM: $TRANSFORM"
OUT=`echo $IN | sed s/$TRANSFORM/.pem/`
#echo "OUT: $OUT"
answer=""

#functions
function test-usage {
if [ -z "$IN" ];then
printf "Usage: $0 [certificate]\n"
exit 1
fi
}

function check-duplication {
if [ "$OUT" = "$IN" ];then
echo "ERROR: The input and output file names match the input file must have a suffix."
exit 1
fi
}

function check-existing {
while [ -f "$OUT" ];do
echo "WARNING! $OUT already exists."
read -p "Are you sure you would like to overwrite this file? (Yes or No): " answer
case $answer in
[Yy]* ) echo yes; break;;
[Nn]* ) exit 0;;
*) echo "Please answer Yes or No.";;
esac
done
}

function check-format {
openssl pkcs7 -in $IN -text -noout 2>/dev/null
if [ $? -gt 0 ]; then
echo $IN is not in PKCS7 format certificate, we cannot process this file.
exit 2
fi
}

function convert {
echo "converting $IN to PEM format, successful output will be called $OUT"
openssl pkcs7 -in $IN -text -out $OUT -print_certs
}

function confirm-complete {
if [ "$OUT" -nt "$IN" ];then
echo "Your certificate has been successfully converted."
exit 0
else
echo "There has been an issue converting your certificate."
exit 1
fi
}

#carry out functions (in this order)
test-usage
check-duplication
check-existing
check-format
convert
confirm-complete
exit 0
