modifier_disruptor_glimpse_nb2017 = class({})

--------------------------------------------------------------------------------

function modifier_disruptor_glimpse_nb2017:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_disruptor_glimpse_nb2017:IsPurgable()
	return true;
end

--------------------------------------------------------------------------------

function modifier_disruptor_glimpse_nb2017:OnCreated( kv )
	if IsServer() then
		self.vPositions = {}
		for i = 1,17 do
			table.insert( self.vPositions, self:GetParent():GetOrigin() )
		end

		self.flExpireTime = -1
		self:StartIntervalThink( 0.5 )
	end
end

--------------------------------------------------------------------------------

function modifier_disruptor_glimpse_nb2017:OnIntervalThink()
	if IsServer() then
		if self.flExpireTime ~= -1 and GameRules:GetGameTime() > self.flExpireTime then
			if self.hThinker ~= nil then
				self.hThinker:EndGlimpse( self:GetParent() )
			end
			self.flExpireTime = -1
			self.hThinker = nil
		end

		for i = 1,16 do
			self.vPositions[i] = self.vPositions[i+1]
		end

		self.vPositions[ #self.vPositions ] = self:GetParent():GetOrigin()
	end
end

--------------------------------------------------------------------------------

function modifier_disruptor_glimpse_nb2017:GetOldestPosition()
	return self.vPositions[1]
end

--------------------------------------------------------------------------------

function modifier_disruptor_glimpse_nb2017:SetExpireTime( flTime )
	if IsServer() then
		self.flExpireTime = flTime
	end
end

--------------------------------------------------------------------------------

function modifier_disruptor_glimpse_nb2017:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_disruptor_glimpse_nb2017:OnDeath( params )
	if IsServer() then
		local hUnit = params.unit
		if hUnit == self:GetParent() then
			if self.hThinker ~= nil then
				self.hThinker:RemoveUnit( hUnit )
			end
		end
	end
end