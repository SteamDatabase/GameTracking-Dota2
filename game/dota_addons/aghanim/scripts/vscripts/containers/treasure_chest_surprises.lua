
require( "rewards" )
require( "reward_tables" )
require( "map_encounter" )

function CAghanim:ChooseTreasureSurprise( hPlayerHero, hTreasureEnt )
	hTreasureEnt.nRewardSpawnDist = 64

	if hTreasureEnt.RoomReward ~= nil then
		self:SpawnRoomReward( hTreasureEnt )
		return
	end

	if hTreasureEnt.fNeutralItemChance == nil then
		printf( "ERROR -- ChooseTreasureSurprise(): No fNeutralItemChance specified for this chest." )
	end

	if hTreasureEnt.fItemChance == nil then
		printf( "ERROR -- ChooseTreasureSurprise(): No fItemChance specified for this chest." )
	end

	if hTreasureEnt.nTrapLevel == nil or hTreasureEnt.nTrapLevel <= 0 then
		printf( "ERROR -- ChooseTreasureSurprise(): Field \"nTrapLevel\" is missing or is 0 or less." )
	end

	if hTreasureEnt.fTrapChance == nil then
		printf( "ERROR -- ChooseTreasureSurprise(): No fTrapChance specified for this chest." )
	end

	if hTreasureEnt.szTraps == nil or #hTreasureEnt.szTraps == 0 then
		printf( "ERROR -- ChooseTreasureSurprise(): Field \"szTraps\" is missing or empty for this chest." )
	end

	--[[
	--These are initialized when the crate unit is spawned in map_encounter
	printf( "----------------------------------------" )
	printf( "  hTreasureEnt.fItemChance: %.2f", hTreasureEnt.fItemChance )
	printf( "  hTreasureEnt.fNeutralItemChance: %.2f", hTreasureEnt.fNeutralItemChance )
	printf( "  hTreasureEnt.fTrapChance: %.2f", hTreasureEnt.fTrapChance )
	]]

	local fNeutralItemThreshold = 1 - hTreasureEnt.fNeutralItemChance
	local fItemThreshold = fNeutralItemThreshold - hTreasureEnt.fItemChance
	local fTrapThreshold = fItemThreshold - hTreasureEnt.fTrapChance

	local fRandRoll = RandomFloat( 0, 1 )

	--[[
	printf( "----------------------------------------" )
	printf( "fRandRoll: %.2f", fRandRoll )
	printf( "fItemThreshold: %.2f", fItemThreshold )
	printf( "fNeutralItemThreshold: %.2f", fNeutralItemThreshold )
	printf( "fTrapThreshold: %.2f", fTrapThreshold )
	]]

	if fRandRoll >= fNeutralItemThreshold then
		self:CreateTreasureNeutralItemDrop( hPlayerHero, hTreasureEnt )
		--printf( "fRandRoll (%.2f) >= fNeutralItemThreshold (%.2f)", fRandRoll, fNeutralItemThreshold )
		return
	elseif fRandRoll >= fItemThreshold then
		self:CreateTreasureItemDrop( hPlayerHero, hTreasureEnt )
		--printf( "fRandRoll (%.2f) >= fItemThreshold (%.2f)", fRandRoll, fItemThreshold )
		return
	elseif fRandRoll >= fTrapThreshold then
		self:ChooseTreasureTrap( hPlayerHero, hTreasureEnt )
		--printf( "fRandRoll (%.2f) >= fTrapThreshold (%.2f)", fRandRoll, fTrapThreshold )
		return
	else
		self:CreateTreasureGoldDrop( hPlayerHero, hTreasureEnt )
		--printf( "else drop gold, fRandRoll was %.2f", fRandRoll )
		return
	end
end

---------------------------------------------------------------------------

function CAghanim:CreateTreasureNeutralItemDrop( hPlayerHero, hTreasureEnt )
	printf( "CreateTreasureNeutralItemDrop" )

	local nNeutralItemsToDrop = RandomInt( hTreasureEnt.nMinNeutralItems, hTreasureEnt.nMaxNeutralItems )

	for i = 1, nNeutralItemsToDrop do
		local hCurrentEncounter = self:GetCurrentRoom():GetEncounter()
		hCurrentEncounter:DropNeutralItemFromUnit( hTreasureEnt, hPlayerHero, true )
	end
end

---------------------------------------------------------------------------

