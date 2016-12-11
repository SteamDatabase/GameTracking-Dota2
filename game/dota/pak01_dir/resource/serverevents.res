//=========== (C) Copyright 1999 Valve, L.L.C. All rights reserved. ===========
//
// The copyright to the contents herein is the property of Valve, L.L.C.
// The contents may be used and/or copied only with the written permission of
// Valve, L.L.C., or in accordance with the terms and conditions stipulated in
// the agreement/contract under which the contents have been supplied.
//=============================================================================

// Don't change this file, it defines engine events

"engineevents"
{
//////////////////////////////////////////////////////////////////////
// Server events
//////////////////////////////////////////////////////////////////////

	"server_spawn"				// send once a server starts
	{
		"hostname"	"string"	// public host name
		"address"	"string"	// hostame, IP or DNS name	
		"port"		"short"		// server port
		"game"		"string"	// game dir 
		"mapname"	"string"	// map name
		"addonname" "string"    // addon name
		"maxplayers"	"long"		// max players
		"os"		"string"	// WIN32, LINUX
		"dedicated"	"bool"		// true if dedicated server
		"password"	"bool"		// true if password protected
	}
	
	"server_pre_shutdown" 		// server is about to be shut down	
	{
		"reason"	"string"	// reason why server is about to be shut down
	}
	
	"server_shutdown" 			// server shut down	
	{
		"reason"	"string"	// reason why server was shut down
	}
	
	"server_cvar" 				// a server console var has changed
	{
		"cvarname"	"string"	// cvar name, eg "mp_roundtime"		
		"cvarvalue"	"string"	// new cvar value
	}
	
	"server_message"			// a generic server message
	{
		"text"		"string"	// the message text
	}

	"server_addban"
	{
		"name"		"string"	// player name
		"userid"	"short"		// user ID on server
		"networkid"	"string"	// player network (i.e steam) id
		"ip"		"string"	// IP address
		"duration"	"string"	// length of the ban
		"by"		"string"	// banned by...
		"kicked"	"bool"		// whether the player was also kicked
	}

	"server_removeban"
	{
		"networkid"	"string"	// player network (i.e steam) id
		"ip"		"string"	// IP address
		"by"		"string"	// removed by...
	}
	
	"player_connect"			// a new client connected
	{
		"name"		"string"	// player name		
		"index"		"byte"		// player slot (entity index-1)
		"userid"	"short"		// user ID on server (unique on server)
		"networkid" "string" // player network (i.e steam) id
		"address"	"string"	// ip:port
	}
	
	"player_info"				// a player changed his name
	{
		"name"			"string"	// player name		
		"index"			"byte"		// player slot (entity index-1)
		"userid"		"short"		// user ID on server (unique on server)
		"networkid"		"string"	// player network (i.e steam) id
		"bot"			"bool"		// true if player is a AI bot
	}
	
	"player_disconnect"			// a client was disconnected
	{
		"userid"	"short"		// user ID on server
		"reason"	"short"	// see networkdisconnect enum protobuf
		"name"		"string"	// player name
		"networkid"	"string"	// player network (i.e steam) id
		"PlayerID"	"short"
	}

	"player_activate"
	{
		"userid"	"short"		// user ID on server
	}
	
	"player_connect_full"			// player has sent final message in the connection sequence
	{
		"userid"	"short"		// user ID on server
		"index"		"byte"		// player slot (entity index-1)
		"PlayerID"	"short"
	}

	"player_say"
	{
		"userid"	"short"		// user ID on server
		"text"		"string"	// the say text
	}

	"player_full_update"
	{
		"userid"	"short"		// user ID on server
		"count"		"short"		// Number of this full update
	}
}
