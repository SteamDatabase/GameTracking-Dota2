#!/bin/bash

echo "> Configuring"

cd "${0%/*}"

cp game/dota/gameinfo.gi game/dota/gameinfo_backup.gi
sed -i '/These are optional language paths./a Game dota/addons/metamod' game/dota/gameinfo.gi

cp -r ../.support/metamod/. game/dota/addons/
mv game/dota/addons/lobby.cfg game/dota/cfg/lobby.cfg

echo "> Running the game"

bash game/dota.sh -dedicated -source2genoutdir ./_dump/schema/ -vdumpoutdir ./_dump/lua/ +map dota +log off -dotacfg lobby.cfg -quitafterdump > /dev/null 2>&1

echo "> Cleanup"

rm -r game/dota/addons/
rm game/dota/cfg/lobby.cfg
mv game/dota/gameinfo_backup.gi game/dota/gameinfo.gi
