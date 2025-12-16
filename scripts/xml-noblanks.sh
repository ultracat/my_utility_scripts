#!/bin/bash

cwd=$(pwd)

echo $cwd

for entry in "$cwd"/*.xml
do
	echo "$entry"
	xmllint --noblanks --encode utf8 "$entry" > "${entry%.*}"-noblanks.xml
done
