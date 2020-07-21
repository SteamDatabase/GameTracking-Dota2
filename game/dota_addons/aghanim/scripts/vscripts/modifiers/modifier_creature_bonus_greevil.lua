modifier_creature_bonus_greevil = class({})

--------------------------------------------------------------------------------

function modifier_creature_bonus_greevil:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_greevil:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_greevil:OnCreated( kv )
	self.total_gold = self:GetAbility():GetSpecialValueFor( "total_gold" )
	self.time_limit = self:GetAbility():GetSpecialValueFor( "time_limit" )
	self.gold_bag_duration = self:GetAbility():GetSpecialValueFor( "gold_bag_duration" )
	if IsServer() then
		self.flAccumDamage = 0
		self.nBagsDropped = 0
		self.bTeleporting = false
		self.vCenter = GameRules.Aghanim:GetCurrentRoom():GetOrigin() + RandomVector( RandomFloat( 0, 500 ) )
		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = self.vCenter
			})

		self.flExpireTime = GameRules:GetGameTime() + self.time_limit
		self:StartIntervalThink( 3.0 )
	end
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_greevil:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TELEPORTED,
	}

	return funcs
end

function modifier_creature_bonus_greevil:OnIntervalThink()
	if not IsServer() then
		return
	end

	if self.bTeleporting == true then
		return
	end

	if GameRules:GetGameTime() > self.flExpireTime then
		self:TeleportOut()
		return
	end

	ExecuteOrderFromTable({
		UnitIndex = self:GetParent():entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = FindPathablePositionNearby( self.vCenter, 500, 2500 )
		})	

end

--------------------------------------------------------------------------------

function modifier_creature_bonus_greevil:OnTakeDamage( params )
	if IsServer() then
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
			self.flAccumDamage = self.flAccumDamage + flDamage
			if self.flAccumDamage >= 100 then
				local newItem = CreateItem( "item_bag_of_gold", nil, nil )
				local nGoldAmount = 44
				newItem:SetPurchaseTime( 0 )
				newItem:SetCurrentCharges( nGoldAmount )
					
				local drop = CreateItemOnPositionSync( hUnit:GetAbsOrigin(), newItem )
				local dropTarget = FindPathablePositionNearby( hUnit:GetAbsOrigin(), 50, 250 )
				newItem:LaunchLoot( true, 300, 0.75, dropTarget )
				newItem:SetLifeTime( self.gold_bag_duration )

				self.flAccumDamage = self.flAccumDamage - 100
				self.nBagsDropped = self.nBagsDropped + 1
				self.total_gold = self.total_gold - 20
				if self.total_gold <= 0 then
					self:TeleportOut()
				end
			end
		end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_greevil:TeleportOut()
	local tower = Entities:FindByName( nil, "bonus_chicken_tp_target" )
	if tower == nil then
		self:GetParent():ForceKill( false )
		return
	end

	for i = 0, DOTA_ITEM_MAX - 1 do
		local item = self:GetParent():GetItemInSlot( i )
		if item then
			if item:GetAbilityName() == "item_travel_boots" then
				ExecuteOrderFromTable({
					UnitIndex = self:GetParent():entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					AbilityIndex = item:entindex(),
					TargetIndex = tower:entindex()
				})
				self.bTeleporting = true
				return
			end
		end
	end

	FindClearSpaceForUnit( self:GetParent(), tower:GetOrigin(), true )
	self:GetParent():ForceKill( false )

end

--------------------------------------------------------------------------------

function modifier_creature_bonus_greevil:OnTeleported( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			self:GetParent():ForceKill( false )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_greevil:GetModifierMoveSpeed_Absolute( params )
	if IsServer() then
		return 500 + ( self.nBagsDropped * 10 )
	end
	return 500
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_greevil:GetMinHealth( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_greevil:CheckState()
	local state = {}
	if IsServer()  then
		state =
		{
			[MODIFIER_STATE_STUNNED] = false,
			[MODIFIER_STATE_ROOTED] = false,
		}
		if GameRules:GetGameTime() > self.flExpireTime or self.total_gold <= 0 then
			state[MODIFIER_STATE_MAGIC_IMMUNE] = true
			state[MODIFIER_STATE_INVULNERABLE] = true
			state[MODIFIER_STATE_OUT_OF_GAME] = true
		end
	end
	
	return state
end


--------------------------------------------------------------------------------

function modifier_creature_bonus_greevil:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end