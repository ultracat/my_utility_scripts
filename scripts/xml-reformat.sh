#!/bin/bash

cwd=$(pwd)

echo $cwd

for entry in "$cwd"/*.xml
do
	echo "$entry"
	xmllint --format --encode utf8 "$entry" > "${entry%.*}"-format.xml
done
