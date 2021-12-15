frozen_giant_dance_smash = class({})

------------------------------------------------------------------------

LinkLuaModifier( "modifier_frozen_giant_dance_smash", "modifiers/creatures/modifier_frozen_giant_dance_smash", LUA_MODIFIER_MOTION_NONE )

------------------------------------------------------------------------

function frozen_giant_dance_smash:Precache( context )
	PrecacheResource( "particle", "particles/creatures/ogre/ogre_melee_smash.vpcf", context )
end

-----------------------------------------------------------------------------

function frozen_giant_dance_smash:ProcsMagicStick()
	return false
end

-----------------------------------------------------------------------------

function frozen_giant_dance_smash:GetPlaybackRateOverride()
	return 0.75
end

-----------------------------------------------------------------------------

function frozen_giant_dance_smash:GetChannelAnimation()
	return ACT_DOTA_VICTORY
end

------------------------------------------------------------------------

function frozen_giant_dance_smash:OnAbilityPhaseStart()
	if IsServer() == false then 
		return true 
	end


	return true 
end


------------------------------------------------------------------------

function frozen_giant_dance_smash:OnAbilityPhaseInterrupted()
	if IsServer() == false then 
		return  
	end

	

end


------------------------------------------------------------------------

function frozen_giant_dance_smash:OnSpellStart()
	if IsServer() == false then 
		return  
	end

	self.stomp_radius = self:GetSpecialValueFor( "stomp_radius" )
	self.stomp_damage = self:GetSpecialValueFor( "stomp_damage" )
	self.stomp_stun_duration = self:GetSpecialValueFor( "stomp_stun_duration" )
	self.stomp_slow_duration = self:GetSpecialValueFor( "stomp_slow_duration" )

	self.vecAttachments = 
	{
		"attach_right_foot",
		"attach_left_foot",
		"attach_right_foot",
		"attach_left_foot",
		"attach_right_foot",
		"attach_left_foot",
		"attach_right_foot",
		"attach_left_foot",
	}
	self.flDelays =
	{
		self:GetSpecialValueFor( "delay_1" ),
		self:GetSpecialValueFor( "delay_2" ),
		self:GetSpecialValueFor( "delay_3" ),
		self:GetSpecialValueFor( "delay_4" ),
		self:GetSpecialValueFor( "delay_5" ),
		self:GetSpecialValueFor( "delay_6" ),
		self:GetSpecialValueFor( "delay_7" ),
		self:GetSpecialValueFor( "delay_8" ),
	}

	self.flNextStompTime = GameRules:GetGameTime() + self.flDelays[ 1 ]
	table.remove( self.flDelays, 1 )
end

------------------------------------------------------------------------

function frozen_giant_dance_smash:OnChannelThink( flInterval )
	if IsServer() == false then 
		return  
	end

	if GameRules:GetGameTime() < self.flNextStompTime then 
		return 
	end

	if #self.flDelays > 0 then 
		self.flNextStompTime = GameRules:GetGameTime() + self.flDelays[ 1 ]
		table.remove( self.flDelays, 1 )
	else
		self.flNextStompTime = 999999999999
	end

	local hAttachment = self:GetCaster():ScriptLookupAttachment( self.vecAttachments[ 1 ] )
	table.remove( self.vecAttachments, 1 )

	local vDamageCenter = self:GetCaster():GetAttachmentOrigin( hAttachment )

	EmitSoundOnLocationWithCaster( vDamageCenter, "OgreTank.GroundSmash", self:GetCaster() )
	local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ogre/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN,  self:GetCaster()  )
	ParticleManager:SetParticleControl( nFXIndex, 0, vDamageCenter )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.stomp_radius, self.stomp_radius, self.stomp_radius ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )


	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vDamageCenter, self:GetCaster(), self.stomp_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	for _,hEnemy in pairs ( enemies ) do 
		if hEnemy and hEnemy:IsNull() == false and hEnemy:IsInvulnerable() == false then 


			local kv ={}
			kv[ "duration" ] = self:GetSpecialValueFor( "armor_reduction_duration" )
			hEnemy:AddNewModifier( self:GetCaster(), self, "modifier_frozen_giant_dance_smash", kv )
			
			local damageInfo = 
			{
				victim = hEnemy,
				attacker = self:GetCaster(),
				damage = self.stomp_damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self,
			}

			ApplyDamage( damageInfo )


			if not ( hEnemy:IsNull() ) and hEnemy ~= nil and hEnemy:IsAlive() == false then
					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControlEnt( nFXIndex, 0, hEnemy, PATTACH_POINT_FOLLOW, "attach_hitloc", hEnemy:GetOrigin(), true )
					ParticleManager:SetParticleControl( nFXIndex, 1, hEnemy:GetOrigin() )
					ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
					ParticleManager:SetParticleControlEnt( nFXIndex, 10, hEnemy, PATTACH_ABSORIGIN_FOLLOW, nil, hEnemy:GetOrigin(), true )
					ParticleManager:ReleaseParticleIndex( nFXIndex )

					EmitSoundOn( "Dungeon.BloodSplatterImpact", hEnemy )
			else
				hEnemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.stomp_stun_duration } )
				EmitSoundOn( "Roshan.Attack.Post", hEnemy )
			end
		end
	end
end