
modifier_living_treasure = class({})

--------------------------------------------------------------------------------

function modifier_living_treasure:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_living_treasure:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_living_treasure:OnCreated( kv )
	--print( "modifier_living_treasure OnCreated" )

	--[[
	local szModelName = "models/courier/beetlejaws/mesh/beetlejaws.vmdl" --self:GetParent():GetModelName()
	DoEntFire( szModelName, "SetAnimation", "beetlejaws_ground_spawn", 0, self:GetParent(), self:GetParent() )
	]]

	--self.total_gold = self:GetAbility():GetSpecialValueFor( "total_gold" ) -- doesn't work
	self.total_gold = 8000
	--self.time_limit = self:GetAbility():GetSpecialValueFor( "time_limit" ) -- doesn't work
	self.time_limit = 60.0
	--print( string.format( "self.total_gold: %f, self.time_limit: %f", self.total_gold, self.time_limit ) )

	if IsServer() then
		self:GetParent():SetTeam( DOTA_TEAM_BADGUYS )
		--self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_living_treasure_anim_chest", {} )

		self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_provide_vision", { duration = -1 } )

		self.flAccumDamage = 0
		self.nBagsDropped = 0
		self.bTeleporting = false
		self.vCenter = Vector( 7554, 5520, 423 )

		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = self.vCenter
			})

		self.flExpireTime = GameRules:GetGameTime() + self.time_limit
		self:StartIntervalThink( 3.0 )
	end

	self.bInitialized = true
end

--------------------------------------------------------------------------------

function modifier_living_treasure:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TELEPORTED,
	}

	return funcs
end

function modifier_living_treasure:OnIntervalThink()
	if IsServer() then
		if not self.bTeleporting then
			ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = self.vCenter + RandomVector( 3500 )
			})
		end

		if GameRules:GetGameTime() > self.flExpireTime then
			print( "modifier_living_treasure:OnIntervalThink - Out of time, ForceKill. Gold remaining: " .. self.total_gold )
			self:GetParent():ForceKill( false )
			--self:TeleportOut()
			self:StartIntervalThink( -1 )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_living_treasure:OnTakeDamage( params )
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

				-- Gold amt correlates with dmg done
				local fFuzzyDamage = RandomFloat( flDamage * 0.9, flDamage * 1.1 )
				local nGoldAmount = math.max( 100, ( fFuzzyDamage * 0.5 ) )
				newItem:SetPurchaseTime( 0 )
				newItem:SetCurrentCharges( nGoldAmount )
					
				local drop = CreateItemOnPositionSync( hUnit:GetAbsOrigin(), newItem )
				local dropTarget = hUnit:GetAbsOrigin() + RandomVector( RandomFloat( 50, 250 ) )
				newItem:LaunchLoot( true, 300, 0.75, dropTarget )

				self.flAccumDamage = self.flAccumDamage - 100
				self.nBagsDropped = self.nBagsDropped + 1
				self.total_gold = self.total_gold - nGoldAmount
				if self.total_gold <= 0 then
					print( "modifier_living_treasure:OnIntervalThink - Out of gold, ForceKill" )
					self:GetParent():ForceKill( false )
					--self:TeleportOut()
					self:StartIntervalThink( -1 )
				end
			end
		end
	end

	return 0
end

--------------------------------------------------------------------------------

--[[
function modifier_living_treasure:TeleportOut()
	local tower = Entities:FindByNameNearest( "dota_badguys_tower1_bot", self:GetParent():GetOrigin(), 99999 )
	if tower ~= nil then
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
			else
				FindClearSpaceForUnit( self:GetParent(), tower:GetOrigin(), true )
				self:GetParent():ForceKill( false )
			end
		end
	end
end
]]

--------------------------------------------------------------------------------

function modifier_living_treasure:OnTeleported( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			self:GetParent():ForceKill( false )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_living_treasure:GetModifierMoveSpeed_Absolute( params )
	if IsServer() then
		--local bonus_speed_per_bag = self:GetAbility():GetSpecialValueFor( "bonus_speed_per_bag" ) -- doesn't work
		local bonus_speed_per_bag = 5
		return self:GetParent():GetBaseMoveSpeed() + ( self.nBagsDropped * bonus_speed_per_bag )
	end
	return self:GetParent():GetBaseMoveSpeed()
end

--------------------------------------------------------------------------------

function modifier_living_treasure:GetMinHealth( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_living_treasure:CheckState()
	local state = {}
	if IsServer()  then
		state =
		{
			[MODIFIER_STATE_STUNNED] = false,
			[MODIFIER_STATE_ROOTED] = false,
		}
		if self.bInitialized then
			--print( string.format( "GameRules:GetGameTime() == %f, self.flExpireTime == %f, self.total_gold == %f", GameRules:GetGameTime(), self.flExpireTime, self.total_gold ) )
			if GameRules:GetGameTime() > self.flExpireTime or self.total_gold <= 0 then
				state[MODIFIER_STATE_MAGIC_IMMUNE] = true
				state[MODIFIER_STATE_INVULNERABLE] = true
				state[MODIFIER_STATE_OUT_OF_GAME] = true
			end
		end
	end
	
	return state
end


--------------------------------------------------------------------------------

function modifier_living_treasure:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end