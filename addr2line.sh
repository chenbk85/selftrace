#!/bin/sh

if [ -z "$1" ]; then
	echo "Usage: addr2line.sh <executable>"
	exit 1
fi

sed -nre 's@^.*\[([0-9a-fx]*)\]$$@\1@;T;p' \
		| addr2line -Cafipse "$1" \
		| grep -v '?? ??'
