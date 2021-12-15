
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_FrozenRavine == nil then
	CMapEncounter_FrozenRavine = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_FrozenRavine:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	local bInvulnerable = true
	self.bPenguin1CrateOpened = false
	self.bPenguin2CrateOpened = false
	self.bPenguin3CrateOpened = false
	self.bPenguin4CrateOpened = false
	self.bPenguin5CrateOpened = false

	self:AddSpawner( CDotaSpawner( "spawner_penguin", "spawner_penguin",
		{ 
			{
				EntityName = "npc_dota_rescue_penguin",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( "preplaced_enemies_peons", "spawner_peon",
		{ 
			{
				EntityName = "npc_dota_creature_yak",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 150.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( "preplaced_enemies_captains", "spawner_captain",
		{ 
			{
				EntityName = "npc_dota_creature_frozen_giant",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self:SetSpawnerSchedule( "spawner_penguin", nil )
	self:SetSpawnerSchedule( "preplaced_enemies_peons", nil )
	self:SetSpawnerSchedule( "preplaced_enemies_captains", nil )
	
	self:SetCalculateRewardsFromUnitCount( true )
end

--------------------------------------------------------------------------------

function CMapEncounter_FrozenRavine:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_riki/riki_blink_strike.vpcf", context )
	PrecacheResource( "particle", "particles/destruction/wooden_cage_destruction.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_FrozenRavine:GetPreviewUnit()
	return "npc_dota_creature_frozen_giant"
end

--------------------------------------------------------------------------------

function CMapEncounter_FrozenRavine:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_FrozenRavine:Start()
	CMapEncounter.Start( self )
	self.vecPenguinRestPoints = self:GetRoom():FindAllEntitiesInRoomByName( "igloo_penguin", true )
end

--------------------------------------------------------------------------------

function CMapEncounter_FrozenRavine:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "rescue_penguins", 0, 5 )
end

--------------------------------------------------------------------------------

function CMapEncounter_FrozenRavine:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )
end


--------------------------------------------------------------------------------

function CMapEncounter_FrozenRavine:GetMaxSpawnedUnitCount()
	local nCount = CMapEncounter.GetMaxSpawnedUnitCount( self )
	return nCount - 5 
end

--------------------------------------------------------------------------------

function CMapEncounter_FrozenRavine:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	for _,hSpawnedUnit in pairs( hSpawnedUnits ) do 

		if hSpawnedUnit:GetUnitName() == "npc_dota_rescue_penguin" then
			hSpawnedUnit:AddNewModifier( hSpawnedUnit, nil, "modifier_no_healthbar", { duration = -1 } ) 
			hSpawnedUnit:AddNewModifier( hSpawnedUnit, nil, "modifier_invulnerable", { duration = -1 } )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_FrozenRavine:OnThink()
	CMapEncounter.OnThink( self )

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do 
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero then 
			if hPlayerHero.vecPenguins ~= nil then 
				for _,hPenguin in pairs ( hPlayerHero.vecPenguins ) do 
					if hPenguin and hPenguin:IsNull() == false and hPenguin:IsAlive() and not hPenguin.bRescued then
						hPenguin:MoveToNPC( hPlayerHero )
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_FrozenRavine:OnTriggerStartTouch( event )
	CMapEncounter.OnTriggerStartTouch( self, event )

	-- Get the trigger that activates the room
	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )

	printf( "szTriggerName: %s, hUnit:GetUnitName(): %s, hTriggerEntity:GetName(): %s", szTriggerName, hUnit:GetUnitName(), hTriggerEntity:GetName() )

	if hUnit == nil then 
		return 
	end

	local bRealHero = hUnit:IsRealHero()
	if hUnit:IsRealHero() then 
		if szTriggerName == "trigger_penguin_1" then
			if self.bPenguin1CrateOpened == false then
				print( "Penguin 1 has been rescued" )
		   		self:OnPenguinCrateOpened( hUnit, hTriggerEntity )
		   		self.bPenguin1CrateOpened = true
		   	end
		elseif szTriggerName == "trigger_penguin_2" then
			if self.bPenguin2CrateOpened == false then
				print( "Penguin 2 has been rescued" )
		   		self:OnPenguinCrateOpened( hUnit, hTriggerEntity )
		   		self.bPenguin2CrateOpened = true
		   	end
		elseif szTriggerName == "trigger_penguin_3" then
			if self.bPenguin3CrateOpened == false then
				print( "Penguin 3 has been rescued" )
		   		self:OnPenguinCrateOpened( hUnit, hTriggerEntity )
		   		self.bPenguin3CrateOpened = true
		   	end
		elseif szTriggerName == "trigger_penguin_4" then
			if self.bPenguin4CrateOpened == false then
				print( "Penguin 4 has been rescued" )
		   		self:OnPenguinCrateOpened( hUnit, hTriggerEntity )
		   		self.bPenguin4CrateOpened = true
		   	end
		elseif szTriggerName == "trigger_penguin_5" then
			if self.bPenguin5CrateOpened == false then
				print( "Penguin 5 has been rescued" )
		   		self:OnPenguinCrateOpened( hUnit, hTriggerEntity )
		   		self.bPenguin5CrateOpened = true
		   	end
		end
	end

	if hUnit:IsNull() == false and hUnit:IsAlive() and hUnit.bRescued == nil and hUnit:GetUnitName() == "npc_dota_rescue_penguin" and szTriggerName == "trigger_igloo" then 
		
		hUnit:AddNewModifier( hUnit, nil, "modifier_no_healthbar", { duration = -1 } ) 
		hUnit:AddNewModifier( hUnit, nil, "modifier_invulnerable", { duration = -1 } )

		local nIndex = RandomInt( 1, #self.vecPenguinRestPoints ) 
		local hRestPoint = self.vecPenguinRestPoints[ nIndex ]
		if hRestPoint then 
			hUnit:MoveToPosition( hRestPoint:GetAbsOrigin() )
			table.remove( self.vecPenguinRestPoints, nIndex )
		end

		local newItem = CreateItem( "item_bag_of_gold", nil, nil )
		newItem:SetPurchaseTime( 0 )
		newItem:SetCurrentCharges( 100 * AGHANIM_PLAYERS  )
		local drop = CreateItemOnPositionSync( hUnit:GetAbsOrigin(), newItem )
		local dropTarget = hUnit:GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )
		newItem:LaunchLoot( true, 150, 0.75, dropTarget )

		hUnit.bRescued = true 
		if hUnit.hFollowEntity and hUnit.hFollowEntity.vecPenguins then
			for k,v in pairs ( hUnit.hFollowEntity.vecPenguins ) do 
				if v == hUnit then 
					table.remove( hUnit.hFollowEntity.vecPenguins, k )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_FrozenRavine:OnPenguinCrateOpened( hUnit, hTriggerEntity )
	
	local hPenguins = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, hTriggerEntity:GetOrigin(), nil, 500,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )
	if #hPenguins > 0 then
		print( "Allies found" )
	end
	for _,hPenguin in pairs( hPenguins ) do
		print ( hPenguin:GetUnitName() )
		if hPenguin:GetUnitName() == "npc_dota_rescue_penguin" then
			print( "Penguin found" )
			EmitSoundOn( "Dungeon.Cage.Break", hPenguin )
			local nFXIndex = ParticleManager:CreateParticle( "particles/destruction/wooden_cage_destruction.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, hPenguin:GetOrigin() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			hPenguin:RemoveModifierByName( "modifier_no_healthbar" ) 
			hPenguin:RemoveModifierByName( "modifier_invulnerable" )
			
			hPenguin.hFollowEntity = hUnit
			hPenguin:MoveToNPC( hUnit )
			hPenguin:SetFollowRange( 300 )

			if hUnit.vecPenguins == nil then
				hUnit.vecPenguins = {} 
			end

			table.insert( hUnit.vecPenguins, hPenguin )

			local nCurrentValue = self:GetEncounterObjectiveProgress( "rescue_penguins" )
			self:UpdateEncounterObjective( "rescue_penguins", nCurrentValue + 1, 5 )
			--PrintTable( hUnit.vecPenguins, " (-> " )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_FrozenRavine:OnComplete()
	CMapEncounter.OnComplete( self )

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do 
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero then 
			if hPlayerHero.vecPenguins ~= nil then 
				for k,hPenguin in pairs ( hPlayerHero.vecPenguins ) do 
					if hPenguin and hPenguin:IsNull() == false and hPenguin:IsAlive() and not hPenguin.bRescued and hPenguin.hFollowEntity ~= nil then

						hPenguin:AddNewModifier( hPenguin, nil, "modifier_no_healthbar", { duration = -1 } ) 
						hPenguin:AddNewModifier( hPenguin, nil, "modifier_invulnerable", { duration = -1 } )

						local nIndex = RandomInt( 1, #self.vecPenguinRestPoints ) 
						local hRestPoint = self.vecPenguinRestPoints[ nIndex ]
						if hRestPoint then 
							hPenguin:MoveToPosition( hRestPoint:GetAbsOrigin() )
							table.remove( self.vecPenguinRestPoints, nIndex )
						end
						local newItem = CreateItem( "item_bag_of_gold", nil, nil )
						newItem:SetPurchaseTime( 0 )
						newItem:SetCurrentCharges( 100 * AGHANIM_PLAYERS  )
						local drop = CreateItemOnPositionSync( hPenguin:GetAbsOrigin(), newItem )
						local dropTarget = hPenguin:GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )
						newItem:LaunchLoot( true, 150, 0.75, dropTarget )

						hPenguin.bRescued = true 
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_FrozenRavine
