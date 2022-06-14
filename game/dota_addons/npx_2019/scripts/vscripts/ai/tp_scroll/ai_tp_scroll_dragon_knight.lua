
local DK_BOT_STATE_IDLE					= 0
local DK_BOT_STATE_ATTACK				= 1
local DK_BOT_STATE_FIRE					= 2
local DK_BOT_STATE_STUN					= 3
local DK_BOT_STATE_TP					= 4

-----------------------------------------------------------------------------------------------------

if CTPScrollDragonKnightBot == nil then
	CTPScrollDragonKnightBot = class({})
end

function CTPScrollDragonKnightBot:constructor( me )
	self.me = me

	self.hAbilityFire = self.me:FindAbilityByName( "dragon_knight_breathe_fire" )
	self.hAbilityStun = self.me:FindAbilityByName( "dragon_knight_dragon_tail" )
	
	for _,hTower in ipairs( Entities:FindAllByClassname( "npc_dota_tower" ) ) do
		if hTower:GetTeam() == me:GetTeam() then
			self.hTpLocation = hTower
			break
		end
	end

	self.nBotState = DK_BOT_STATE_IDLE
	self.hAttackTarget = nil
	self.hTownPortalItem = nil

	self.hOnTakeDamageEvent = ListenToGameEvent( "entity_hurt", Dynamic_Wrap( CTPScrollDragonKnightBot, "OnTakeDamage" ), self )
end

function CTPScrollDragonKnightBot:OnRemove()
	if self.hOnTakeDamageEvent then
		StopListeningToGameEvent( self.hOnTakeDamageEvent )
	end
end

function CTPScrollDragonKnightBot:OnTakeDamage( event )
	if not event.entindex_killed or not event.entindex_attacker then
		return -- This happens on restart
	end

	local hTarget = EntIndexToHScript( event.entindex_killed )
	local hAttacker = EntIndexToHScript( event.entindex_attacker )
	if hTarget and hTarget == self.me and hAttacker and hAttacker:IsHero() and self.hTownPortalItem and self.hTownPortalItem:IsFullyCastable() then
		self:ChangeBotState( DK_BOT_STATE_TP )
		StopListeningToGameEvent( self.hOnTakeDamageEvent )
		self.hOnTakeDamageEvent = nil
	end
end

function CTPScrollDragonKnightBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

function CTPScrollDragonKnightBot:BotThink()
	if not IsServer() then
		return
	end

	if not self.me:IsAlive() then
		return
	end

	if GameRules:IsGamePaused() then
		return
	end

	if self.hTownPortalItem == nil then
		self.hTownPortalItem = self.me:FindItemInInventory( "item_tpscroll" )
		if self.hTownPortalItem then
			self.hTownPortalItem:EndCooldown()
		end
	end

	if self.nBotState == DK_BOT_STATE_IDLE then
		local rgTargets = {}
		if self.hTownPortalItem and self.hTownPortalItem:IsFullyCastable() then
			rgTargets = FindUnitsInRadius( self.me:GetTeam(), self.me:GetOrigin(), self.me, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )
		else
			rgTargets = FindUnitsInRadius( self.me:GetTeam(), self.me:GetOrigin(), self.me, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )
		end
		if #rgTargets > 0 then
			self.hAttackTarget = rgTargets[1]
			self:ChangeBotState( DK_BOT_STATE_ATTACK )
		end
	
	elseif self.nBotState == DK_BOT_STATE_ATTACK then	
		if not self.hAttackTarget:IsAlive() or not IsLocationVisible( self.me:GetTeam(), self.hAttackTarget:GetAbsOrigin() ) then
			self.me:Stop()
			self:ChangeBotState( DK_BOT_STATE_IDLE )
			return
		end
		
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = self.hAttackTarget:entindex(),
		} )

	elseif self.nBotState == DK_BOT_STATE_STUN then
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			AbilityIndex = self.hAbilityStun:entindex(),
			TargetIndex = self.hAttackTarget:entindex(),
		} )
		
		if self.hAbilityStun and not self.hAbilityStun:IsFullyCastable() then
			self:ChangeBotState( DK_BOT_STATE_IDLE )
		end

	elseif self.nBotState == DK_BOT_STATE_FIRE then
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			AbilityIndex = self.hAbilityFire:entindex(),
			TargetIndex = self.hAttackTarget:entindex(),
		} )
		
		if self.hAbilityFire and not self.hAbilityFire:IsFullyCastable() then
			self:ChangeBotState( DK_BOT_STATE_IDLE )
		end

	elseif self.nBotState == DK_BOT_STATE_TP then
		if self.hTownPortalItem and self.hTownPortalItem:IsNull() == false then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.hTownPortalItem:entindex(),
				Position = self.hTpLocation:GetAbsOrigin(),
			} )
		end

		if self.hTownPortalItem and self.hTownPortalItem:IsNull() == false and not self.hTownPortalItem:IsFullyCastable() and not self.hTownPortalItem:IsChanneling() then
			self:ChangeBotState( DK_BOT_STATE_IDLE )
		end
	end

end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "DragonKnightThink", DragonKnightThink, 0.25 )
		thisEntity.Bot = CTPScrollDragonKnightBot( thisEntity )
	end
end

function DragonKnightThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.1
end

function UpdateOnRemove()
	thisEntity.Bot:OnRemove()
end
