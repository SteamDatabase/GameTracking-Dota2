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

		self.nProjHandle = -1
		self.flTime = 0.0
		self.flHeight = 0.0
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

function modifier_storegga_grabbed_debuff:UpdateHorizontalMotion( me, dt )
	if IsServer() then
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