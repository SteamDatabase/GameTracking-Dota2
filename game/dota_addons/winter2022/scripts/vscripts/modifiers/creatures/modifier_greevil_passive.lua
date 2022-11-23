
require( "winter2022_utility_functions" )

modifier_greevil_passive = class({})

LinkLuaModifier("modifier_greevil_has_no_candy", "modifiers/creatures/modifier_greevil_has_no_candy", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function modifier_greevil_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_greevil_passive:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_greevil_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

--------------------------------------------------------------------------------

function modifier_greevil_passive:OnCreated( kv )
	self.nBagsDropped = 0

	if IsServer() == false then
		return
	end

	self:SetHasCustomTransmitterData( true )

	self.base_status_resist = self:GetAbility():GetSpecialValueFor( "base_status_resist" )
	self.accumulated_dmg_per_pop = self:GetAbility():GetSpecialValueFor( "accumulated_dmg_per_pop" )
	self.dmg_threshold_increase_per_min = self:GetAbility():GetSpecialValueFor( "dmg_threshold_increase_per_min" )
	self.drop_candy_to_attacker = self:GetAbility():GetSpecialValueFor( "drop_candy_to_attacker" )
	self.move_speed_per_drop = self:GetAbility():GetSpecialValueFor( "move_speed_per_drop" )
	self.dmg_threshold_growth_factor = self:GetAbility():GetSpecialValueFor( "dmg_threshold_growth_factor" )
	self.dmg_intake_multiplier = self:GetAbility():GetSpecialValueFor( "dmg_intake_multiplier" )

	local health_pct_per_min = self:GetAbility():GetSpecialValueFor( "health_pct_per_min" )
	local armor_per_min = self:GetAbility():GetSpecialValueFor( "armor_per_min" )
	local kv =
	{
		damage_buff_pct = 0,
		hp_buff_pct = math.floor( (GameRules:GetGameTime() / 60) * health_pct_per_min ),
		model_scale = 0,
		armor_buff = math.floor( (GameRules:GetGameTime() / 60) * armor_per_min ),
	}
	--print( 'GREEVIL BUFF STATS:' )
	--PrintTable( kv )
	self:GetParent():AddNewModifier( nil, nil, "modifier_creature_buff", kv )

	local fGameTime = GameRules:GetGameTime()
	self.flAdjustedDmgPerPop = self.accumulated_dmg_per_pop + ( math.pow( ( fGameTime / 60 ) * self.dmg_threshold_increase_per_min, self.dmg_threshold_growth_factor ) )
	--print( '^GREEVIL - ADJUSTED DMG PER POP = ' .. self.flAdjustedDmgPerPop )
	self.flAccumDamage = 0

	self.vCenter = self:GetParent():GetAbsOrigin()
	--self.vCenter = Vector( 13407, 1820, 512 ) + RandomVector( RandomFloat( 0, 500 ) )

	ExecuteOrderFromTable({
		UnitIndex = self:GetParent():entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.vCenter
	})
end

--------------------------------------------------------------------------------

function modifier_greevil_passive:AddCustomTransmitterData( )
	return
	{
		move_speed_per_drop = self.move_speed_per_drop,
		nBagsDropped = self.nBagsDropped,
	}
end

--------------------------------------------------------------------------------

function modifier_greevil_passive:HandleCustomTransmitterData( data )
	self.move_speed_per_drop = data.move_speed_per_drop
	self.nBagsDropped = data.nBagsDropped
end


--------------------------------------------------------------------------------

function modifier_greevil_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_greevil_passive:OnTakeDamage( params )
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

			self.flAccumDamage = self.flAccumDamage + ( flDamage * self.dmg_intake_multiplier )
			--print( 'GREEVIL - TAKING ' .. flDamage .. '. Total damage so far = ' .. self.flAccumDamage )

			if self.flAccumDamage >= self.flAdjustedDmgPerPop then
				--[[
				local hBuff = self:GetParent():FindModifierByName( "modifier_greevil_passive_status_resist" )
				if hBuff == nil then
					local kv_resist = { duration = self.status_resist_duration, }
					printf( "self.status_resist_duration: %.1f", self.status_resist_duration )
					hBuff = self:GetParent():AddNewModifier( nil, self:GetAbility(), "modifier_greevil_passive_status_resist", kv_resist )
				end

				if hBuff then
					hBuff:SetDuration( self.status_resist_duration, true ) -- poor man's bFixedDuration
					hBuff:IncrementStackCount()
				end
				]]

				local nCandyToDrop = math.floor( self.flAccumDamage / self.flAdjustedDmgPerPop )
				if self:GetParent():HasModifier("modifier_greevil_has_no_candy") then nCandyToDrop = 0 end
				--print( 'GREEVIL - going to drop candy = ' .. nCandyToDrop )
				self.flAccumDamage = self.flAccumDamage - ( nCandyToDrop * self.flAdjustedDmgPerPop )
				--print( 'GREEVIL - new damage accumulation = ' .. self.flAccumDamage )

				GameRules.Winter2022.SignOutTable["stats"].CandyCounts.generated = GameRules.Winter2022.SignOutTable["stats"].CandyCounts.generated + nCandyToDrop

				if hAttacker ~= nil and not hAttacker:IsNull() and hAttacker:IsOwnedByAnyPlayer() then
					GameRules.Winter2022:GrantEventAction( hAttacker:GetPlayerOwnerID(), "winter2022_hit_greevils_for_candy", nCandyToDrop )
				end

				while nCandyToDrop > 0 do
					local bBigBag = false
					if nCandyToDrop >= _G._G.WINTER2022_CANDY_COUNT_IN_CANDY_BAG then
						bBigBag = true
						nCandyToDrop = nCandyToDrop - _G._G.WINTER2022_CANDY_COUNT_IN_CANDY_BAG
						self.nBagsDropped = self.nBagsDropped + _G._G.WINTER2022_CANDY_COUNT_IN_CANDY_BAG
					else
						nCandyToDrop = nCandyToDrop - 1
						self.nBagsDropped = self.nBagsDropped + 1
					end

					if self.drop_candy_to_attacker == 1 then
						GameRules.Winter2022:DropCandyAtPosition( self:GetParent():GetAbsOrigin(), self:GetParent(), hAttacker, bBigBag, 1.0 )
					else
						GameRules.Winter2022:DropCandyAtPosition( self:GetParent():GetAbsOrigin(), self:GetParent(), nil, bBigBag, 1.0 )
					end
				end
				self:SendBuffRefreshToClients()
			end
		end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_greevil_passive:GetModifierMoveSpeedBonus_Constant( params )
	--if IsServer() then
	--	print( 'SERVER - BAGS DROPPED = ' .. self.nBagsDropped )
	--	print( 'SERVER - SPEED PER = ' .. self.move_speed_per_drop )
	--else
	--	print( 'CLIENT - BAGS DROPPED = ' .. self.nBagsDropped )
	--	print( 'CLIENT - SPEED PER = ' .. self.move_speed_per_drop )
	--end
	--print( 'SPEED BONUS = ' .. self.nBagsDropped * self.move_speed_per_drop )
	return self.nBagsDropped * self.move_speed_per_drop
end

--------------------------------------------------------------------------------

function modifier_greevil_passive:GetModifierIgnoreMovespeedLimit( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_greevil_passive:GetMinHealth( params )
	if IsServer() then
		if self:GetParent():GetUnitName() == "npc_dota_greevil" then
			return 0
		end

		return self:GetParent():GetMaxHealth()
	end
	return 250
end

--------------------------------------------------------------------------------

function modifier_greevil_passive:GetModifierExtraHealthPercentage( params )
	--return math.floor( self:GetBuffLevel() * 100 )
	return 100
end

--------------------------------------------------------------------------------

function modifier_greevil_passive:GetModifierProvidesFOWVision( params )
	if params.target ~= nil and ( params.target:GetTeamNumber() == DOTA_TEAM_GOODGUYS or params.target:GetTeamNumber() == DOTA_TEAM_BADGUYS or params.target:GetTeamNumber() == DOTA_TEAM_CUSTOM_1 ) then
		return 1
	end
	return 0
end

--------------------------------------------------------------------------------

function modifier_greevil_passive:CheckState()
	local state = {}
	if IsServer()  then
		state =
		{
			--[MODIFIER_STATE_STUNNED] = false,
			--[MODIFIER_STATE_ROOTED] = false,
			[MODIFIER_STATE_DISARMED] = true,
			--[MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
		}

		if self:GetParent():GetForceAttackTarget() ~= nil then
			--print( 'GREEVIL IS TAUNTED! UN-DISARMING!' )
			state[MODIFIER_STATE_DISARMED] = false
		end
	end
	
	return state
end

--------------------------------------------------------------------------------
