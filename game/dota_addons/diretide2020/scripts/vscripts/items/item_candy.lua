if item_candy == nil then
	item_candy = class({})
	item_candy_bag = item_candy
end

--------------------------------------------------------------------------------

function item_candy:Precache( context )
	PrecacheResource( "particle", "particles/candy_score.vpcf", context )
end

--------------------------------------------------------------------------------

function item_candy:Spawn()
	self.flSpawnTime = GameRules:GetDOTATime( false, true )
end

--------------------------------------------------------------------------------

function item_candy:OnSpellStart()
	if IsServer() then
		local nNumCandy = self:GetCurrentCharges()
		-- This runs twice because it is set to both autopickup (additem runs OnSpellStart) and also AutoUse.
		-- so if we get here with no charges, bail.
		if nNumCandy == 0 then
			return
		end

		
		local hTarget = self:GetCaster()
		local hHeroBucket = hTarget:FindAbilityByName( "hero_candy_bucket" )
		if hHeroBucket ~= nil then
			EmitSoundOnClient( "Candy.Pickup", self:GetCaster():GetPlayerOwner() )
			--printf( "item_candy:OnSpellStart - candy being picked up; found hero's candy bucket, adding %d candy to it", nNumCandy )
			local nTotalCandy = hHeroBucket:GetCandy() + nNumCandy
			hHeroBucket:SetCurrentAbilityCharges( nTotalCandy )

			local nPlayerID = self:GetCaster():GetPlayerOwnerID()
			--print( '{STATS} candy_picked_up - Adding ' .. nNumCandy .. ' to PlayerID ' .. nPlayerID )
			GameRules.Diretide.EventMetaData[ nPlayerID ]["candy_picked_up"] =  GameRules.Diretide.EventMetaData[ nPlayerID ]["candy_picked_up"] + nNumCandy

			if self.nMapIndex ~= nil and GameRules.Diretide.m_vecMapCandyRespawns ~= nil then
				GameRules.Diretide.m_vecMapCandyRespawns[self.nMapIndex] = true
			end

			self:SetCurrentCharges( 1 )
			self:SpendCharge()
		end
	end
end

--------------------------------------------------------------------------------

function item_candy:CanUnitPickUp( hUnit )
	if hUnit ~= nil and hUnit:IsNull() == false and hUnit:IsAlive() and hUnit:IsRealHero() then
		return true
	end

	return false
end

--------------------------------------------------------------------------------
