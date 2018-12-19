
modifier_spectre_dagger = class({})

-----------------------------------------------------------------------------

function modifier_spectre_dagger:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
end

-----------------------------------------------------------------------------

function modifier_spectre_dagger:OnCreated( kv )
	if IsServer() then
		self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )
		self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )

		self:GetParent():Interrupt()
		self:GetParent():SetForceAttackTarget( self:GetCaster() )
		self:GetParent():AddNewModifier( self:GetCaster(), nil, "modifier_phased", { duration = -1 } )

		EmitSoundOn( "Creature_Spectre.Dagger.VictimLoop", self:GetParent() )

		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster() )
		self:AddParticle( self.nFXIndex, false, false, -1, false, true )
	end
end

-----------------------------------------------------------------------------

function modifier_spectre_dagger:OnDestroy()
	if IsServer() then
		self:GetParent():SetForceAttackTarget( nil )
		self:GetParent():RemoveModifierByName( "modifier_phased" )

		StopSoundOn( "Creature_Spectre.Dagger.VictimLoop", self:GetParent() )
		EmitSoundOn( "Creature_Spectre.Dagger.VictimEnd", self:GetParent() )

		ParticleManager:DestroyParticle( self.nFXIndex, false ) -- this probably has issues where the particle persists on caster if my parent dies while it's on
	end
end

-----------------------------------------------------------------------------

function modifier_spectre_dagger:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_spectre_dagger:GetModifierMoveSpeedBonus_Constant( params )
	return self.bonus_move_speed
end

--------------------------------------------------------------------------------

function modifier_spectre_dagger:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

--------------------------------------------------------------------------------

