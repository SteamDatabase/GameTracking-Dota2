require('minigames/taunt_game')
require('minigames/techies_game')
require('minigames/chain_frost_game')
require('minigames/crystal_maiden_game')
require('minigames/zuus_race')
require('minigames/mirana_arrow_game')
require('minigames/necro_game')
require('minigames/pudge_wars_game')
require('minigames/shadowfiend_wars')
require('minigames/remote_mine_game')
require('minigames/monkey_king_game')
require('minigames/earth_spirit_soccer')
require('minigames/druid_game')
require('minigames/drow_archer_game')
require('minigames/ogre_seal_game')
require('minigames/ogre_game')
require('minigames/bloodseeker_game')
require('minigames/spirit_breaker_race')
require('minigames/zombie_game')
require('minigames/ursa_game')
require('minigames/invoker_leader_game')
require('minigames/furion_teleport_game')
require('minigames/spirit_breaker_game')
require('minigames/templar_game')
require('minigames/campfire_survival')
require('minigames/enchantress_game')
require('minigames/techies_sumo_game')
require('minigames/snowball_game')
require('minigames/fire_trap_game')
require('minigames/storegga_game')
require('minigames/antimage_game')
require('minigames/timbersaw_game')


tMINIGAME_INIT_TABLE = {
	-- snowball_game = {
	-- 	name = "Snowball",
	-- 	description = "",
	-- 	hero = {
	-- 		heroName = "npc_dota_hero_tusk",
	-- 		health = 100,
	-- 		mana = 0,
	-- 		abilities = {
	-- 			"snowball_lua",
	-- 		},			
	-- 	},
	-- 	arena = "snow_medium",
	-- 	game = SnowballGame:new{duration=-1},
	-- },

	taunt_game = {
		name = "DOTA_Frostivus_2017_Suicidal_Axe_Name",
		description = "DOTA_Frostivus2017_Suicidal_Axe_Desc",
		hero = {
			heroName = "npc_dota_hero_axe",
			health = 100,
			mana = 100,
			abilities = {
				"custom_berserkers_call",
			},			
		},
		arena = "snow_small",
		game = TauntGame:new{duration=120},
	},

	suicidal_pudge_game = {
		name = "DOTA_Frostivus_2017_Suicidal_Pudge_Name",
		description = "DOTA_Frostivus2017_Suicidal_Pudge_Desc",
		hero = {
			heroName = "npc_dota_hero_crystal_maiden",
			health = 100,
			mana = 100,
			manaRegen = .6,
			moveSpeed = 275,
			abilities = {
				"custom_frostbite",
			},			
		},
		arena = "snow_small",
		game = SuicidalPudgeGame:new{duration=180},
	},

	chain_frost_game = {
		name = "DOTA_Frostivus_2017_Chain_Frost_Tag_Name",
		description = "DOTA_Frostivus2017_Chain_Frost_Tag_Desc",
		hero = {
			heroName = "npc_dota_hero_terrorblade",
			health = 1000,
			healthRegen = 1.65,
			mana = 300,
			manaRegen = .65,
			abilities = {
				"conjure_image_lua",
			},			
		},
		arena = "snow_small",
		game = ChainFrostGame:new{duration=120},
	},

	remote_mine_game = {
		name = "DOTA_Frostivus_2017_Minefield_Survival_Name",
		description = "DOTA_Frostivus2017_Minefield_Survival_Desc",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_techies",
			health = 100,
			healthRegen = 1,
			mana = 0,
			abilities = {
			},			
		},
		arena = "snow_small",
		game = RemoteMineGame:new{duration=120},
	},

	zuus_race = {
		name = "DOTA_Frostivus_2017_Minefield_Racing_Name",
		description = "DOTA_Frostivus2017_Minefield_Racing_Desc",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_zuus",
			health = 100,
			healthRegen = 1,
			mana = 100,
			manaRegen = .165,
			vision = 9000,
			moveSpeed = 250,
			abilities = {
				"lightning_bolt_lua",
				"place_land_mine_lua"
			},			
		},
		arena = "snow_race",
		game = ZuusRaceGame:new{duration=180},
	},

	mirana_arrow_game = {
		name = "DOTA_Frostivus_2017_Arrow_Practice_Name",
		description = "DOTA_Frostivus2017_Arrow_Practice_Desc",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_mirana",
			health = 100,
			mana = 100,
			vision = 9000,
			abilities = {
				"mirana_arrow_lua"
			},			
		},
		arena = "snow_long",
		game = MiranaArrowGame:new{duration=120},
	},

	necro_game = {
		name = "DOTA_Frostivus_2017_Survive_the_Winter_Name",
		description = "DOTA_Frostivus2017_Survive_the_Winter_Desc",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_queenofpain",
			health = 100,
			mana = 100,
			abilities = {
			},			
		},
		arena = "snow_arena",
		game = NecroGame:new{duration=120},
	},

	pudge_wars = {
		name = "DOTA_Frostivus_2017_Pudge_Wars_Name",
		description = "DOTA_Frostivus2017_Pudge_Wars_Desc",
		hero = {
			heroName = "npc_dota_hero_pudge",
			health = 100,
			healthRegen = 1.5,
			mana = 200,
			manaRegen = .5,
			abilities = {
				"custom_pudge_meat_hook",
			},			
		},
		arena = "snow_arena",
		game = PudgeWars:new{duration=120},
	},

	-- shadowfiend_wars = {
	-- 	name = "Shadowfiend Wars",
	-- 	description = "Get points by killing other players",
	-- 	hero = {
	-- 		heroName = "npc_dota_hero_nevermore",
	-- 		health = 100,
	-- 		healthRegen = .35,
	-- 		mana = 100,
	-- 		abilities = {
	-- 			"custom_shadowraze1",
	-- 			"custom_shadowraze2",
	-- 			"custom_shadowraze3",
	-- 		},
	-- 	},
	-- 	arena = "snow_arena",
	-- 	game = ShadowfiendWars:new{duration=120},
	-- },

	-- monkey_king_game = {
	-- 	name = "Monkey Mischief",
	-- 	description = "Find and kill the 20 disguised Monkey Kings",
	-- 	hero = {
	-- 		heroName = "npc_dota_hero_lion",
	-- 		health = 100,
	-- 		mana = 100,
	-- 		vision = 9000,
	-- 		abilities = {
	-- 			"lion_finger_lua"
	-- 		},
	-- 	},
	-- 	arena = "snow_small",
	-- 	game = MonkeyKingGame:new{duration=120},
	-- },

	earth_spirit_game = {
		name = "DOTA_Frostivus_2017_Kaolin_Soccer_Name",
		description = "DOTA_Frostivus2017_Kaolin_Soccer_Desc",
		hero = {
			heroName = "npc_dota_hero_earth_spirit",
			health = 100,
			mana = 100,
			moveSpeed = 360,
			abilities = {
				"earth_spirit_kick_lua",
			},
		},
		arena = "snow_small",
		game = EarthSpiritGame:new{duration=120},
	},

	-- druid_game = {
	-- 	name = "Boar, Bear, Hawk",
	-- 	description = "Last Druid Standing",
	-- 	hero = {
	-- 		heroName = "npc_dota_hero_lone_druid",
	-- 		health = 300,
	-- 		mana = 100,
	-- 		manaRegen = .4,
	-- 		noWearables = true,
	-- 		abilities = {
	-- 			"shapeshift_bear_lua",
	-- 			"shapeshift_boar_lua",				
	-- 			"shapeshift_hawk_lua",
	-- 		},
	-- 	},
	-- 	arena = "snow_arena",
	-- 	game = DruidGame:new{duration=180},
	-- },

	archer_wars = {
		name = "DOTA_Frostivus_2017_Archer_Wars_Name",
		description = "DOTA_Frostivus2017_Archer_Wars_Desc",
		hero = {
			heroName = "npc_dota_hero_drow_ranger",
			health = 100,
			healthRegen = .6,
			mana = 100,
			armor = 3,
			abilities = {
				"drow_shoot_arrow_lua",
			},
		},
		arena = "snow_arena",
		game = DrowArcherGame:new{duration=180},
	},

	ogre_seal_game = {
		name = "DOTA_Frostivus_2017_Ogre_Seal_Survival_Name",
		description = "DOTA_Frostivus2017_Ogre_Seal_Survival_Desc",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_vengefulspirit",
			health = 100,
			healthRegen = .8,
			mana = 100,
			abilities = {
				"custom_nether_swap",
			},
		},
		arena = "snow_small",
		game = OgreSealGame:new{duration=120},
	},

	ogre_game = {
		name = "DOTA_Frostivus_2017_Ogre_Survival_Name",
		description = "DOTA_Frostivus2017_Ogre_Survival_Desc",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_puck",
			health = 100,
			healthRegen = .8,
			mana = 100,
			abilities = {
				"custom_puck_phase_shift"
			},
		},
		arena = "snow_small",
		game = OgreGame:new{duration=120},
	},

	bloodseeker_game = {
		name = "DOTA_Frostivus_2017_Red_Light_Green_Light_Name",
		description = "DOTA_Frostivus2017_Red_Light_Green_Light_Desc",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_weaver",
			health = 100,
			mana = 100,
			moveSpeed = 150,
			vision = 9000,
			abilities = {
				"shukuchi_lua"
			},
		},
		arena = "snow_race",
		game = BloodseekerGame:new{duration=120},
	},

	spirit_breaker_race = {
		name = "DOTA_Frostivus_2017_Spirit_Breaker_Race_Name",
		description = "DOTA_Frostivus2017_Spirit_Breaker_Race_Desc",
		hero = {
			heroName = "npc_dota_hero_spirit_breaker",
			health = 100,
			mana = 100,
			abilities = {
				"race_charge_lua"
			},
		},
		arena = "race_lanes",
		game = SpiritBreakerRaceGame:new{duration=75},		
	},

	zombie_game = {
		name = "DOTA_Frostivus_2017_Zombies_Zombies_Zombies_Name",
		description = "DOTA_Frostivus2017_Zombies_Zombies_Zombies_Desc",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_sniper",
			health = 100,
			mana = 100,
			manaRegen = .25,
			armor = 3,
			abilities = {
				"sniper_ground_shot_lua",
			},
		},
		arena = "snow_arena",
		game = ZombieGame:new{duration=180},
	},

	ursa_game = {
		name = "DOTA_Frostivus_2017_Poke_the_Ogre_Name",
		description = "DOTA_Frostivus2017_Poke_the_Ogre_Desc",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_ursa",
			health = 1000,
			healthRegen = 1.35,
			mana = 100,
			manaRegen = .33,
			armor = 3,
			abilities = {
				"custom_overpower",
				"custom_fury_swipes",
			},
		},
		arena = "snow_small",
		game = UrsaGame:new{duration=120},
	},

	invoker_leader_game = {
		name = "DOTA_Frostivus_2017_Follow_the_Leader_Name",
		description = "DOTA_Frostivus2017_Follow_the_Leader_Desc",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_invoker",
			health = 5,
			mana = 0,
			modifierName = "modifier_rooted_lua",
			abilities = {				
				"invoker_quas_lua",
				"invoker_wex_lua",
				"invoker_exort_lua",
				"generic_hidden",
				"generic_hidden",
				"invoker_invoke_lua",
			},
		},
		arena = "snow_stage",
		game = InvokerLeaderGame:new{duration=120},
	},

	furion_teleport_game = {
		name = "DOTA_Frostivus_2017_Coin_Collection_Name",
		description = "DOTA_Frostivus2017_Coin_Collection_Desc",
		hero = {
			heroName = "npc_dota_hero_furion",
			health = 100,
			mana = 0,
			vision = 10000,
			abilities = {
				"furion_teleport_lua",
			},
		},
		arena = "snow_large_center",
		game = FurionTeleportGame:new{duration=75},
	},

	spirit_breaker_game = {
		name = "DOTA_Frostivus_2017_Spirit_Breaker_Sumo_Name",
		description = "DOTA_Frostivus2017_Spirit_Breaker_Sumo_Desc",
		hero = {
			heroName = "npc_dota_hero_spirit_breaker",
			health = 100,
			mana = 0,
			armor = 3,
			moveSpeed = 300,
			abilities = {
				"greater_bash_lua",
			},
		},
		arena = "snow_tiny",
		game = SpiritBreakerGame:new{duration=120},
	},

	templar_game = {
		name = "DOTA_Frostivus_2017_Refraction_Survival_Name",
		description = "DOTA_Frostivus2017_Refraction_Survival_Desc",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_templar_assassin",
			health = 3,
			mana = 100,
			modifierName = "modifier_rooted_lua",
			abilities = {
				"refraction_lua",
			},			
		},
		arena = "snow_stage",
		game = TemplarGame:new{duration=120},
	},

	-- campfire_survival = {
	-- 	name = "Campfire Survival",
	-- 	description = "Survive the blizzard by finding campfires to keep you warm",
	-- 	hero = {
	-- 		heroName = "npc_dota_hero_ancient_apparition",
	-- 		health = 100,
	-- 		mana = 100,
	-- 		vision = 1200,
	-- 		abilities = {
	-- 			"custom_cold_feet",
	-- 			"custom_ice_vortex",
	-- 		},			
	-- 	},
	-- 	arena = "snow_large",
	-- 	game = CampfireSurvivalGame:new{duration=-1},
	-- },

	enchantress_game = {
		name = "DOTA_Frostivus_2017_Impetus_Throwing_Contest_Name",
		description = "DOTA_Frostivus2017_Impetus_Throwing_Contest_Desc",
		hero = {
			heroName = "npc_dota_hero_enchantress",
			health = 100,
			mana = 0,
			items = {"item_blink_lua"},
			abilities = {
				"impetus_lua"
			},			
		},
		arena = "snow_medium",
		game = EnchantressGame:new{duration=75},
	},

	techies_sumo_game = {
		name = "DOTA_Frostivus_2017_Techies_Knockout_Name",
		description = "DOTA_Frostivus2017_Techies_Knockout_Desc",
		hero = {
			heroName = "npc_dota_hero_techies",
			health = 100,
			mana = 0,
			abilities = {
				"place_propulsion_mine_lua",
				"detonate_propulsion_mine_lua",
			},
		},
		arena = "snow_tiny",
		game = TechiesSumoGame:new{duration=120},
	},

	fire_trap_game = {
		name = "DOTA_Frostivus_2017_Fire_Trap_Race_Name",
		description = "DOTA_Frostivus2017_Fire_Trap_Race_Desc",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_sven",
			health = 100,
			mana = 0,
			abilities = {
			},
		},
		arena = "snow_race",
		game = FireTrapGame:new{duration=120},
	},

	-- storegga_game = {
	-- 	name = "Avalanche Survival",
	-- 	description = "Survive the avalanches caused by the elder tiny",
	-- 	hero = {
	-- 		heroName = "npc_dota_hero_tiny",
	-- 		health = 100,
	-- 		mana = 0,
	-- 		abilities = {
	-- 		},
	-- 	},
	-- 	arena = "snow_medium",
	-- 	game = StoreggaGame:new{duration=180},
	-- },

	antimage_game = {
		name = "DOTA_Frostivus_2017_An_End_To_All_Magic_Name",
		description = "DOTA_Frostivus2017_An_End_To_All_Magic_Desc",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_antimage",
			health = 100,
			mana = 100,
			abilities = {
				"custom_antimage_blink",
			},
		},
		arena = "snow_tiny",
		game = AntimageGame:new{duration=120},
	},

	timbersaw_game = {
		name = "DOTA_Frostivus_2017_Deforestation_Name",
		description = "DOTA_Frostivus2017_Deforestation_Desc",
		hero = {
			heroName = "npc_dota_hero_shredder",
			health = 100,
			mana = 0,
			abilities = {
				"whirling_death_lua",
				"timber_chain_lua",
				"generic_hidden",
				"generic_hidden",
				"generic_hidden",
				"chakram_lua",
				"chakram_return_lua",
			},
		},
		arena = "snow_large_center",
		game = TimbersawGame:new{duration=75},
	},
}

return tMINIGAME_INIT_TABLE