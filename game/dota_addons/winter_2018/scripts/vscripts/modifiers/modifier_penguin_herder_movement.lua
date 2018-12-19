require( "event_queue" )

modifier_penguin_herder_movement = class({})

----------------------------------------------------------------------------------

function modifier_penguin_herder_movement:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_penguin_herder_movement:IsPurgable()
	return false
end


function modifier_penguin_herder_movement:GetActivityTranslationModifiers( params )
	return "haste"
end

--------------------------------------------------------------------------------

function modifier_penguin_herder_movement:GetModifierDisableTurning( params )
	return 1
end

-----------------------------------------------------------------------

function modifier_penguin_herder_movement:GetOverrideAnimation( params )
	--local hUnit = self:GetParent()
	--if hUnit then
	--	local hBashed = hUnit:FindModifierByName( "modifier_bashed" )
	--	if hBashed then
	--		return ACT_DOTA_DISABLED
	--	end
	--end
	return ACT_DOTA_GENERIC_CHANNEL_1
end

function modifier_penguin_herder_movement:CreateSledParticle()
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/herder_sled.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	end
end

function modifier_penguin_herder_movement:GetSpeed()
	local hUnit = self:GetParent()
	local flSpeed = self.speed;
	if hUnit.hTrain ~= nil then
		flSpeed = min(self.max_speed, self.speed + self.speed_per_penguin*#hUnit.hTrain)
	end
	--printf("herder speed %s", flSpeed)
	return flSpeed
end

----------------------------------------------------------------------------------

function modifier_penguin_herder_movement:OnCreated( kv )
	if IsServer() then
		kv = { speed=400, speed_per_penguin=20, max_speed=900, crash_impaired_duration=1 }
		self.speed = kv["speed"]
		self.max_speed = kv["max_speed"]
		self.speed_per_penguin = kv["speed_per_penguin"]
		self.crash_impaired_duration = kv["crash_impaired_duration"]
		self.EventQueue = CEventQueue()

		self.flDesiredYaw = self:GetCaster():GetAnglesAsVector().y

		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
			return
		end

		if self.nFXIndex == nil then
			self:CreateSledParticle()
		end

		local hUnit = self:GetParent()
		hUnit.hTrain = {}	

		self:StartIntervalThink( 0.1 )
	end
end

--------------------------------------------------------------------------------

function modifier_penguin_herder_movement:OnIntervalThink()
	if IsServer() then

		local flNow = GameRules:GetGameTime()

		local hUnit = self:GetParent()

		if FIRST_HERDING_PENGUIN_SPAWN_TIME ~= nil and (flNow - FIRST_HERDING_PENGUIN_SPAWN_TIME) > HERDING_PENGUIN_ROUND_DURATION then
			--if hUnit.hTrain and TableLength(hUnit.hTrain) > 0 then 
				ExecuteOrderFromTable({
				UnitIndex = hUnit:entindex(),
				OrderType = DOTA_UNIT_ORDER_STOP
				})

				local flDelay = 0
				local flDelayIncrement = math.min(0.25, 3.0/#hUnit.hTrain)
				for i=1,#hUnit.hTrain,1 do
					local hPenguin = hUnit.hTrain[i]
					if hPenguin and not hPenguin:IsNull() then
						self.EventQueue:AddEvent( flDelay,
						function(hPenguin)
							local hBuff = hPenguin:FindModifierByName( "modifier_creature_herding_penguin" )
							hBuff:DropLoot()
						end, hPenguin )
						flDelay = flDelay + flDelayIncrement
					end
				end

				self.EventQueue:AddEvent( flDelay,
				function(hUnit)
						hUnit.hTrain = {}
				end, hUnit )
			--else
				self:Destroy()
			--end
			return
		end

		local nTargetFlags = DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
		local hPenguins = FindUnitsInRadius( hUnit:GetTeamNumber(), hUnit:GetOrigin(), hUnit, 50, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, nTargetFlags, 0, false )	
		for _, hPenguin in pairs( hPenguins ) do
			if hPenguin ~= nil and hPenguin:IsNull() == false then
				if  ( hPenguin:GetUnitName() == "npc_dota_creature_herding_penguin"  ) then
					if hPenguin.hHerder ~= nil and ( hPenguin.hHerder ~= self:GetParent() or (hPenguin.nPenguinIndex ~= nil and hPenguin.nPenguinIndex > 1) ) then
						local hBuff = hPenguin:FindModifierByName( "modifier_creature_herding_penguin" )
						if hPenguin.hMoveTarget ~= nil and hBuff and hBuff:InLine() then
							self:Crash( hPenguin )
						end
					end
				end
			end
		end

		local hBuildings = FindUnitsInRadius( hUnit:GetTeamNumber(), hUnit:GetOrigin(), hUnit, 10, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, nTargetFlags, 0, false )
		for _, hBuilding in pairs( hBuildings ) do
			if hBuilding ~= nil and hBuilding:IsNull() == false then
				if hBuilding:IsBuilding() then
				--if hBuilding:IsTower() or (hBuilding:IsHero() and hBuilding ~= hUnit) then
					self:Crash( hBuilding )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_penguin_herder_movement:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		if self.nFXIndex ~= nil then
			printf("destroying particle %s", self.nFXIndex)
			ParticleManager:DestroyParticle( self.nFXIndex, true )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_penguin_herder_movement:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_penguin_herder_movement:CheckState()
	local state =
	{
		[ MODIFIER_STATE_MUTED ] = true,
		[ MODIFIER_STATE_SILENCED ] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_penguin_herder_movement:UpdateHorizontalMotion( hUnit, dt )
	if IsServer() then
	
		local flNow = GameRules:GetGameTime()

		local hBashed = hUnit:FindModifierByName( "modifier_bashed" )
		if hBashed then
			return
		end

		--local flTurnAmount = 0.0
		local curAngles = hUnit:GetAngles()

		-- if self.flDesiredYaw < 0 then
		-- 	self.flDesiredYaw = 2*math.pi + self.flDesiredYaw
		-- end

		-- if self.flDesiredYaw >= 315 or self.flDesiredYaw < 45 then
		-- 	self.flDesiredYaw = 0
		-- elseif self.flDesiredYaw >= 45 and self.flDesiredYaw < 135 then
		-- 	self.flDesiredYaw = 90
		-- elseif self.flDesiredYaw >= 135 and self.flDesiredYaw < 225 then
		-- 	self.flDesiredYaw = 180
		-- elseif self.flDesiredYaw >= 225 and self.flDesiredYaw < 315 then
		-- 	self.flDesiredYaw = 270
		-- else
		-- 	printf("something went wrong %s", self.flDesiredYaw)
		-- end


		local flTurnAmount = 0.0
		local curAngles = self:GetCaster():GetAngles()
		
		local flAngleDiff = UTIL_AngleDiff( self.flDesiredYaw, curAngles.y )
		
		local flTurnRate = 400
		flTurnAmount = flTurnRate * dt
		flTurnAmount = math.min( flTurnAmount, math.abs( flAngleDiff ) )
	
		if flAngleDiff < 0.0 then
			flTurnAmount = flTurnAmount * -1
		end

		if flAngleDiff ~= 0.0 then
			curAngles.y = curAngles.y + flTurnAmount
			hUnit:SetAbsAngles( curAngles.x, curAngles.y, curAngles.z )
		end

		--hUnit:SetAbsAngles( curAngles.x, self.flDesiredYaw, curAngles.z )
		
		local vNewPos = hUnit:GetOrigin() + hUnit:GetForwardVector() * ( dt * self:GetSpeed() )
		if GridNav:CanFindPath( hUnit:GetOrigin(), vNewPos ) == false then
			self:Crash()
			return
		end

		hUnit:SetOrigin( vNewPos )

		--self.nCurSpeed = math.min( self.nCurSpeed + self.speed_step, self.speed )
		
	end
end

--------------------------------------------------------------------------------

function modifier_penguin_herder_movement:Crash( hCrashTarget )

	local flNow = GameRules:GetGameTime()
	local hUnit = self:GetParent()
	local flTimeSinceLastCrash = hUnit.flLastCrashTime ~= nil and (flNow - hUnit.flLastCrashTime) or 10000

	local hTrain = hUnit.hTrain

	--printf("CRASHING!: time since last crash is %s", flTimeSinceLastCrash)

	if TableLength(hTrain) > 0 then
		ScreenShake( hUnit:GetOrigin(), 10.0, 100.0, 0.5, 1300.0, 0, true )
		hUnit:AddNewModifier( hUnit, nil, "modifier_bashed", { duration=self.crash_impaired_duration} )
		GridNav:DestroyTreesAroundPoint( hUnit:GetOrigin(), 100, false )
		self.flDesiredYaw = self.flDesiredYaw + 180
	end

	for index, hPenguin in pairs( hTrain ) do
		if hPenguin and not hPenguin:IsNull() then
			local hBuff = hPenguin:FindModifierByName( "modifier_creature_herding_penguin" )
			if hBuff then
				hBuff:Disconnect()
			end
		end
	end

	hUnit.hTrain = {}
	hUnit.flLastCrashTime = flNow
	
end

--------------------------------------------------------------------------------

function modifier_penguin_herder_movement:OnOrder( params )
	if IsServer() then
		if not self:GetCaster() then
			return 0
		end
	
		local hOrderedUnit = params.unit 
		local hTargetUnit = params.target
		local nOrderType = params.order_type	

		if hOrderedUnit ~= self:GetParent() then
			return 0
		end

		--printf("ordered %s target %s order type %s", hOrderedUnit.unitName, hTargetUnit, nOrderType)

		if nOrderType == DOTA_UNIT_ORDER_MOVE_TO_POSITION or nOrderType == DOTA_UNIT_ORDER_ATTACK_MOVE then
			if hOrderedUnit == self:GetParent() then
				local vDir = params.new_pos - self:GetCaster():GetOrigin()
				vDir.z = 0
				vDir = vDir:Normalized()
				local angles = VectorAngles( vDir )
				local hBuff = self:GetCaster():FindModifierByName( "modifier_penguin_herder_movement" )

				if hBuff ~= nil then
					-- TODO!
					--if math.abs( angles.y - hBuff.flDesiredYaw ) < 180  then
						hBuff.flDesiredYaw = angles.y
					--end
					--printf("setting desired yaw to %s", hBuff.flDesiredYaw)
				end	
			end
		end
	end

	return 0
end

-----------------------------------------------------------------------
