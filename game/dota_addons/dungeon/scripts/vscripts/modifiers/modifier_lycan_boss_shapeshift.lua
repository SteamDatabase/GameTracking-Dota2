modifier_lycan_boss_shapeshift = class({})

--------------------------------------------------------------------------------

function modifier_lycan_boss_shapeshift:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_shapeshift:OnCreated( kv )	
	if IsServer() then
		self.nPortraitFXIndex = -1
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_shapeshift_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_mane", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_tail", self:GetParent():GetOrigin(), true )
		if self.nPortraitFXIndex == -1 then
			self.nPortraitFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_shapeshift_portrait.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( self.nPortraitFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_mouth", self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nPortraitFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_upper_jaw", self:GetParent():GetOrigin(), true )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_shapeshift:OnDestroy()
	if IsServer() then
		ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_shapeshift_revert.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) )
		ParticleManager:DestroyParticle( self.nPortraitFXIndex, true )
	end
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_shapeshift:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_shapeshift:GetModifierModelChange( params )
	return "models/creeps/knoll_1/werewolf_boss.vmdl"
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_shapeshift:GetActivityTranslationModifiers( params )
	return "shapeshift"
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_shapeshift:GetModifierModelScale( params )
	return 75
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_shapeshift:GetModifierMoveSpeed_Absolute( params )
	return 550
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_shapeshift:GetModifierPercentageCooldown( params )
	return 50
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_shapeshift:GetModifierAttackPointConstant( params )
	return 0.43
end
