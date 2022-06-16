--[[ items.lua ]]

--Spawns Bags of Gold in the middle
function COverthrowGameMode:ThinkGoldDrop()
	local r = RandomInt( 1, 100 )
	if r > ( 100 - self.m_GoldDropPercent ) then
		self:SpawnGold()
	end
end

function COverthrowGameMode:SpawnGold()
	local overBoss = Entities:FindByName( nil, "@overboss" )
	local throwCoin = nil
	local throwCoin2 = nil
	if overBoss then
		throwCoin = overBoss:FindAbilityByName( 'dota_ability_throw_coin' )
		throwCoin2 = overBoss:FindAbilityByName( 'dota_ability_throw_coin_long' )
	end

	-- sometimes play the long anim
	if throwCoin2 and RandomInt( 1, 100 ) > 80 then
		overBoss:CastAbilityNoTarget( throwCoin2, -1 )
	elseif throwCoin then
		overBoss:CastAbilityNoTarget( throwCoin, -1 )
	else
		self:SpawnGoldEntity( Vector( 0, 0, 0 ) )
	end
end

function COverthrowGameMode:SpawnGoldEntity( spawnPoint )
	EmitGlobalSound("Item.PickUpGemWorld")
	local newItem = CreateItem( "item_bag_of_gold", nil, nil )
	local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
	local dropRadius = RandomFloat( self.m_GoldRadiusMin, self.m_GoldRadiusMax )
	newItem:LaunchLootInitialHeight( false, 0, 500, 0.75, spawnPoint + RandomVector( dropRadius ) )
	newItem:SetContextThink( "KillLoot", function() return self:KillLoot( newItem, drop ) end, 20 )
end


