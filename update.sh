#!/bin/bash

cd "${0%/*}"
. ../common.sh

echo "Processing Dota 2..."

ProcessDepot ".so"
ProcessVPK
ProcessToolAssetInfo

while IFS= read -r -d '' file
do
	baseFile="${file%.*}.txt"
	
	echo "> VPK $baseFile"
	
	../.support/vpktool "$file" > "$baseFile"
done <   <(find "game/dota/maps/" -type f -name "*.vpk" -print0)

FixUCS2

CreateCommit "$(grep "ClientVersion=" game/dota/steam.inf | grep -o '[0-9\.]*')" "$1"
