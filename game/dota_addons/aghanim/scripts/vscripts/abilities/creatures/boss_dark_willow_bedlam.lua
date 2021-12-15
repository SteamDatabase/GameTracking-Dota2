boss_dark_willow_bedlam = class({})

----------------------------------------------------

function boss_dark_willow_bedlam:Precache( context )
	PrecacheResource( "particle", "particles/test_particle/dark_willow_boss_channel.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_willowisp_base_attack.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_wisp_aoe_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_wisp_aoe.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_willowisp_ambient.vpcf", context )
	PrecacheUnitByNameSync( "npc_dota_dark_willow_creature", context, -1 )
end

----------------------------------------------------

function boss_dark_willow_bedlam:OnAbilityPhaseStart()
	if IsServer() == false then 
		return true
	end

	self.nChannelFX = ParticleManager:CreateParticle( "particles/test_particle/dark_willow_boss_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	return true
end

----------------------------------------------------

function boss_dark_willow_bedlam:OnAbilityPhaseInterrupted()
	if IsServer() == false then 
		return
	end

	ParticleManager:DestroyParticle( self.nChannelFX, false )
end

----------------------------------------------------

function boss_dark_willow_bedlam:OnSpellStart()
	if IsServer() == false then 
		return
	end

	EmitSoundOn( "Hero_DarkWillow.WispStrike.Cast", self:GetCaster() )

	self.roaming_radius = self:GetSpecialValueFor( "roaming_radius" )
	self.roaming_seconds_per_rotation = self:GetSpecialValueFor( "roaming_seconds_per_rotation" )
	self.wisp_interval = self:GetSpecialValueFor( "wisp_interval" )
	self.wisp_count = self:GetSpecialValueFor( "wisp_count" )
	self.additional_rotation_seconds_per_wisp = self:GetSpecialValueFor( "additional_rotation_seconds_per_wisp" )
	self.nWispsRemaining = self.wisp_count 
	self.reversed = false 

	self.flNextWispTime = GameRules:GetGameTime()
end

----------------------------------------------------

function boss_dark_willow_bedlam:OnChannelThink( flInterval )
	if IsServer() == false then 
		return
	end

	if GameRules:GetGameTime() >= self.flNextWispTime then 
		self.flNextWispTime = GameRules:GetGameTime() + self.wisp_interval
		self:CreateWisp()
		EmitSoundOn( "Hero_DarkWillow.WillOWisp.Damage", self:GetCaster() )
	end
end

----------------------------------------------------

function boss_dark_willow_bedlam:CreateWisp()
	if IsServer() == false then 
		return
	end

	if self.nWispsRemaining <= 0 then 
		return 
	end

	local nWispsCreated = self.wisp_count - self.nWispsRemaining

	for i = 1,2 do
		local kv = {}
		kv[ "roaming_radius" ] = self.roaming_radius * ( 1 + nWispsCreated )
		kv[ "roaming_seconds_per_rotation" ] = self.roaming_seconds_per_rotation + ( self.additional_rotation_seconds_per_wisp * nWispsCreated )
		kv[ "reversed" ] = self.reversed 
		kv[ "duration" ] = self:GetChannelTime() - ( GameRules:GetGameTime() - self:GetChannelStartTime() ) 
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_boss_dark_willow_bedlam", kv ) 
		self.reversed = not self.reversed 
	end
	
	self.nWispsRemaining = self.nWispsRemaining - 1 
end	

----------------------------------------------------

function boss_dark_willow_bedlam:OnChannelFinish()
	if IsServer() == false then 
		return 
	end

	ParticleManager:DestroyParticle( self.nChannelFX, false )
end

----------------------------------------------------

function boss_dark_willow_bedlam:OnProjectileHit( hTarget, vLocation )
	if IsServer() == false then 
		return true
	end

	if hTarget == nil then 
		return true  
	end

	local attack_damage = self:GetSpecialValueFor( "attack_damage" )
	local damageInfo = 
	{
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = attack_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
	}
		
	ApplyDamage( damageInfo )
	EmitSoundOn( "Hero_DarkWillow.WillOWisp.Damage", hTarget )

	return true
end