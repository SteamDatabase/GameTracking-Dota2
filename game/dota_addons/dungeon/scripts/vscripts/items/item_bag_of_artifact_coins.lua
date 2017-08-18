item_bag_of_artifact_coins = class({})

---------------------------------------------------------------------

function item_bag_of_artifact_coins:OnSpellStart()
	if IsServer() then

		local nCoinAmount = self:GetCurrentCharges() 
		if self:GetCaster() ~= nil and self:GetCaster():GetPlayerOwner() ~= nil then
			GameRules.Dungeon:OnArtifactCoinsFound( self:GetCaster():GetPlayerOwner():GetPlayerID(), nCoinAmount )
		end
		
		self:SpendCharge()
	end
end