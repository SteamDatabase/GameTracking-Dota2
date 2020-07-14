
modifier_ride_morty = class({})

----------------------------------------------------------------------------------

function modifier_ride_morty:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_ride_morty:IsPurgable()
	return false
end

-----------------------------------------------------------------------

function modifier_ride_morty:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

----------------------------------------------------------------------------------

function modifier_ride_morty:OnCreated( kv )
	if IsServer() then
		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
			self:Destroy()
			return
		end
	end
end


--------------------------------------------------------------------------------

function modifier_ride_morty:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_ride_morty:CheckState()
	local state =
	{
		[ MODIFIER_STATE_INVULNERABLE ] = true,
		[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
		[ MODIFIER_STATE_SILENCED ] = true,
		[ MODIFIER_STATE_UNSELECTABLE ] = true,
		[ MODIFIER_STATE_COMMAND_RESTRICTED ] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_ride_morty:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		if self:GetCaster() then
			me:SetAbsOrigin( self:GetCaster():GetAbsOrigin() )

			local MortyAngles = self:GetCaster():GetAngles() 
			me:SetAbsAngles( MortyAngles.x, MortyAngles.y, MortyAngles.z )
		end
	end
end


--------------------------------------------------------------------------------

function modifier_ride_morty:UpdateVerticalMotion( me, dt )
	if IsServer() then
		if  self:GetCaster() then

			local vPos =  self:GetCaster():GetAbsOrigin()
			vPos.z = vPos.z + 50
			me:SetAbsOrigin( vPos )	
		end
	end
end


--------------------------------------------------------------------------------

function modifier_ride_morty:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )
	end
end


--------------------------------------------------------------------------------

function modifier_ride_morty:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end


--------------------------------------------------------------------------------

function modifier_ride_morty:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end




