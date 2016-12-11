if lina_fireball == nil then
	lina_fireball = class({})
end
--LinkLuaModifier( "lina_fireball_modifier", LUA_MODIFIER_MOTION_HORIZONTAL )

function lina_fireball:StopSwingGesture()
	print( "lina_fireball:StopSwingGesture()" )
	if self.nCurrentGesture ~= nil then
		self:GetCaster():RemoveGesture( self.nCurrentGesture )
		self.nCurrentGesture = nil
	end
end

function lina_fireball:StartSwingGesture( nAction )
	print( "lina_fireball:StartSwingGesture()" )
	if self.nCurrentGesture ~= nil then
		self:GetCaster():RemoveGesture( self.nCurrentGesture )
	end
	self.nCurrentGesture = nAction
	self:GetCaster():StartGesture( nAction )
end

function lina_fireball:OnAbilityPhaseStart()
	print( "lina_fireball:OnAbilityPhaseStart()" )
	local result = self.BaseClass.OnAbilityPhaseStart( self )
	if result then
		self:StartSwingGesture( ACT_DOTA_ATTACK )
	end
	return result
end

function lina_fireball:OnAbilityPhaseInterrupted()
	print( "lina_fireball:OnAbilityPhaseInterrupted()" )
	self:StopSwingGesture()
end

--[[
function lina_fireball:OnSpellStart()
	local nDamageAmount = self:GetCaster():GetAverageTrueAttackDamage() + self:GetAbilityDamage() + RandomInt( 0, 10 ) - 5
	ApplyDamage( {
		victim = self:GetCursorTarget(),
		attacker = self:GetCaster(),
		damage = nDamageAmount,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		ability = self
	} )
end
]]

function lina_fireball:OnSpellStart()
	print( "lina_fireball:OnSpellStart()" )
	--[[
	if self.hVictim ~= nil then
		self.hVictim:InterruptMotionControllers( true )
	end
	]]

	self.fireball_damage = self:GetSpecialValueFor( "fireball_damage" )  
	self.fireball_speed = self:GetSpecialValueFor( "fireball_speed" )
	self.fireball_width = self:GetSpecialValueFor( "fireball_width" )
	self.fireball_distance = self:GetSpecialValueFor( "fireball_distance" )
	self.fireball_followthrough_constant = self:GetSpecialValueFor( "fireball_followthrough_constant" )

	self.vision_radius = self:GetSpecialValueFor( "vision_radius" )  
	self.vision_duration = self:GetSpecialValueFor( "vision_duration" )  
	
	if self:GetCaster() and self:GetCaster():IsHero() then
		local hFireball = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
		if hFireball ~= nil then
			hFireball:AddEffects( EF_NODRAW )
		end
	end

	self.vStartPosition = self:GetCaster():GetOrigin()
	self.vProjectileLocation = vStartPosition

	local vDirection = self:GetCursorPosition() - self.vStartPosition
	vDirection.z = 0.0

	local vDirection = ( vDirection:Normalized() ) * self.fireball_distance
	self.vTargetPosition = self.vStartPosition + vDirection

	self.vHookOffset = Vector( 0, 0, 96 )
	local vHookTarget = self.vTargetPosition + self.vHookOffset
	local vKillswitch = Vector( ( ( self.fireball_distance / self.fireball_speed ) * 2 ), 0, 0 )

	self.nChainParticleFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_base_attack.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleAlwaysSimulate( self.nChainParticleFXIndex )
	ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + self.vHookOffset, true )
	ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 1, vHookTarget )
	ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 2, Vector( self.fireball_speed, self.fireball_distance, self.fireball_width ) )
	ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 3, vKillswitch )
	ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 4, Vector( 1, 0, 0 ) )
	ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 5, Vector( 0, 0, 0 ) )
	ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 7, self:GetCaster(), PATTACH_CUSTOMORIGIN, nil, self:GetCaster():GetOrigin(), true )

	EmitSoundOn( "Hero_Pudge.AttackHookExtend", self:GetCaster() )

	local projectile_info = {
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(),
		vVelocity = vDirection:Normalized() * self.fireball_speed,
		fDistance = self.fireball_distance,
		fStartRadius = self.fireball_width ,
		fEndRadius = self.fireball_width ,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
	}

	self.fireball_projectile = ProjectileManager:CreateLinearProjectile( projectile_info )

	self.hVictim = nil
