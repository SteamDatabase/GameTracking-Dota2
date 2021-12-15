
modifier_polarity_ghost_polarity_swap = class({})

--------------------------------------------------------------

function modifier_polarity_ghost_polarity_swap:IsHidden()
	return true
end

--------------------------------------------------------------

function modifier_polarity_ghost_polarity_swap:IsPurgable()
	return false
end

--------------------------------------------------------------

function modifier_polarity_ghost_polarity_swap:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_polarity_ghost_polarity_swap:OnDeath( params )
	if IsServer() then
		if params.unit ~= nil and params.unit == self:GetParent() then

			print( 'Ghost died! creating a thinker to shoot projectiles at heroes!' )
			local hDummy = CreateUnitByName( "npc_dota_dummy_caster", self:GetParent():GetAbsOrigin(), true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber() )
			if hDummy ~= nil then
				local hAbility = hDummy:AddAbility( "polarity_swap_projectile_thinker" )
				hAbility:UpgradeAbility( true )
			end	
		end		
	end
end