function CAghanim:CreateTreasureItemDrop( hPlayerHero, hTreasureEnt )
	printf( "CreateTreasureItemDrop" )
	if hTreasureEnt ~= nil and hTreasureEnt.Items ~= nil then
		local nItemsToDrop = RandomInt( hTreasureEnt.nMinItems, hTreasureEnt.nMaxItems )

		for i = 1, nItemsToDrop do
			local nRandomIndex = RandomInt( 1, #hTreasureEnt.Items )
			local newItem = CreateItem( hTreasureEnt.Items[ nRandomIndex ], nil, nil )
			local drop = CreateItemOnPositionForLaunch( hTreasureEnt:GetAbsOrigin(), newItem )

			local vPos = self:GetChestRewardSpawnPos( hTreasureEnt )

			newItem:LaunchLootInitialHeight( false, 0, 200, 0.75, vPos )

			EmitSoundOn( "Dungeon.TreasureItemDrop", hTreasureEnt )

			local gameEvent = {}
			gameEvent["player_id"] = hPlayerHero:GetPlayerID()
			gameEvent["team_number"] = DOTA_TEAM_GOODGUYS
			gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_" .. newItem:GetAbilityName()
			gameEvent["message"] = "#Dungeon_FoundChestItem"
			FireGameEvent( "dota_combat_event_message", gameEvent )
		end
	end
end

---------------------------------------------------------------------------

function CAghanim:ChooseTreasureTrap( hPlayerHero, hTreasureEnt )
	printf( "ChooseTreasureTrap" )
	local szTrapToUse = hTreasureEnt.szTraps[ RandomInt( 1, #hTreasureEnt.szTraps ) ]
	--printf( "szTrapToUse == \"%s\"", szTrapToUse )

	if szTrapToUse == "creature_techies_land_mine" then
		self:CreateTreasureMineTrap( hPlayerHero, hTreasureEnt )
	elseif szTrapToUse == "trap_sun_strike" then
		self:CreateTreasureSunStrikeTrap( hPlayerHero, hTreasureEnt )
	end
end

---------------------------------------------------------------------------

function CAghanim:CreateTreasureMineTrap( hPlayerHero, hTreasureEnt )
	printf( "CreateTreasureMineTrap()" )
	local szAbilityName = "creature_techies_land_mine"
	local hLandMineAbility = hTreasureEnt:FindAbilityByName( szAbilityName )
	if hLandMineAbility == nil then
		printf( "ERROR -- CreateTreasureMineTrap: \"%s\" is missing required ability \"%s\"", hTreasureEnt:GetUnitName(), szAbilityName )
		return
	end
	hLandMineAbility:SetLevel( hTreasureEnt.nTrapLevel )

	local vMinePos = hTreasureEnt:GetAbsOrigin()
	local hMine = CreateUnitByName( "npc_dota_creature_techies_land_mine", vMinePos, true, hTreasureEnt, hTreasureEnt, DOTA_TEAM_BADGUYS )
	if hMine ~= nil then
		hMine:AddNewModifier( hTreasureEnt, hLandMineAbility, "modifier_creature_techies_land_mine", { fadetime = 0 } )
		hMine:SetTeam( DOTA_TEAM_BADGUYS )
		local vAngles = hMine:GetAnglesAsVector()
		hMine:SetAngles( vAngles.x, 0, vAngles.z )
		EmitSoundOnLocationWithCaster( hMine:GetOrigin(), "TreasureChest.MineTrap.Plant", hMine )

		local gameEvent = {}
		gameEvent["player_id"] = hPlayerHero:GetPlayerID()
		gameEvent["team_number"] = DOTA_TEAM_GOODGUYS
		gameEvent["locstring_value"] = "npc_dota_creature_techies_land_mine"
		gameEvent["message"] = "#Dungeon_FoundChestTrap"
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end
end

---------------------------------------------------------------------------

function CAghanim:CreateTreasureSunStrikeTrap( hPlayerHero, hTreasureEnt )
	printf( "CreateTreasureSunStrikeTrap()" )
	local szAbilityName = "trap_sun_strike"
	local hSunStrikeAbility = hTreasureEnt:FindAbilityByName( szAbilityName )
	if hSunStrikeAbility == nil then
		printf( "ERROR -- CreateTreasureSunStrikeTrap: \"%s\" is missing required ability \"%s\"", hTreasureEnt:GetUnitName(), szAbilityName )
		return
	end
	hSunStrikeAbility:SetLevel( hTreasureEnt.nTrapLevel )

	hTreasureEnt:SetTeam( DOTA_TEAM_BADGUYS )

	local hEnemies = FindUnitsInRadius( hTreasureEnt:GetTeamNumber(), hTreasureEnt:GetOrigin(), hTreasureEnt, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy ~= nil and hEnemy:IsRealHero() then
			local kv = 
			{
				duration = hSunStrikeAbility:GetSpecialValueFor( "delay" ),
				area_of_effect = hSunStrikeAbility:GetSpecialValueFor( "area_of_effect" ),
				vision_distance = hSunStrikeAbility:GetSpecialValueFor( "vision_distance" ),
			 	vision_duration = hSunStrikeAbility:GetSpecialValueFor( "vision_duration" ),
				damage = hSunStrikeAbility:GetSpecialValueFor( "damage" ),
			}

			local vTarget = hEnemy:GetOrigin() -- + hEnemy:GetForwardVector() * 100

			CreateModifierThinker( hTreasureEnt, hSunStrikeAbility, "modifier_invoker_sun_strike", kv, vTarget, hTreasureEnt:GetTeamNumber(), false )

			EmitSoundOnLocationForAllies( vTarget, "Creature.Flamestrike.Charge", hEnemy )

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_WORLDORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, vTarget )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 50, 1, 1 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
	end

	local gameEvent = {}
	gameEvent["player_id"] = hPlayerHero:GetPlayerID()
	gameEvent["team_number"] = DOTA_TEAM_GOODGUYS
	gameEvent["locstring_value"] = "trap_sun_strike"
	gameEvent["message"] = "#Dungeon_FoundChestTrap"
	FireGameEvent( "dota_combat_event_message", gameEvent )
end

---------------------------------------------------------------------------

function CAghanim:CreateTreasureGoldDrop( hPlayerHero, hTreasureEnt )
	printf( "CreateTreasureGoldDrop" )

	local nDepth = self:GetCurrentRoom():GetDepth()
	local nMinGold, nMaxGold = GetMinMaxGoldChoiceReward( nDepth, true )

	local newItem = CreateItem( "item_bag_of_gold", nil, nil )
	newItem:SetPurchaseTime( 0 )
	local nGoldToDrop = math.random( nMinGold, nMaxGold )
	newItem:SetCurrentCharges( nGoldToDrop )

	local drop = CreateItemOnPositionSync( hTreasureEnt:GetAbsOrigin(), newItem )

	local vPos = self:GetChestRewardSpawnPos( hTreasureEnt )

	newItem:LaunchLoot( true, 200, 0.75, vPos )
	EmitSoundOn( "Dungeon.TreasureItemDrop", hTreasureEnt )

	local gameEvent = {}
	gameEvent["player_id"] = hPlayerHero:GetPlayerID()
	gameEvent["team_number"] = DOTA_TEAM_GOODGUYS
	gameEvent["int_value"] = nGoldToDrop
	gameEvent["message"] = "#Dungeon_FoundChestGold"
	FireGameEvent( "dota_combat_event_message", gameEvent )
end

---------------------------------------------------------------------------

function CAghanim:GetChestRewardSpawnPos( hTreasureEnt )
	local vPos = hTreasureEnt:GetAbsOrigin() + RandomVector( hTreasureEnt.nRewardSpawnDist )

	local nAttempts = 0
	while ( ( not GridNav:CanFindPath( hTreasureEnt:GetOrigin(), vPos ) ) and ( nAttempts < 5 ) ) do
		vPos = hTreasureEnt:GetOrigin() + RandomVector( hTreasureEnt.nRewardSpawnDist )
		nAttempts = nAttempts + 1

		if nAttempts >= 5 then
			vPos = hTreasureEnt:GetOrigin()
		end
	end

	return vPos
end

---------------------------------------------------------------------------


function CAghanim:SpawnRoomReward( hTreasureEnt )
	if hTreasureEnt.Encounter == nil then
		return
	end

	hTreasureEnt.nRewardSpawnDist = 200

	local nMinGold, nMaxGold = GetMinMaxGoldChoiceReward( hTreasureEnt.nDepth, hTreasureEnt.nEliteRank > 0 )
	for _, szReward in pairs( hTreasureEnt.RoomReward ) do
		if szReward == "item_life_rune" then
			hTreasureEnt.Encounter:DropLifeRuneFromUnit( hTreasureEnt, hTreasureEnt, false )
		elseif szReward == "item_bag_of_gold" then
			local newItem = CreateItem( szReward, nil, nil )
			newItem:SetPurchaseTime( 0 )
			newItem:SetCurrentCharges( math.random( nMinGold, nMaxGold ) )
			local drop = CreateItemOnPositionSync( hTreasureEnt:GetAbsOrigin(), newItem )
			local vPos = self:GetBreakableRewardSpawnPos( hTreasureEnt )
			newItem:LaunchLoot( true, 300, 0.5, vPos )
		else
			hTreasureEnt.Encounter:DropItemFromRoomRewardContainer( hTreasureEnt, szReward, false )
		end

		EmitSoundOn( "Dungeon.TreasureItemDrop", hTreasureEnt )
	end
end

---------------------------------------------------------------------------
