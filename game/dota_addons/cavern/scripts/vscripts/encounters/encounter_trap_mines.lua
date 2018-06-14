require( "encounters/encounter_trap_base" )

if encounter_trap_mines == nil then
	encounter_trap_mines = class({},{}, encounter_trap_base)
end

LinkLuaModifier( "modifier_trap_techies_land_mine", "modifiers/modifier_trap_techies_land_mine", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------

function encounter_trap_mines:GetEncounterLevels()
	return { 1, 2, 3, 4 }
end

--------------------------------------------------------------------
function encounter_trap_mines:Start()

	encounter_trap_base.Start(self)

	local MineCount = { 25, 35, 50, 65 }

	local nCreepCount = MineCount[ self.hRoom:GetRoomLevel() ]
	local hUnits = self:SpawnNonCreepsRandomlyInRoom( "npc_dota_creature_techies_land_mine", nCreepCount, 0.7)

	for _,hUnit in pairs(hUnits) do
		hUnit:AddNewModifier(hUnit, nil, "modifier_trap_techies_land_mine", { fadetime=0.1, radius=180, radius_random_max=200, proximity_threshold=200, percentage_damage=40, activation_delay=0.9, invisible=true } )
		hUnit:SetTeam( DOTA_TEAM_BADGUYS )
	end

	return true
end
--------------------------------------------------------------------
