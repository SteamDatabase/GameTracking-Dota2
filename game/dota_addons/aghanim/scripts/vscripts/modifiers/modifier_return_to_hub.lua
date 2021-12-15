modifier_return_to_hub = class({})

---------------------------------------------------------------------------

function modifier_return_to_hub:IsHidden()
	return true
end

---------------------------------------------------------------------------

function modifier_return_to_hub:GetAttributes() 
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

---------------------------------------------------------------------------

function modifier_return_to_hub:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_return_to_hub:OnCreated( kv )
	if IsServer() then
		self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_camera_follow", { duration = 5 } )

		self.bMoved = false
		self.flOffsetZ = nil
		if self:ApplyVerticalMotionController() == false or self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
		end

		self.nEnterPortalFX = ParticleManager:CreateParticle( "particles/creatures/aghanim/portal_summon.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nEnterPortalFX, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControlForward( self.nEnterPortalFX, 0, self:GetParent():GetForwardVector() )
		EmitSoundOn( "SeasonalConsumable.TI10.Portal.Open", self:GetParent() )
		EmitSoundOn( "SeasonalConsumable.TI10.Portal.Loop", self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_return_to_hub:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 20000000
end

--------------------------------------------------------------------------------

function modifier_return_to_hub:CheckState()
	local state =
	{
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true 
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_return_to_hub:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveVerticalMotionController( self )
		self:GetParent():RemoveHorizontalMotionController( self )
	end
end

--------------------------------------------------------------------------------

function modifier_return_to_hub:UpdateVerticalMotion( me, dt )
	if IsServer() then
		if self:GetElapsedTime() < 2.0 then 
			return
		end

		local flOffset = -12
		if self.bMoved then 
			flOffset = 12
			if self.flOffsetZ ~= nil then 
				local vOffetPos = self:GetParent():GetAbsOrigin() + Vector( 0, 0, self.flOffsetZ )
				self:GetParent():SetOrigin( vOffetPos )
				self:GetParent():RemoveEffects( EF_NODRAW )
				self.flOffsetZ = nil
			end
		end

		local vNewPos = self:GetParent():GetAbsOrigin() + Vector( 0, 0, flOffset )
		self:GetParent():SetOrigin( vNewPos )
	end
end

--------------------------------------------------------------------------------

function modifier_return_to_hub:UpdateHorizontalMotion( me, dt )
	if IsServer() then 
		if self:GetElapsedTime() > 4.0 and self.bMoved == false then 
			self.bMoved = true 

			ParticleManager:DestroyParticle( self.nEnterPortalFX, false )
			StopSoundOn( "SeasonalConsumable.TI10.Portal.Open", self:GetParent() )
			StopSoundOn( "SeasonalConsumable.TI10.Portal.Loop", self:GetParent() )

			local HubRoom = GameRules.Aghanim:GetRoom( "hub" )
			local hHubReturnTarget = HubRoom:FindAllEntitiesInRoomByName( "hub_return_locator", false )
			local vLocation = HubRoom:GetOrigin()
			if #hHubReturnTarget > 0 then 
				vLocation = hHubReturnTarget[ 1 ]:GetOrigin()
			end	
			local flBeforeMoveZ = self:GetParent():GetAbsOrigin().z
			local flOldHeightZ = GetGroundHeight( self:GetParent():GetAbsOrigin(), self:GetParent() )
			local flHeightDiff = flOldHeightZ - flBeforeMoveZ
			self:GetParent():SetOrigin( vLocation )

			local flMoveGroundHeightZ = GetGroundHeight( vLocation, self:GetParent() )
			self.flOffsetZ = flMoveGroundHeightZ - flHeightDiff
			self:GetParent():AddEffects( EF_NODRAW )
			
			CenterCameraOnUnit( self:GetParent():GetPlayerOwnerID(), self:GetParent() )

			if GameRules.Aghanim and GameRules.Aghanim:GetRoom( "hub" ) and GameRules.Aghanim:GetRoom( "hub" ):GetEncounter() then 
				CustomGameEventManager:Send_ServerToPlayer( self:GetParent():GetPlayerOwner(),"introduce_encounter", GameRules.Aghanim:GetRoom( "hub" ):GetEncounter().ClientData )
			end

			self.nEnterPortalFX = ParticleManager:CreateParticle( "particles/creatures/aghanim/portal_summon.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( self.nEnterPortalFX, 0, self:GetParent():GetAbsOrigin() )
			ParticleManager:SetParticleControlForward( self.nEnterPortalFX, 0, self:GetParent():GetForwardVector() )

			EmitSoundOn( "SeasonalConsumable.TI10.Portal.Open", self:GetParent() )
			EmitSoundOn( "SeasonalConsumable.TI10.Portal.Loop", self:GetParent() )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_return_to_hub:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_return_to_hub:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_return_to_hub:OnDestroy()
	if IsServer() then 
		if self.nEnterPortalFX then 
			ParticleManager:DestroyParticle( self.nEnterPortalFX, false )
		end
		StopSoundOn( "SeasonalConsumable.TI10.Portal.Open", self:GetParent() )
		StopSoundOn( "SeasonalConsumable.TI10.Portal.Loop", self:GetParent() )

		
		local HubRoom = GameRules.Aghanim:GetRoom( "hub" )
		local hHubReturnTarget = HubRoom:FindAllEntitiesInRoomByName( "hub_return_locator", false )
		if #hHubReturnTarget > 0 then 
			FindClearSpaceForUnit( self:GetParent(), hHubReturnTarget[ 1 ]:GetOrigin(), true )	
		else
			FindClearSpaceForUnit( self:GetParent(), HubRoom:GetOrigin(), true )
		end	

		CenterCameraOnUnit( self:GetParent():GetPlayerOwnerID(), self:GetParent() )
		
		self:GetParent():RemoveEffects( EF_NODRAW )
		self:GetParent():Interrupt()
	end
end


--------------------------------------------------------------------------------