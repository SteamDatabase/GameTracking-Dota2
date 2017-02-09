#!/bin/bash

cd "${0%/*}"
. ../common.sh

echo "Processing Dota 2..."

ProcessDepot ".dylib"
ProcessVPK

mono ../.support/SourceDecompiler/Decompiler.exe -i "game/dota/pak01_dir.vpk" -o "game/dota/pak01_dir/"
mono ../.support/SourceDecompiler/Decompiler.exe -i "game/core/pak01_dir.vpk" -o "game/core/pak01_dir/"

while IFS= read -r -d '' file
do
	baseFile="${file%.*}.txt"
	
	echo "> VPK $baseFile"
	
	../.support/vpktool "$file" > "$baseFile"
done <   <(find "game/dota/maps/" -type f -name "*.vpk" -print0)

echo "Fixing UCS-2"

while IFS= read -r -d '' file
do
	if ! file --mime "$file" | grep "charset=utf-16le"
	then
		continue
	fi

	temp_file=$(mktemp)
	iconv -t UTF-8 -f UCS-2 -o "$temp_file" "$file" &&
	mv -f "$temp_file" "$file"
done <   <(find game/ -name "*.txt" -type f -print0)

CreateCommit "$(grep "ClientVersion=" game/dota/steam.inf | grep -o '[0-9\.]*')"
