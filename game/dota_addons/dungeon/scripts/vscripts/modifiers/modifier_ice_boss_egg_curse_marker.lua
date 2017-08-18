modifier_ice_boss_egg_curse_marker = class({})

--------------------------------------------------------------------------------

function modifier_ice_boss_egg_curse_marker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ice_boss_egg_curse_marker:GetStatusEffectName()
	return "particles/status_fx/status_effect_iceblast_half.vpcf"
end

--------------------------------------------------------------------------------

function modifier_ice_boss_egg_curse_marker:OnCreated( kv )
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end