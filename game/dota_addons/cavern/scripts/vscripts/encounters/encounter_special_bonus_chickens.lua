
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_special_bonus_chickens == nil then
	encounter_special_bonus_chickens = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_special_bonus_chickens:GetEncounterType()
	return CAVERN_ROOM_TYPE_SPECIAL
end

--------------------------------------------------------------------

function encounter_special_bonus_chickens:GetEncounterLevels()
	return { 1, 2, 3, 4 }
end

--------------------------------------------------------------------

function encounter_special_bonus_chickens:IsCleared()
	return self.bSpawned == true
end

--------------------------------------------------------------------

function encounter_special_bonus_chickens:Start()
	
	CCavernEncounter.Start( self )
	
	self.bSpawned = false;
	self.hRoom.hRoomVolume:SetContextThink( GetEncounterContext("Chicken"), function() return self:OnThink() end, 0.0 )

	return true
end

function encounter_special_bonus_chickens:Spawn()
	local nCreepCount = 7 * self.hRoom:GetRoomLevel()
	self:SpawnNonCreepsRandomlyInRoom( "npc_dota_creature_small_bonus_chicken", nCreepCount, 0.8)
	self.bSpawned = true
end


function encounter_special_bonus_chickens:OnThink()
	if IsServer() then
		if not self.bActive then
			return nil
		end

		if self.bSpawned then
			return nil
		end

		-- spawn chickens once someone gets close to the center of the room
		local heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.hRoom.vRoomCenter, nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )

		if #heroes > 0 then
			self:Spawn()
		end	

		return 0.5
	end
end

--------------------------------------------------------------------
