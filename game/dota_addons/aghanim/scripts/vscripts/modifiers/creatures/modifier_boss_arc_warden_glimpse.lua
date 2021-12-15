modifier_boss_arc_warden_glimpse = class({})

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_glimpse:IsHidden()
	return true
end

------------------------------------------------------------------

function modifier_boss_arc_warden_glimpse:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_glimpse:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_glimpse:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_glimpse:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_glimpse:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_glimpse:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_glimpse:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

------------------------------------------------------------------

function modifier_boss_arc_warden_glimpse:OnCreated( kv )
	if IsServer() then
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
			return
		end

		self.nPlayerOwnerID = self:GetParent():GetPlayerOwnerID()
		PlayerResource:SetCameraTarget( self.nPlayerOwnerID, self:GetParent() )

		self.vStartPos = Vector( kv.x, kv.y, kv.z )

		local vecVelocity = self.vStartPos - self:GetParent():GetAbsOrigin()
		vecVelocity.z = 0
		local fDist = vecVelocity:Length2D()
		vecVelocity = vecVelocity:Normalized()

		local fDuration = self:GetDuration()

		vecVelocity = vecVelocity * ( fDist / fDuration )
		print( 'GLIMPSE duration = ' .. fDuration .. '. distance = ' .. fDist .. ' - velocity = ' .. vecVelocity.x .. ', ' .. vecVelocity.y .. ', ' .. vecVelocity.z )

		-- create a projectile to give vision
		local info = 
		{
			Ability = self:GetAbility(),
			vSpawnOrigin = self:GetParent():GetAbsOrigin(),
			vVelocity = vecVelocity,
			fDistance = fDist,
			Source = self:GetCaster(),
		}

		self.nProjectile = ProjectileManager:CreateLinearProjectile( info )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, false )

		EmitSoundOn( "Hero_Disruptor.Glimpse.Target", self:GetParent() )
		EmitSoundOnLocationWithCaster( self.vStartPos, "Hero_Disruptor.Glimpse.Destination", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_glimpse:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		if self:GetParent() ~= nil and self:GetParent():IsAlive() then
			if ProjectileManager:IsValidProjectile( self.nProjectile ) == true then
				local vLocation = ProjectileManager:GetLinearProjectileLocation( self.nProjectile )
				--print( 'ARC WARDEN GLIMPSE Updating player location to ' .. vLocation.x .. ', ' .. vLocation.y .. ', ' .. vLocation.z )
				me:SetOrigin( vLocation )

				local vVelocity = ProjectileManager:GetLinearProjectileVelocity( self.nProjectile )
				local angles = VectorAngles( vVelocity )
				me:SetAbsAngles( angles.x, angles.y, angles.z )
			end
		end		
	end
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_glimpse:OnHorizontalMotionInterrupted()
	if IsServer() then
		--print( 'ERROR - GLIMPSE being destroyed by interruption of horizontal motion!' )
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_glimpse:OnDestroy()
	if IsServer() then
		--print( 'GLIMPSE - modifier_boss_arc_warden_glimpse:OnDestroy()' )
		PlayerResource:SetCameraTarget( self.nPlayerOwnerID, nil )

		if self:GetParent() then
			self:GetParent():RemoveHorizontalMotionController( self )

			if self:GetParent():IsAlive() then
				FindClearSpaceForUnit( self:GetParent(), self.vStartPos, true )
				self:GetParent():Interrupt()

				EmitSoundOn( "Hero_Disruptor.Glimpse.End", self:GetParent() )
				StopSoundOn( "Hero_Disruptor.Glimpse.Target", self:GetParent() );
		
				CenterCameraOnUnit( self:GetParent():GetPlayerOwnerID(), self:GetParent() )
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_glimpse:CheckState()
	local state = 
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
	
	return state
end


