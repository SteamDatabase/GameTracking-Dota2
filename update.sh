#!/bin/bash

cd "${0%/*}"
. ../common.sh

echo "Processing Dota 2..."

../tools/dump_source2.sh dota dota

ProcessDepot ".dll"
ProcessDepot ".so"
DeduplicateStringsFrom ".so" "game/bin/linuxsteamrt64/libengine2_strings.txt" "game/bin/linuxsteamrt64/libtier0_strings.txt" "DumpSource2/.stringsignore"
DeduplicateStringsFrom ".dll" "game/bin/linuxsteamrt64/libengine2_strings.txt" "game/bin/linuxsteamrt64/libtier0_strings.txt" "DumpSource2/.stringsignore"
ProcessVPK
ProcessToolAssetInfo

FixUCS2

CreateCommit "$(grep "ClientVersion=" game/dota/steam.inf | grep -o '[0-9\.]*')" "$1"