end

function lina_fireball:OnProjectileHit( hTarget, vLocation )
	print( "lina_fireball:OnProjectileHit()" )
	if hTarget == self:GetCaster() then
		return false
	end

	if hTarget ~= nil and ( not ( hTarget:IsCreep() or hTarget:IsConsideredHero() ) ) then
		Msg( "Target was invalid")
		return false
	end

	if hTarget ~= nil then
		print( "lina_fireball's projectile has hit a valid target" )
		EmitSoundOn( "Hero_Pudge.AttackHookImpact", hTarget )

		--hTarget:AddNewModifier( self:GetCaster(), self, "lua_abilities/lina_fireball_modifier", nil )
		
		if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
			local damage = {
					victim = hTarget,
					attacker = self:GetCaster(),
					damage = self.fireball_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,		
					ability = this
				}

			ApplyDamage( damage )

			if not hTarget:IsAlive() then
				--self.bDiedInFireball = true
			end

			local nFXIndex = ParticleManager:CreateParticle( "particles/hw_fx/hw_rosh_fireball_fire_launch.vpcf", PATTACH_CUSTOMORIGIN, hTarget )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
			self:SetContextThink( "self:Think_DestroyFireballHitParticle", function() return self:Think_DestroyFireballHitParticle( nFXIndex ) end, 0.5 )
		end

		AddFOWViewer( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), self.vision_radius, self.vision_duration, false )
		self.hVictim = hTarget

		print( "ProjectileManager:DestroyLinearProjectile( self.fireball_projectile )" )
		ProjectileManager:DestroyLinearProjectile( self.fireball_projectile )
		self:SetContextThink( "self:Think_DestroyFireballParticle", function() return self:Think_DestroyFireballParticle( nFXIndex ) end, 0.2 )
	end

	if hTarget ~= nil and ( not hTarget:IsInvisible() ) then
		ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin() + self.vHookOffset, true )
		ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 4, Vector( 0, 0, 0 ) )
		ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 5, Vector( 1, 0, 0 ) )
	end

	return true
end

function lina_fireball:Think_DestroyFireballParticle()
	print( "lina_fireball:Think_DestroyFireballParticle()" )
	ParticleManager:DestroyParticle( self.nChainParticleFXIndex, false )
	ParticleManager:ReleaseParticleIndex( self.nChainParticleFXIndex )
end

function lina_fireball:Think_DestroyFireballHitParticle( nFXIndex )
	print( "lina_fireball:Think_DestroyFireballHitParticle( nFXIndex )" )
	ParticleManager:DestroyParticle( nFXIndex, false )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end

function lina_fireball:OnProjectileThink( vLocation )
	self.vProjectileLocation = vLocation
	local flRadius = 300
	local flDuration = 1
	AddFOWViewer( self:GetCaster():GetTeamNumber(), self.vProjectileLocation, flRadius, flDuration, true )
	local vDelta = self.vProjectileLocation - self.vStartPosition
	local nDistanceTraveled = vDelta:Length()
	if nDistanceTraveled > 700 then
		print( "  nDistanceTraveled == " .. tostring( nDistanceTraveled ) )
	end
	if nDistanceTraveled >= self.fireball_distance - 96 then
		print( "  projectile reached its max distance so destroy the projectile and its particle" )
		ProjectileManager:DestroyLinearProjectile( self.fireball_projectile )
		ParticleManager:DestroyParticle( self.nChainParticleFXIndex, true )
	end
end

function lina_fireball:GetCastRange( vLocation, hTarget )
	--print( "lina_fireball:GetCastRange( vLocation, hTarget )" )
	return 1500
end