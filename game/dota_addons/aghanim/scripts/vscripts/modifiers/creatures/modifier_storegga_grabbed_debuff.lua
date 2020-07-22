
modifier_storegga_grabbed_debuff = class({})

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:OnCreated( kv )
	if IsServer() then
		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
			self:Destroy()
			return
		end

		self.hold_time = kv.hold_time
		--print( "hold_time" .. self.hold_time )

		self.nProjHandle = -1
		self.flTime = 0.0
		self.flHeight = 0.0

		self.impact_radius = self:GetAbility():GetSpecialValueFor( "impact_radius" )

		self.bDropped = false
		self:StartIntervalThink( self.hold_time )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:CheckState()
	local state = 
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:OnIntervalThink()
	if IsServer() then	
		if self.bDropped == false then
			self.bDropped = true
			print ( "modifier_storegga_grabbed_debuff:OnIntervalThink dropped" )
			self:GetCaster():RemoveModifierByName( "modifier_storegga_grabbed_buff" )

			self.nProjHandle = -2 
			self.flTime = 0.5
			self.flHeight = GetGroundHeight( self:GetParent():GetAbsOrigin(), self:GetParent() )

			self:StartIntervalThink( self.flTime )
			return
		else
			local vLocation = GetGroundPosition( self:GetParent():GetAbsOrigin(), self:GetParent() )
			
			local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ogre/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )
			ParticleManager:SetParticleControl( nFXIndex, 0, vLocation )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.impact_radius, self.impact_radius, self.impact_radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			EmitSoundOnLocationWithCaster( vLocation, "Ability.TossImpact", self:GetCaster() )
			self:Destroy()
		end	
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		local vLocation = me:GetAbsOrigin()
		if self.nProjHandle == -1 then
			local attach = self:GetCaster():ScriptLookupAttachment( "attach_attack2" )
			vLocation = self:GetCaster():GetAttachmentOrigin( attach )
		elseif self.nProjHandle ~= -2 then
			vLocation = ProjectileManager:GetLinearProjectileLocation( self.nProjHandle )
		end
		vLocation.z = 0.0
		me:SetOrigin( vLocation )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:UpdateVerticalMotion( me, dt )
	if IsServer() then
		local vMyPos = me:GetOrigin()
		if self.nProjHandle == -1 then
			local attach = self:GetCaster():ScriptLookupAttachment( "attach_attack2" )
			local vLocation = self:GetCaster():GetAttachmentOrigin( attach )
			vMyPos.z = vLocation.z
		else
			local flGroundHeight = GetGroundHeight( vMyPos, me )
			local flHeightChange = dt * self.flTime * self.flHeight * 1.3
			vMyPos.z = math.max( vMyPos.z - flHeightChange, flGroundHeight )
		end
		me:SetOrigin( vMyPos )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

function modifier_storegga_grabbed_debuff:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetCaster() then
			self:Destroy()
		end
	end

	return 0
end
