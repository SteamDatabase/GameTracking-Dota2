-- All blessing modifiers must be linked here
LinkLuaModifier( "modifier_blessing_bottle_upgrade", "modifiers/modifier_blessing_bottle_upgrade", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_armor", "modifiers/modifier_blessing_armor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_attack_speed", "modifiers/modifier_blessing_attack_speed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_evasion", "modifiers/modifier_blessing_evasion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_mana_boost", "modifiers/modifier_blessing_mana_boost", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_health_boost", "modifiers/modifier_blessing_health_boost", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_magic_resist", "modifiers/modifier_blessing_magic_resist", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_magic_damage_bonus", "modifiers/modifier_blessing_magic_damage_bonus", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_damage_bonus", "modifiers/modifier_blessing_damage_bonus", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_movement_speed", "modifiers/modifier_blessing_movement_speed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_damage_reflect", "modifiers/modifier_blessing_damage_reflect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_spell_life_steal", "modifiers/modifier_blessing_spell_life_steal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_life_steal", "modifiers/modifier_blessing_life_steal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_potion_arcanist", "modifiers/modifier_blessing_potion_arcanist", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_potion_dragon", "modifiers/modifier_blessing_potion_dragon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_potion_echo_slam", "modifiers/modifier_blessing_potion_echo_slam", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_potion_torrent", "modifiers/modifier_blessing_potion_torrent", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_potion_shadow_wave", "modifiers/modifier_blessing_potion_shadow_wave", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_potion_ravage", "modifiers/modifier_blessing_potion_ravage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_potion_purification", "modifiers/modifier_blessing_potion_purification", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_respawn_time_reduction", "modifiers/modifier_blessing_respawn_time_reduction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_respawn_invulnerability", "modifiers/modifier_blessing_respawn_invulnerability", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_death_detonation", "modifiers/modifier_blessing_death_detonation", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_strength", "modifiers/modifier_blessing_strength", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_agility", "modifiers/modifier_blessing_agility", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_intelligence", "modifiers/modifier_blessing_intelligence", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_potion_health", "modifiers/modifier_blessing_potion_health", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_potion_mana", "modifiers/modifier_blessing_potion_mana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_restore_mana", "modifiers/modifier_blessing_restore_mana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_book_strength", "modifiers/modifier_blessing_book_strength", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_book_agility", "modifiers/modifier_blessing_book_agility", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_book_intelligence", "modifiers/modifier_blessing_book_intelligence", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blessing_refresher_shard", "modifiers/modifier_blessing_refresher_shard", LUA_MODIFIER_MOTION_NONE )

-- Uncomment + change blessing modifier names for debugging
_G.BLESSING_MODIFIERS_FORCE_LIST =
{
--	modifier_blessing_bottle_upgrade = 1,	-- 1 is the claim count
--	modifier_blessing_armor = 1,
--	modifier_blessing_attack_speed = 1,
--	modifier_blessing_evasion = 1,
--	modifier_blessing_mana_boost = 1,
--	modifier_blessing_health_boost = 1,
--	modifier_blessing_magic_resist = 1,
--	modifier_blessing_magic_damage_bonus = 1,
--	modifier_blessing_damage_bonus = 1,
--	modifier_blessing_movement_speed = 1,
--	modifier_blessing_spell_life_steal = 1,
--	modifier_blessing_life_steal = 1,
--	grant_blessing_bonus_life = 1,
--	grant_blessing_potion_starting_mango = 1,
--	modifier_blessing_potion_arcanist = 1,
--	modifier_blessing_potion_dragon = 1,
--	modifier_blessing_potion_echo_slam = 1,
--	modifier_blessing_potion_torrent = 1,
--	modifier_blessing_potion_shadow_wave = 1,
--	modifier_blessing_potion_ravage = 1,
--	modifier_blessing_potion_purification = 1,
--	modifier_blessing_respawn_time_reduction = 1,
--	modifier_blessing_potion_health = 1,
--	modifier_blessing_potion_mana = 1,
--	modifier_blessing_restore_mana = 1,
--	grant_blessing_gold_start_bonus = 1,
--	modifier_blessing_respawn_invulnerability = 1,
--	modifier_blessing_death_detonation = 1,
--	modifier_blessing_book_strength = 1,
--	modifier_blessing_book_agility = 1,
--	modifier_blessing_book_intelligence = 1,
--	modifier_blessing_intelligence = 1,
--	modifier_blessing_refresher_shard = 1,
}

