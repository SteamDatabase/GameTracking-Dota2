
modifier_beastmaster_statue_casting = class({})

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_casting:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_casting:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_casting:OnCreated( kv )
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_magic.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_casting:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_casting:GetOverrideAnimation( params )
	return ACT_DOTA_GENERIC_CHANNEL_1
end

--------------------------------------------------------------------------------
