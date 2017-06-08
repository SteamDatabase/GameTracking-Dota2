modifier_pre_teleport = class({})

--------------------------------------------------------------------------------

function modifier_pre_teleport:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_pre_teleport:OnCreated( kv )
	if IsServer() then
		self:GetParent():AddEffects( EF_NODRAW )
		self.vPos = self:GetParent():GetOrigin()
		self.bTPFinished = false
	end
end

--------------------------------------------------------------------------------

function modifier_pre_teleport:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TELEPORTED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_pre_teleport:OnTeleported( params )
	if IsServer() then
		if params.unit == self:GetParent() and self.bTPFinished == false then
			self.bTPFinished = true
			--FindClearSpaceForUnit( self:GetParent(), self.vPos, true )
			self:GetParent():RemoveEffects( EF_NODRAW )
			self:GetParent():RemoveModifierByName( "modifier_command_restricted" )
			if GameRules.Dungeon ~= nil then
				GameRules.Dungeon:OnPlayerHeroEnteredZone( self:GetParent(), "start" )
			end
			self:Destroy()

		end	
	end
end

--------------------------------------------------------------------------------

function modifier_pre_teleport:CheckState()
	local state = 
	{
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	}
	
	return state
end