_G.BLESSING_MODIFIERS =
{
--	example_blessing_modifier_name =
--	{
--		action_name = <associated action name>,
--		keys = 
--		{
--			<keys>
--		}
--	},
--
--  This version allows you to specify different keys per action level
--	example_blessing_modifier_name =
--	{
--		action_name = <associated action name>,
--		keys = 
--		{
--			{
--				<keys for level 1 blessing>
--			},
--			{
--				<keys for level 2 blessing>
--			},
--		}
--	},

	grant_blessing_potion_starting_mango =
	{
		scoreboard_order = 1,
		action_name = "blessing_potion_starting_mango",
		blessing_type = BLESSING_TYPE_ITEM_GRANT,
		keys =
		{
			items =
			{
				item_flask = 1,
				item_enchanted_mango = 1,
			}
		}
	},

	modifier_blessing_bottle_upgrade =
	{
		scoreboard_order = 1,
		action_name = "blessing_bottle_upgrade",
		keys =
		{
			max_charges = 1,
		},
	},

	-- Str Tree
	modifier_blessing_strength =
	{
		scoreboard_order = 102,
		action_names = 
		{
			"blessing_stat_str",
			"blessing_stat_str_2",
			"blessing_stat_str_3",
		},
		keys =
		{
			{
				str_bonus = 2
			},
			{
				str_bonus = 5
			},
			{
				str_bonus = 9
			},
		},
	},	

	modifier_blessing_book_strength =
	{
		scoreboard_order = 101,
		action_name = "blessing_book_strength",
		keys =
		{
			bonus_stat = 1
		},
	},

	modifier_blessing_armor =
	{
		scoreboard_order = 206,
		action_name = "blessing_armor_bonus",
		keys = 
		{
			bonus_armor = 2
		},
	},

	modifier_blessing_potion_health =
	{
		scoreboard_order = 103,
		action_name = "blessing_potion_health",
		keys =
		{
			hp_restore_pct_bonus = 20
		},
	},

	modifier_blessing_respawn_time_reduction =
	{
		scoreboard_order = 104,
		action_name = "blessing_respawn_time_reduction",
		keys =
		{
			respawn_time_reduction = 0.25
		},
	},

	modifier_blessing_potion_echo_slam =
	{
		scoreboard_order = 205,
		action_name = "blessing_potion_echo_slam",
		keys =
		{
			echo_slam_echo_damage_percent = 40,
		}
	},	

	modifier_blessing_health_boost =
	{
		scoreboard_order = 100,
		action_name = "blessing_health_boost",
		keys = 
		{
			bonus_health_per_level = 10
		},
	},

	modifier_blessing_damage_reflect =
	{
		scoreboard_order = 112,
		action_name = "blessing_damage_reflection",
		keys =
		{
			damage_reflect = 0.04
		}
	},

	modifier_blessing_potion_torrent =
	{
		scoreboard_order = 110,
		action_name = "blessing_potion_torrent",
		keys =
		{
			torrent_damage_percent = 50,
		}
	},	

	modifier_blessing_refresher_shard =
	{
		scoreboard_order = 11,
		action_name = "blessing_refresher_shard",
		keys =
		{
			health_restore_percent = 50,
		}
	},	

	grant_blessing_bonus_life =
	{
		scoreboard_order = 312,
		action_name = "blessing_bonus_life",
		blessing_type = BLESSING_TYPE_LIFE_GRANT,
		keys =
		{
			lives = 1,
		}
	},

	-- Agi tree
	modifier_blessing_agility =
	{
		scoreboard_order = 202,
		action_names = 
		{
			"blessing_stat_agi",
			"blessing_stat_agi_2",
			"blessing_stat_agi_3",
		},
		keys =
		{
			{
				agi_bonus = 2
			},
			{
				agi_bonus = 5
			},
			{
				agi_bonus = 9
			},
		},
	},	

	modifier_blessing_evasion =
	{
		scoreboard_order = 207,
		action_name = "blessing_evasion",
		keys = 
		{
			bonus_evasion = 5
		},
	},

	modifier_blessing_attack_speed =
	{
		scoreboard_order = 200,
		action_name = "blessing_attack_speed",
		keys = 
		{
			bonus_attack_speed = 10
		},
	},

	modifier_blessing_book_agility =
	{
		scoreboard_order = 201,
		action_name = "blessing_book_agility",
		keys =
		{
			bonus_stat = 1
		},
	},

	grant_blessing_gold_start_bonus =
	{
		scoreboard_order = 203,
		action_name = "blessing_gold_start_bonus",
		blessing_type = BLESSING_TYPE_GOLD_GRANT,
		keys =
		{
			gold_amount = 125,
		}
	},

	modifier_blessing_potion_purification =
	{
		scoreboard_order = 107,
		action_name = "blessing_potion_purification",
		keys =
		{
			radius_percent = 100,
		}
	},	

	modifier_blessing_life_steal =
	{
		scoreboard_order = 109,
		action_name = "blessing_life_steal",
		keys =
		{
			life_steal_pct = 5
		},
	},

	modifier_blessing_respawn_invulnerability =
	{
		scoreboard_order = 204,
		action_name = "blessing_respawn_invulnerability",
		keys =
		{
			respawn_invulnerability_time_bonus = 0.0,
			min_move_speed = 550,
			bonus_attack_speed = 50,
		},
	},

	modifier_blessing_potion_arcanist =
	{
		scoreboard_order = 304,
		action_name = "blessing_potion_arcanist",
		keys =
		{
			cooldown_reduction_percent = 50,
			manacost_reduction_percent = 50,
		},
	},

	modifier_blessing_potion_dragon =
	{
		scoreboard_order = 211,
		action_name = "blessing_potion_dragon",
		keys =
		{
			bonus_attack_damage_percent = 25,
		},
	},

	modifier_blessing_movement_speed =
	{
		scoreboard_order = 210,
		action_name = "blessing_movement_speed",
		keys = 
		{
			bonus_movement_speed = 8
		},
	},

	modifier_blessing_damage_bonus =
	{
		scoreboard_order = 212,
		action_name = "blessing_damage_bonus",
		keys = 
		{
			bonus_damage = 2
		},
	},

	-- Int tree
	modifier_blessing_intelligence =
	{
		scoreboard_order = 302,
		action_names = 
		{
			"blessing_stat_int",
			"blessing_stat_int_2",
			"blessing_stat_int_3",
		},
		keys =
		{
			{
				int_bonus = 2
			},
			{
				int_bonus = 5
			},
			{
				int_bonus = 9
			},
		},
	},	

	modifier_blessing_book_intelligence =
	{
		scoreboard_order = 303,
		action_name = "blessing_book_intelligence",
		keys =
		{
			bonus_stat = 1
		},
	},

	modifier_blessing_mana_boost =
	{
		scoreboard_order = 300,
		action_name = "blessing_mana_boost",
		keys = 
		{
			bonus_mana = 10
		},
	},

	modifier_blessing_potion_mana =
	{
		scoreboard_order = 301,
		action_name = "blessing_potion_mana",
		keys =
		{
			mana_restore_pct_bonus = 20
		},
	},

	modifier_blessing_spell_life_steal =
	{
		scoreboard_order = 311,
		action_name = "blessing_spell_life_steal",
		keys =
		{
			spell_life_steal = 5
		},
	},

	modifier_blessing_potion_shadow_wave =
	{
		scoreboard_order = 106,
		action_name = "blessing_potion_shadow_wave",
		keys =
		{
			damage_percent = 50,
		}
	},	

	modifier_blessing_death_detonation =
	{
		scoreboard_order = 105,
		action_name = "blessing_death_detonation",
		keys =
		{
			detonation_damage_per_level = 100,
			detonation_radius = 350,
		},
	},

	modifier_blessing_magic_resist =
	{
		scoreboard_order = 307,
		action_name = "blessing_magic_resist",
		keys = 
		{
			bonus_magic_resist = 5
		},
	},

	modifier_blessing_potion_ravage =
	{
		scoreboard_order = 308,
		action_name = "blessing_potion_ravage",
		keys =
		{
			duration_percent = 50,
		}
	},	

	modifier_blessing_restore_mana =
	{
		scoreboard_order = 305,
		action_name = "blessing_restore_mana",
		keys =
		{
			mana_on_kill = 6
		},
	},

	modifier_blessing_magic_damage_bonus =
	{
		scoreboard_order = 309,
		action_name = "blessing_magic_damage_bonus",
		keys = 
		{
			bonus_magic_damage = 6
		},
	},
}