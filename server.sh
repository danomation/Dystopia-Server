#!/bin/sh

apt-get -y update && apt-get -y upgrade
sudo apt -y update && sudo apt -y upgrade
sudo add-apt-repository multiverse
sudo dpkg --add-architecture i386
sudo apt -y install software-properties-common lib32gcc-s1 steamcmd
sudo apt-get -y install base-essentials nano net-tools

# note: steam user must already be created
# otherwise use chown and chmod to resolve any perm issues
mkdir -p /home/steam
cd /home/steam

# steamcmd
#wait for final prompt then ctrl+c to main prompt

export HOME=/home/steam
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$PATH

STEAMCMD_PATH=/usr/games/steamcmd
GAME_PATH=/home/steam/Steam/steamapps/common/DystopiaDedicatedServer
GAME_DIR=dystopia
GAME_PORT_OFFSET=0
GAME_MAP=dys_detonate
GAME_MAXPLAYERS=32
GAME_TICKRATE=100
GAME_TV_ENABLED=0
GAME_TV_NAME="YourTVBotName"

GAME_ARGS="-debug -game ${GAME_PATH}/${GAME_DIR} +maxplayers ${GAME_MAXPLAYERS} +map ${GAME_MAP} -tickrate ${GAME_TICKRATE} +log on"
GAME_TV_ARGS="+tv_enable 1 +tv_autorecord 1 +tv_maxclients 0 +tv_transmitall 1 +tv_dispatchmode 2 +tv_name ${GAME_TV_NAME} +tv_allow_camera_man 0"
if [ 0 -lt $GAME_TV_ENABLED ]
        then
        GAME_ARGS="${GAME_ARGS} ${GAME_TV_ARGS}"
fi

$STEAMCMD_PATH +force_install_dir $GAME_PATH \
        +login anonymous \
        +app_update 17585 \
        -beta release_candidate \
        +quit

export LD_LIBRARY_PATH="${GAME_PATH}"/bin:"${GAME_PATH}"/bin/linux32:$LD_LIBRARY_PATH
cd "${GAME_PATH}"

while :
do
        $GAME_PATH/bin/linux32/srcds -port $( expr 27015 + $GAME_PORT_OFFSET ) -console -debug -game $GAME_PATH/$GAME_DIR $GAME_ARGS
        echo "\nRestarting server... ($(date '+%Y-%m-%d %H:%M:%S'))\n"
        sleep 1
done
