
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_treasure_chest == nil then
	encounter_treasure_chest = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_treasure_chest:GetEncounterType()
	return CAVERN_ROOM_TYPE_TREASURE
end

--------------------------------------------------------------------

function encounter_treasure_chest:GetEncounterLevels()
	return { 1, 2, 3, 4 }
end

--------------------------------------------------------------------

function encounter_treasure_chest:Start()

	CCavernEncounter.Start( self )

	local ChestScales = { 2, 2.5, 3, 4, 5, 5.5 }

	self.hRoom.nEffectiveLevel = self.hRoom:GetRoomLevel()
	local flRand = RandomFloat(0,1)
	if flRand >= 0.7 then
		self.hRoom.nEffectiveLevel = self.hRoom.nEffectiveLevel + 1
	end	

	self.hChest = self:SpawnNonCreepByName( "npc_special_treasure_chest", self.hRoom.vRoomCenter + RandomVector( 1 * self.hRoom.nEffectiveLevel ), true, nil, nil, DOTA_TEAM_BADGUYS )
	if self.hChest ~= nil then
		self.hChest:SetModelScale(  ChestScales[self.hRoom.nEffectiveLevel] )
		self.hChest:SetForwardVector( Vector( 0, -1, 0 ) )
	end

	self.hRoom.hRoomVolume:SetContextThink( GetEncounterContext( "SpecialTreasureChest" ), function() return self:OnThink() end, 0.2 )

	return true
end

--------------------------------------------------------------------

function encounter_treasure_chest:OnThink()
	if IsServer() then

		if not self.bActive then
			return nil
		end

		if not self.bChestInitialized then
			local nTreasureLevel = self:GetTreasureLevel()
			local nTreasureGold = self.nTreasureGoldForEncounter
			local nTreasureXP = self.nTreasureXPForEncounter
			if self:ApplyAllRewardsToChest() then
				nTreasureGold = nTreasureGold + self.nCreatureGoldForEncounter
				nTreasureXP = nTreasureXP + self.nCreatureXPForEncounter
			end

			self.hChest.hTreasureRoom = self.hRoom -- tell the chest unit about this so that the modifier can pick it up in its OnCreated
			local kv =
			{
				TreasureLevel = nTreasureLevel,
				XpReward = nTreasureXP,
				GoldReward = nTreasureGold,
				TreasureType = CAVERN_TREASURE_TYPE_SPECIAL
			}
			self.hChest:AddNewModifier( self.hChest, nil, "modifier_treasure_chest", kv )
			self.bChestInitialized = true
		end
	end

	return nil
end

--------------------------------------------------------------------

