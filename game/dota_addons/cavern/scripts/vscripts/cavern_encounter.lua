
if CCavernEncounter == nil then
	CCavernEncounter = class({})
end

require( "cavern_room" )
require( "event_queue" )
require( "juke_paths" )

_nEncounterThinkContextCount = 1

function GetEncounterContext( szEncounterName )
	if not szEncounterName then
		szEncounterName = "Generic"
	end

	local szContextName = string.format("EncounterContext_%s_%d", szEncounterName, _nEncounterThinkContextCount )
	_nEncounterThinkContextCount = _nEncounterThinkContextCount + 1
	return szContextName
end

--------------------------------------------------------------------

function CCavernEncounter:constructor( hRoom )
	if hRoom == nil then
		--print( "CCavernEncounter:constructor - ERROR - hRoom is nil" )
		return
	end

	self.hRoom = hRoom
	self:Reset()
end

function CCavernEncounter:Reset()
	self.nGoldForEncounter = nil
	self.nXPForEncounter = nil
	self.hUnits = {}	
	self.hCreeps = {}	
	self.bActive = false
	self.nNumUnitsToSpawn = nil
	self.bHasSpawnedDoodads = false
end

--------------------------------------------------------------------

function CCavernEncounter:GetEncounterName()
	return self.hRoom:GetSelectedEncounterName()
end

--------------------------------------------------------------------

function CCavernEncounter:GetEncounterType()
	return CAVERN_ROOM_TYPE_INVALID
end

--------------------------------------------------------------------

function CCavernEncounter:GetEncounterLevels()
	return { 1 }
end

function CCavernEncounter:GetTreasureType()
	if self.hRoom:GetRoomLevel() == CAVERN_MAX_ROOM_DIFFICULTY_LEVEL or self:GetEncounterType() == CAVERN_ROOM_TYPE_TRAP then
		return CAVERN_TREASURE_TYPE_SPECIAL
	else
		return CAVERN_TREASURE_TYPE_REGULAR
	end
end

function CCavernEncounter:SetNumUnitsToSpawn( nNumUnitsToSpawn )
	self.nNumUnitsToSpawn = nNumUnitsToSpawn
end

-- by default rewards are split between mob last hits and the chest, in some cases we want the chest to contain everything
function CCavernEncounter:ApplyAllRewardsToChest()
	return false
end

--------------------------------------------------------------------

function CCavernEncounter:Start()

	if self.hRoom:GetRoomLevel() < 1 or self.bActive == true then
		return
	end

	self.nCreatureGoldForEncounter = CAVERN_CREATURE_GOLD_PER_ENCOUNTER_LEVEL[ self.hRoom:GetRoomLevel() ]
	self.nCreatureXPForEncounter = CAVERN_CREATURE_XP_PER_ENCOUNTER_LEVEL[ self.hRoom:GetRoomLevel() ]

	self.nTreasureGoldForEncounter = CAVERN_TREASURE_GOLD_PER_ENCOUNTER_LEVEL[ self.hRoom:GetRoomLevel() ]
	self.nTreasureXPForEncounter = CAVERN_TREASURE_XP_PER_ENCOUNTER_LEVEL[ self.hRoom:GetRoomLevel() ]

	--if self.nGoldForEncounter == nil then
	--	print( "ERROR - Encounter " .. self:GetEncounterName() .. " cannot find gold values for level " .. self.hRoom:GetRoomLevel() )
	--end
	--if self.nXPForEncounter == nil then
	--	print( "ERROR - Encounter " .. self:GetEncounterName() .. " cannot find XP values for level " .. self.hRoom:GetRoomLevel() )
	--end

	self.bTreasureHasSpawned = false

	self.hRoom.hRoomVolume:SetContextThink( GetEncounterContext( "Base" ), function() return self:BaseOnThink() end, 0.0 )

	return true
end

--------------------------------------------------------------------

