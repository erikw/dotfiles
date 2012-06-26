#!/bin/bash
# Generates a sig file from parameters.
# $siggen.sh "role" "email"

role=
email="erik.westrup@gmail.com"
[[ -n "$1" ]] && role=", ${1}"
[[ -n "$2" ]] && email=$2

# Swedish address
#read -d '' out  <<-EOF
read -d '' out  <<EOF
-- 
Erik Westrup${role}
<${email}>
+49 174-9388546 | 2r.se
Schwedter Str. 22, 10119 Berlin, Germany
-----------------------------------------
This email is encrypted with 2ROT-13.
EOF


echo -e "\n"
echo -e "$out"
exit 0
