
modifier_elemental_tiny_grab = class({})

--------------------------------------------------------------------------------

function modifier_elemental_tiny_grab:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_elemental_tiny_grab:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_elemental_tiny_grab:OnCreated( kv )
	if IsServer() then
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
			return
		end
	end
end

--------------------------------------------------------------------------------

function modifier_elemental_tiny_grab:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_elemental_tiny_grab:CheckState()
	local state = 
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_elemental_tiny_grab:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
	end
end

--------------------------------------------------------------------------------

function modifier_elemental_tiny_grab:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		local vLocation = nil
		if self:GetParent() ~= nil and self:GetParent():IsAlive() then
			local attach = self:GetCaster():ScriptLookupAttachment( "attach_attack" )
			vLocation = self:GetCaster():GetAttachmentOrigin( attach )
			me:SetOrigin( vLocation )
		end
		
	end
end


--------------------------------------------------------------------------------

function modifier_elemental_tiny_grab:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_elemental_tiny_grab:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

function modifier_elemental_tiny_grab:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetCaster() then
			self:Destroy()
		end
	end

	return 0
end
