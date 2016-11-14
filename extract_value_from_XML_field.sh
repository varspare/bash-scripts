#!/bin/bash
#MD 19/10/2012
#This script iterates through a list. Pulls a single value from the named XML file using a serach for a field name,
# isolating the value and then outputing the name of the file and the value of the field on a single line into a comma
# seperated output file. 
#Hacked together from this site http://stackoverflow.com/questions/893585/how-to-parse-xml-in-bash
#TODO- variables, error checking
#XML parsing function
read_dom () {
    local IFS=\>
    read -d \< ENTITY CONTENT
}
#for loop with input file, the input file should be a list of filenames (full path can be here or at the end of the script with the input for the while loop
for i in `cat /userx/the_doc_gen_error_listing/files.txt` ; do
while read_dom; do
#variable ENTITY has to be given a value to search for
    if [[ $ENTITY = "busProcess" ]]; then
        echo $i","$CONTENT
    fi
#This next line gives the while loop an input file (<) and ensures we append (>>) to an output file
done < /the/PRD/inbound/$i >> /userx/the_doc_gen_error_listing/the_doc_gen_error_listing.csv
done
