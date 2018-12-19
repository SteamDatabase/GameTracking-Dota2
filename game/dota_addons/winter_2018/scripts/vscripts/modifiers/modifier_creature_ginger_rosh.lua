require( "ai/ai_shared" )
require( "event_queue" )

modifier_creature_ginger_rosh = class({})

--------------------------------------------------------------------------------

function modifier_creature_ginger_rosh:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_ginger_rosh:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_creature_ginger_rosh:OnCreated( kv )
	self.total_gold = self:GetAbility():GetSpecialValueFor( "total_gold" )
	self.time_limit = self:GetAbility():GetSpecialValueFor( "time_limit" )
	if IsServer() then
		local hUnit = self:GetParent()
		local flNow = GameRules:GetGameTime()

		self.EventQueue = CEventQueue()

		self.flAccumDamage = 0
		self.nBagsDropped = 0
		self.bDead = false	

		if _G.FIRST_GINGER_ROSH_SPAWN_TIME == nil then
			_G.FIRST_GINGER_ROSH_SPAWN_TIME = GameRules:GetGameTime()
		end

		self.flExpireTime = _G.FIRST_GINGER_ROSH_SPAWN_TIME + self.time_limit  + RandomFloat(0,1)
		self:StartIntervalThink( 0 )

		self.flStartingStackDamageThreshold = 150
		self.flStackDamageThresholdScale = 1.3

		self.flStackDamageThreshold = self.flStartingStackDamageThreshold
		self.flStartingModelScale = hUnit:GetModelScale()

		self.flNextSneezeTime = nil
		self.flSneezeInterval = 15
		self.nMaxStackCount = 8
		self.flMaxModelScale = 4.0

		self.flMoveInterval = 5.0
		self.flMaxMoveSpeed = 425
		self.flMaxMoveSpeedReduction = 200

		self.nGoldBagMin = 150
		self.nGoldBagMax = 250

	end
end

--------------------------------------------------------------------------------

function modifier_creature_ginger_rosh:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TELEPORTED,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_creature_ginger_rosh:GetModifierStatusResistanceStacking( params )
	return 50 
end

--------------------------------------------------------------------------------

function modifier_creature_ginger_rosh:OnIntervalThink()
	if IsServer() then

		-- this is a weird pattern, we start a think with an interval of zero to get
		-- the first one to happen right away, then set it to the desired value on the first/subsequent thinks
		self:StartIntervalThink( 2 )

		local hUnit = self:GetParent()

		local flNow = GameRules:GetGameTime()

		if self.bDead == true then
			StopOrder( hUnit )
			return
		end

		if flNow > self.flExpireTime then
			StopOrder( hUnit )
			if not self.bDead then
				self:Die(0)
			end
			return
		end

		--if self:GetStackCount() >= self.nMaxStacks or (self.flNextSneezeTime ~= nil and ( flNow > self.flNextSneezeTime ) ) then	
		if self:GetStackCount() >= self.nMaxStackCount then	
			--printf("SNEEZING OUT PRESENTS")
			StopOrder( hUnit )
			hUnit:StartGesture( ACT_DOTA_IDLE_RARE )	
			hUnit.bSneezing = true

			EmitSoundOn( "GingerRoshan.DropPresents", hUnit )

			local flDelay = 0
			for i=1,self:GetStackCount(),1 do
				self.EventQueue:AddEvent( flDelay, 
					function(self, hUnit) 

						if hUnit:IsNull() then
							return
						end

						self:DecrementStackCount()
						self:UpdateModelScale()

						local nBagsToDrop = 2
						for j=1,nBagsToDrop,1 do 
							local newItem = CreateItem( "item_bag_of_gold", nil, nil )
							local nGoldAmount = RandomInt( self.nGoldBagMin, self.nGoldBagMax )
							newItem:SetPurchaseTime( 0 )
							newItem:SetCurrentCharges( nGoldAmount / nBagsToDrop )
							local drop = CreateItemOnPositionSync( hUnit:GetAbsOrigin(), newItem )
							local flRange = 100+nGoldAmount/1.5
							newItem:LaunchLoot( true, 250, 0.75, hUnit:GetAbsOrigin() + Vector( RandomFloat(-flRange,flRange), RandomFloat(-flRange, flRange), 0) )
							drop:SetModelScale( RemapValClamped( nGoldAmount, 100, 200, 1, 1.5) )
						end	
					end
				, self, hUnit )
				flDelay = flDelay + 3.0/self:GetStackCount()
			end
			self:Die( flDelay )	

		else
			if self.flNextMoveTime == nil or (flNow > self.flNextMoveTime) then
				local vGoalPosition = GetRandomPathablePositionWithin( WINTER_MAP_CENTER_RUNE , 4000 )
				ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = vGoalPosition
				})
				self.flNextMoveTime = flNow + self.flMoveInterval
			end
		end

			
	end
