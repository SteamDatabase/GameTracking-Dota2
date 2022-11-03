modifier_mounted = class({})

----------------------------------------------------------------------------------
function modifier_mounted:IsHidden()
	return true
end

----------------------------------------------------------------------------------
function modifier_mounted:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
function modifier_mounted:CheckState()
	local state = 
	{
		[ MODIFIER_STATE_DISARMED ] = true,
	}
	return state
end

--------------------------------------------------------------------------------
function modifier_mounted:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_EVENT_ON_STATE_CHANGED,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

-----------------------------------------------------------------------
function modifier_mounted:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------
function modifier_mounted:GetModifierDisableTurning( params )
	return 1
end

--------------------------------------------------------------------------------
function modifier_mounted:OnStateChanged( params )
	local hParent = self:GetParent()
	if not IsServer() or params.unit ~= hParent then return end

	if hParent:IsStunned() or hParent:IsHexed() or hParent:IsFrozen() or hParent:IsRooted() or hParent:IsTaunted() or hParent:IsFeared() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------
function modifier_mounted:OnOrder( params )
	if not IsServer() then return end

	if params.unit == self:GetParent() then
		local validMoveOrders =
		{
			[DOTA_UNIT_ORDER_ATTACK_TARGET] = true,
			[DOTA_UNIT_ORDER_MOVE_TO_TARGET] = true,
			[DOTA_UNIT_ORDER_MOVE_TO_POSITION] = true,
			[DOTA_UNIT_ORDER_ATTACK_MOVE] = true,
			[DOTA_UNIT_ORDER_PICKUP_ITEM] = true,
			[DOTA_UNIT_ORDER_PICKUP_RUNE] = true,
		}

		if validMoveOrders[params.order_type] then
			local vTargetPos = params.new_pos
			if params.target ~= nil and params.target:IsNull() == false then
				vTargetPos = params.target:GetAbsOrigin()
			end

			local vMountOrigin = self:GetMount():GetOrigin()
			if self.angle_correction ~= nil and self.angle_correction > 0 then
				-- correct for ogre seal hop by aniticipating where we will end up and calculating from there.
				-- clamp by order distance in case the order is already directly in front of us
				local flOrderDist = (vMountOrigin - vTargetPos):Length2D()
				vMountOrigin = vMountOrigin + self:GetMount():GetForwardVector() * math.min(self.angle_correction, flOrderDist * 0.75)
			end

			local vDir = vTargetPos - vMountOrigin
			vDir.z = 0
			vDir = vDir:Normalized()
			local angles = VectorAngles( vDir )

			self:GetMount().flDesiredYaw = angles.y
		end
	end
end

----------------------------------------------------------------------------------
function modifier_mounted:OnTakeDamage( params )
	if not IsServer() then return end

	local hVictim = params.unit
	local hAttacker = params.attacker
	if hVictim == nil or hVictim:IsNull() or hVictim ~= self:GetParent() then
		return
	end

	if hAttacker == nil or hAttacker:IsNull() or hAttacker == hVictim then
		return
	end

	if self:GetAbility() ~= nil and self:GetAbility():GetSpecialValueFor("dismount_from_damage") == 1 then
		if ( IsConsideredHeroDamageSource(hAttacker) or hAttacker == GameRules.Winter2022.hRoshan ) then
			self:Destroy()
		end
	end
end

----------------------------------------------------------------------------------
function modifier_mounted:OnCreated( kv )
	if not IsServer() then return end

	self.flCreationTime = GameRules:GetDOTATime( false, true )

	self.bMoving = false
	self:GetParent():StartGesture( ACT_DOTA_GENERIC_CHANNEL_1 )

	self.angle_correction = self:GetAbility():GetSpecialValueFor("angle_correction")

	if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
		self:Destroy()
		return
	end
end

--------------------------------------------------------------------------------
function modifier_mounted:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():RemoveHorizontalMotionController( self )
	self:GetParent():RemoveVerticalMotionController( self )

	self:GetParent():RemoveGesture( ACT_DOTA_GENERIC_CHANNEL_1 )

	if self:GetAbility().OnDismount ~= nil then
		self:GetAbility():OnDismount()
	end

	if self:IsMountMoving() then
		-- Animate dismount
		local vLocation = self:GetParent():GetAbsOrigin() + ( self:GetParent():GetForwardVector() * 50 )
		local kv =
		{
			center_x = vLocation.x,
			center_y = vLocation.y,
			center_z = vLocation.z,
			should_stun = false, 
			duration = 0.4,
			knockback_duration = 0.3,
			knockback_distance = 50,
			knockback_height = 75,
		}

		self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_knockback", kv )
	end

	-- Put ability on cooldown
	local hSummonAbility = self:GetParent():FindAbilityByName("summon_penguin")
	if hSummonAbility then
		hSummonAbility:StartCooldown( hSummonAbility:GetCooldown(-1) )
	end
end

--------------------------------------------------------------------------------
function modifier_mounted:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end
	
	if not self:GetMount():IsAlive() then
		self:Destroy()
		return
	end

	if self.bMoving == false and self:IsMountMoving() then
		self.bMoving = true
		self:GetParent():FadeGesture( ACT_DOTA_GENERIC_CHANNEL_1 )
	end
	
	-- Do nothing! This is handled by modifier_mount_movement or modifier_mount_hop_movement in order to avoid update order issues
end

--------------------------------------------------------------------------------
function modifier_mounted:UpdateVerticalMotion( me, dt )
	-- Do nothing! This is handled by modifier_mount_movement or modifier_mount_hop_movement in order to avoid update order issues
end

--------------------------------------------------------------------------------
function modifier_mounted:OnHorizontalMotionInterrupted()
	if not IsServer() then return end
	self:Destroy()
end

--------------------------------------------------------------------------------
function modifier_mounted:OnVerticalMotionInterrupted()
	if not IsServer() then return end
	self:Destroy()
end

--------------------------------------------------------------------------------
function modifier_mounted:IsMountMoving()
	return self:GetCaster():HasModifier("modifier_mount_movement") or self:GetCaster():HasModifier("modifier_mount_hop_movement")
end

--------------------------------------------------------------------------------
function modifier_mounted:GetMount()
	return self:GetCaster()
end
