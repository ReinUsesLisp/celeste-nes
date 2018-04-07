#!/bin/sh
cd "$(dirname "$0")"

for tmx in `ls *.tmx`; do
	tiled --export-map $tmx "${tmx%%.*}.json"
	python3 export.py "${tmx%%.*}.json" > "${tmx%%.*}.tmp"
	echo "$tmx done"
done

rm -f levels.bin
cat *.tmp > levels.bin
echo "levels.bin done"

rm -f *.json
for tmx in `ls *.tmx`; do
	rm -f "${tmx%%.*}.tmp"
done

