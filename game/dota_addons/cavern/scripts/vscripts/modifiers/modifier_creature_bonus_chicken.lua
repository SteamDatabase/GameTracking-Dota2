modifier_creature_bonus_chicken = class({})

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:OnCreated( kv )
	self.total_bags = self:GetAbility():GetSpecialValueFor( "total_bags" )
	self.gold_per_bag = self:GetAbility():GetSpecialValueFor( "gold_per_bag" )
	self.dmg_per_bag = self:GetAbility():GetSpecialValueFor( "dmg_per_bag" )	

	if IsServer() then
		self.flAccumDamage = 0
		self.nBagsDropped = 0
		self.bTeleporting = false
		self:GetParent():SetContextThink( GetEncounterContext("ChickenMod"), function() return self:OnThink() end, 0.0 )
		--self:StartIntervalThink( 3 )
		--MoveOrder( self:GetParent(), self:GetParent():GetAbsOrigin() + RandomVector( 2500 ) )

	end
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TELEPORTED,
	}

	return funcs
end

function modifier_creature_bonus_chicken:OnThink()
	if IsServer() then
		if not self.bTeleporting then	

			if RandomFloat(0, 1) < 0.10 then
				EmitSoundOn("Cavern.ChickenAmbient", self:GetParent())
			end

			MoveOrder( self:GetParent(), self:GetParent():GetAbsOrigin() + RandomVector( 2500 ) )
		end

		if self.nBagsDropped >= self.total_bags then
			self:TeleportOut()
		end
	end
	return RandomFloat(2.5,3.5)
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:OnDeath( params )
	if IsServer() then
		StopSoundOn("Cavern.ChickenAmbient", self:GetParent())
		StopSoundOn("Cavern.ChickenDamage", self:GetParent())
	end
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:OnTakeDamage( params )
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
			if self.flAccumDamage >= self.dmg_per_bag then
				LaunchGoldBag(self.gold_per_bag, hUnit:GetAbsOrigin(), hUnit:GetAbsOrigin() + RandomVector( RandomFloat( 50, 250 ) ) )
				self.flAccumDamage = self.flAccumDamage - self.dmg_per_bag
				self.nBagsDropped = self.nBagsDropped + 1

				EmitSoundOn("Cavern.ChickenDamage", self:GetParent())

				if self.nBagsDropped >= self.total_bags then
					self:TeleportOut()
				end
			end
		end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:TeleportOut()

	--print("chicken teleporting out!")
	self:GetParent():ForceKill( false )

	--[[
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
			self:GetParent():ForceKill( false )
		end
	end--]]
	
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:OnTeleported( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			self:GetParent():ForceKill( false )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:GetModifierMoveSpeed_Absolute( params )
	if IsServer() then
		return 550 + ( self.nBagsDropped * 50 )
	end
	return 550
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:GetMinHealth( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:CheckState()
	local state = {}
	if IsServer()  then
		state =
		{
			[MODIFIER_STATE_STUNNED] = false,
			[MODIFIER_STATE_ROOTED] = false,
		}
		if self.nBagsDropped >= self.total_bags then
			state[MODIFIER_STATE_MAGIC_IMMUNE] = true
			state[MODIFIER_STATE_INVULNERABLE] = true
			state[MODIFIER_STATE_OUT_OF_GAME] = true
		end
	end
	
	return state
end


--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end