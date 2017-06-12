
---------------------------------------------------------------------------

function CDungeon:ChooseTreasureSurprise( hPlayerHero, hTreasureEnt )
	hTreasureEnt.nRewardSpawnDist = 64

	if hTreasureEnt.zone == nil then
		print( "CDungeon:ChooseTreasureSurprise() -- WARNING: No zone found for this chest. Defaulting to \"forest\"" )
		hTreasureEnt.zone = self:GetZoneByName( "forest" )
	end

	for _,zone in pairs( self.Zones ) do
		zone:OnTreasureOpened( hTreasureEnt.zone.szName )
	end

	if hTreasureEnt.Items == nil then
		print( "CDungeon:ChooseTreasureSurprise() -- WARNING: No items table found for this chest. Will give you some branches instead." )
		hTreasureEnt.Items =
		{
			"item_branches",
		}
	end

	if hTreasureEnt.nMinGold == nil then
		print( "CDungeon:ChooseTreasureSurprise() -- WARNING: Missing nMinGold value for this chest. Will use a default value based on player level instead." )
		hTreasureEnt.nMinGold = hPlayerHero:GetLevel() * 150
	end

	if hTreasureEnt.nMaxGold == nil then
		print( "CDungeon:ChooseTreasureSurprise() -- WARNING: Missing nMaxGold value for this chest. Will use a default value based on player level instead." )
		hTreasureEnt.nMaxGold = hPlayerHero:GetLevel() * 300
	end

	if hTreasureEnt.szTraps == nil or #hTreasureEnt.szTraps == 0 then
		print( "CDungeon:ChooseTreasureSurprise() -- WARNING: Field named szTraps is missing or empty for this chest.  Using default data instead." )
		hTreasureEnt.szTraps =
		{
			"creature_techies_land_mine",
			"trap_sun_strike",
		}
	end

	if hTreasureEnt.nTrapLevel == nil or hTreasureEnt.nTrapLevel <= 0 then
		print( "CDungeon:ChooseTreasureSurprise() -- WARNING: Field named nTrapLevel is missing or is 0 or less.  Using default data instead." )
		hTreasureEnt.nTrapLevel = 1
	end

	if hTreasureEnt.fRelicChance == nil then
		hTreasureEnt.fRelicChance = 0.01
		print( string.format( "CDungeon:ChooseTreasureSurprise() -- WARNING: No fRelicChance specified for this chest. Setting it to %.2f", hTreasureEnt.fRelicChance ) )
	end

	if hTreasureEnt.fItemChance == nil then
		hTreasureEnt.fItemChance = 0.3
		print( string.format( "CDungeon:ChooseTreasureSurprise() -- WARNING: No fItemChance specified for this chest. Setting it to %.2f", hTreasureEnt.fItemChance ) )
	end

	local fRelicThreshold = 1 - hTreasureEnt.fRelicChance -- inverting because of how chances are authored, so comparisons below are more intuitive
	local fItemThreshold = 1 - hTreasureEnt.fItemChance

	local fRandRoll = RandomFloat( 0, 1 )

	--print( string.format( "fRandRoll: %.2f", fRandRoll ) )
	--print( string.format( "fRelicThreshold: %.2f, fItemThreshold: %.2f", fRelicThreshold, fItemThreshold ) )

	if hTreasureEnt.Relics ~= nil and #hTreasureEnt.Relics > 0 and fRandRoll >= fRelicThreshold then
		self:CreateTreasureRelicDrop( hPlayerHero, hTreasureEnt )
		return
	elseif fRandRoll >= fItemThreshold then
		self:CreateTreasureItemDrop( hPlayerHero, hTreasureEnt )
		return
	else
		local bTrap = RandomFloat( 0, 1 ) >= 0.6
		if bTrap then
			self:ChooseTreasureTrap( hPlayerHero, hTreasureEnt )
			return
		else
			self:CreateTreasureGoldDrop( hPlayerHero, hTreasureEnt )
			return
		end
	end
end

---------------------------------------------------------------------------

function CDungeon:CreateTreasureItemDrop( hPlayerHero, hTreasureEnt )
	if hTreasureEnt ~= nil and hTreasureEnt.Items ~= nil then
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

---------------------------------------------------------------------------

