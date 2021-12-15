require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

--------------------------------------------------------------------------------

if CMapEncounter_Gaolers == nil then
	CMapEncounter_Gaolers = class( {}, {}, CMapEncounter )
end


--------------------------------------------------------------------------------

function CMapEncounter_Gaolers:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_razor", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_ogre_magi", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_phantom_assassin", context )
	PrecacheResource( "particle", "particles/econ/events/plus/high_five/high_five_lvl3_overhead_hearts.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_razor.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Gaolers:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.hPrisoners = {}

	self:AddSpawner( CDotaSpawner( "spawner_gaoler", "spawner_gaoler",
		{ 
			{
				EntityName = "npc_dota_creature_gaoler",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )


	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{ 
			{
				EntityName = "npc_dota_creature_meranth_guard",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 200.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_prisoner_1", "spawner_prisoner_1",
		{ 
			{
				EntityName = "npc_dota_creature_meranth_prisoner_1",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 200.0,
			},
		} ) )
	self:AddSpawner( CDotaSpawner( "spawner_prisoner_2", "spawner_prisoner_2",
		{ 
			{
				EntityName = "npc_dota_creature_meranth_prisoner_2",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 200.0,
			},
		} ) )
	self:AddSpawner( CDotaSpawner( "spawner_prisoner_3", "spawner_prisoner_3",
		{ 
			{
				EntityName = "npc_dota_creature_meranth_prisoner_3",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self:SetSpawnerSchedule( "spawner_gaoler", nil )
	self:SetSpawnerSchedule( "spawner_peon", nil )
	self:SetSpawnerSchedule( "spawner_prisoner_1", nil )
	self:SetSpawnerSchedule( "spawner_prisoner_2", nil )
	self:SetSpawnerSchedule( "spawner_prisoner_3", nil )
end


--------------------------------------------------------------------------------

function CMapEncounter_Gaolers:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "free_slardar_prisoners", 0, 3 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Gaolers:GetMaxSpawnedUnitCount()
	return CMapEncounter.GetMaxSpawnedUnitCount( self ) - 3 
end

--------------------------------------------------------------------------------

function CMapEncounter_Gaolers:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner.szSpawnerName == "spawner_prisoner_1" then
		self.hPrisoners[1] = hSpawnedUnits
		print( "CMapEncounter_Gaolers:OnSpawnerFinished - spawner_prisoner_1" )
	elseif hSpawner.szSpawnerName == "spawner_prisoner_2" then
		self.hPrisoners[2] = hSpawnedUnits
		print( "CMapEncounter_Gaolers:OnSpawnerFinished - spawner_prisoner_2" )
	elseif hSpawner.szSpawnerName == "spawner_prisoner_3" then
		self.hPrisoners[3] = hSpawnedUnits
		print( "CMapEncounter_Gaolers:OnSpawnerFinished - spawner_prisoner_3" )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Gaolers:MustKillForEncounterCompletion( hEnemyCreature )
	if hEnemyCreature:GetUnitName() == "npc_dota_creature_meranth_prisoner_1" or
	   hEnemyCreature:GetUnitName() == "npc_dota_creature_meranth_prisoner_2" or
	   hEnemyCreature:GetUnitName() == "npc_dota_creature_meranth_prisoner_3" then
		return false
	end

	return CMapEncounter.MustKillForEncounterCompletion( self, hEnemyCreature )
end

--------------------------------------------------------------------------------

function CMapEncounter_Gaolers:GetPreviewUnit()
	return "npc_dota_creature_gaoler"
end

--------------------------------------------------------------------------------

function CMapEncounter_Gaolers:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Gaolers:OnTriggerStartTouch( event )
	CMapEncounter.OnTriggerStartTouch( self, event )

	-- Get the trigger that activates the room
	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )

	self.hPrisonersToRelease = nil
	if self.hPrisoners ~= nil then
		if szTriggerName == "cell_button_1" then
			print( "Cell 1 has been opened!" )
			self.hPrisonersToRelease = self.hPrisoners[1]
		elseif szTriggerName == "cell_button_2" then
			print( "Cell 2 has been opened!" )
			self.hPrisonersToRelease = self.hPrisoners[2]
		elseif szTriggerName == "cell_button_3" then
			print( "Cell 3 has been opened!" )
			self.hPrisonersToRelease = self.hPrisoners[3]
		end
	end

	if self.hPrisonersToRelease ~= nil then
		for _,hPrisoner in pairs( self.hPrisonersToRelease ) do
			if hPrisoner ~= nil and hPrisoner:IsNull() == false and hPrisoner:IsAlive() == true then
				print( '^^^Releasing a prisoner!!! - ' .. hPrisoner:GetUnitName() )
				hPrisoner:RemoveAbility( 'ability_prisoner_locked_up' )
				hPrisoner:RemoveModifierByName( 'modifier_prisoner_locked_up' )
				local nCurrentValue = self:GetEncounterObjectiveProgress( "free_slardar_prisoners" )
				self:UpdateEncounterObjective( "free_slardar_prisoners", nCurrentValue + 1, nil )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Gaolers:OnComplete()
	CMapEncounter.OnComplete( self )

	-- Reward some gold for each prisoner that has survived
	if self.hPrisoners ~= nil then
		for _,hPrisoners in pairs( self.hPrisoners ) do
			for _,hPrisoner in pairs( hPrisoners ) do
				if hPrisoner ~= nil and hPrisoner:IsNull() == false and hPrisoner:IsAlive() then
					hPrisoner:RemoveAbility( 'ability_prisoner_locked_up' )
					hPrisoner:RemoveModifierByName( 'modifier_prisoner_locked_up' )
					hPrisoner.bStartRescue = true

					local hGoldAbility = hPrisoner:FindAbilityByName( 'generic_ability_gold_bag_fountain_250' )
					if hGoldAbility ~= nil then
						hPrisoner.szGoldFountainAbility = "generic_ability_gold_bag_fountain_250"
						local gold_value = hGoldAbility:GetSpecialValueFor( "gold_value" )
						local duration = hGoldAbility:GetSpecialValueFor( "duration" )
						local think_interval = hGoldAbility:GetSpecialValueFor( "think_interval" )
						local nGoldAmount = math.ceil( ( duration / think_interval ) * gold_value )
						--print( 'GOLD CALCULATED = ' .. nGoldAmount )

						local bFireEvent = false
						local gameEvent = {}
						gameEvent["player_id"] = 0
						gameEvent["teamnumber"] = DOTA_TEAM_GOODGUYS
						gameEvent["message"] = "#DOTA_HUD_EncounterGaolers_RescuedPrisoner"
						gameEvent["int_value"] = tonumber( nGoldAmount )
						if hPrisoner:GetUnitName() == 'npc_dota_creature_meranth_prisoner_1' then
							gameEvent["locstring_value"] = "#npc_dota_creature_meranth_prisoner_1"
							bFireEvent = true
						elseif hPrisoner:GetUnitName() == 'npc_dota_creature_meranth_prisoner_2' then
							gameEvent["locstring_value"] = "#npc_dota_creature_meranth_prisoner_2"
							bFireEvent = true
						elseif hPrisoner:GetUnitName() == 'npc_dota_creature_meranth_prisoner_3' then
							gameEvent["locstring_value"] = "#npc_dota_creature_meranth_prisoner_3"
							bFireEvent = true
						end

						if bFireEvent then
							hPrisoner.tGoldFountainGameEvent = gameEvent
						end
					end

					local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/plus/high_five/high_five_lvl3_overhead_hearts.vpcf", PATTACH_OVERHEAD_FOLLOW, hPrisoner )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Gaolers
