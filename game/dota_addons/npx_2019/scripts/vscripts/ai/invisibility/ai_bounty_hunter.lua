
local BOUNTY_HUNTER_BOT_STATE_INTRO					= 0
local BOUNTY_HUNTER_BOT_STATE_IDLE					= 1
local BOUNTY_HUNTER_BOT_STATE_FLEE					= 2
local BOUNTY_HUNTER_BOT_STATE_SHADOW_WALK_WANDER	= 3

-----------------------------------------------------------------------------------------------------

if CInvisibilityBountyHunterBot == nil then
	CInvisibilityBountyHunterBot = class({})
end

-----------------------------------------------------------------------------------------------------

function CInvisibilityBountyHunterBot:constructor( me )
	self.me = me
	self.hAbilityShadowWalk = self.me:FindAbilityByName( "bounty_hunter_wind_walk" )
	self.nBotState = BOUNTY_HUNTER_BOT_STATE_INTRO
	self.hAttackTarget = nil
end

-----------------------------------------------------------------------------------------------------

function CInvisibilityBountyHunterBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

-----------------------------------------------------------------------------------------------------

function CInvisibilityBountyHunterBot:BotThink()

	if not IsServer() then
		return
	end
	if self.bWasKilled then
		return -1
	end
	if ( not self.me:IsAlive() ) then
		self.bWasKilled = true
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if self.nBotState == BOUNTY_HUNTER_BOT_STATE_INTRO then

		local hIntroLocation = Entities:FindByName( nil, "bounty_hunter_intro_pos" )
		if hIntroLocation ~= nil then

			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = hIntroLocation:GetAbsOrigin(),
				Queue = false,
			} )

			self:ChangeBotState( BOUNTY_HUNTER_BOT_STATE_IDLE )
		end

	elseif self.nBotState == BOUNTY_HUNTER_BOT_STATE_IDLE then

		-- if we're dusted then run away
		local hDust = self.me:FindModifierByName( "modifier_item_dustofappearance" )
		if hDust ~= nil then
			local hFleeLocation = Entities:FindByName( nil, "bounty_hunter_flee_pos" )
			if hFleeLocation ~= nil then

				ExecuteOrderFromTable( {
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
					Position = hFleeLocation:GetAbsOrigin(),
					Queue = false,
				} )

				self:ChangeBotState( BOUNTY_HUNTER_BOT_STATE_FLEE )
			end
			return
		end

		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		if #Heroes > 0 then
			self.hAttackTarget = Heroes[1]
			self:ChangeBotState( BOUNTY_HUNTER_BOT_STATE_SHADOW_WALK_WANDER )
		end
	
	elseif self.nBotState == BOUNTY_HUNTER_BOT_STATE_SHADOW_WALK_WANDER then

		-- if we're dusted then run away
		local hDust = self.me:FindModifierByName( "modifier_item_dustofappearance" )
		if hDust ~= nil then
			local hFleeLocation = Entities:FindByName( nil, "bounty_hunter_flee_pos" )
			if hFleeLocation ~= nil then

				ExecuteOrderFromTable( {
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
					Position = hFleeLocation:GetAbsOrigin(),
					Queue = false,
				} )

				self:ChangeBotState( BOUNTY_HUNTER_BOT_STATE_FLEE )
			end
			return
		end

		-- continually reapply shadow walk
		if self.hAbilityShadowWalk:IsFullyCastable() then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.hAbilityShadowWalk:entindex(),
			} )
		end

	elseif self.nBotState == BOUNTY_HUNTER_BOT_STATE_FLEE then
		
		-- fail the task if the bounty hunter makes it to his destination
		local hFleeLocation = Entities:FindByName( nil, "bounty_hunter_flee_pos" )
		if hFleeLocation ~= nil then
			local fDistanceToGoal = ( self.me:GetAbsOrigin() - hFleeLocation:GetAbsOrigin() ):Length2D()
			if fDistanceToGoal < 400 then
				local hTask = GameRules.DotaNPX:GetTask( "kill_bounty_hunter" )
				if hTask ~= nil and hTask:IsCompleted() == false then
					hTask:CompleteTask( false, false, "scenario_invisibility_failure_bounty_escaped" )
				end
			end
		end

	end
end

-----------------------------------------------------------------------------------------------------

function CInvisibilityBountyHunterBot:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
	} )

end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "BountyHunterThink", BountyHunterThink, 0.25 )
		thisEntity.Bot = CInvisibilityBountyHunterBot( thisEntity )
	end
end

-----------------------------------------------------------------------------------------------------

function BountyHunterThink()
	if IsServer() == false then
		return -1
	end

	local fThinkTime = thisEntity.Bot:BotThink()
	if fThinkTime then
		return fThinkTime
	end

	return 0.1
end

-----------------------------------------------------------------------------------------------------

function FindItemByName( hUnit, strItemName )
	for iSlot = DOTA_ITEM_SLOT_1,DOTA_ITEM_MAX do
		local hItem = hUnit:GetItemInSlot( iSlot )
		if hItem and hItem:GetAbilityName() == strItemName then
			return hItem
		end
	end
end
