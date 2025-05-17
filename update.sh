#!/bin/bash
set -euo pipefail

cd "${0%/*}"
. ../common.sh

echo "Processing Dota 2..."

set +e
../tools/dump_source2.sh dota DOTA
DUMPER_EXIT_CODE=$?
set -e

ProcessDepot ".dll"
ProcessDepot ".so"
DeduplicateStringsFrom ".so" "game/bin/linuxsteamrt64/libengine2_strings.txt" "game/bin/linuxsteamrt64/libtier0_strings.txt" "DumpSource2/.stringsignore"
DeduplicateStringsFrom ".dll" "game/bin/linuxsteamrt64/libengine2_strings.txt" "game/bin/linuxsteamrt64/libtier0_strings.txt" "DumpSource2/.stringsignore"
ProcessVPK
ProcessToolAssetInfo

FixUCS2

CreateCommit "$(grep "ClientVersion=" game/dota/steam.inf | grep -o '[0-9\.]*')" "${1:-}"

echo "Done"

exit "$DUMPER_EXIT_CODE"
