modifier_creature_bonus_pig = class({})

--------------------------------------------------------------------------------

function modifier_creature_bonus_pig:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_pig:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_pig:OnCreated( kv )
	if IsServer() == false then
		return
	end

	self.total_gold = self:GetAbility():GetSpecialValueFor( "total_gold" )
	self.time_limit = self:GetAbility():GetSpecialValueFor( "time_limit" )
	self.gold_bag_duration = self:GetAbility():GetSpecialValueFor( "gold_bag_duration" )
	self.damage_counter_duration = self:GetAbility():GetSpecialValueFor( "damage_counter_duration" )
	
	self.flAccumDamage = 0
	self.nBagsDropped = 0
	self.bTeleporting = false
	local roomCenter = Entities:FindAllByName( "room_center" )
	if #roomCenter > 0 then
		local hRoomCenter = roomCenter[1]
		self.vCenter = hRoomCenter:GetAbsOrigin() + RandomVector( RandomFloat( 0, 500 ) )
		ExecuteOrderFromTable({
		UnitIndex = self:GetParent():entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.vCenter
		})
	end		

	self.flExpireTime = GameRules:GetGameTime() + self.time_limit
	self:StartIntervalThink( 0.25 )

	-- Add the damage counter
	local kv = { duration = -1 } -- self.damage_counter_duration
	self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_bonus_pig_damage_counter", kv )
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_pig:DeclareFunctions()
	local funcs = 
	{
		--MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TELEPORTED,
	}

	return funcs
end

function modifier_creature_bonus_pig:OnIntervalThink()
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

	local roomCenter = Entities:FindAllByName( "room_center" )
	if #roomCenter > 0 then
		self:StartIntervalThink(5.0)
		local nRandomTarget = RandomInt( 1, #roomCenter )
		local hRoomCenter = roomCenter[nRandomTarget]
		self.vCenter = hRoomCenter:GetAbsOrigin() + RandomVector( RandomFloat( 0, 500 ) )
		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = FindPathablePositionNearby( self.vCenter, 500, 2500 )
			})	
	end

end

--------------------------------------------------------------------------------
-- (unused for now) --
function modifier_creature_bonus_pig:OnTakeDamage( params )
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
			if self.flAccumDamage >= 150 then
				--[[
				local newItem = CreateItem( "item_bag_of_gold", nil, nil )
				local nGoldAmount = 20
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
				]]
			end
		end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_pig:TeleportOut()
	-- make sure we're not leashed by slark
	self:GetParent():RemoveModifierByName( "modifier_aghsfort_slark_pounce_leash" )
	-- add no cc so we don't get stunned
	self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_absolute_no_cc", { duration = -1 } )

	local tower = Entities:FindByName( nil, "bonus_tp_target" )
	if tower == nil then
		print( "Tower is nil" )
		self:GetParent():ForceKill( false )
		return
	end

	print( "Tower classname = " .. tower:GetClassname() )
	for i = 0, DOTA_ITEM_MAX - 1 do
		local item = self:GetParent():GetItemInSlot( i )
		if item then
			if item:GetAbilityName() == "item_tpscroll" then
				print( "Executing TP")
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

function modifier_creature_bonus_pig:OnTeleported( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			self:GetParent():ForceKill( false )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_pig:GetModifierMoveSpeed_Absolute( params )
	if IsServer() then
		return 500 + ( self:GetParent().nBagsDropped * 10 )
	end
	return 500
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_pig:GetMinHealth( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_pig:CheckState()
	local state = {}
	if IsServer()  then
		state =
		{
			[MODIFIER_STATE_STUNNED] = false,
			[MODIFIER_STATE_ROOTED] = false,
			[MODIFIER_STATE_FEARED] = false,
			[MODIFIER_STATE_TAUNTED] = false,
			[MODIFIER_STATE_HEXED] = false,
			[MODIFIER_STATE_SILENCED] = false,
			[MODIFIER_STATE_FROZEN] = false,
			[MODIFIER_STATE_DISARMED] = false,
		}

		if GameRules:GetGameTime() > self.flExpireTime or self.total_gold <= 0 then
			state[MODIFIER_STATE_MAGIC_IMMUNE] = true
			state[MODIFIER_STATE_INVULNERABLE] = true
			state[MODIFIER_STATE_OUT_OF_GAME] = true
			state[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true
		end

	end
	
	return state
end


--------------------------------------------------------------------------------

function modifier_creature_bonus_pig:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end