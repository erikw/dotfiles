#!/usr/bin/env bash
# Print NTLM(NT4) hash of input string.

if [ "$#" -eq 1 ]; then
	iconv -f ASCII -t UTF-16LE <(printf "$1") | openssl dgst -md4 | awk '{print $2}'
else
	iconv -f ASCII -t UTF-16LE | openssl dgst -md4 | awk '{print $2}'
fi
