
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_combat_trollcamp == nil then
	encounter_combat_trollcamp = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_combat_trollcamp:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_trollcamp:GetEncounterLevels()
	return { 1 }
end

--------------------------------------------------------------------

function encounter_combat_trollcamp:Start()
	CCavernEncounter.Start( self )

	self:SetNumUnitsToSpawn( 1 )	
	local vSpawnPoint = self.hRoom.vRoomCenter

	-- Note: spawning a building seems to silently fail if we try to pass "true" for the FindClearSpace argument
	local hUnit = self:SpawnCreepByName( "npc_dota_creature_troll_camp1", vSpawnPoint, false, nil, nil, DOTA_TEAM_BADGUYS )
	hUnit:SetForwardVector( Vector( 0, -1, 0 ) )
	self.hSpawner = hUnit:AddNewModifier(
		hUnit, nil, "modifier_generic_spawner", 
		{
			npc_name = "npc_dota_neutral_forest_troll_berserker_cavern", 
			spawn_rate = 0.5, 
			radius = 175, 
			max_spawns = 10, 
			on_take_damage = true
		}
	)

	hUnit:AddNewModifier( hUnit, nil, "modifier_troll_camp", { duration = -1 } )

	self.hRoom.hRoomVolume:SetContextThink( GetEncounterContext( "Trollcamp" ), function() return self:OnThink() end, 0.0 )

	return true
end

--------------------------------------------------------------------

function encounter_combat_trollcamp:OnThink()
	if IsServer() then
		if not self.bActive then
			return nil
		end

		local flRange = 2500
		local heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.hRoom.vRoomCenter, nil, flRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )

		if #heroes > 0 then
			self.hSpawner.disabled = false
		else
			self.hSpawner.disabled = true
		end

		return 1.0
	end
end

--------------------------------------------------------------------