function CDungeon:CreateTreasureRelicDrop( hPlayerHero, hTreasureEnt )
	if hTreasureEnt ~= nil and hTreasureEnt.Relics ~= nil then
		local nRandomIndex = RandomInt( 1, #hTreasureEnt.Relics )
		local newItem = CreateItem( hTreasureEnt.Relics[ nRandomIndex ], nil, nil )
		local drop = CreateItemOnPositionForLaunch( hTreasureEnt:GetAbsOrigin(), newItem )

		local vPos = self:GetChestRewardSpawnPos( hTreasureEnt )

		newItem:LaunchLootInitialHeight( false, 0, 200, 0.75, vPos )

		EmitSoundOn( "Dungeon.TreasureRelicDrop", hTreasureEnt )

		local gameEvent = {}
		gameEvent["player_id"] = hPlayerHero:GetPlayerID()
		gameEvent["team_number"] = DOTA_TEAM_GOODGUYS
		gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_" .. newItem:GetAbilityName()
		gameEvent["message"] = "#Dungeon_FoundChestItem"
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end
end

---------------------------------------------------------------------------

function CDungeon:CreateTreasureRuneDrop( hPlayerHero, hTreasureEnt )
	local newItem = CreateItem( "item_life_rune", nil, nil )
	newItem:SetPurchaseTime( 0 )
	local drop = CreateItemOnPositionSync( hTreasureEnt:GetAbsOrigin(), newItem )
	local vPos = hTreasureEnt:GetAbsOrigin() + RandomVector( hTreasureEnt.nRewardSpawnDist )
	newItem:LaunchLoot( false, 150, 0.75, vPos )
end

---------------------------------------------------------------------------

function CDungeon:CreateTreasureGoldDrop( hPlayerHero, hTreasureEnt )
	local Zone = hTreasureEnt.zone
	local nGoldToDrop = RandomInt( hTreasureEnt.nMinGold, hTreasureEnt.nMaxGold )

	--print( "Zone.nGoldRemaining == " .. Zone.nGoldRemaining )
	if ( Zone.nGoldRemaining <= 0 ) or ( ( Zone.nGoldRemaining - nGoldToDrop ) <= 0 ) then
		nGoldToDrop = nGoldToDrop * 0.5
	end

	--print( "Chest nGoldToDrop == " .. nGoldToDrop )

	--print( "Before chest drop, Zone.nGoldRemaining == " .. Zone.nGoldRemaining )
	--print( "CDungeon:OnTreasureOpen() - Drop a bag with " .. nGoldToDrop .. " gold.")
	if nGoldToDrop > 0 then
		local newItem = CreateItem( "item_bag_of_gold", nil, nil )
		newItem:SetPurchaseTime( 0 )
		newItem:SetCurrentCharges( nGoldToDrop )
		local drop = CreateItemOnPositionSync( hTreasureEnt:GetAbsOrigin(), newItem )

		local vPos = self:GetChestRewardSpawnPos( hTreasureEnt )

		newItem:LaunchLoot( true, 200, 0.75, vPos )
		Zone.nGoldRemaining = Zone.nGoldRemaining - nGoldToDrop
		EmitSoundOn( "Dungeon.TreasureItemDrop", hTreasureEnt )
		--print( "After chest drop, Zone.nGoldRemaining == " .. Zone.nGoldRemaining )

		local gameEvent = {}
		gameEvent["player_id"] = hPlayerHero:GetPlayerID()
		gameEvent["team_number"] = DOTA_TEAM_GOODGUYS
		gameEvent["int_value"] = nGoldToDrop
		gameEvent["message"] = "#Dungeon_FoundChestGold"
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end
end

---------------------------------------------------------------------------

function CDungeon:ChooseTreasureTrap( hPlayerHero, hTreasureEnt )
	local szTrapToUse = hTreasureEnt.szTraps[ RandomInt( 1, #hTreasureEnt.szTraps ) ]
	--print( "szTrapToUse == " .. szTrapToUse )

	if szTrapToUse == "creature_techies_land_mine" then
		self:CreateTreasureMineTrap( hPlayerHero, hTreasureEnt )
	elseif szTrapToUse == "trap_sun_strike" then
		self:CreateTreasureSunStrikeTrap( hPlayerHero, hTreasureEnt )
	end
end

---------------------------------------------------------------------------

function CDungeon:CreateTreasureMineTrap( hPlayerHero, hTreasureEnt )
	--print( "[treasure_chest_surprises] CreateMineTrap()" )
	local hLandMineAbility = hTreasureEnt:FindAbilityByName( "creature_techies_land_mine" )
	if hLandMineAbility == nil then
		print( string.format( "CDungeon:OnTreasureOpen - ERROR: %s is missing required ability", hTreasureEnt:GetUnitName() ) )
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

function CDungeon:CreateTreasureSunStrikeTrap( hPlayerHero, hTreasureEnt )
	--print( "[treasure_chest_surprises] CreateSunStrikeTrap()" )
	local hSunStrikeAbility = hTreasureEnt:FindAbilityByName( "trap_sun_strike" )
	if hSunStrikeAbility == nil then
		print( string.format( "CDungeon:OnTreasureOpen - ERROR: %s is missing required ability", hTreasureEnt:GetUnitName() ) )
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

			EmitSoundOnLocationForAllies( vTarget, "Hero_Invoker.SunStrike.Charge", hEnemy )

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

function CDungeon:GetChestRewardSpawnPos( hTreasureEnt )
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

