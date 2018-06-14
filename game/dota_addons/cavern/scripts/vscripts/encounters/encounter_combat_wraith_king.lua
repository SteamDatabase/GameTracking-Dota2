
require( "cavern_encounter" )

LinkLuaModifier( "modifier_creature_wraith_king_reincarnation", "modifiers/modifier_creature_wraith_king_reincarnation", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_wraith_king_wake", "modifiers/modifier_creature_wraith_king_wake", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------

if encounter_combat_wraith_king == nil then
	encounter_combat_wraith_king = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_combat_wraith_king:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_wraith_king:GetEncounterLevels()
	return { 3 }
end

function encounter_combat_wraith_king:Reset()
	CCavernEncounter.Reset( self )
	self.bWraithsKilled = false
	self.bEncounterCleared = false
end

function encounter_combat_wraith_king:IsCleared()
	return self.bEncounterCleared == true
end

function encounter_combat_wraith_king:ApplyAllRewardsToChest()
	return true
end

--------------------------------------------------------------------

function encounter_combat_wraith_king:Start()
	CCavernEncounter.Start( self )
	
	self.EventQueue = CEventQueue()
	self.nNumUnitsToSpawn = 4
	local flOffsetMin = 250
	local flOffsetMax = 500

	for i = 1, self.nNumUnitsToSpawn do
		local vSpawnPoint = self.hRoom.vRoomCenter + ( RandomVector( 1 ) * RandomFloat( flOffsetMin, flOffsetMax ) )
		local hUnit = self:SpawnNonCreepByName( "npc_dota_creature_wraith_king", vSpawnPoint, true, nil, nil, DOTA_TEAM_BADGUYS )
		hUnit:AddNewModifier(hUnit, nil, "modifier_creature_wraith_king_reincarnation", {} )

		hUnit:FaceTowards( vSpawnPoint + RandomVector( 1 ) * flOffsetMin )
	end

	self.hRoom.hRoomVolume:SetContextThink( GetEncounterContext( "WraithKing" ), function() return self:OnThink() end, 0.0 )

	return true
end

--------------------------------------------------------------------

function encounter_combat_wraith_king:OnThink()
	if IsServer() then

		if self.bEncounterCleared then
			return nil
		end

		if self.bWraithsKilled then
			return 0.5
		end

		local bAllDead = true

		for _,hUnit in pairs(self.hUnits) do
			--printf("unit %s alive %s awake %s", _, hUnit:IsAlive(), hUnit.bAwake)
			if hUnit.FindModifierByName ~= nil and not hUnit:IsNull() and hUnit:FindModifierByName("modifier_creature_wraith_king_reincarnation") ~= nil then
				if hUnit:IsAlive() and hUnit.bAwake == true then
					bAllDead = false
				end
			end
		end

		if bAllDead then 
			for _,hUnit in pairs(self.hUnits) do
				if hUnit.FindModifierByName ~= nil and not hUnit:IsNull() and hUnit:FindModifierByName("modifier_creature_wraith_king_reincarnation") ~= nil then
					hUnit:RemoveModifierByName("modifier_creature_wraith_king_reincarnation")
					StopSoundOn( "Cavern.Reincarnate", hUnit )
					hUnit:SetUnitCanRespawn(false)
					hUnit:ForceKill(false)
				end
			end

			self.bWraithsKilled = true
			self.EventQueue:AddEvent( 0.5, 
			function(self)	
				self.bEncounterCleared = true
			end, self )

		end

		return 0.5
	end
end

--------------------------------------------------------------------

