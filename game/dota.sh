#!/bin/bash

# figure out the absolute path to the script being run a bit
# non-obvious, the ${0%/*} pulls the path out of $0, cd's into the
# specified directory, then uses $PWD to figure out where that
# directory lives - and all this in a subshell, so we don't affect
# $PWD

GAMEROOT=$(cd "${0%/*}" && echo $PWD)

#determine platform
UNAME=`uname`
if [ "$UNAME" == "Darwin" ]; then
   # Workaround OS X El Capitan 10.11 System Integrity Protection (SIP) which does not allow
   # DYLD_INSERT_LIBRARIES to be set for system processes.
   if [ "$STEAM_DYLD_INSERT_LIBRARIES" != "" ] && [ "$DYLD_INSERT_LIBRARIES" == "" ]; then
      export DYLD_INSERT_LIBRARIES="$STEAM_DYLD_INSERT_LIBRARIES"
   fi
   # prepend our lib path to LD_LIBRARY_PATH
   export DYLD_LIBRARY_PATH="${GAMEROOT}"/bin/osx64:$DYLD_LIBRARY_PATH
elif [ "$UNAME" == "Linux" ]; then
   # prepend our lib path to LD_LIBRARY_PATH
   export LD_LIBRARY_PATH="${GAMEROOT}"/bin/linuxsteamrt64:$LD_LIBRARY_PATH
   USE_STEAM_RUNTIME=1
fi

if [ -z $GAMEEXE ]; then
   if [ "$UNAME" == "Darwin" ]; then
      GAMEEXE=bin/osx64/dota2.app/Contents/MacOS/dota2
   elif [ "$UNAME" == "Linux" ]; then
      GAMEEXE=bin/linuxsteamrt64/dota2
   fi
fi

ulimit -n 2048

# Set default thread size.
ulimit -Ss 1024

# enable nVidia threaded optimizations
export __GL_THREADED_OPTIMIZATIONS=1
# enable Mesa threaded shader compiles
export multithread_glsl_compiler=1

# On Mac, you can set this so ctrl+click will be treated as a right click.
# export SDL_MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK=1

# and launch the game
cd "$GAMEROOT"

# Enable path match if we are running with loose files
if [ "$UNAME" == "Linux" ]; then
	export ENABLE_PATHMATCH=1
fi

# Run inside of the Steam runtime if necessary and allowed.
if [ "$STEAM_RUNTIME_ROOT" != "" ]; then
    # Already in the runtime.
    USE_STEAM_RUNTIME=0
fi
if [ "$STEAM_RUNTIME" = "0" ]; then
    # Runtime is explicitly disabled.
    USE_STEAM_RUNTIME=0
fi

if [ "$USE_STEAM_RUNTIME" = "1" ]; then
    STEAM_RUNTIME_PREFIX=/valve/steam-runtime/bin/run.sh
    if [ ! -f $STEAM_RUNTIME_PREFIX ]; then
        STEAM_RUNTIME_PREFIX=
    fi
    if [ "$STEAM_RUNTIME_PREFIX" != "" ]; then
        echo "Running with the Steam runtime SDK"
    fi
fi

# Do the following for strace:
# 	GAME_DEBUGGER="strace -f -o strace.log"
# Do the following for tcmalloc
#   LD_PRELOAD=../src/thirdparty/gperftools-2.0/.libs/libtcmalloc_debug.so:$LD_PRELOAD

STATUS=42
while [ $STATUS -eq 42 ]; do
	if [ "${GAME_DEBUGGER}" == "gdb" ] || [ "${GAME_DEBUGGER}" == "cgdb" ]; then
		ARGSFILE=$(mktemp $USER.dota.gdb.XXXX)
		echo b main > "$ARGSFILE"

		# Set the LD_PRELOAD varname in the debugger, and unset the global version. This makes it so that
		#   gameoverlayrenderer.so and the other preload objects aren't loaded in our debugger's process.
		echo set env LD_PRELOAD=$LD_PRELOAD >> "$ARGSFILE"
		echo show env LD_PRELOAD >> "$ARGSFILE"
		echo set disable-randomization off >> "$ARGSFILE"
		unset LD_PRELOAD

		echo run $@ >> "$ARGSFILE"
		echo show args >> "$ARGSFILE"
		${GAME_DEBUGGER} "${GAMEROOT}"/${GAMEEXE} -x "$ARGSFILE"
		rm "$ARGSFILE"
	elif [ "${GAME_DEBUGGER}" == "lldb" ]; then
		${GAME_DEBUGGER} "${GAMEROOT}"/${GAMEEXE} -- $@
	else
		${STEAM_RUNTIME_PREFIX} ${GAME_DEBUGGER} "${GAMEROOT}"/${GAMEEXE} "$@"
	fi
	STATUS=$?
done
exit $STATUS
