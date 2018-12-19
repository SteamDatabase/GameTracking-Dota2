
modifier_kobold_overboss_detonator_thinker = class({})

--------------------------------------------------------------------------------

function modifier_kobold_overboss_detonator_thinker:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_kobold_overboss_detonator_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
function modifier_kobold_overboss_detonator_thinker:OnDestroy()
	if IsServer() then 

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_nuke.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
				
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		
		if self:GetParent() ~= nil then
			local damage =
			{
				victim = self:GetParent(),
				attacker = self:GetParent(),
				damage = self:GetParent():GetHealth(),
				damage_type = DAMAGE_TYPE_PURE,
				ability = self:GetAbility(),
				damage_flags = DOTA_DAMAGE_FLAG_HPLOSS
			}
			ApplyDamage( damage )
			EmitSoundOn( "Hero_Pudge.AttackHookImpact", self:GetParent() )
		end
	end
end


function modifier_kobold_overboss_detonator_thinker:CheckState()
	local state = {}
	if IsServer()  then
		state[ MODIFIER_STATE_INVULNERABLE ] = true
		state[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true
		state[ MODIFIER_STATE_DISARMED ] = true
		state[ MODIFIER_STATE_ROOTED ] = true
		state[ MODIFIER_STATE_STUNNED ] = true
	end

	return state
end

function modifier_kobold_overboss_detonator_thinker:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end


function modifier_kobold_overboss_detonator_thinker:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_kobold_overboss_detonator_thinker:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_kobold_overboss_detonator_thinker:GetEffectName()
    return "particles/units/heroes/hero_gyrocopter/gyro_guided_missle_fuse_sparks.vpcf"
end