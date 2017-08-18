modifier_sled_penguin_movement = class({})

----------------------------------------------------------------------------------

function modifier_sled_penguin_movement:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_sled_penguin_movement:IsPurgable()
	return false
end

----------------------------------------------------------------------------------

function modifier_sled_penguin_movement:OnCreated( kv )
	if IsServer() then
		self.max_sled_speed = self:GetAbility():GetSpecialValueFor( "max_sled_speed" )
		self.speed_step = self:GetAbility():GetSpecialValueFor( "speed_step" )
		self.nCurSpeed = 50
		self.nGold = 0
		self.flDesiredYaw = self:GetCaster():GetAnglesAsVector().y
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
			return
		end

		if self:GetParent() == self:GetCaster() then
			self:GetParent():StartGesture( ACT_DOTA_SLIDE )
		end

	end
end

--------------------------------------------------------------------------------

function modifier_sled_penguin_movement:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		if self:GetParent() == self:GetCaster() then
			self:GetCaster():RemoveGesture( ACT_DOTA_SLIDE_LOOP )
			
			local newItem = CreateItem( "item_bag_of_gold", nil, nil )
			newItem:SetPurchaseTime( 0 )
			newItem:SetCurrentCharges( self.nGold )
			local drop = CreateItemOnPositionSync( self:GetParent():GetAbsOrigin(), newItem )
			local dropTarget = self:GetParent():GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )
			newItem:LaunchLoot( true, 150, 0.75, dropTarget )

			EmitSoundOn( "Hero_Tusk.IceShards.Penguin", self:GetParent() )
			self:GetParent():MoveToPosition( Vector( -11691.494, 15214.293, 2564.000 ) + RandomVector( 50 ) )	
		else
			GameRules.Dungeon:OnPenguinRideFinished( self:GetParent():GetPlayerID(), self:GetElapsedTime() )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_sled_penguin_movement:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_sled_penguin_movement:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = self:GetCaster() == self:GetParent(),
		[MODIFIER_STATE_INVULNERABLE] = self:GetCaster() == self:GetParent(),
		[MODIFIER_STATE_NO_HEALTH_BAR] = self:GetCaster() == self:GetParent(),
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_sled_penguin_movement:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		if self:GetCaster() == self:GetParent() then
			if self.bStartedLoop == nil and self:GetElapsedTime() > 0.3 then
				self.bStartedLoop = true
				self:GetCaster():StartGesture( ACT_DOTA_SLIDE_LOOP )
			end

			local flTurnAmount = 0.0
			local curAngles = self:GetCaster():GetAngles()
			
			local flAngleDiff = UTIL_AngleDiff( self.flDesiredYaw, curAngles.y )
			
			local flTurnRate = 60
			--local flTurnRateMod = 25 * self.nCurSpeed / self.max_sled_speed 
			--flTurnRate = flTurnRate - flTurnRateMod
			flTurnAmount = flTurnRate * dt
			flTurnAmount = math.min( flTurnAmount, math.abs( flAngleDiff ) )
		
			if flAngleDiff < 0.0 then
				flTurnAmount = flTurnAmount * -1
			end

			if flAngleDiff ~= 0.0 then
				curAngles.y = curAngles.y + flTurnAmount
				me:SetAbsAngles( curAngles.x, curAngles.y, curAngles.z )
			end

			local vNewPos = self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector() * ( dt * self.nCurSpeed )
			if GridNav:CanFindPath( me:GetOrigin(), vNewPos ) == false then
				self:Destroy()

				return
			end
			me:SetOrigin( vNewPos )
			self.nGold = self.nGold + 1
			self.nCurSpeed = math.min( self.nCurSpeed + self.speed_step, self.max_sled_speed )
		else
			if self:GetCaster():IsAlive() == false or self:GetCaster():FindModifierByName( "modifier_sled_penguin_movement" ) == nil then
				self:Destroy()
				return
			end
			--local attachment = self:GetCaster()ScriptLookupAttachment( )
			me:SetOrigin( self:GetCaster():GetOrigin() )
			local casterAngles = self:GetCaster():GetAngles() 
			me:SetAbsAngles( casterAngles.x, casterAngles.y, casterAngles.z )
		end
		
	end
end

--------------------------------------------------------------------------------

function modifier_sled_penguin_movement:GetOverrideAnimation( params )
	if self:GetParent() ~= self:GetCaster() then
		return ACT_DOTA_FLAIL
	end
	return ACT_DOTA_SLIDE_LOOP
end


-----------------------------------------------------------------------

function modifier_sled_penguin_movement:OnOrder( params )
	if IsServer() then
		local hOrderedUnit = params.unit 
		local hTargetUnit = params.target
		local nOrderType = params.order_type
		if nOrderType == DOTA_UNIT_ORDER_MOVE_TO_POSITION or nOrderType == DOTA_UNIT_ORDER_ATTACK_MOVE then
			if hOrderedUnit == self:GetParent() and self:GetParent() ~= self:GetCaster() then
				local vDir = params.new_pos - self:GetCaster():GetOrigin()
				vDir.z = 0
				vDir = vDir:Normalized()
				local angles = VectorAngles( vDir )
				local hBuff = self:GetCaster():FindModifierByName( "modifier_sled_penguin_movement" )
				if hBuff ~= nil then
					hBuff.flDesiredYaw = angles.y
				end	
			end
		end

	end
	return 0
end

-----------------------------------------------------------------------

function modifier_sled_penguin_movement:GetModifierDisableTurning( params )
	return 1
end