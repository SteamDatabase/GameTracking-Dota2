item_treasure_box = class({})

function item_treasure_box:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_treasure_box:OnSpellStart()
	if IsServer() then
		local CurrentZone = nil
		for _,Zone in pairs( GameRules.Dungeon.Zones ) do
			if Zone ~= nil and Zone:ContainsUnit( self:GetCaster() ) then
				CurrentZone = Zone
			end
		end

		if CurrentZone == nil then
			self:SpendCharge()
			return
		end

		local ChestTable = CurrentZone.Chests[#CurrentZone.Chests]
		local hTreasure = CreateUnitByName( ChestTable.szNPCName, self:GetCaster():GetOrigin() + RandomVector( RandomFloat( 50, 100 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
		if hTreasure ~= nil then
			hTreasure.zone = CurrentZone
			hTreasure.Items = ChestTable.Items
			hTreasure.fItemChance = ChestTable.fItemChance
			hTreasure.Relics = ChestTable.Relics
			hTreasure.fRelicChance = ChestTable.fRelicChance
			hTreasure.nMinGold = ChestTable.nMinGold
			hTreasure.nMaxGold = ChestTable.nMaxGold
			hTreasure.szTraps = ChestTable.szTraps
			hTreasure.nTrapLevel = ChestTable.nTrapLevel
			EmitSoundOn( "Dungeon.TreasureItemDrop", hTreasure )
		end
		self:SpendCharge()
	end
end

--------------------------------------------------------------------------------