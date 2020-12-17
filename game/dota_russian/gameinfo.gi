"GameInfo"
{
	game 		"Dota 2"
	title 		"Dota 2"

	gamelogo 1
	type		multiplayer_only

	nomodels 1
	nohimodel 1
	nocrosshair 0
	GameData	"dota.fgd"
	SupportsDX8	0
	nodegraph 0
	tonemapping 0 // Hide tonemapping ui in tools mode

	FileSystem
	{
		SteamAppId				570 // This will mount all the GCFs we need (240=CS:S, 220=HL2).
		BreakpadAppId			373300	// Report crashes under beta DLC, not the S1 game.  Delete this when all clients are switched to S2
		BreakpadAppId_Tools		375360  // Use a separate bucket of buckets for "-tools" crashes so that they don't get drowned out by game crashes. Falls back to BreakpadAppId/SteamAppId if missing
		
		//
		// The code that loads this file automatically does a few things here:
		//
		// 1. For each "Game" search path, it adds a "GameBin" path, in <dir>\bin
		// 2. For each "Game" search path, it adds another "Game" path in front of it with _<langage> at the end.
		//    For example: c:\hl2\cstrike on a french machine would get a c:\hl2\cstrike_french path added to it.
		// 3. For the first "Game" search path, it adds a search path called "MOD".
		// 4. For the first "Game" search path, it adds a search path called "DEFAULT_WRITE_PATH".
		//

		//
		// Search paths are relative to the exe directory\..\
		//
		SearchPaths
		{
			Game				dota_russian
			Game				dota
			Game				core

			Mod					dota_russian
			Mod					dota

			AddonRoot			dota_addons

			// Note: addon content is included in publiccontent by default.
			PublicContent		dota_core
			PublicContent		core
		}
	}

	MaterialSystem2
	{
		RenderModes
		{
			"game" "Default"
			"game" "DotaDeferred"
			"game" "DotaForward"
			"game" "Depth"

			"tools" "ToolsVis" // Visualization modes for all shaders (lighting only, normal maps only, etc.)
			"tools" "ToolsWireframe" // This should use the ToolsVis mode above instead of being its own mode
			"tools" "ToolsUtil" // Meant to be used to render tools sceneobjects that are mod-independent, like the origin grid
		}
	}

	Engine2
	{
		"HasModAppSystems" "1"
		"Capable64Bit" "1"
		"UsesScaleform" "1"
		"HasGameUI" "1" // dota uses gameui
		"GameUIFromClient" "1"  // AND that gameui comes from client.dll
		"URLName" "dota2"
		"UsesBink" "0"
		"RenderingPipeline"
		{
			"SkipPostProcessing" "1"
			"SupportsMSAA" "0"
		}
		
		"BugBait"
		{
			// Used by 'bug:' in chat to normalize report settings during playtests
			"Owner" "triage*" 
			"Severity" "high"
			"Priority" "none"
			"Category" "---"
			"Product" "dota"
			"Component" "dota"
		}
	}

	SceneSystem
	{
		"SunLightManagerCount" "0"
	}

	ToolsEnvironment
	{
		"Engine"	"Source 2"
		"ToolsDir"	"../sdktools"	// NOTE: Default Tools path. This is relative to the mod path.
		"DeveloperHelpURL" "https://intranet.valvesoftware.com/wiki/Source_2_SDK"
		"ToolsProductName" "Dota2 Workshop Tools"
	}
	
	Hammer
	{
		"fgd"					"../dota/dota.fgd"	// NOTE: This is relative to the 'mod' path.
		"GameFeatureSet"		"Dota"
		"LoadScriptEntities"	"0"
		"DefaultTextureScale"	"0.250000"
		"DefaultSolidEntity"	"trigger_multiple"
		"DefaultPointEntity"	"info_player_start_goodguys"
		"NavMarkupEntity"		"func_nav_markup"
		"EnableDotaTools"		"1"
		"DefaultGridTileSet"	"/maps/tilesets/radiant_basic.vmap"
		"DefaultGridTileSet2"	"/maps/tilesets/dire_basic.vmap"
		"AddonMapCommand"		"dota_launch_custom_game"
		"PostMapLoadCommands"	"jointeam good" // Commands sent to the console by hammer after it finishes building a map and loads it
		"RequiredGameEntities"	"info_player_start_goodguys; info_player_start_badguys; env_global_light; ent_dota_game_events"
	}

	MaterialEditor
	{
		"DefaultShader"			"hero"
	}
	
	ResourceCompiler
	{
		// Overrides of the default builders as specified in code, this controls which map builder steps
		// will be run when resource compiler is run for a map without specifiying any specific map builder
		// steps. Additionally this controls which builders are displayed in the hammer build dialog.
		DefaultMapBuilders
		{			
			"light"		"0"	// Dota does not use baked lighting
			"envmap"	"0"	// Dota doesn't generate environment maps from the map
			"gridnav"	"1"	// Dota generates its grid navigation data by default
		}
	}

	RenderPipelineAliases
	{
		"Tools"			"Dota"
		"EnvMapBake"	"Dota"
	}
}
