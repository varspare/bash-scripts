test.sh
#!/bin/bash
~$USER/test1.sh
#print the return code passwd back by test1.sh
echo $?

test1.sh
#!/bin/bash
~$USER/test2.sh
#exit $? returns the return code of the last command to the parent process rather than the return code for this script
exit $?

test2.sh
#!/bin/bash
touch ~$USER/abc.txt


(apply the above 3 scripts)
run once then change abc.txt so it cannot be overwritten e.g. chmod 000 abc.txt
