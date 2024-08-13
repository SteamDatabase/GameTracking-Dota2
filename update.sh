#!/bin/bash

cd "${0%/*}"
. ../common.sh

echo "Processing Dota 2..."

ProcessDepot ".dll"
ProcessDepot ".so"
DeduplicateStringsFrom ".so" "game/bin/linuxsteamrt64/libengine2_strings.txt" "game/bin/linuxsteamrt64/libtier0_strings.txt"
ProcessVPK
ProcessToolAssetInfo
FixUCS2

CreateCommit "$(grep "ClientVersion=" game/dota/steam.inf | grep -o '[0-9\.]*')" "$1"
