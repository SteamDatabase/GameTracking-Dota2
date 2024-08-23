"GameInfo"
{
	//
	// gameinfo.gi is the non-branch-varying content and can be integrated between branches.
	// Branch-varying info, such as the game/title and app IDs, is in gameinfo_branchspecific.gi.
	//

	gamelogo 1
	type		multiplayer_only

	nomodels 1
	nohimodel 1
	nocrosshair 0
	GameData	"dota.fgd"
	nodegraph 0
	tonemapping 0 // Hide tonemapping ui in tools mode

	FileSystem
	{
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

			Write				dota

			// These are optional language paths. They must be mounted first, which is why there are first in the list.
			// *LANGUAGE* will be replaced with the actual language name. If not running a specific language, these paths will not be mounted
			AddonRoot_Language	dota_*LANGUAGE*_addons

			AddonRoot			dota_addons

			// Note: addon content is included in publiccontent by default.
			PublicContent		dota_core
			PublicContent		core
		}
		
		"UserSettingsPathID"	"USRLOCAL"
		"LegacyUserSettingsPathID"	"MOD"
				
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
		"PanoramaUIClientFromClient" "1" // IPanoramaUIClient is implemented by client.dll
		"HasLegacyGameUI" "1" // dota uses some legacy gameui systems
		"URLName" "dota2"
		"MsaaOverrideType" "0"
        "MaxNetworkableEntities" "10000"
        "MaxNonNetworkableEntities" "10000"
        // The shader binary cache on non-Windows can be over 500MB.
		// Also currently demo files are loaded entirely into memory for
		// 64-bit binaries so they can easily use 100's of MB at load time.
        // Go ahead and allow very large allocations, essentially removing this warning.
		"AllocWarnMB" "2000"
		"ReserveWarnMB" "64"

		"DefaultRenderSystem"					"-vulkan" [ $LINUX || $OSX ] // macOS/Linux default to Vulkan
		"SupportsVulkanParticleOptimizations"	"1"

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

		"NoResetInputOnGameOverlay" "1"
	}

	SceneFileCache
	{
		"ServerUsesSceneImageFile" "0"
	}

	SceneSystem
	{
		"SunLightManagerCount" "0"
		"TransformTextureRowCount" "2048"
		"CMTAtlasWidth" "1024"
		"CMTAtlasHeight" "512"
		"CMTAtlasChunkSize" "128"
		"DrawParticleChildrenSeparateFromParents" "1"
		"MaxAutoPartitions" "8"
		"LayerBatchThreshold" "512" [ $OSX && $CPU_EMULATED ] // Apple M1 - increase sc_layer_batch_threshold from 128 -> 512. Reduces TBDR memory bandwidth.
	}

	SoundSystem
	{
		"SteamAudioEnabled" "0"
		"snd_event_browser_default_stack" "dota_update_default"
	}

	ToolsEnvironment
	{
		"Engine"	"Source 2"
		"ToolsDir"	"../sdktools"	// NOTE: Default Tools path. This is relative to the mod path.
		"DeveloperHelpURL" "https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools"
		"ToolsProductName" "Dota2 Workshop Tools"
		"HideCoreMod"	"1"
		"SupportsActivities"	"1"
	}

	Hammer
	{
		"fgd"						"dota.fgd"	// NOTE: This is relative to the 'mod' path.
		"GameFeatureSet"			"Dota"
		"LoadScriptEntities"		"0"
		"DefaultTextureScale"		"0.250000"
		"DefaultSolidEntity"		"trigger_dota"
		"DefaultPointEntity"		"info_player_start_dota"
		"NavMarkupEntity"			"func_nav_markup"
		"EnableDotaTools"			"1"
		"DefaultGridTileSet"		"/maps/tilesets/radiant_basic.vmap"
		"DefaultGridTileSet2"		"/maps/tilesets/dire_basic.vmap"
		"DotaMaxTrees"				"8000"
		"AddonMapCommand"			"dota_launch_custom_game"
		"PostMapLoadCommands"		"jointeam good" // Commands sent to the console by hammer after it finishes building a map and loads it
		"RequiredGameEntities"		"info_player_start_goodguys|info_player_start_dota; info_player_start_badguys|info_player_start_dota; env_global_light; ent_dota_game_events"
		"UnitsFiles"				"scripts/npc/npc_units.txt; scripts/npc/npc_units_staging.txt; scripts/npc/npc_units_custom.txt; scripts/npc/npc_heroes.txt; scripts/npc/npc_heroes_staging.txt"
		"ItemsFiles"				"scripts/npc/items.txt; scripts/npc/items_staging.txt; scripts/npc/npc_items_custom.txt"
		"OverlayBoxSize"			"16"
		"TileGridBlendOrderBGRA"	"1"
		"TileGridBlendDefaultColor"	"0 255 0"
		"UseFirstAnimationAsDefault" "1"
	}

	MaterialEditor
	{
		"DefaultShader"			"global_lit_simple"
		"ExpressionHelpUrl"		"https://intranet.valvesoftware.com/index.php/Source_2.0/Shader_Format#Shader.2FMaterial_Expression_Syntax"
	}

	ModelCompile
	{
	}
	
	ModelDoc
	{
		"models_gamedata"			"models_gamedata.fgd"
		"features"					"econitems;editorconfig"
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

		"DeprecatedBehaviorVersionsAllowed"	"1"

		MeshCompiler
		{
			EncodeVertexBuffer      "1"
			EncodeIndexBuffer       "1"
		}

		WorldRendererBuilder
		{
			UseAggregateInstances       	    "1"
			VisibilityGuidedMeshClustering      "1"
			MinimumTrianglesPerClusteredMesh    "512"
			MinimumVerticesPerClusteredMesh     "512"
			MinimumVolumePerClusteredMesh       "1024"
			MaxPrecomputedVisClusterMembership  "16"
		}
		SoundStackScripts
		{
			CompilerVersion "1"
		//	CompileForCompare "1"
		}

		ExperimentalVDataLocalization
		{
			GameOutputPath	"resource/localization/vdata"
			TokenPrefix		"DOTA_VData_"
		}
	}

	RenderPipelineAliases
	{
		"Tools"			"Dota:Forward"
		"EnvMapBake"	"Dota"
	}
	
	Particles
	{
		"GameSupportsLegacyShaders"			"1"
		"features"							"no_gpu_blobs"
	}

	RenderSystem
	{
		SwapChainSampleableDepth 1
		"VulkanSteamShaderCache"			"1"
		"OpenGLForceSM30"					"1"
		"LowLatency"						"1"
	}

	vdata_editor
	{
		"fgd"				"vdata_dota.fgd"
	}

	ConVars
	{
		"r_size_cull_threshold"		"0.4"
		"cl_predict"				"0"
		"cl_usesocketsforloopback" "1"
		"sv_early_network_message_processing" "1"
		"disable_source_soundscape_trace" "1"
	}

	pulse
	{
		"pulse_enabled"					"1"
	}
}

