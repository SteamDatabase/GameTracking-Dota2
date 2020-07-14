
ogre_magi_channelled_bloodlust = class({})
LinkLuaModifier( "modifier_ogre_magi_channelled_bloodlust", "modifiers/creatures/modifier_ogre_magi_channelled_bloodlust", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ogre_magi_channelled_bloodlust:Precache( context )

	PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", context )
 	PrecacheResource( "particle", "particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", context )

end

-----------------------------------------------------------------------------

function ogre_magi_channelled_bloodlust:OnSpellStart()
	if IsServer() then
		local hTarget = self:GetCursorTarget()
		if hTarget ~= nil then
			self.hTarget = hTarget
			self.hTarget:AddNewModifier( self:GetCaster(), self, "modifier_ogre_magi_channelled_bloodlust", { duration = -1 } )

			EmitSoundOn( "OgreMagi.Bloodlust.Target", self.hTarget )
			EmitSoundOn( "OgreMagi.Bloodlust.Target.FP", self.hTarget )
			EmitSoundOn( "OgreMagi.Bloodlust.Loop", self:GetCaster() )

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true  )
			ParticleManager:SetParticleControlEnt( nFXIndex, 2, self.hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hTarget:GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 3, self.hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, self.hTarget:GetOrigin(), true   )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
	end
end

-----------------------------------------------------------------------------

function ogre_magi_channelled_bloodlust:OnChannelFinish( bInterrupted )
	if IsServer() then
		if bInterrupted then
			self:StartCooldown( self:GetSpecialValueFor( "interrupted_cooldown" ) )
		end

		if self.hTarget ~= nil then
			local hMyBuff = self.hTarget:FindModifierByNameAndCaster( "modifier_ogre_magi_channelled_bloodlust", self:GetCaster() ) 
			if hMyBuff then
				hMyBuff:Destroy()
			end
			StopSoundOn( "OgreMagi.Bloodlust.Loop", self:GetCaster() )
			self.hTarget = nil
		end
	end
end

-----------------------------------------------------------------------------

