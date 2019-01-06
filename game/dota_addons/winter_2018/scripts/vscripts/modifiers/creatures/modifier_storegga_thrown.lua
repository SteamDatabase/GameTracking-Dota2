
modifier_storegga_thrown = class({})

--------------------------------------------------------------------------------

function modifier_storegga_thrown:GetEffectName()
	return "particles/items_fx/force_staff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_storegga_thrown:GetStatusEffectName()
	return "particles/status_fx/status_effect_forcestaff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_storegga_thrown:StatusEffectPriority()
	return 10
end

--------------------------------------------------------------------------------

function modifier_storegga_thrown:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_storegga_thrown:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_storegga_thrown:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_thrown:OnCreated( kv )
	if IsServer() then
		if self:GetCaster() == nil or self:GetCaster():IsNull() or self:GetCaster():IsAlive() == false then
			self:Destroy()
			return
		end

		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
			self:Destroy()
			return
		end

		-- Note: these values get updated by the ability
		self.nProjHandle = -1
		self.flTime = 0.0
		self.flHeight = 0.0
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_thrown:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		if self:GetCaster() == nil or self:GetCaster():IsNull() or self:GetCaster():IsAlive() == false then
			self:Destroy()
			return
		end

		local vLocation = nil
		if self.nProjHandle == -1 then
			local attach = self:GetCaster():ScriptLookupAttachment( "attach_attack2" )
			vLocation = self:GetCaster():GetAttachmentOrigin( attach )
		else
			vLocation = ProjectileManager:GetLinearProjectileLocation( self.nProjHandle )
		end

		vLocation.z = 0.0
		me:SetOrigin( vLocation )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_thrown:UpdateVerticalMotion( me, dt )
	if IsServer() then
		if self:GetCaster() == nil or self:GetCaster():IsNull() or self:GetCaster():IsAlive() == false then
			self:Destroy()
			return
		end

		if not self.bInitialized and self.flTime ~= 0.0 then
			self.fTotalTravelTime = self.flTime
			self.fTravelStartTime = GameRules:GetGameTime()
			self.bInitialized = true
		end

		local vMyPos = me:GetOrigin()
		if self.nProjHandle == -1 then
			local attach = self:GetCaster():ScriptLookupAttachment( "attach_attack2" )
			local vLocation = self:GetCaster():GetAttachmentOrigin( attach )
			vMyPos.z = vLocation.z
		else
			local fTravelTimeElapsed = GameRules:GetGameTime() - self.fTravelStartTime
			local fHalfTotalTime = self.fTotalTravelTime / 2
			local fHeightMultiplier = 0.4
			if fTravelTimeElapsed <= fHalfTotalTime then
				-- We want to arc up during the first half of the rock trajectory
				--print( string.format( "arc UP; fNow - fTravelTimeElapsed: %f; fHalfTotalTime: %f;", fTravelTimeElapsed, fHalfTotalTime ) )
				local fGroundHeight = GetGroundHeight( vMyPos, me )
				local flHeightChange = dt * self.flTime * self.flHeight * fHeightMultiplier
				vMyPos.z = math.max( vMyPos.z + flHeightChange, fGroundHeight )
			else
				-- We want to arc down during the second half of the rock trajectory
				--print( string.format( "arc DOWN; fNow - fTravelTimeElapsed: %f; fHalfTotalTime: %f;", fTravelTimeElapsed, fHalfTotalTime ) )
				local fGroundHeight = GetGroundHeight( vMyPos, me )
				local fTimeRemaining = ( self.fTotalTravelTime - fTravelTimeElapsed )
				local bNearlyArrived = ( fTimeRemaining < 0.5 )
				if bNearlyArrived and ( vMyPos.z > 100 ) then -- to refine this, we'll want to compare our height to the height of the ground at the destination
					fHeightMultiplier = 0.8
				end
				local flHeightChange = dt * self.flTime * self.flHeight * fHeightMultiplier
				vMyPos.z = math.max( vMyPos.z - flHeightChange, fGroundHeight )
			end
		end

		me:SetOrigin( vMyPos )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_thrown:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_thrown:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_thrown:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_storegga_thrown:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

function modifier_storegga_thrown:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetCaster() then
			self:Destroy()
		end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_storegga_thrown:CheckState()
	local state = 
	{
		[ MODIFIER_STATE_STUNNED ] = true,
		[ MODIFIER_STATE_INVULNERABLE ] = true,
		[ MODIFIER_STATE_OUT_OF_GAME ] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_storegga_thrown:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )

		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
