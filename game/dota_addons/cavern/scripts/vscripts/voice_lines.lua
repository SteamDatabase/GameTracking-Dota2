
--------------------------------------------------------------------------------

_G.g_Laughs =
{
	npc_dota_creature_sniper =
	{
		"sniper_snip_laugh_02",
		"sniper_snip_laugh_03",
		"sniper_snip_laugh_04",
		"sniper_snip_laugh_05",
		"sniper_snip_laugh_06",
		"sniper_snip_laugh_07",
		"sniper_snip_laugh_08",
		"sniper_snip_laugh_09",
	},

	npc_dota_creature_enigma =
	{
		"enigma_enig_laugh_01",
		"enigma_enig_laugh_02",
		"enigma_enig_laugh_03",
		"enigma_enig_laugh_04",
		"enigma_enig_laugh_05",
		"enigma_enig_laugh_06",
		"enigma_enig_laugh_07",
		"enigma_enig_laugh_08",
	},
}

--------------------------------------------------------------------------------

_G.g_StandardTaunts =
{
	npc_dota_creature_sniper =
	{
		"sniper_snip_ability_shrapnel_02",
		"sniper_snip_ability_shrapnel_03",
		"sniper_snip_ability_shrapnel_05",
		"sniper_snip_ability_shrapnel_06",
		"sniper_snip_ability_shrapnel_07",
		"sniper_snip_tf2_02",
		"sniper_snip_tf2_04",
	},
}

--------------------------------------------------------------------------------

_G.g_DeathTaunts =
{
	npc_dota_creature_sniper =
	{
		"sniper_snip_kill_01",
		"sniper_snip_kill_02",
		"sniper_snip_kill_03",
		"sniper_snip_kill_04",
		"sniper_snip_kill_05",
		"sniper_snip_kill_06",
		"sniper_snip_kill_07",
		"sniper_snip_kill_08",
		"sniper_snip_kill_09",
		"sniper_snip_kill_10",
		"sniper_snip_kill_11",
		"sniper_snip_kill_12",
		"sniper_snip_kill_13",
		"sniper_snip_kill_14",
	},

	npc_dota_creature_enigma =
	{
		"enigma_enig_kill_01",
		"enigma_enig_kill_02",
		"enigma_enig_kill_03",
		"enigma_enig_kill_04",
		"enigma_enig_kill_05",
		"enigma_enig_kill_06",
		"enigma_enig_kill_07",
		"enigma_enig_kill_08",
		"enigma_enig_kill_09",
		"enigma_enig_kill_10",
		"enigma_enig_kill_11",
		"enigma_enig_kill_12",
	},
}

--------------------------------------------------------------------------------

_G.g_AbilityLines =
{
	--[[
	npc_dota_creature_ice_boss =
	{
		ice_boss_shatter_projectile =
		{
			Chance = 33,
			Lines =
			{
				"winter_wyvern_winwyv_arctic_burn_01",
				"winter_wyvern_winwyv_arctic_burn_02",
			},
		},
	},
	]]
}

_G.VictoryLines =
{
	"announcer_ann_custom_victory_02", -- yellow
	"announcer_ann_custom_victory_04", -- orange
	"announcer_ann_custom_victory_06", -- blue
	"announcer_ann_custom_victory_10", -- green
	"announcer_ann_custom_victory_08", -- brown
	"announcer_ann_custom_victory_09", -- cyan
	"announcer_ann_custom_victory_07", -- olive
	"announcer_ann_custom_victory_05", -- purple
}

--------------------------------------------------------------------------------

function CCavern:FireLaugh( laughUnit )
	if laughUnit ~= nil then
		if laughUnit.flSpeechCooldown ~= nil and GameRules:GetGameTime() < laughUnit.flSpeechCooldown then
			return
		end
		local UnitLaughs = g_Laughs[laughUnit:GetUnitName()]
		if UnitLaughs ~= nil and #UnitLaughs > 0 then
			local szLaugh = UnitLaughs[ RandomInt( 1, #UnitLaughs ) ]
			laughUnit:EmitSoundParams( szLaugh, 0, VOICE_VOLUME, 0 )
			laughUnit.flSpeechCooldown = GameRules:GetGameTime() + VOICE_LINE_COOLDOWN
			laughUnit.flNextLaughTime = GameRules:GetGameTime() + VOICE_LAUGH_COOLDOWN
		end
	end
end

--------------------------------------------------------------------------------

function CCavern:FireTaunt( tauntUnit )
	if tauntUnit ~= nil then
		if tauntUnit.flSpeechCooldown ~= nil and GameRules:GetGameTime() < tauntUnit.flSpeechCooldown then
			return
		end
		local UnitTaunts = g_StandardTaunts[tauntUnit:GetUnitName()]
		if UnitTaunts ~= nil and #UnitTaunts > 0 then
			tauntUnit:EmitSoundParams( UnitTaunts[RandomInt( 1, #UnitTaunts )], 0, VOICE_VOLUME, 0 )
			tauntUnit.flSpeechCooldown = GameRules:GetGameTime() + ( VOICE_LINE_COOLDOWN * 2 )
			tauntUnit.flNextPeriodicTauntTime = GameRules:GetGameTime() + VOICE_PERIODIC_TAUNT_COOLDOWN
		end	
	end
end

--------------------------------------------------------------------------------

function CCavern:FireDeathTaunt( killerUnit )
	if killerUnit ~= nil then
		if killerUnit.flSpeechCooldown ~= nil and GameRules:GetGameTime() < killerUnit.flSpeechCooldown then
			return
		end
		local UnitDeathTaunts = g_DeathTaunts[killerUnit:GetUnitName()]
		if UnitDeathTaunts ~= nil and #UnitDeathTaunts > 0 then
			local szDeathTaunt = UnitDeathTaunts[ RandomInt( 1, #UnitDeathTaunts ) ]
			killerUnit:EmitSoundParams( UnitDeathTaunts[RandomInt( 1, #UnitDeathTaunts )], 0, VOICE_VOLUME, 0 )
			killerUnit.flSpeechCooldown = GameRules:GetGameTime() + VOICE_LINE_COOLDOWN
		end	
	end
end

--------------------------------------------------------------------------------

function CCavern:FireAbilityLine( casterUnit, szAbilityName )
	if casterUnit ~= nil and szAbilityName ~= nil then
		if casterUnit.flSpeechCooldown ~= nil and GameRules:GetGameTime() < casterUnit.flSpeechCooldown then
			return
		end
		local UnitAbilityLines = g_AbilityLines[casterUnit:GetUnitName()]
		if UnitAbilityLines ~= nil then
			local abilityLineData = UnitAbilityLines[szAbilityName]
			if abilityLineData ~= nil then
				local nChance = abilityLineData["Chance"]
				local thisAbilityLines = abilityLineData["Lines"]
				if thisAbilityLines ~= nil and #thisAbilityLines > 0 and RollPercentage( nChance ) then
					casterUnit:EmitSoundParams( thisAbilityLines[RandomInt( 1, #thisAbilityLines )], 0, VOICE_VOLUME, 0 )
					casterUnit.flSpeechCooldown = GameRules:GetGameTime() + VOICE_LINE_COOLDOWN
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
