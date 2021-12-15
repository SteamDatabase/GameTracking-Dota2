require( "modifiers/modifier_blessing_base" )

modifier_blessing_life_steal = class( modifier_blessing_base )

-------------------------------------------------------------------------------

function modifier_blessing_life_steal:GetTexture()
	return "../items/lifesteal"
end

-------------------------------------------------------------------------------

function modifier_blessing_life_steal:OnBlessingCreated( kv )
	self.life_steal_pct = kv.life_steal_pct
end

--------------------------------------------------------------------------------

function modifier_blessing_life_steal:GetStatusEffectName()
	return "particles/generic_gameplay/generic_lifesteal.vpcf"
end

--------------------------------------------------------------------------------

function modifier_blessing_life_steal:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_life_steal:OnAttacked( params )
	if IsServer() then
		--print( 'modifier_blessing_life_steal:OnAttacked' )

		if self:GetParent():PassivesDisabled() then
			return 1
		end

		if params.attacker ~= nil and params.attacker == self:GetParent() and params.target ~= nil then
			local heal = ( params.damage * self.life_steal_pct / 100 )
			--print( 'modifier_blessing_life_steal healing for ' .. heal )
			self:GetParent():HealWithParams( heal, nil, true, true, nil, false )
			ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) )
		end
	end

	return 1
end

--------------------------------------------------------------------------------

function modifier_blessing_life_steal:OnTooltip( params )
	return self.life_steal_pct
end

--------------------------------------------------------------------------------
function modifier_blessing_life_steal:IsPermanent()
	return true
end