end

function modifier_creature_ginger_rosh:UpdateModelScale()
	local hUnit = self:GetParent()
	local flModelScaleFactor =  RemapValClamped( self:GetStackCount(), 0, self.nMaxStackCount, 1, self.flMaxModelScale )	
	--printf("stack count to %d, model scale to %s", self:GetStackCount(), flModelScaleFactor )
	hUnit:SetModelScale(self.flStartingModelScale * flModelScaleFactor )
end

--------------------------------------------------------------------------------

function modifier_creature_ginger_rosh:OnTakeDamage( params )
	if IsServer() then
		local flNow = GameRules:GetGameTime()
		local hUnit = params.unit
		local hAttacker = params.attacker
		if hAttacker == nil or hAttacker:IsBuilding() then
			return 0
		end
		if hUnit == self:GetParent() then		
			local flDamage = params.damage
			if flDamage <= 0 then
				return
			end

			if hUnit.bSneezing == true then
				return
			end

			self.flAccumDamage = self.flAccumDamage + flDamage
			if self.flAccumDamage >= self.flStackDamageThreshold then

				self.flAccumDamage = self.flAccumDamage - self.flStackDamageThreshold
				self:IncrementStackCount()
				self:UpdateModelScale()

				self.flStackDamageThreshold = self.flStackDamageThreshold *self.flStackDamageThresholdScale

				--printf("damage threshold at stack %s is %s", self:GetStackCount(), self.flStackDamageThreshold)

				if self:GetParent():GetModelScale() > 3.0 then
					EmitSoundOn( "GingerRoshan.LowPitchGrunt", hUnit )
				elseif self:GetParent():GetModelScale() > 2.0 then
					EmitSoundOn( "GingerRoshan.NormalPitchGrunt", hUnit )
				else
					EmitSoundOn( "GingerRoshan.HighPitchGrunt", hUnit )
				end
			end
		end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_creature_ginger_rosh:Die( flDelay )
	if IsServer() then
		local hUnit = self:GetParent()
		self.bDead = true
		self.EventQueue:AddEvent( flDelay, 
			function(self, hUnit) 
				if not hUnit:IsNull() then
					EmitSoundOn( "GingerRoshan.Death", hUnit )
					hUnit:ForceKill( false )
				end
			end
		, self, hUnit )
	end
end

--------------------------------------------------------------------------------

function modifier_creature_ginger_rosh:GetModifierMoveSpeed_Absolute( params )
	if IsServer() then
		local fSpeed = self.flMaxMoveSpeed - RemapValClamped( self:GetStackCount(), 0, self.nMaxStackCount, 0, self.flMaxMoveSpeedReduction )
		return fSpeed
	end

	return self.flMaxMoveSpeed
end

--------------------------------------------------------------------------------

function modifier_creature_ginger_rosh:GetMinHealth( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_creature_ginger_rosh:CheckState()
	local state = {}
	if IsServer()  then
		state =
		{
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		}
		if self.bDead or self.bSzeezing or GameRules:GetGameTime() > self.flExpireTime or self.total_gold <= 0 then
			state[MODIFIER_STATE_MAGIC_IMMUNE] = true
			state[MODIFIER_STATE_INVULNERABLE] = true
			state[MODIFIER_STATE_OUT_OF_GAME] = true
		end
	end
	
	return state
end


--------------------------------------------------------------------------------

function modifier_creature_ginger_rosh:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end