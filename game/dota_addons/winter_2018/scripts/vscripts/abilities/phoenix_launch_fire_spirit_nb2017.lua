phoenix_launch_fire_spirit_nb2017 = class({})

--------------------------------------------------------------------------------

function phoenix_launch_fire_spirit_nb2017:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function phoenix_launch_fire_spirit_nb2017:OnUpgrade()
	if IsServer() then
		if self:GetCaster() == nil then
			return
		end

		local hAbility = self:GetCaster():FindAbilityByName( "phoenix_fire_spirits_nb2017" )
		if hAbility ~= nil and hAbility:GetLevel() ~= self:GetLevel() then
			hAbility:SetLevel( self:GetLevel() )
		end
	end
end


--------------------------------------------------------------------------------

function phoenix_launch_fire_spirit_nb2017:OnSpellStart()
	if IsServer() then
		self.spirit_speed = self:GetSpecialValueFor( "spirit_speed" )
		self.radius = self:GetSpecialValueFor( "radius" )
		self.duration = self:GetSpecialValueFor( "duration" )
		self.hp_cost_perc = self:GetSpecialValueFor( "hp_cost_perc" )

		local hBuff = self:GetCaster():FindModifierByName( "modifier_phoenix_fire_spirits_nb2017" )
		if hBuff == nil or hBuff:GetStackCount() <= 0 then
			if hBuff ~= nil then
				hBuff:Destroy()
			end
			return
		end

		local vLocation = self:GetCursorPosition() 
		local vStartPos = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_hitloc" ) )
		local vDirection = vLocation - vStartPos
		vDirection.z = 0.0
		local flLength = vDirection:Length2D()

		local vNewDirection = vDirection
		vNewDirection = vNewDirection:Normalized()
		
		local vVel = vNewDirection * self.spirit_speed
		vVel.z = 0.0

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_launch.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, vStartPos );
		ParticleManager:SetParticleControl( nFXIndex, 1, vVel );
		ParticleManager:SetParticleControl( nFXIndex, 2, vLocation );
		ParticleManager:SetParticleControl( nFXIndex, 3, Vector( self.spirit_speed, self.spirit_speed, self.spirit_speed ) );

		if self.FX == nil then
			self.FX = {}
		end

		table.insert( self.FX, nFXIndex )

		local info =
		{
			Ability = self,
			EffectName = nil,
			vSpawnOrigin = vStartPos,
			vVelocity = vNewDirection * self.spirit_speed,
			fDistance = flLength,
			fStartRadius = 0,
			fEndRadius = 0,
			Source = self:GetCaster(),
		}

		ProjectileManager:CreateLinearProjectile( info )
		hBuff:DecrementStackCount()
		if hBuff:GetStackCount() <= 0 then
			hBuff:Destroy()
		end

		self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_2 )
		EmitSoundOn( "Hero_Phoenix.FireSpirits.Launch", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function phoenix_launch_fire_spirit_nb2017:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		ParticleManager:DestroyParticle( self.FX[1], true )
		table.remove( self.FX, 1 )

		EmitSoundOnLocationForAllies( vLocation, "Hero_Phoenix.FireSpirits.Target", self:GetCaster() )
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", PATTACH_WORLDORIGIN, nil );
		ParticleManager:SetParticleControl( nFXIndex, 0, vLocation );
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, self.radius, self.radius ) );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vLocation, self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in ipairs( enemies ) do
				if enemy ~= nil and enemy:IsMagicImmune() == false  and enemy:IsInvulnerable() == false then
					EmitSoundOn( "Hero_Phoenix.FireSpirits.ProjectileHit", enemy )
					enemy:AddNewModifier( self:GetCaster(), self, "modifier_phoenix_fire_spirits_burn_nb2017", { duration = self.duration } )
				end
			end
		end
	end
	
	return false
end


--------------------------------------------------------------------------------