--Removes Bags of Gold after they expire
function COverthrowGameMode:KillLoot( item, drop )

	if drop:IsNull() then
		return
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, drop )
	ParticleManager:SetParticleControl( nFXIndex, 0, drop:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	EmitGlobalSound("Item.PickUpWorld")

	UTIL_Remove( item )
	UTIL_Remove( drop )
end

function COverthrowGameMode:SpecialItemAdd( event )
	local item = EntIndexToHScript( event.ItemEntityIndex )
	local owner = EntIndexToHScript( event.HeroEntityIndex )
	local hero = owner:GetClassname()
	local ownerTeam = owner:GetTeamNumber()
	local sortedTeams = {}
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		table.insert( sortedTeams, { teamID = team, teamScore = GetTeamHeroKills( team ) } )
	end

	-- reverse-sort by score
	table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )
	local n = TableCount( sortedTeams )
	local leader = sortedTeams[1].teamID
	local lastPlace = sortedTeams[n].teamID

	local tableindex = 0

	local tier1 = 
	{
		"item_keen_optic",				--
		--"item_ocean_heart",			-- !no water!
		"item_broom_handle",			--
		"item_trusty_shovel",			--
		"item_arcane_ring",				--
		"item_chipped_vest",			--
		"item_possessed_mask",			--
		"item_mysterious_hat",			-- fairy's trinket
		"item_unstable_wand",			-- pig pole
		"item_pogo_stick",				-- tumbler's toy
	}

	local tier2 =
	{
		"item_ring_of_aquila",			--
		"item_nether_shawl",			--
		"item_dragon_scale",			--
		"item_pupils_gift",				--
		"item_vambrace",				--
		"item_misericorde",				-- brigand's blade
		"item_grove_bow",				--
		--"item_philosophers_stone",	-- !game is not long enough for bonus gold to matter!
		"item_essence_ring",			--
		"item_paintball",				-- fae grenade
		"item_bullwhip",				--
		"item_quicksilver_amulet",		--
	}

	local tier3 =
	{
		"item_quickening_charm",		--
		"item_black_powder_bag",		-- blast rig
		"item_spider_legs",				--
		"item_paladin_sword",			--
		"item_titan_sliver",			--
		"item_mind_breaker",			--
		"item_enchanted_quiver",		--
		"item_elven_tunic",				--
		"item_cloak_of_flames",			--
		"item_ceremonial_robe",			--
		"item_psychic_headband",		--
	}

	local tier4 =
	{
		"item_timeless_relic",			--
		"item_spell_prism",				--
		"item_ascetic_cap",				--
		"item_heavy_blade",				-- witchbane
		"item_flicker",					--
		"item_ninja_gear",				--
		"item_the_leveller",			--
		"item_spy_gadget",				-- telescope
		"item_trickster_cloak",			--
		"item_stormcrafter",			--
		"item_penta_edged_sword",		--
	}

	local tier5 =
	{
		"item_force_boots",				--
		"item_desolator_2",				--
		"item_seer_stone",				--
		"item_mirror_shield",			--
		"item_apex",					--
		"item_demonicon",				--
		"item_fallen_sky",				--
		"item_force_field",				-- arcanist's armor
		"item_pirate_hat",				--
		"item_ex_machina",				--
		"item_giants_ring",				--
		"item_book_of_shadows",			--
	}

	local t1 = PickRandomShuffle( tier1, self.tier1ItemBucket )
	local t2 = PickRandomShuffle( tier2, self.tier2ItemBucket )
	local t3 = PickRandomShuffle( tier3, self.tier3ItemBucket )
	local t4 = PickRandomShuffle( tier4, self.tier4ItemBucket )
	local t5 = PickRandomShuffle( tier5, self.tier5ItemBucket )

	local spawnedItem = ""

	-- pick the item we're giving them
	local nLeaderKills = GetTeamHeroKills( leader )

	if nLeaderKills <= 5 then
		spawnedItem = t1
	elseif nLeaderKills > 5 and nLeaderKills <= 13 then
		if ownerTeam == leader and ( self.leadingTeamScore - self.runnerupTeamScore > 3 ) then
			spawnedItem = t1
		elseif ownerTeam == lastPlace then
			spawnedItem = t3
		else
			spawnedItem = t2
		end
	elseif nLeaderKills > 13 and nLeaderKills <= 21 then
		if ownerTeam == leader and ( self.leadingTeamScore - self.runnerupTeamScore > 3 ) then
			spawnedItem = t2
		elseif ownerTeam == lastPlace then
			spawnedItem = t4
		else
			spawnedItem = t3
		end
	elseif nLeaderKills > 21 then
		if ownerTeam == leader and ( self.leadingTeamScore - self.runnerupTeamScore > 3 ) then
			spawnedItem = t3
		elseif ownerTeam == lastPlace then
			spawnedItem = t5
		else
			spawnedItem = t4
		end
	end

	-- add the item to the inventory and broadcast
	owner:AddItemByName( spawnedItem )
	EmitGlobalSound("Overthrow.Item.Claimed")
	local overthrow_item_drop =
	{
		hero_id = hero,
		dropped_item = spawnedItem
	}
	CustomGameEventManager:Send_ServerToAllClients( "overthrow_item_drop", overthrow_item_drop )
end

function COverthrowGameMode:ThinkSpecialItemDrop()
	-- Stop spawning items after the maximum amount
	if self.nNextSpawnItemNumber >= self.nMaxItemSpawns then
		return
	end
	-- Don't spawn if the game is about to end
	if nCOUNTDOWNTIMER < 20 then
		return
	end
	local t = GameRules:GetDOTATime( false, false )
	local tSpawn = ( self.spawnTime * self.nNextSpawnItemNumber )
	local tWarn = tSpawn - self.warnTime
	
	if not self.hasWarnedSpawn and t >= tWarn then
		-- warn the item is about to spawn
		-- we might fail to reserve a spot in which case we'll just skip and move on to the next spawn
		if self:WarnItem() == false then
			self.nNextSpawnItemNumber = self.nNextSpawnItemNumber + 1
			return
		end
		self.hasWarnedSpawn = true
	elseif t >= tSpawn then
		-- spawn the item
		self:SpawnItem()
		self.nNextSpawnItemNumber = self.nNextSpawnItemNumber + 1
		self.hasWarnedSpawn = false
	end
end

