#!/usr/bin/env bash
# Generates a sig file from parameters.
# $siggen.sh "role" "email"

role=
email=
[[ -n "$1" ]] && role=", ${1}"
[[ -n "$2" ]] && email=$'\n'"$2"


read -d '' out  <<EOF
--
Erik Westrup${role}
http://erikw.me${email}
-------------------------------------
This email is encrypted with 2ROT-13.
EOF


echo -e "\n"
echo -e "$out"
exit 0
