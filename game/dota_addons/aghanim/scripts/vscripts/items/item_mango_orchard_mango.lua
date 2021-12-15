
item_mango_orchard_mango = class({})

--------------------------------------------------------------------------------

function item_mango_orchard_mango:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_mango_orchard_mango:OnSpellStart()
	if IsServer() then
		if self:GetCaster() == nil then 
			return 
		end
		
		local hMangoToss = self:GetCaster():FindAbilityByName( "mango_orchard_toss_mango" )
		if hMangoToss then 
			hMangoToss:SetCurrentAbilityCharges( hMangoToss:GetCurrentAbilityCharges() + 1 )
			EmitSoundOnLocationForPlayer( "DOTA_Item.Mango.Activate", self:GetCaster():GetAbsOrigin(), self:GetCaster():GetPlayerOwnerID() )	
		end

		UTIL_Remove( self )
	end
end

--------------------------------------------------------------------------------
