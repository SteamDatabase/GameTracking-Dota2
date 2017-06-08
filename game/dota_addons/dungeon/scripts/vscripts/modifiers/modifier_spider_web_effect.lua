modifier_spider_web_effect = class({})

--------------------------------------------------------------------------

function modifier_spider_web_effect:IsHidden()
	return false
end

--------------------------------------------------------------------------

function modifier_spider_web_effect:OnCreated( kv )
	if IsServer() then
		--self:StartIntervalThink( 0.0001 )
		self.flLastZ = self:GetParent():GetOrigin().z
		self.flLastPitch = self:GetParent():GetAnglesAsVector().x

		self.flLastTraversableHeight = nil
	end
end

--------------------------------------------------------------------------------

function modifier_spider_web_effect:CheckState()
	local state =
	{
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}

	return state
end

------------------------------------------------------------------------------------

function modifier_spider_web_effect:OnIntervalThink()
	if IsServer() then
		if self:GetParent():GetAggroTarget() == nil then
			return
		end

		local vOrigin = self:GetParent():GetOrigin()
		local vAngles = self:GetParent():GetAnglesAsVector()
		local flRemainder = vOrigin.z % 128
		local flNewPitch = 0

		if vOrigin.z == self.flLastZ then
			return
		end

		if GridNav:IsTraversable( vOrigin ) == true then
			self:GetParent():SetAngles( 0, vAngles.y, vAngles.z ) 
			self.flLastTraversableHeight = vOrigin.z
		else
			local flNewPitch = 0
			local flHeightDiff = self.flLastZ - vOrigin.z
			local flRemappedHeightDiffToPitch = flHeightDiff / ( 128 / 90 )

			if flRemainder == 0 then
				if vOrigin.z < self.flLastZ then
					flNewPitch = 90
				else
					flNewPitch = -90
				end		
			else
				if vOrigin.z < self.flLastZ then
					--Climbing down a wall
					flNewPitch = math.min( vAngles.x + flRemappedHeightDiffToPitch, 90.0 )
					self:GetParent():SetAngles( flNewPitch, vAngles.y, vAngles.z ) 
				else
					--Climbing up
					flNewPitch = math.max( vAngles.x + flRemappedHeightDiffToPitch, -90.0 )
					self:GetParent():SetAngles( flNewPitch, vAngles.y, vAngles.z ) 
				end
			end

			if flNewPitch ~= self.flLastPitch then
				--print( "Z: " .. vOrigin.z )
				--print( "Remainder: " .. flRemainder )
				--print( "Remapped Height to Pitch: " .. flRemappedHeightDiffToPitch )
				--print( "Pitch: " .. flNewPitch )
				
			end
		end

		self.flLastZ = vOrigin.z 
		self.flLastPitch = flNewPitch
	end
end



--------------------------------------------------------------------------
