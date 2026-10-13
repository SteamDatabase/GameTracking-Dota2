#!/bin/bash
set -euo pipefail

cd "${0%/*}"
. ../common.sh

echo "Processing Dota 2..."

set +e
../tools/dump_source2.sh DOTA
DUMPER_EXIT_CODE=$?
set -e

ProcessDepot ".dll" ".exe"
DeduplicateStrings
ProcessVPK
ProcessToolAssetInfo

echo "::group::Extracting VPKs"

set +e
# When updating vpk_filepath, also update "game/dota/pak01_dir.vpk:..." in files.json, since only those entries are downloaded
"$VRF_PATH" \
	--input "game/dota/pak01_dir.vpk" \
	--output "game/dota/pak01_dir/" \
	--vpk_cache \
	--vpk_decompile \
	--vpk_filepath "scripts/npc/*.txt,scripts/*.vdata_c,scripts/heroes.herolist_c,resource/localization/*_english.txt,patchnotes/patchnotes.vdpn_c"
VRF_EXIT_CODE=$?
if [[ "$DUMPER_EXIT_CODE" -eq 0 ]] && [[ "$VRF_EXIT_CODE" -ne 0 ]]; then
	DUMPER_EXIT_CODE=$VRF_EXIT_CODE
fi
set -e

echo "::endgroup::"

FixUCS2

CreateCommit "$(grep "ClientVersion=" game/dota/steam.inf | grep -o '[0-9\.]*')" "$(grep -o '[0-9\.]*' steam_buildid.txt)"

echo "Done"

exit "$DUMPER_EXIT_CODE"
