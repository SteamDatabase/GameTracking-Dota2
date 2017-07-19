#!/bin/bash

echo "> Configuring"

cd "${0%/*}"

cp game/dota/gameinfo.gi game/dota/gameinfo_backup.gi
sed -i '/These are optional language paths./a Game dota/addons/metamod' game/dota/gameinfo.gi

cp -r ../.support/metamod/. game/dota/addons/
mv game/dota/addons/lobby.cfg game/dota/cfg/lobby.cfg

cp ../steamworks/linux64/steamclient.so game/bin/linuxsteamrt64/steamclient.so

echo "> Running the game"

chmod +x game/bin/linuxsteamrt64/dota2
bash game/dota.sh -dedicated -source2genoutdir /home/steamdb/backend/files/dota/_dump/schema/ -vdumpoutdir /home/steamdb/backend/files/dota/_dump/lua/ +map dota +log off -dotacfg lobby.cfg -quitafterdump

echo "> Cleanup"

rm -r game/dota/addons/
rm game/dota/cfg/lobby.cfg
mv game/dota/gameinfo_backup.gi game/dota/gameinfo.gi
rm game/bin/linuxsteamrt64/steamclient.so
