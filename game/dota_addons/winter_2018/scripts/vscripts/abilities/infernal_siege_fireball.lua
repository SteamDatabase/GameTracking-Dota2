require( "event_queue" )

infernal_siege_fireball = class({})

--------------------------------------------------------------------------------

function infernal_siege_fireball:IsStealable()
	return false
end

function infernal_siege_fireball:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function infernal_siege_fireball:OnSpellStart()
	if IsServer() then
		self.radius = self:GetSpecialValueFor( "radius" )
		self.damage = self:GetSpecialValueFor( "damage" )
		self.duration = self:GetSpecialValueFor( "duration" )
		self.burn_interval = self:GetSpecialValueFor( "burn_interval" )
		self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
	
		local vLocation = self:GetCursorPosition() 
		local vStartPos = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_attack1" ) )
		local vDirection = vLocation - vStartPos
		vDirection.z = 0.0
		local flLength = vDirection:Length2D()

		local vNewDirection = vDirection
		vNewDirection = vNewDirection:Normalized()
		
		local vVel = vNewDirection * self.projectile_speed
		vVel.z = 0.0

		local nFXIndex = ParticleManager:CreateParticle( "particles/waves/infernal/invoker_forged_spirit_projectile_2.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, vStartPos )
		ParticleManager:SetParticleControl( nFXIndex, 1, vLocation )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( self.projectile_speed, 0,0 ))
		ParticleManager:SetParticleControl( nFXIndex, 3, vLocation )
		ParticleManager:SetParticleControl( nFXIndex, 9, vLocation )

		if self.FX == nil then
			self.FX = {}
		end

		table.insert( self.FX, nFXIndex )

		local info =
		{
			Ability = self,
			EffectName = nil,
			vSpawnOrigin = vStartPos,
			vVelocity = vNewDirection * self.projectile_speed,
			fDistance = flLength,
			fStartRadius = 0,
			fEndRadius = 0,
			Source = self:GetCaster(),
		}

		ProjectileManager:CreateLinearProjectile( info )

		self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_2 )
		EmitSoundOn( "Hero_Phoenix.FireSpirits.Launch", self:GetCaster() )
	end
end

function infernal_siege_fireball:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		ParticleManager:DestroyParticle( self.FX[1], true )
		table.remove( self.FX, 1 )

		--EmitSoundOnLocationForAllies( vLocation, "Hero_Phoenix.FireSpirits.Target", self:GetCaster() )
		--local nFXIndex = ParticleManager:CreateParticle( "particles/waves/infernal/infernal_siege_fireball.vpcf", PATTACH_WORLDORIGIN, nil );
		--ParticleManager:SetParticleControl( nFXIndex, 0, vLocation );
		--ParticleManager:SetParticleControl( nFXIndex, 2, Vector( self.duration, 0, 0 ) );
		--ParticleManager:ReleaseParticleIndex( nFXIndex );
	
		local kv = {
			radius = self.radius,
			damage_per_tick = self.damage,
			duration = self.duration,
			burn_interval = self.burn_interval,
		}
		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_siege_fireball_thinker", kv, vLocation, self:GetCaster():GetTeamNumber(), false )

		--hThinker.EventQueue = CEventQueue()
		--hThinker.EventQueue:AddEvent( self.duration,
		--function(nFXIndex)
		--	ParticleManager:DestroyParticle( nFXIndex, true )
		--end, nFXIndex )

		EmitSoundOnLocationWithCaster( vLocation, "Hero_Phoenix.FireSpirits.ProjectileHit", self:GetCaster() )

		-- ParticleManager:SetParticleControl( nFXIndex, 0, vLocation );
		-- ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, self.radius, self.radius ) );
		-- ParticleManager:ReleaseParticleIndex( nFXIndex );

		-- local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vLocation, self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		-- if #enemies > 0 then
		-- 	for _,enemy in ipairs( enemies ) do
		-- 		if enemy ~= nil and enemy:IsMagicImmune() == false  and enemy:IsInvulnerable() == false then
		-- 			EmitSoundOn( "Hero_Phoenix.FireSpirits.ProjectileHit", enemy )
		-- 			enemy:AddNewModifier( self:GetCaster(), self, "modifier_phoenix_fire_spirits_burn_nb2017", { duration = self.duration } )
		-- 		end
		-- 	end
		-- end
	end
	
	return false
end

function infernal_siege_fireball:OnDestroy( ) 
	if IsServer() then
		if( self:GetParent() ~= nil ) then 
			UTIL_Remove( GetParent() )
		end
	end
end



--------------------------------------------------------------------------------