function CCavernEncounter:BaseOnThink()
	if IsServer() then

		--printf("%s thinking - %s %s", self:GetEncounterName(), tostring(self.bActive), tostring(self:IsCleared()) )
		if self.bActive and self:IsCleared() then
			self:SpawnTreasureChest()
			EmitSoundOn( "CombatEncounter.Complete", self.hRoom.hRoomVolume )
			self.bActive = false
			return -1
		end

		return 0.5
	end
end

--------------------------------------------------------------------

-- can be overriden by rooms if we want 
function CCavernEncounter:GetTreasureLevel()
	return self.hRoom:GetRoomLevel()
end

--------------------------------------------------------------------

function CCavernEncounter:SpawnTreasureChest()
	local nTreasureLevel = self:GetTreasureLevel()

	local szTreasureCreature = "npc_treasure_chest"
	if self:GetTreasureType() == CAVERN_TREASURE_TYPE_SPECIAL then
		szTreasureCreature = "npc_special_treasure_chest"
	end

	self.hChest = self:SpawnNonCreepByName( szTreasureCreature, self.hRoom.vRoomCenter + RandomVector( 1 * nTreasureLevel ), true, nil, nil, DOTA_TEAM_BADGUYS )
	if self.hChest ~= nil then
		self.hChest:SetForwardVector( Vector( 0, 1, 0 ) )
		self.hChest:SetModelScale( ChestScales[ nTreasureLevel ] )
		if self:GetTreasureType() == CAVERN_TREASURE_TYPE_SPECIAL then
			self.hChest:SetModelScale( SpecialChestScales[ nTreasureLevel ] )
		end
	end

	if not self.bChestInitialized then
		local nTreasureGold = self.nTreasureGoldForEncounter
		local nTreasureXP = self.nTreasureXPForEncounter
		if self:ApplyAllRewardsToChest() then
			nTreasureGold = nTreasureGold + self.nCreatureGoldForEncounter
			nTreasureXP = nTreasureXP + self.nCreatureXPForEncounter
		end
		self.hChest.hTreasureRoom = self.hRoom -- tell the chest unit about this so that the modifier can pick it up in its OnCreated
		self.hChest:AddNewModifier( self.hChest, nil, "modifier_treasure_chest", { TreasureLevel=nTreasureLevel, XpReward=nTreasureXP, GoldReward=nTreasureGold, TreasureType=self:GetTreasureType() } )
		self.bChestInitialized = true
	end

	self.bTreasureHasSpawned = true

end

--------------------------------------------------------------------

function CCavernEncounter:OnStartComplete()
	
	if self:GetEncounterType() == CAVERN_ROOM_TYPE_MOB and self.nNumUnitsToSpawn == nil then
		print( "ERROR - Encounter " .. self:GetEncounterName() .. " has not stated how many units it will spawn, it won't correctly reward XP/Gold!")
		return
	end

	if self:GetEncounterType() == CAVERN_ROOM_TYPE_TRAP then
		self:SpawnTreasureChest()
	end

	self.bActive = true
end

--------------------------------------------------------------------

function CCavernEncounter:IsCleared()
	if self.bTreasureHasSpawned == true then
		return true
	end

	if self.hCreeps == nil then
		return true
	end

	if not self.bActive then
		return false
	end

	local bAllDead = true
	for _,hUnit in pairs(self.hCreeps) do
		if not hUnit:IsNull() and hUnit:IsAlive() then
			bAllDead = false
		end
	end

	--printf("returning %s", tostring(bAllDead))
	return bAllDead and #self.hCreeps > 0

end

--------------------------------------------------------------------

function CCavernEncounter:Cleanup()

	for _,hUnit in pairs(self.hUnits) do
		if hUnit ~= nil and not hUnit:IsNull() then
			UTIL_Remove( hUnit )
		end
	end

	self.hUnits = {}
	self.hCreeps = {}
	self.bActive = false
	print( "Stopping encounter " .. self:GetEncounterName() .. " in room " .. self.hRoom:GetRoomID() )
end


--------------------------------------------------------------------

