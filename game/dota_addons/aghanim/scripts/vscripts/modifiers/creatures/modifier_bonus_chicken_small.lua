
require( "utility_functions" )

modifier_bonus_chicken_small = class({})

--------------------------------------------------------------------------------

function modifier_bonus_chicken_small:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_bonus_chicken_small:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_bonus_chicken_small:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

--------------------------------------------------------------------------------

function modifier_bonus_chicken_small:OnCreated( kv )
	self.base_status_resist = self:GetAbility():GetSpecialValueFor( "base_status_resist" )

	if IsServer() == false then
		return
	end

	self.total_gold = self:GetAbility():GetSpecialValueFor( "total_gold" )
	self.gold_per_bag = self:GetAbility():GetSpecialValueFor( "gold_per_bag" )
	self.bags_per_pop = self:GetAbility():GetSpecialValueFor( "bags_per_pop" )
	self.time_limit = self:GetAbility():GetSpecialValueFor( "time_limit" )
	self.gold_bag_duration = self:GetAbility():GetSpecialValueFor( "gold_bag_duration" )
	self.accumulated_dmg_per_pop = self:GetAbility():GetSpecialValueFor( "accumulated_dmg_per_pop" )

	--self.status_resist_duration = self:GetAbility():GetSpecialValueFor( "status_resist_duration" )
	--self.status_resist_max_stacks = self:GetAbility():GetSpecialValueFor( "status_resist_max_stacks" )
	self.think_interval = self:GetAbility():GetSpecialValueFor( "think_interval" )

	self.flAccumDamage = 0
	self.nBagsDropped = 0
	self.bTeleporting = false

	self.vCenter = Vector( 13407, 1820, 512 ) + RandomVector( RandomFloat( 0, 500 ) )
		
	ExecuteOrderFromTable({
	UnitIndex = self:GetParent():entindex(),
	OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
	Position = self.vCenter
	})

	self.flExpireTime = GameRules:GetGameTime() + self.time_limit

	self:StartIntervalThink( self.think_interval )
end

--------------------------------------------------------------------------------

function modifier_bonus_chicken_small:OnIntervalThink()
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

