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
	self.bConsumed = false
end

--------------------------------------------------------------------------------

function item_candy:OnSpellStart()
	if IsServer() then
		-- This runs twice because it is set to both autopickup (additem runs OnSpellStart) and also AutoUse.
		-- so track first use with bConsumed.
		if self.bConsumed then
			return
		end

		if AddCandyToHero( self:GetCaster(), self:GetCurrentCharges() ) then
			if self.nDroppedByTeam ~= nil then
				if self:GetCaster():GetTeamNumber() ~= self.nDroppedByTeam then
					GameRules.Winter2022:GrantEventAction( self:GetCaster():GetPlayerID(), "winter2022_steal_candy", self:GetCurrentCharges() )
				end
			end

			self.bConsumed = true
			self:SetCurrentCharges( 1 )
			self:SpendCharge()
		end
	end
end

--------------------------------------------------------------------------------

function item_candy:CanUnitPickUp( hUnit )
	if hUnit ~= nil and hUnit:IsNull() == false and hUnit:IsAlive() and hUnit:IsRealHero() then
		if _G.WINTER2022_CAN_PICKUP_CANDY_WHEN_FULL == false then
			local hAbility = hUnit:FindAbilityByName("hero_candy_bucket")
			if hAbility and hAbility:GetCandy() >= 99 then return false end
		end
		
		return true
	end

	return false
end

--------------------------------------------------------------------------------
