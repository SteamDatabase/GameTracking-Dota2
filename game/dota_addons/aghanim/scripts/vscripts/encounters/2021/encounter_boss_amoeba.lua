require( "encounters/encounter_boss_base" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_BossAmoeba == nil then
	CMapEncounter_BossAmoeba = class( {}, {}, CMapEncounter_BossBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:constructor( hRoom, szEncounterName )
	CMapEncounter_BossBase.constructor( self, hRoom, szEncounterName )

	self:AddSpawner( CDotaSpawner( "spawner_boss", "spawner_boss",
		{
			{
				EntityName = self:GetPreviewUnit(),
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
	
			},
		} ) )

	self.nBabyCount = 0
	self.nBabyCountUltTrigger = 25
	
	self.flUltCooldownMin = 12
	self.flUltCooldownMax = 30
	self.flUltCooldownInitial = 15

	self.flNextUltTimeMin = GameRules:GetGameTime() + self.flUltCooldownInitial
	self.flNextUltTimeMax = GameRules:GetGameTime() + self.flUltCooldownInitial

	self.nAmoebaCountBoss = 1
	self.nAmoebaCountLarge = 2
	self.nAmoebaCountMedium = 4
	self.nAmoebaCountSmall = 8

	self.BossHealthTable = {}
	self.fBossMaxHealth = self:GenerateBossMaxHealth()
end

--------------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:GetPreviewUnit()
	return "npc_dota_creature_amoeba_boss"
end

--------------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:GetBaseHealthForAmoeba( szBossName )
	local kv = GetUnitKeyValuesByName( szBossName )
	return kv.StatusHealth
end

---------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:GetHealthPerLevelForAmoeba( szBossName )
	local kv = GetUnitKeyValuesByName( szBossName )
	return kv.Creature.HPGain
end

--------------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:GenerateBossMaxHealth()
	local nTotal = 0

	local nAscensionLevel = GameRules.Aghanim:GetAscensionLevel()

	self.BossHealthTable[1] = {}
	self.BossHealthTable[1].StatusHealth = self:GetBaseHealthForAmoeba( 'npc_dota_creature_amoeba_boss' )
	self.BossHealthTable[1].HealthPerLevel = self:GetHealthPerLevelForAmoeba( 'npc_dota_creature_amoeba_boss' )

	self.BossHealthTable[2] = {}
	self.BossHealthTable[2].StatusHealth = self:GetBaseHealthForAmoeba( 'npc_dota_creature_amoeba_large' )
	self.BossHealthTable[2].HealthPerLevel = self:GetHealthPerLevelForAmoeba( 'npc_dota_creature_amoeba_large' )

	self.BossHealthTable[3] = {}
	self.BossHealthTable[3].StatusHealth = self:GetBaseHealthForAmoeba( 'npc_dota_creature_amoeba_medium' )
	self.BossHealthTable[3].HealthPerLevel = self:GetHealthPerLevelForAmoeba( 'npc_dota_creature_amoeba_medium' )

	self.BossHealthTable[4] = {}
	self.BossHealthTable[4].StatusHealth = self:GetBaseHealthForAmoeba( 'npc_dota_creature_amoeba_small' )
	self.BossHealthTable[4].HealthPerLevel = self:GetHealthPerLevelForAmoeba( 'npc_dota_creature_amoeba_small' )

	--print( '1 boss amoeba health = ' .. self.BossHealthTable[1].StatusHealth + ( self.BossHealthTable[1].HealthPerLevel * nAscensionLevel ) )
	nTotal = nTotal + ( self.nAmoebaCountBoss * ( self.BossHealthTable[1].StatusHealth + ( self.BossHealthTable[1].HealthPerLevel * nAscensionLevel ) ) )
	--print( ' Total Health = ' .. nTotal )
	
	--print( '1 large amoeba health = ' .. self.BossHealthTable[2].StatusHealth + ( self.BossHealthTable[2].HealthPerLevel * nAscensionLevel ) )
	nTotal = nTotal + ( self.nAmoebaCountLarge * ( self.BossHealthTable[2].StatusHealth + ( self.BossHealthTable[2].HealthPerLevel * nAscensionLevel ) ) )
	--print( ' Total Health = ' .. nTotal )

	--print( '1 medium amoeba health = ' .. self.BossHealthTable[3].StatusHealth + ( self.BossHealthTable[3].HealthPerLevel * nAscensionLevel ) )
	nTotal = nTotal + ( self.nAmoebaCountMedium * ( self.BossHealthTable[3].StatusHealth + ( self.BossHealthTable[3].HealthPerLevel * nAscensionLevel ) ) )
	--print( ' Total Health = ' .. nTotal )
	
	--print( '1 small amoeba health = ' .. self.BossHealthTable[4].StatusHealth + ( self.BossHealthTable[4].HealthPerLevel * nAscensionLevel ) )
	nTotal = nTotal + ( self.nAmoebaCountSmall * ( self.BossHealthTable[4].StatusHealth + ( self.BossHealthTable[4].HealthPerLevel * nAscensionLevel ) ) )
	--print( ' Total Health = ' .. nTotal )

	return nTotal
end

--------------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:Precache( context )
	CMapEncounter_BossBase.Precache( self, context )
	
	PrecacheUnitByNameSync( "npc_dota_creature_amoeba_large", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_creature_amoeba_medium", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_creature_amoeba_small", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_creature_amoeba_baby", context, -1 )

	--PrecacheResource( "particle_folder", "particles/units/heroes/hero_shredder", context )
	--PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_shredder.vsndevts", context )
	--PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_shredder.vsndevts", context )
	--PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_chakram_aghs.vpcf", context )
	--PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_chakram_stay.vpcf", context )
	--PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_chakram_return.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:OnEncounterLoaded()
	CMapEncounter_BossBase.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:OnThink()
	CMapEncounter_BossBase.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:CanAmoebaCastBlobSuck( hAmoeba )
	--print( 'CAN CAST SUCK? - next ult time min = ' .. self.flNextUltTimeMin .. '. ult time max = ' .. self.flNextUltTimeMax .. '. Game Time = ' .. GameRules:GetGameTime() .. '. Baby Count = ' .. self.nBabyCount )

	-- if we're in the min time between ults then the baby count can also trigger it
	if self.flNextUltTimeMin < GameRules:GetGameTime() then
		if self.nBabyCount > self.nBabyCountUltTrigger then
			--print( 'YES! BABY COUNT TRIGGERED WITHIN THE MIN WINDOW' )
			self.flNextUltTimeMin = GameRules:GetGameTime() + self.flUltCooldownMin
			self.flNextUltTimeMax = GameRules:GetGameTime() + self.flUltCooldownMax
			return true
		end
	end

	-- at a certain point we're just going to let it go through to keep it spicy
	if self.flNextUltTimeMax < GameRules:GetGameTime() then
		--print( 'YES! MAX WINDOW TRIGGERED' )
		self.flNextUltTimeMin = GameRules:GetGameTime() + self.flUltCooldownMin
		self.flNextUltTimeMax = GameRules:GetGameTime() + self.flUltCooldownMax
		return true
	end

	--print( 'NO' )
	return false
	--[[
	for _,hBoss in pairs( self.Bosses ) do
		if hBoss.AI ~= nil then
			if hBoss.AI.hBlobSuck ~= nil then
				if hBoss.AI.hBlobSuck:IsFullyCastable() then
					hBoss.AI:Interrupt()
					hBoss.AI
				end
			end
		end
	end
	]]--
end

--------------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:OnNonPlayerBeginCast( event )
	CMapEncounter_BossBase.OnNonPlayerBeginCast( self, event )

	--if event.abilityname ~= nil and event.abilityname == "amoeba_blob_suck" then
	--	print( 'BLOB IS SUCKING! RESETTING TIMER!' )
	--	self.flNextUltTime = GameRules:GetGameTime() + self.flUltCooldown
	--end
end

--------------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:MustKillForEncounterCompletion( hEnemyCreature )
    if hEnemyCreature:GetUnitName() == "npc_dota_creature_amoeba_baby" or
       hEnemyCreature:GetUnitName() == "npc_dota_dummy_caster" then
    	return false
    end
    return true
end

--------------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:OnBossSpawned( hBoss )
	CMapEncounter_BossBase.OnBossSpawned( self, hBoss )

	hBoss.AI:SetEncounter( self )
end

---------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:UpdateBossHP()
	local flHPResolution = 500.0;

	local netTable = {}
	local nEntIndex = -1;
	local szUnitName = self:GetBossUnitName();

	local flMaxHP = 0
	local flCurHP = 0
	local flBossHP = 0
	local bAnyActive = false

	local nAmoebasToSpawnBoss = self.nAmoebaCountBoss
	local nAmoebasToSpawnLarge = self.nAmoebaCountLarge
	local nAmoebasToSpawnMedium = self.nAmoebaCountMedium
	local nAmoebasToSpawnSmall = self.nAmoebaCountSmall

	for _,hBoss in pairs ( self.Bosses ) do
		if hBoss and not hBoss:IsNull() then
			if hBoss:IsAlive() then
				bAnyActive = true
				flCurHP = flCurHP + hBoss:GetHealth()

				if hBoss:GetUnitName() == 'npc_dota_creature_amoeba_boss' then
					nAmoebasToSpawnBoss = nAmoebasToSpawnBoss - 1
					--print( 'FOUND A LIVING BOSS - reducing boss number by 1 to ' .. nAmoebasToSpawnBoss )
				elseif hBoss:GetUnitName() == 'npc_dota_creature_amoeba_large' then
					nAmoebasToSpawnLarge = nAmoebasToSpawnLarge - 1
					--print( 'FOUND A LIVING LARGE - reducing large number by 1 to ' .. nAmoebasToSpawnLarge )
				elseif hBoss:GetUnitName() == 'npc_dota_creature_amoeba_medium' then
					nAmoebasToSpawnMedium = nAmoebasToSpawnMedium - 1
					--print( 'FOUND A LIVING MEDIUM - reducing medium number by 1 to ' .. nAmoebasToSpawnMedium )
				elseif hBoss:GetUnitName() == 'npc_dota_creature_amoeba_small' then
					nAmoebasToSpawnSmall = nAmoebasToSpawnSmall - 1
					--print( 'FOUND A LIVING SMALL - reducing large number by 1 to ' .. nAmoebasToSpawnSmall )
				end
			end
			nEntIndex = hBoss:entindex()
		end
	end

	--print( 'Health for living amoebas is ' .. flCurHP )
	--print( 'Adding health for ' .. nAmoebasToSpawnBoss .. ' BOSS' )
	--print( 'Adding health for ' .. nAmoebasToSpawnLarge .. ' LARGE' )
	--print( 'Adding health for ' .. nAmoebasToSpawnMedium .. ' MEDIUM' )
	--print( 'Adding health for ' .. nAmoebasToSpawnSmall .. ' SMALL' )

	local nAscensionLevel = GameRules.Aghanim:GetAscensionLevel()
	flCurHP = flCurHP + ( nAmoebasToSpawnBoss * ( self.BossHealthTable[1].StatusHealth + ( self.BossHealthTable[1].HealthPerLevel * nAscensionLevel ) ) )
	flCurHP = flCurHP + ( nAmoebasToSpawnLarge * ( self.BossHealthTable[2].StatusHealth + ( self.BossHealthTable[2].HealthPerLevel * nAscensionLevel ) ) )
	flCurHP = flCurHP + ( nAmoebasToSpawnMedium * ( self.BossHealthTable[3].StatusHealth + ( self.BossHealthTable[3].HealthPerLevel * nAscensionLevel ) ) )
	flCurHP = flCurHP + ( nAmoebasToSpawnSmall * ( self.BossHealthTable[4].StatusHealth + ( self.BossHealthTable[4].HealthPerLevel * nAscensionLevel ) ) )

	--print( 'Final current health = ' .. flCurHP )

	flBossHP = math.floor( flHPResolution * ( flCurHP / self.fBossMaxHealth ) ) / flHPResolution;

	CustomNetTables:SetTableValue( "boss_net_table", "current_boss", { active=bAnyActive, hp = flBossHP, ent_index=nEntIndex, unit_name=szUnitName } )
end

---------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:OnEnemyCreatureSpawned( hEnemyCreature )
	CMapEncounter_BossBase.OnEnemyCreatureSpawned( self, hEnemyCreature )

	if hEnemyCreature:GetUnitName() == "npc_dota_creature_amoeba_baby" then
		self.nBabyCount = self.nBabyCount + 1
		--print( 'BABY SPAWNED! Up to ' .. self.nBabyCount )
	end

	if hEnemyCreature:GetUnitName() ~= "npc_dota_creature_amoeba_boss" and
	   hEnemyCreature:GetUnitName() ~= "npc_dota_creature_amoeba_baby" and
	   hEnemyCreature:GetUnitName() ~= "npc_dota_dummy_caster" then
		--print( 'Calling AddBossToBossTable() for name = ' .. hEnemyCreature:GetUnitName() )
		self:AddBossToBossTable( hEnemyCreature )
	end

	if	hEnemyCreature:GetUnitName() == 'npc_dota_creature_amoeba_large' or
		hEnemyCreature:GetUnitName() == 'npc_dota_creature_amoeba_medium' or
		hEnemyCreature:GetUnitName() == 'npc_dota_creature_amoeba_small' or
		hEnemyCreature:GetUnitName() == 'npc_dota_creature_amoeba_baby' then

		hEnemyCreature.AI:SetEncounter( self )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:OnEntityKilled( event )
	CMapEncounter_BossBase.OnEntityKilled( self, event )

	local hVictim = nil
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end

	if hVictim ~= nil then
		if hVictim:GetUnitName() == "npc_dota_creature_amoeba_boss" then
			self.nAmoebaCountBoss = self.nAmoebaCountBoss - 1
		elseif hVictim:GetUnitName() == "npc_dota_creature_amoeba_large" then
			self.nAmoebaCountLarge = self.nAmoebaCountLarge - 1
		elseif hVictim:GetUnitName() == "npc_dota_creature_amoeba_medium" then
			self.nAmoebaCountMedium = self.nAmoebaCountMedium - 1
		elseif hVictim:GetUnitName() == "npc_dota_creature_amoeba_small" then
			self.nAmoebaCountSmall = self.nAmoebaCountSmall - 1
		elseif hVictim:GetUnitName() == "npc_dota_creature_amoeba_baby" then
			self.nBabyCount = self.nBabyCount - 1
			--print( 'BABY KILLED! Down to ' .. self.nBabyCount )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:IntroduceBoss( hEncounteredBoss )
	CMapEncounter_BossBase.IntroduceBoss( self, hEncounteredBoss )

	EmitGlobalSound( "Boss.Intro" )

	local hRelays
	hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "entrance_relay", false )
	for _, hRelay in pairs( hRelays ) do
		print( 'FOUND RELAY! Triggering!' )
		hRelay:Trigger( nil, nil )
	end
end

---------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:StartBossFight()
	CMapEncounter_BossBase.StartBossFight( self )

	self.flNextUltTimeMin = GameRules:GetGameTime() + self.flUltCooldownInitial
	self.flNextUltTimeMax = GameRules:GetGameTime() + self.flUltCooldownInitial
end

---------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:OnBossKilled( hBoss, hAttacker )
	CMapEncounter_BossBase.OnBossKilled( self, hBoss, hAttacker )

	if #self.Bosses == 0 then
		local vecBabies = self:GetRoom():FindAllEntitiesInRoomByName( "npc_dota_creature_amoeba_baby", false )
		if #vecBabies > 0 then
			for _,hBaby in pairs ( vecBabies ) do
				hBaby:ForceKill( false )
			end
		end

	elseif #self.Bosses == 1 and self.Bosses[1]:GetUnitName() == "npc_dota_creature_amoeba_small" then
		-- Now, let's add the gold modifier to the last remaining boss.
		print( '**1** Amoeba left! Adding gold fountain ability' )

		local hAbility = self.Bosses[1]:AddAbility( "generic_gold_bag_fountain_8000" )
		hAbility:UpgradeAbility( true )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:OnComplete()
	CMapEncounter_BossBase.OnComplete( self )

	print( 'COMPLETE! Attempting to open completion door!' )
	local hRelays
	hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "completion_door_relay", false )
	for _, hRelay in pairs( hRelays ) do
		print( 'FOUND RELAY! Triggering!' )
		hRelay:Trigger( nil, nil )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BossAmoeba:OnTriggerStartTouch( event )
	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	-- Teleport hero to location inside the arena
	if szTriggerName == "trigger_entrance" then
		--print( "Player has left the arena!" )
		local hTeleportTargetEntrance = Entities:FindByName( nil, "teleport_players" )
		local vTeleportPosEntrance = hTeleportTargetEntrance:GetAbsOrigin()
		FindClearSpaceForUnit( hUnit, vTeleportPosEntrance, true )
	end

end

--------------------------------------------------------------------------------

return CMapEncounter_BossAmoeba

