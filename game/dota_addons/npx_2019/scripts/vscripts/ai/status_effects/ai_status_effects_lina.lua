
local LINA_BOT_STATE_IDLE						= 0
local LINA_BOT_STATE_CAST_SPELLS				= 1
local LINA_BOT_STATE_TP							= 2 

-----------------------------------------------------------------------------------------------------

if CStatusEffectsLinaBot == nil then
	CStatusEffectsLinaBot = class({})
end

function CStatusEffectsLinaBot:constructor( me )
	self.me = me

	self.hAbilityLagunaBlade = self.me:FindAbilityByName( "lina_laguna_blade" )
	self.hAbilityLSA = self.me:FindAbilityByName( "lina_light_strike_array" )
	self.hAbilityDragonSlave = self.me:FindAbilityByName( "lina_dragon_slave" )
	self.bActivated = false

	self.nBotState = LINA_BOT_STATE_IDLE
	self.hAttackTarget = nil

	for _,hTower in ipairs( Entities:FindAllByClassname( "ent_dota_fountain" ) ) do
		if hTower:GetTeam() == me:GetTeam() then
			self.hTpLocation = hTower
			break
		end
	end

	self.hTownPortalItem = nil


end

-----------------------------------------------------------------------------------------------------

function CStatusEffectsLinaBot:StartAI()
	if self.nBotState ~= LINA_BOT_STATE_IDLE then
		return
	end

	self:ChangeBotState( LINA_BOT_STATE_CAST_SPELLS )
end

-----------------------------------------------------------------------------------------------------

function CStatusEffectsLinaBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

-----------------------------------------------------------------------------------------------------

function CStatusEffectsLinaBot:FindBestTarget()
	local Heroes = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), self.me, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	if #Heroes > 0 then
		-- prioritize ursa
		for _,hHero in pairs( Heroes ) do
			if hHero:GetUnitName() == "npc_dota_hero_shadow_shaman" then
				self.hAttackTarget = hHero
				return
			end
		end
	end
	return nil
end

function CStatusEffectsLinaBot:BotThink()

	if not self.me:IsAlive() then
		return
	end

	if self.nBotState == LINA_BOT_STATE_INACTIVE then
		if self.hAttackTarget ~= nil then
			UTIL_Remove(self.hAttackTarget )
		end
			self.me:RemoveSelf()
		return -1
	end

	if self.hTownPortalItem == nil then
		self.hTownPortalItem = self.me:FindItemInInventory( "item_tpscroll" )
		if self.hTownPortalItem then
			self.hTownPortalItem:EndCooldown()
		end
	end

	self.me:SetHealth( self.me:GetMaxHealth() )

	if self.hAttackTarget == nil then
		self:FindBestTarget()
	end

	if self.hAttackTarget ~= nil and self.hAttackTarget:FindModifierByName("modifier_bashed") ~= nil and self.bActivated == false then
		self.bActivated = true
		self:ChangeBotState( LINA_BOT_STATE_CAST_SPELLS )
	end

	if self.nBotState == LINA_BOT_STATE_CAST_SPELLS then

		if self.hAttackTarget ~= nil and not self.hAttackTarget:IsAlive() then
			self:ChangeBotState( LINA_BOT_STATE_TP )	
			return
		end
		if self.hAbilityLSA ~= nil  and self.hAbilityLSA:IsFullyCastable() == true then

			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.hAbilityLSA:entindex(),
				Position = self.hAttackTarget:GetAbsOrigin()
			} )
			return 1.0
		elseif self.hAbilityDragonSlave ~= nil and self.hAbilityDragonSlave:IsFullyCastable() == true then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.hAbilityDragonSlave:entindex(),
				Position = self.hAttackTarget:GetAbsOrigin()
			} )
			return 1.0
		
		elseif self.hAbilityLagunaBlade ~= nil and self.hAbilityLagunaBlade:IsFullyCastable() == true then
				ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				AbilityIndex = self.hAbilityLagunaBlade:entindex(),
				TargetIndex = self.hAttackTarget:entindex()
			} )
			return 1.0
		else 			
		  		ExecuteOrderFromTable( {
				  UnitIndex = self.me:entindex(),
				  OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = self.hAttackTarget:entindex()
			} )
		end
	end

	if self.nBotState == LINA_BOT_STATE_TP then
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hTownPortalItem:entindex(),
			Position = self.hTpLocation:GetAbsOrigin(),
		} )
		
		if self.hTownPortalItem and not self.hTownPortalItem:IsFullyCastable() and not self.hTownPortalItem:IsChanneling() then
			self.nBotState = LINA_BOT_STATE_INACTIVE
			return -1
		end
	end


end

function CStatusEffectsLinaBot:MoveToLocation( vPos )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vPos,
		Queue = true,
	} )
end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "StatusEffectsLinaBot", StatusEffectsLinaBot, 0.5 )

		thisEntity.Bot = CStatusEffectsLinaBot( thisEntity )
	end
end

function StatusEffectsLinaBot()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.5
end


