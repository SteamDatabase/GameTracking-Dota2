
modifier_meteor_channel = class({})

----------------------------------------

function modifier_meteor_channel:OnCreated( kv )
	self.hPlayerEnt = nil

	if IsServer() then
		self.Players = {}
		self.bInMotion = false
		self.flMinHeight = 0
		self.flMaxHeight = 200
		self.flChannelTime = kv.meteor_channel_time
		self.t = 0
		self:StartIntervalThink( 0.1 )
	end
end

--------------------------------------------------------------------------------

function modifier_meteor_channel:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_meteor_channel:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_meteor_channel:GetPriority()
	return 10
end

----------------------------------------------------------------------------------------

function modifier_meteor_channel:CheckState()
	local state =
	{
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

-----------------------------------------------------------------------

function modifier_meteor_channel:OnIntervalThink()
	if IsServer() then
		if self.bInMotion == false then
			if self:ApplyVerticalMotionController() == false then 
				self:Destroy()
			end
			self.bInMotion = true
			self:StartIntervalThink( -1 )
			return
		end
	end
end

--------------------------------------------------------------------------------

function modifier_meteor_channel:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveVerticalMotionController( self )
	end
end

--------------------------------------------------------------------------------

function modifier_meteor_channel:UpdateVerticalMotion( me, dt )
	if IsServer() then

		-- x2 so we can take t from 0-2 for one full cos cycle up and back down
		self.t = self.t + ( ( dt / self.flChannelTime ) * 2 )
		--print( "dt = " .. dt ..  "   t = " .. self.t )

		local curve = -( math.cos( 3.14159 * self.t ) - 1 ) / 2
		local flHeightOffset = curve * self.flMaxHeight
		--print( "sin result = " .. curve .. ".  Height offset = " .. flHeightOffset )

		local flGroundHeight = GetGroundHeight( self:GetParent():GetAbsOrigin(), self:GetParent() )

		local vNewLocation = self:GetParent():GetAbsOrigin()
		vNewLocation.z = flGroundHeight + flHeightOffset

		me:SetOrigin( vNewLocation )
	end
end

--------------------------------------------------------------------------------

function modifier_meteor_channel:OnVerticalMotionInterrupted()
	if IsServer() then
		print( "motion interrupted" )
		self:Destroy()
	end
end