function COverthrowGameMode:PlanNextSpawn()
	if self.itemSpawnLocations == nil then
		self.itemSpawnLocations = {}
		self.itemSpawnLocationsInUse = {}
		local nMaxSpawns = 8
		if GetMapName() == "desert_quintet" then
			print("map is desert_quintet")
			nMaxSpawns = 6
		elseif GetMapName() == "temple_quartet" then
			print("map is temple_quartet")
			nMaxSpawns = 4
		end

		for i=1,nMaxSpawns do
			local spawnName = "item_spawn_" .. i
			--print( '^^^SEARCHING FOR SPAWN POINT NAMED = ' .. spawnName )
			local hSpawnLocation = Entities:FindByName( nil, spawnName )
			if hSpawnLocation == nil then
				print( '^^^MISSING SPAWN LOCATION = ' .. spawnName )
			else
				local newSpawnLocation =
				{
					hSpawnLocation = hSpawnLocation,
					path_track_name = "item_spawn_" .. i,
					world_effects_name = "item_spawn_particle_" .. i,
				}
				self.itemSpawnLocations[i] = newSpawnLocation
			end
		end
	end

	if #self.itemSpawnLocations <= 0 then
		--print( 'RAN OUT OF SPAWN LOCATIONS!' )
		return false
	end

	local r = RandomInt( 1, #self.itemSpawnLocations )
	local spawnPoint = self.itemSpawnLocations[r]
	table.remove( self.itemSpawnLocations, r )
	table.insert( self.itemSpawnLocationsInUse, spawnPoint )

	self.hCurrentItemSpawnLocation = spawnPoint

	return true
end

function COverthrowGameMode:WarnItem()
	-- find the spawn point
	if self:PlanNextSpawn() == false then
		return false
	end

	local spawnLocation = self.hCurrentItemSpawnLocation.hSpawnLocation:GetAbsOrigin();

	-- notify everyone
	CustomGameEventManager:Send_ServerToAllClients( "item_will_spawn", { spawn_location = spawnLocation } )
	EmitGlobalSound( "Overthrow.Item.Warning" )
	
	-- fire the destination particles
	DoEntFire( self.hCurrentItemSpawnLocation.world_effects_name, "Start", "0", 0, self, self )

	-- Give vision to the spawn area (unit is on goodguys, but shared vision)
	self.hItemDestinationRevealer = CreateUnitByName( "npc_vision_revealer", spawnLocation, false, nil, nil, DOTA_TEAM_GOODGUYS )
	self.nItemDestinationParticles = ParticleManager:CreateParticle( "particles/econ/wards/f2p/f2p_ward/f2p_ward_true_sight_ambient.vpcf", PATTACH_ABSORIGIN, self.hItemDestinationRevealer )
	ParticleManager:SetParticleControlEnt( self.nItemDestinationParticles, PATTACH_ABSORIGIN, self.hItemDestinationRevealer, PATTACH_ABSORIGIN, "attach_origin", self.hItemDestinationRevealer:GetAbsOrigin(), true )

	return true
end

function COverthrowGameMode:SpawnItem()
	-- notify everyone
	CustomGameEventManager:Send_ServerToAllClients( "item_has_spawned", {} )
	EmitGlobalSound( "Overthrow.Item.Spawn" )

	-- spawn the item
	local startLocation = Vector( 0, 0, 700 )
	local treasureCourier = CreateUnitByName( "npc_dota_treasure_courier" , startLocation, true, nil, nil, DOTA_TEAM_NEUTRALS )
	local treasureAbility = treasureCourier:FindAbilityByName( "dota_ability_treasure_courier" )
	treasureAbility:SetLevel( 1 )
    --print ("Spawning Treasure")
    treasureCourier:SetInitialGoalEntity( self.hCurrentItemSpawnLocation.hSpawnLocation )
    --local particleTreasure = ParticleManager:CreateParticle( "particles/items_fx/black_king_bar_avatar.vpcf", PATTACH_ABSORIGIN, treasureCourier )
	--ParticleManager:SetParticleControlEnt( particleTreasure, PATTACH_ABSORIGIN, treasureCourier, PATTACH_ABSORIGIN, "attach_origin", treasureCourier:GetAbsOrigin(), true )
	--treasureCourier:Attribute_SetIntValue( "particleID", particleTreasure )
end

function COverthrowGameMode:ForceSpawnItem()
	if self:WarnItem() then
		self:SpawnItem()
	end
end

function COverthrowGameMode:KnockBackFromTreasure( center, radius, knockback_duration, knockback_distance, knockback_height )
	local targetType = bit.bor( DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_HERO )
	local knockBackUnits = FindUnitsInRadius( DOTA_TEAM_NOTEAM, center, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, targetType, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
 
	local modifierKnockback =
	{
		center_x = center.x,
		center_y = center.y,
		center_z = center.z,
		duration = knockback_duration,
		knockback_duration = knockback_duration,
		knockback_distance = knockback_distance,
		knockback_height = knockback_height,
	}

	for _,unit in pairs(knockBackUnits) do
--		print( "knock back unit: " .. unit:GetName() )
		unit:AddNewModifier( unit, nil, "modifier_knockback", modifierKnockback );
	end
end


function COverthrowGameMode:TreasureDrop( treasureCourier )

	-- Destroy vision revealer
	self.hItemDestinationRevealer:RemoveSelf()
	ParticleManager:DestroyParticle( self.nItemDestinationParticles, false )

	--Create the death effect for the courier
	local spawnPoint = treasureCourier:GetInitialGoalEntity():GetAbsOrigin()
	spawnPoint.z = 400
	local fxPoint = treasureCourier:GetInitialGoalEntity():GetAbsOrigin()
	fxPoint.z = 400
	local deathEffects = ParticleManager:CreateParticle( "particles/treasure_courier_death.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( deathEffects, 0, fxPoint )
	ParticleManager:SetParticleControlOrientation( deathEffects, 0, treasureCourier:GetForwardVector(), treasureCourier:GetRightVector(), treasureCourier:GetUpVector() )
	EmitGlobalSound( "lockjaw_Courier.Impact" )
	EmitGlobalSound( "lockjaw_Courier.gold_big" )

	--Spawn the treasure chest at the selected item spawn location
	local newItem = CreateItem( "item_treasure_chest", nil, nil )
	local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
	drop:SetForwardVector( treasureCourier:GetRightVector() ) -- oriented differently
	newItem:LaunchLootInitialHeight( false, 0, 50, 0.25, spawnPoint )

	self.hCurrentItemSpawnLocation.hDrop = drop

	--print( '^^^ITEM SPAWN LOCATIONS' )
	--PrintTable( self.itemSpawnLocations )
	--print( '^^^ITEM SPAWN LOCATIONS IN USE' )
	--PrintTable( self.itemSpawnLocationsInUse )

	--Stop the particle effect
	DoEntFire( "item_spawn_particle_" .. self.itemSpawnIndex, "stopplayendcap", "0", 0, self, self )

	--Knock people back from the treasure
	self:KnockBackFromTreasure( spawnPoint, 375, 0.25, 400.1, 100 )
		
	--Destroy the courier
	UTIL_Remove( treasureCourier )

	-- create the minimap/revealer for the treasure now that it's on the ground
	-- this one is attached to the table of data for the spawn location so we can clean it up when the treasure is picked up
	self.hCurrentItemSpawnLocation.hItemDestinationRevealer = CreateUnitByName( "npc_treasure_revealer", self.hCurrentItemSpawnLocation.hSpawnLocation:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS )
	self.hCurrentItemSpawnLocation.nItemDestinationParticles = ParticleManager:CreateParticle( "particles/econ/wards/f2p/f2p_ward/f2p_ward_true_sight_ambient.vpcf", PATTACH_ABSORIGIN, self.hCurrentItemSpawnLocation.hItemDestinationRevealer )
	ParticleManager:SetParticleControlEnt( self.hCurrentItemSpawnLocation.nItemDestinationParticles, PATTACH_ABSORIGIN, self.hCurrentItemSpawnLocation.hItemDestinationRevealer, PATTACH_ABSORIGIN, "attach_origin", self.hCurrentItemSpawnLocation.hItemDestinationRevealer:GetAbsOrigin(), true )
end

function COverthrowGameMode:ForceSpawnGold()
	self:SpawnGold()
end

