
modifier_morty_leash = class({})

--------------------------------------------------------------------------------

function modifier_morty_leash:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_morty_leash:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_morty_leash:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_morty_leash:OnCreated( kv )
	if IsServer() then
		self.flMinX = kv.min_x
		self.flMinY = kv.min_y
		self.flMaxX = kv.max_x
		self.flMaxY = kv.max_y
		self:StartIntervalThink( 0.01 )
	end
end

-----------------------------------------------------------------------

function modifier_morty_leash:OnIntervalThink()

	local vCurrentPos = self:GetParent():GetAbsOrigin()
	local vClamped = Vector( vCurrentPos.x, vCurrentPos.y, vCurrentPos.z )

	if vClamped.x < self.flMinX then
		vClamped.x = self.flMinX
	elseif vClamped.x > self.flMaxX then
		vClamped.x = self.flMaxX
	end

	if vClamped.y < self.flMinY then
		vClamped.y = self.flMinY
	elseif vClamped.y > self.flMaxY then
		vClamped.y = self.flMaxY
	end

	if vCurrentPos ~= vClamped then
		print( "Morty Teleporting from " .. tostring( vCurrentPos ) .. " to " .. tostring( vClamped ) )
		FindClearSpaceForUnit( self:GetParent(), vClamped, true )
	end

end