function CCavernEncounter:SpawnCreepByName(...)
	local args = {...}

	if self.nNumUnitsToSpawn == nil then
		print( "ERROR - Attempting to spawn creep " .. args[1] .. " before setting self.nNumUnitsToSpawn" )
		return nil
	end

	local hUnit = self:SpawnNonCreepByName(...)
	assert( hUnit ~= nil, "ERROR: SpawnCreepByName - hUnit is nil" )
	table.insert( self.hCreeps, hUnit )

	-- This will want more granularity for mobs in the rooms but should work for basic purposes now.
	if self:GetEncounterType() == CAVERN_ROOM_TYPE_MOB then
		hUnit.nMinGoldBounty = self.nCreatureGoldForEncounter / self.nNumUnitsToSpawn
		hUnit.nMaxGoldBounty = self.nCreatureGoldForEncounter / self.nNumUnitsToSpawn
		hUnit.nDeathXP = self.nCreatureXPForEncounter / self.nNumUnitsToSpawn

		--printf("spawning %s with %d gold and %d xp", args[1], (hUnit.nMinGoldBounty + hUnit.nMaxGoldBounty)/2, hUnit.nDeathXP )
	
		--hUnit.nMinGoldBounty = hUnit:GetMinimumGoldBounty()
		--hUnit.nMaxGoldBounty = hUnit:GetMaximumGoldBounty()
		--hUnit.nDeathXP = hUnit:GetDeathXP()

		if hUnit:IsCreature() then
			hUnit:RemoveAllItemDrops()
		end

	end

	local UnitsWithHiddenSpawn =
	{
		"npc_dota_creature_ghost",
	}

	local bShowSpawnEffect = true

	for _, szUnit in pairs( UnitsWithHiddenSpawn ) do
		if hUnit:GetUnitName() == szUnit then
			bShowSpawnEffect = false
			break
		end
	end

	if bShowSpawnEffect then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_CUSTOMORIGIN, hUnit )
		ParticleManager:SetParticleControl( nFXIndex, 0, hUnit:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end

	return hUnit
end

--------------------------------------------------------------------

function CCavernEncounter:SpawnNonCreepByName(...)
	local hUnit = CreateUnitByName(...)

	if hUnit == nil then
		print( "CCavernEncounter:SpawnNonCreepByName - ERROR - Failed to spawn unit." )
		return
	else
		--print( "Spawned unit named " .. hUnit:GetUnitName() .. " in room # " .. self.hRoom.nRoomID )
	end

	hUnit.hEncounter = self
	hUnit.hRoom = self.hRoom

	hUnit:SetMinimumGoldBounty( 0 )
	hUnit:SetMaximumGoldBounty( 0 )
	hUnit:SetDeathXP( 0 )
	
	table.insert( self.hUnits, hUnit )

	return hUnit
end

--------------------------------------------------------------------

function CCavernEncounter:SpawnTempTreeWithModel( ... )
	
	local hTree = CreateTempTreeWithModel( ... )

	if hTree == nil then
		print( "CCavernEncounter:SpawnNonCreepByName - ERROR - Failed to spawn tree." )
		return
	end

	hTree.hEncounter = self
	hTree.hRoom = self.hRoom

	table.insert( self.hUnits, hTree )

	return hTree
end


--------------------------------------------------------------------

function CCavernEncounter:SpawnCreepsRandomlyInRoom( szUnitName, nCreepCount, flExtent, eTeam )
	local hUnits = {}
	if eTeam == nil then
		eTeam = DOTA_TEAM_BADGUYS
	end

	local nIters = 6

	local i = 1

	for i = 1,nCreepCount do
		local vSpawnPoint = self.hRoom.vRoomCenter + RandomFloat(-flExtent, flExtent) * self.hRoom.vHalfX + RandomFloat(-flExtent, flExtent) * self.hRoom.vHalfY

		local vSafeSpawnPoint = vSpawnPoint
		for j = 1,nIters do
			if GridNav:IsNearbyTree( vSafeSpawnPoint, 75, true) then
				vSafeSpawnPoint = VectorLerp(j/nIters, vSpawnPoint, self.hRoom.vRoomCenter )
			else
				break
			end
		end

		local hUnit = self:SpawnCreepByName( szUnitName, vSafeSpawnPoint, true, nil, nil, eTeam )

		hUnit:FaceTowards( hUnit:GetOrigin() + RandomVector( 1 ) * 50 )

		table.insert( hUnits, hUnit )
	end

	return hUnits
end


--------------------------------------------------------------------

function CCavernEncounter:SpawnNonCreepsRandomlyInRoom( szUnitName, nCreepCount, flExtent,  eTeam )
	local hUnits = {}
	if eTeam == nil then
		eTeam = DOTA_TEAM_BADGUYS
	end

	for i=1,nCreepCount do
		local vSpawnPoint = self.hRoom.vRoomCenter + RandomFloat(-flExtent, flExtent) * self.hRoom.vHalfX + RandomFloat(-flExtent, flExtent) * self.hRoom.vHalfY
		local hUnit = self:SpawnNonCreepByName( szUnitName, vSpawnPoint, true, nil, nil, eTeam )
		table.insert( hUnits, hUnit )
	end
	return hUnits
end

--------------------------------------------------------------------

function CCavernEncounter:ApplyRawRoomRewards()

	local Heroes = self.hRoom.PlayerHeroesPresent
	local HeroesToReward = {}
	for _,Hero in pairs ( Heroes ) do
		if (Hero ~= nil) and Hero:IsRealHero() and (not Hero:IsTempestDouble()) then
			table.insert( HeroesToReward, Hero )
		end
	end

	if #HeroesToReward >= 1 then
		local nGoldAmount = self.nGoldForEncounter  / #HeroesToReward
		local nXPAmount = self.nXPForEncounter  / #HeroesToReward
		for _,Hero in pairs ( HeroesToReward ) do
			Hero:ModifyGold( nGoldAmount, true, DOTA_ModifyGold_Unspecified)
			SendOverheadEventMessage(Hero:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, Hero, nGoldAmount, nil);
			SendOverheadEventMessage(Hero:GetPlayerOwner(), OVERHEAD_ALERT_XP, Hero, nXPAmount, nil);
		end
	end

end

--------------------------------------------------------------------

function CCavernEncounter:SpawnForestInRoom( SpawnedDoodadPositions )
	if self.hRoom == nil then
		print( "CCavernEncounter:SpawnForestInRoom -- ERROR: self.hRoom is nil" )
		return
	end

	local TreeSpawnPositions = {}
	local nTreeCount = RandomInt( 5, 6 )
	local nFailedSpawns = 0
	local nMinTreeDistance = 250
	local nMaxTreeDistance = 800

	for i = 1, nTreeCount do
		local fRandomDistance = nil
		local vTreeSpawnPoint = nil
		local nAttempts = 0
		local nMaxAttempts = 5
		local bFailed = false

		repeat
			fRandomDistance = RandomFloat( nMinTreeDistance, nMaxTreeDistance )
			vTreeSpawnPoint = self.hRoom:GetRoomCenter() + ( RandomVector( 1 ) * fRandomDistance )

			nAttempts = nAttempts + 1
			if nAttempts >= nMaxAttempts then
				bFailed = true
				break
			end
		until ( self:IsGoodTreePosition( TreeSpawnPositions, vTreeSpawnPoint ) == true )

		if bFailed == false then
			local nDuration = 10000
			local szRandomCavernTreeModel = _G.CavernTreeModelNames[ RandomInt( 1, #_G.CavernTreeModelNames ) ]
			self:SpawnTempTreeWithModel( vTreeSpawnPoint, nDuration, szRandomCavernTreeModel )
			table.insert( TreeSpawnPositions, vTreeSpawnPoint )
			table.insert( SpawnedDoodadPositions, vTreeSpawnPoint )
		else
			nFailedSpawns = nFailedSpawns + 1
		end
	end

	--print( string.format( "CCavernEncounter:SpawnForestInRoom -- Tree spawns attempted: %d, tree spawns failed: %d", nTreeCount, nFailedSpawns ) )

	return true
end

--------------------------------------------------------------------

function CCavernEncounter:IsGoodTreePosition( PositionsTable, vCheckPos )
	if self.hRoom == nil then
		print( "IsGoodTreePosition -- ERROR: self.hRoom is nil" )
		return
	end

	local vExtent = self.hRoom.hRoomVolume:GetBoundingMaxs() - self.hRoom.hRoomVolume:GetBoundingMins()
	local vHalfX = Vector( ( vExtent.x / 2.0 ), 0, 0 )
	local vHalfY = Vector( 0, ( vExtent.y / 2.0 ), 0 )

	-- Check whether this spot is pathable (is there a better way to check this?)
	if not GridNav:CanFindPath( vCheckPos, vCheckPos ) then
		--print( "IsGoodTreePosition -- This position isn't pathable" )
		return false
	end

	-- Check against our stored tree positions
	for _, vPos in pairs( PositionsTable ) do
		local fDistance = ( vCheckPos - vPos ):Length2D()

		-- Is this position too close to any other?
		if fDistance < 80 then
			--print( "IsGoodTreePosition -- This position is too close to a stored tree position" )
			return false
		end

		-- Would this position block pathing in a way that isn't visually clear?
		if ( 136 < fDistance ) and ( fDistance < 196 ) then
			--print( "IsGoodTreePosition -- This position would create a tree wall with another tree while looking like you can path through" )
			return false
		end
	end

	-- Check against the room's four entrances
	local vEastEntrance = self.hRoom:GetRoomCenter() + vHalfX
	local vWestEntrance = self.hRoom:GetRoomCenter() - vHalfX
	local vNorthEntrance = self.hRoom:GetRoomCenter() + vHalfY
	local vSouthEntrance = self.hRoom:GetRoomCenter() - vHalfY

	local RoomEntrancePositions =
	{
		vEastEntrance,
		vWestEntrance,
		vNorthEntrance,
		vSouthEntrance,
	}

	for _, vPos in pairs( RoomEntrancePositions ) do
		local fDistance = ( vCheckPos - vPos ):Length2D()
		if fDistance < 300 then
			--print( "IsGoodTreePosition -- This position is too close to one of its four room entrance positions" )
			return false
		end
	end

	--[[
	-- Check against room signage positions
	local vOffsets = { -0.77 * vHalfX, 0.82 * vHalfX, -0.72 * vHalfY, 0.72 * vHalfY } -- @todo: make the signage values this is referring to a global constant
	for _, vOffset in pairs( vOffsets ) do	
		local vPos = GetGroundPosition( self.hRoom:GetRoomCenter() + vOffset, hRoomVolume )
		local fDistance = ( vCheckPos - vPos ):Length2D()
		if fDistance < 110 then
			--print( "IsGoodTreePosition -- This position is too close to a signage position" )
			return false
		end
	end
	]]

	return true
end

--------------------------------------------------------------------

function CCavernEncounter:GenerateDoodads()
	if self.bHasSpawnedDoodads then
		return
	end

	self.bHasSpawnedDoodads = true

	local flCornerDist = 0.40

	local flSpread = 0.2
	local nNudge = 300

	local BreakableCorners = { 
		self.hRoom.vRoomCenter - flCornerDist*self.hRoom.vHalfX - flCornerDist*self.hRoom.vHalfY,
		self.hRoom.vRoomCenter - flCornerDist*self.hRoom.vHalfX + flCornerDist*self.hRoom.vHalfY,
		self.hRoom.vRoomCenter + flCornerDist*self.hRoom.vHalfX + flCornerDist*self.hRoom.vHalfY,
		self.hRoom.vRoomCenter + flCornerDist*self.hRoom.vHalfX - flCornerDist*self.hRoom.vHalfY,
	 }

	local RoomCorners =
	{
		self.hRoom.vRoomCenter - 0.50*self.hRoom.vHalfX - 0.55*self.hRoom.vHalfY,
		self.hRoom.vRoomCenter - 0.50*self.hRoom.vHalfX + 0.45*self.hRoom.vHalfY,
		self.hRoom.vRoomCenter + 0.45*self.hRoom.vHalfX + 0.45*self.hRoom.vHalfY,
		self.hRoom.vRoomCenter + 0.45*self.hRoom.vHalfX - 0.55*self.hRoom.vHalfY,
	}

	local ShopCorners =
	{
		self.hRoom.vRoomCenter - 0.45*self.hRoom.vHalfX - 0.45*self.hRoom.vHalfY,
		self.hRoom.vRoomCenter - 0.45*self.hRoom.vHalfX + 0.45*self.hRoom.vHalfY,
		self.hRoom.vRoomCenter + 0.45*self.hRoom.vHalfX + 0.45*self.hRoom.vHalfY,
		self.hRoom.vRoomCenter + 0.45*self.hRoom.vHalfX - 0.45*self.hRoom.vHalfY,
	}

	local bSpawnDoodadTrees = true
	local EncountersWithoutTreeDoodads =
	{
		"encounter_trap_pudge",
		"encounter_trap_lich",
		"encounter_special_beastmaster",
		"encounter_special_bounty_hunter",
	}

	for _, szEncounter in pairs( EncountersWithoutTreeDoodads ) do
		if self:GetEncounterName() == szEncounter then
			bSpawnDoodadTrees = false
			break
		end
	end

	local SpawnedDoodadPositions = { }

	local flTreeWidth = 128
	local flTreeHeight = 128

	if bSpawnDoodadTrees == true then
		local bSpawnForest = RandomFloat( 0, 1 ) > 0.5
		if bSpawnForest then
			self:SpawnForestInRoom( SpawnedDoodadPositions )
		end

		if self.hRoom:IsRoomAdjacentToMapCenter() == false then
			for i = 1, 4 do
				local vCorner = RoomCorners[i]
				-- there's a chance that a corner will just be empty
				if RandomInt(1,5) > 1 then
					local JukePath = JUKE_PATHS[RandomInt(1,#JUKE_PATHS)]
					if JukePath ~= nil then
						for xx = 1,JUKE_PATH_WIDTH do
							for yy = 1,JUKE_PATH_HEIGHT do
								local exx = (i < 3) and xx or JUKE_PATH_WIDTH - (xx-1)
								local eyy = (i == 1 or i ==4) and yy or JUKE_PATH_HEIGHT - (yy-1)
								if JukePath[eyy]:sub(exx,exx) == '*' then
									local vTreeOffset = flTreeWidth*Vector(xx-3,0,0) + flTreeHeight*Vector(0,3-yy,0)
									local vPos = vCorner + vTreeOffset
									local szRandomCavernTreeModel = _G.CavernTreeModelNames[ RandomInt( 1, #_G.CavernTreeModelNames ) ]
									self:SpawnTempTreeWithModel( vPos, 2000, szRandomCavernTreeModel )
									table.insert( SpawnedDoodadPositions, vPos )
								end
							end
						end
					end
				end
			end
		end
	end

	local bSpawnCornerDoodad = true
	if bSpawnCornerDoodad then
		local fShopChance = 1 - CORNER_SHOP_CHANCE_PER_ROOM
		local fBountyHunterChance = fShopChance - CORNER_BOUNTY_HUNTER_CHANCE_PER_ROOM
		local fRoll = RandomFloat( 0, 1 )

		if fRoll > fShopChance then
			local vPos = ShopCorners[ RandomInt( 1, #ShopCorners ) ]
			local hCornerShop = self:SpawnNonCreepByName( "npc_dota_cavern_shop", vPos, true, nil, nil, DOTA_TEAM_NEUTRALS )
			if hCornerShop ~= nil then
				hCornerShop:SetAbsOrigin( GetGroundPosition( vPos, hCornerShop ) )
				hCornerShop:SetShopType( DOTA_SHOP_HOME )

				local Trigger = SpawnDOTAShopTriggerRadiusApproximate( hCornerShop:GetOrigin(), CAVERN_SHOP_RADIUS )
				if Trigger then
					Trigger:SetShopType( DOTA_SHOP_HOME )
				end

				GridNav:DestroyTreesAroundPoint( vPos, 100, false )

	 			GameRules.Cavern:CreateShopOverheadParticle( hCornerShop )
				table.insert( SpawnedDoodadPositions, vPos )
			else
				printf( "ERROR: GenerateDoodads -- Failed to spawn shop at %s", vPos )
				return
			end
		elseif ( fRoll > fBountyHunterChance ) and ( not self.hRoom:GetTeamSpawnInRoom() ) then
			local vPos = RoomCorners[ RandomInt( 1, #RoomCorners ) ]
			local szUnitName = "npc_dota_statue_bounty_hunter"
			local hUnit = self:SpawnNonCreepByName( szUnitName, vPos, true, nil, nil, DOTA_TEAM_BADGUYS )
			if hUnit ~= nil then
				GridNav:DestroyTreesAroundPoint( vPos, 100, false )
				table.insert( SpawnedDoodadPositions, vPos )
			else
				printf( "ERROR: GenerateDoodads -- Failed to spawn unit \"%s\" at %s", szUnitName, vPos )
				return
			end
		end
	end

	local nRandomBreakableCount = RandomInt( CAVERN_ROOM_MIN_BREAKABLE_DENSITY_PER_ROOM, CAVERN_ROOM_MAX_BREAKABLE_DENSITY_PER_ROOM )
	for i = 1, nRandomBreakableCount do
		local vPos = self:GetGoodCrateSpawnPos( SpawnedDoodadPositions, BreakableCorners )
		if vPos then
			local hUnit = self:SpawnNonCreepByName( "npc_dota_crate", vPos, false, nil, nil, DOTA_TEAM_BADGUYS )
			if hUnit ~= nil then
				hUnit:AddNewModifier( hUnit, self.hRoom, "modifier_breakable_container", { } )
				local fRandomScale = RandomFloat( 0.8, 1.2 )
				hUnit:SetModelScale( fRandomScale )
				hUnit:FaceTowards( hUnit:GetOrigin() + RandomVector ( 1 ) * 50 )
				table.insert( SpawnedDoodadPositions, vPos )
			end
		else
			printf( "Didn't have valid vPos for crate to spawn (GetGoodCrateSpawnPos can fail to find one)" )
		end
	end
end

--------------------------------------------------------------------

function CCavernEncounter:GetGoodCrateSpawnPos( SpawnedDoodadPositions, BreakableCorners )
	-- Try to return a good position, return nil if I can't

	local flSpread = 0.2
	local vCorner = BreakableCorners[ RandomInt( 1, 4 ) ]
	local vPos = vCorner + ( RandomFloat( -flSpread, flSpread ) * self.hRoom.vHalfX ) + ( RandomFloat( -flSpread, flSpread ) * self.hRoom.vHalfY )

	local nAttempts = 0
	while ( ( ( not GridNav:CanFindPath( vPos, vPos ) ) or self:IsPositionTooCloseToADoodad( SpawnedDoodadPositions, vPos ) ) and ( nAttempts < 10 ) ) do
		vCorner = BreakableCorners[ RandomInt( 1, 4 ) ]
		vPos = vCorner + ( RandomFloat( -flSpread, flSpread ) * self.hRoom.vHalfX ) + ( RandomFloat( -flSpread, flSpread ) * self.hRoom.vHalfY )
		nAttempts = nAttempts + 1
	end

	if GridNav:CanFindPath( vPos, vPos ) and self:IsPositionTooCloseToADoodad( SpawnedDoodadPositions, vPos ) == false then
		return vPos
	end

	return nil
end

--------------------------------------------------------------------

function CCavernEncounter:IsPositionTooCloseToADoodad( SpawnedDoodadPositions, vPos )
	local nMinDistance = 100
	for _, vDoodadPos in pairs( SpawnedDoodadPositions ) do
		local fDistance = ( vDoodadPos - vPos ):Length2D()
		if fDistance < nMinDistance then
			--printf( "vPos is within %d units of an existing doodad", nMinDistance )
			return true
		end
	end

	return false
end

--------------------------------------------------------------------
