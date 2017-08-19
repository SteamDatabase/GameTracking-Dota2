ice_boss_projectile_curse = class({})

-----------------------------------------------------------------------

function ice_boss_projectile_curse:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function ice_boss_projectile_curse:OnAbilityPhaseStart()
	if IsServer() then
		if self:GetCursorTarget() ~= nil then
			self:GetCursorTarget():AddNewModifier( self:GetCaster(), self, "modifier_ice_boss_egg_curse_marker", { duration = 5.0 } )
		end
		self.nChannelFX = ParticleManager:CreateParticle( "particles/act_2/ice_boss_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	end
	return true
end

-----------------------------------------------------------------------

function ice_boss_projectile_curse:OnAbilityPhaseInterrupted()
	if IsServer() then
		if self:GetCursorTarget() ~= nil then
			self:GetCursorTarget():RemoveModifierByName( "modifier_ice_boss_egg_curse_marker" )
		end
		
		ParticleManager:DestroyParticle( self.nChannelFX, false )
	end
end

-----------------------------------------------------------------------

function ice_boss_projectile_curse:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )
		if self:GetCursorTarget() == nil then
			return
		end

		EmitSoundOn( "Hero_Winter_Wyvern.WintersCurse.Cast", self:GetCaster() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_start.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true  )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
		local attachment = self:GetCaster():ScriptLookupAttachment( "attach_attack1" )
		local info = 
		{
			Target = self:GetCursorTarget(),
			Source = self:GetCaster(),
			Ability = self,
			EffectName = "particles/act_2/winters_curse_projectile.vpcf",
			iMoveSpeed = self.projectile_speed,
			vSourceLoc = self:GetCaster():GetAttachmentOrigin( attachment ),
			bDodgeable = false,
			bProvidesVision = false,
		}

		ProjectileManager:CreateTrackingProjectile( info )

	end
end

---------------------------------------------------------------------

function ice_boss_projectile_curse:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil then
			hTarget:RemoveModifierByName( "modifier_ice_boss_egg_curse_marker" )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_winter_wyvern_winters_curse_aura", { duration = self:GetSpecialValueFor( "duration" ) } )
			EmitSoundOn( "Hero_Winter_Wyvern.WintersCurse.Target", hTarget )
		end
	end

	return true
end