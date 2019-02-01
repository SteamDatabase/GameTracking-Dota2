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
		SteamAppId				570
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
			// These are optional language paths. They must be mounted first, which is why there are first in the list.
			// *LANGUAGE* will be replaced with the actual language name. If not running a specific language, these paths will not be mounted
			Game_Language		dota_*LANGUAGE*

			// These are optional low-violence paths. They will only get mounted if you're in a low-violence mode.
			Game_LowViolence	dota_lv

			Game				dota
			Game				core

			Mod					dota

			AddonRoot			dota_addons

			// Note: addon content is included in publiccontent by default.
			PublicContent		dota_core
			PublicContent		core
		}

		AddonsChangeDefaultWritePath 0
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
		"UsesVGui" "0"
		"UsesScaleform" "1"
		"UsesPanorama" "1"
		"PanoramaUIClientFromClient" "1" // IPanoramaUIClient is implemented by client.dll
		"HasGameUI" "1" // dota uses gameui
		"GameUIFromClient" "1"  // AND that gameui comes from client.dll
		"URLName" "dota2"
		"MsaaOverrideType" "0"
		"UsesBink" "0"
        "MaxNetworkableEntities" "10000"
        "MaxNonNetworkableEntities" "10000"
        "DefaultDXVersion" "9"
        // The shader binary cache on Linux can be over 100MB so
        // we have to allow very large allocations.
		"AllocWarnMB_linuxsteamrt64" "200"
		// Also currently demo files are loaded entirely into
		// memory for 64-bit binaries so they can use well
		// over 100MB at load time.  Zoid is looking at
		// converting that to streaming.
		"AllocWarnMB_osx64" "200"
		"AllocWarnMB_pc64" "200"
		"AllocWarnMB" "100"
		// There are some known large virtual reservations, such as the SBH, which
		// bypass this limit so we can be fairly conservative.
		"ReserveWarnMB" "64"

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

	SceneFileCache
	{
		"ServerUsesSceneImageFile" "0"
	}

	SceneSystem
	{
		"NoSunLightManager" "1"
		"TransformTextureRowCount" "256"
		"CMTAtlasWidth" "512"
		"CMTAtlasHeight" "512"
		"CMTAtlasChunkSize" "128"
		"DrawParticleChildrenSeparateFromParents" "1"
	}
	
	SoundSystem
	{
		"DisableSteamAudio" "1"
		"DefaultWindowsXAudio" "1"
	}

	ToolsEnvironment
	{
		"Engine"	"Source 2"
		"ToolsDir"	"../sdktools"	// NOTE: Default Tools path. This is relative to the mod path.
		"DeveloperHelpURL" "https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools"
		"ToolsProductName" "Dota2 Workshop Tools"
	}
	
	Hammer
	{
		"fgd"					"dota.fgd"	// NOTE: This is relative to the 'mod' path.
		"GameFeatureSet"		"Dota"
		"LoadScriptEntities"	"0"
		"DefaultTextureScale"	"0.250000"
		"DefaultSolidEntity"	"trigger_dota"
		"DefaultPointEntity"	"info_player_start_dota"
		"NavMarkupEntity"		"func_nav_markup"
		"EnableDotaTools"		"1"
		"DefaultGridTileSet"	"/maps/tilesets/radiant_basic.vmap"
		"DefaultGridTileSet2"	"/maps/tilesets/dire_basic.vmap"
		"DotaMaxTrees"			"8000"
		"AddonMapCommand"		"dota_launch_custom_game"
		"PostMapLoadCommands"	"jointeam good" // Commands sent to the console by hammer after it finishes building a map and loads it
		"RequiredGameEntities"	"info_player_start_goodguys|info_player_start_dota; info_player_start_badguys|info_player_start_dota; env_global_light; ent_dota_game_events"
		"UnitsFiles"			"scripts/npc/npc_units.txt; scripts/npc/npc_units_custom.txt; scripts/npc/npc_heroes.txt"
		"ItemsFiles"			"scripts/npc/items.txt; scripts/npc/npc_items_custom.txt"
		"OverlayBoxSize"		"16"
		"TileGridBlendOrderBGRA"	"1"
		"TileGridBlendDefaultColor"	"0 255 0"
	}

	MaterialEditor
	{
		"DefaultShader"			"global_lit_simple"
		"ExpressionHelpUrl"		"https://intranet.valvesoftware.com/index.php/Source_2.0/Shader_Format#Shader.2FMaterial_Expression_Syntax"
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
		"DotaTileGrid"	"1"
	}

	RenderPipelineAliases
	{
		"Tools"			"Dota:Forward"
		"EnvMapBake"	"Dota"
	}
	
	RenderSystem
	{
		// rendersystemvulkan setting that determines how many partitions scenesystem places
		// in each job. The higher the number, the more work per command buffer. Vulkan has higher 
		// cost per command buffer than software contexts so settings this higher reduces 
		// overall number of command buffers.
		"VulkanSceneSystemJobCost"		"2"
	}
}
