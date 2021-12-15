modifier_aghanim_clone_portal_out = class({})

---------------------------------------------------------------------------

function modifier_aghanim_clone_portal_out:IsHidden()
	return true
end

---------------------------------------------------------------------------

function modifier_aghanim_clone_portal_out:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_aghanim_clone_portal_out:OnCreated( kv )
	if IsServer() then
		self.bDescend = false
		if self:ApplyVerticalMotionController() == false then 
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_aghanim_clone_portal_out:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 20000000
end

--------------------------------------------------------------------------------

function modifier_aghanim_clone_portal_out:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveVerticalMotionController( self )
	end
end

--------------------------------------------------------------------------------

function modifier_aghanim_clone_portal_out:UpdateVerticalMotion( me, dt )
	if IsServer() then
		if self.bDescend == false then  
			return 
		end

		local vNewPos = self:GetParent():GetAbsOrigin() + Vector( 0, 0, -8 )
		self:GetParent():SetAbsOrigin( vNewPos )
	end
end

--------------------------------------------------------------------------------

function modifier_aghanim_clone_portal_out:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_aghanim_clone_portal_out:OnDestroy()
	if IsServer() then 
		self:GetParent():AddEffects( EF_NODRAW )
	end
end


--------------------------------------------------------------------------------