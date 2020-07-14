modifier_large_frostbitten_icicle = class({})

------------------------------------------------------------------

function modifier_large_frostbitten_icicle:OnCreated( kv )
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		self:AddParticle( nFXIndex, false, false, -1, false, false )
	end
end

------------------------------------------------------------------

function modifier_large_frostbitten_icicle:GetStatusEffectName()  
	return "particles/status_fx/status_effect_wyvern_cold_embrace.vpcf"
end

--------------------------------------------------------------------------------

function modifier_large_frostbitten_icicle:CheckState()
	local state = {}
	state[MODIFIER_STATE_STUNNED] = true
	state[MODIFIER_STATE_FROZEN] = true
	
	return state
end