function modifier_bonus_chicken_small:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TELEPORTED,
		--MODIFIER_EVENT_ON_MODIFIER_ADDED,
		--MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_bonus_chicken_small:OnTakeDamage( params )
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

			if hAttacker:GetUnitName() == "npc_dota_creature_bonus_ogre_tank" then 
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hUnit:GetOrigin(), true )
				ParticleManager:SetParticleControl( nFXIndex, 1, hUnit:GetOrigin() )
				ParticleManager:SetParticleControlForward( nFXIndex, 1, -hAttacker:GetForwardVector() )
				ParticleManager:SetParticleControlEnt( nFXIndex, 10, hUnit, PATTACH_ABSORIGIN_FOLLOW, nil, hUnit:GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				EmitSoundOn( "Dungeon.BloodSplatterImpact", enemy )
			end

			if self.flAccumDamage >= self.accumulated_dmg_per_pop then
				--[[
				local hBuff = self:GetParent():FindModifierByName( "modifier_bonus_chicken_small_status_resist" )
				if hBuff == nil then
					local kv_resist = { duration = self.status_resist_duration, }
					printf( "self.status_resist_duration: %.1f", self.status_resist_duration )
					hBuff = self:GetParent():AddNewModifier( nil, self:GetAbility(), "modifier_bonus_chicken_small_status_resist", kv_resist )
				end

				if hBuff then
					hBuff:SetDuration( self.status_resist_duration, true ) -- poor man's bFixedDuration
					hBuff:IncrementStackCount()
				end
				]]

				local nAdjustedAmount = math.ceil( self.gold_per_bag * GameRules.Aghanim:GetGoldModifier() / 100 )

				for i= 1, self.bags_per_pop do
					local newItem = CreateItem( "item_bag_of_gold", nil, nil )
					newItem:SetPurchaseTime( 0 )
					newItem:SetCurrentCharges( nAdjustedAmount )

					local drop = CreateItemOnPositionSync( hUnit:GetAbsOrigin(), newItem )
					local dropTarget = FindPathablePositionNearby( hUnit:GetAbsOrigin(), 150, 300 )
					newItem:LaunchLoot( true, 300, 0.75, dropTarget )
					newItem:SetLifeTime( self.gold_bag_duration )

					self.flAccumDamage = self.flAccumDamage - self.accumulated_dmg_per_pop
					self.nBagsDropped = self.nBagsDropped + 1
					self.total_gold = self.total_gold - nAdjustedAmount

					if self.total_gold <= 0 then
						self:TeleportOut()
						--self:GetParent():ForceKill( false )
					end
				end
			end
		end
	end

	return 0
end

--------------------------------------------------------------------------------


function modifier_bonus_chicken_small:GetModifierMoveSpeed_Absolute( params )
	if IsServer() then
		return 350 + ( self.nBagsDropped * 20 )
	end

	return 350
end

--------------------------------------------------------------------------------

function modifier_bonus_chicken_small:GetMinHealth( params )
	return 1
end

--------------------------------------------------------------------------------

--[[
function modifier_bonus_chicken_small:OnModifierAdded( params )
	if not IsServer() then
		return
	end

	if params.unit ~= self:GetParent() then
		return
	end

	if params.added_buff:GetName() == "modifier_stunned" then
		printf( "modifier_bonus_chicken_small:OnModifierAdded - \"modifier_stunned\"" )
		local hBuff = self:GetParent():FindModifierByName( "modifier_bonus_chicken_small_status_resist" )
		if hBuff == nil then
			printf( "  hBuff == nil, so AddNewModifier" )
			local kv_resist = { duration = self.status_resist_duration, }
			--printf( "self.status_resist_duration: %.1f", self.status_resist_duration )
			hBuff = self:GetParent():AddNewModifier( nil, self:GetAbility(), "modifier_bonus_chicken_small_status_resist", kv_resist )
		end

		if hBuff then
			printf( "hBuff exists, doing SetDuration" )
			hBuff:SetDuration( self.status_resist_duration, true ) -- poor man's bFixedDuration

			if hBuff:GetStackCount() == self.status_resist_max_stacks then
				printf( "  purge" )
				self:GetParent():Purge( false, true, false, true, false )
			end

			hBuff:IncrementStackCount()
		end
	end
end
]]

--------------------------------------------------------------------------------

--[[
function modifier_bonus_chicken_small:GetModifierStatusResistanceStacking( params )
	local nStatusResist = 0

	if IsServer() then
		--printf( "---------------------" )
		--printf( "modifier_bonus_chicken_small:GetModifierStatusResistanceStacking" )

		nStatusResist = self.base_status_resist

		--printf( "  nStatusResist: %d", nStatusResist )
		--printf( "\n" )
	end

	return nStatusResist 
end
]]

--------------------------------------------------------------------------------

function modifier_bonus_chicken_small:TeleportOut()
	-- make sure we're not leashed by slark
	self:GetParent():RemoveModifierByName( "modifier_aghsfort_slark_pounce_leash" )

	local tower = Entities:FindByName( nil, "bonus_chicken_tp_target" )
	if tower == nil then
		self:GetParent():ForceKill( false )
		return
	end

	for i = 0, DOTA_ITEM_MAX - 1 do
		local item = self:GetParent():GetItemInSlot( i )
		if item then
			if item:GetAbilityName() == "item_tpscroll" then
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

function modifier_bonus_chicken_small:OnTeleported( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			self:GetParent():ForceKill( false )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_bonus_chicken_small:CheckState()
	local state = {}
	if IsServer()  then
		state =
		{
			--[MODIFIER_STATE_STUNNED] = false,
			[MODIFIER_STATE_ROOTED] = false,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
		}

		--[[
		local hBuff = self:GetParent():FindModifierByName( "modifier_bonus_chicken_small_status_resist" )
		if hBuff ~= nil then
			if hBuff:GetStackCount() == self.status_resist_max_stacks then
				printf( "become magic immune" )
				state[MODIFIER_STATE_MAGIC_IMMUNE] = true
			end
		end
		]]

		if GameRules:GetGameTime() > self.flExpireTime or self.total_gold <= 0 then
			state[MODIFIER_STATE_MAGIC_IMMUNE] = true
			state[MODIFIER_STATE_INVULNERABLE] = true
			state[MODIFIER_STATE_OUT_OF_GAME] = true
		end
	end
	
	return state
end

--------------------------------------------------------------------------------
