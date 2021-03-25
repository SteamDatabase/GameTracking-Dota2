
local NECROPHOS_BOT_STATE_INTRO					= 0
local NECROPHOS_BOT_STATE_IDLE					= 1
local NECROPHOS_BOT_STATE_ATTACK				= 2
local NECROPHOS_BOT_STATE_REAPERS_SCYTHE		= 3

-----------------------------------------------------------------------------------------------------

if CGlimmerCapeNecrophosBot == nil then
	CGlimmerCapeNecrophosBot = class({})
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeNecrophosBot:constructor( me )
	self.me = me
	self.hAbilityReapersScythe = self.me:FindAbilityByName( "necrolyte_reapers_scythe" )
	self.nBotState = NECROPHOS_BOT_STATE_INTRO
	self.hAttackTarget = nil
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeNecrophosBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeNecrophosBot:MoveToAttackPos()
	local hAttackPosition = Entities:FindByName( nil, "necrophos_attack_pos" )

	if hAttackPosition ~= nil then

		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = hAttackPosition:GetAbsOrigin(),
			Queue = false,
		} )

		self:ChangeBotState( NECROPHOS_BOT_STATE_IDLE )
	end
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeNecrophosBot:BotThink()

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

	print( 'NECROPHOS think - state is ' .. tonumber( self.nBotState ) )

	if self.nBotState == NECROPHOS_BOT_STATE_INTRO then

	elseif self.nBotState == NECROPHOS_BOT_STATE_IDLE then
		local hHero = self:FindBestTarget()
		if hHero ~= nil then
			self.hAttackTarget = hHero
			self:ChangeBotState( NECROPHOS_BOT_STATE_ATTACK )
		end

	elseif self.nBotState == NECROPHOS_BOT_STATE_ATTACK then

		if self.hAttackTarget == nil or self.hAttackTarget:IsNull() == true or self.hAttackTarget:IsAlive() == false then
			self:ChangeBotState( NECROPHOS_BOT_STATE_IDLE )
		end

		self:AttackTarget( self.hAttackTarget )
		print( 'ATTACKING TARGET! ' .. self.hAttackTarget:GetUnitName() )

		local hHero = self:FindBestTarget()
		if hHero == nil then
			self.hAttackTarget = nil
			self:ChangeBotState( NECROPHOS_BOT_STATE_IDLE )

		else
			self.hAttackTarget = hHero

			if self.hAbilityReapersScythe and self.hAbilityReapersScythe:IsFullyCastable() then
				self:ChangeBotState( NECROPHOS_BOT_STATE_REAPERS_SCYTHE )
			end
		end

	elseif self.nBotState == NECROPHOS_BOT_STATE_REAPERS_SCYTHE then

		if self.hAbilityReapersScythe == nil then
			self:ChangeBotState( NECROPHOS_BOT_STATE_IDLE )
		end
		
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			AbilityIndex = self.hAbilityReapersScythe:entindex(),
			TargetIndex = self.hAttackTarget:entindex(),
		} )
		
		if not self.hAbilityReapersScythe:IsFullyCastable() then
			self:ChangeBotState( NECROPHOS_BOT_STATE_ATTACK )
		end

	end
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeNecrophosBot:FindBestTarget()
	local szPrioritizedHeroName = "npc_dota_hero_sniper"

	local Heroes = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), self.me, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	if #Heroes > 0 then
		-- prioritize the proper hero
		for _,hHero in pairs( Heroes ) do
			if hHero:GetUnitName() == szPrioritizedHeroName then
				print( 'FOUND PRIORITIZED HERO ' .. szPrioritizedHeroName )
				return hHero
			end
		end

		-- attack first target in the list as a fallback
		print( 'PRIORITIZED HERO ' .. szPrioritizedHeroName .. ' NOT FOUND - ATTACKING ' .. Heroes[1]:GetUnitName() )
		return Heroes[1]
	end

	return nil
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeNecrophosBot:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
	} )

end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "NecrophosThink", NecrophosThink, 0.25 )
		thisEntity.Bot = CGlimmerCapeNecrophosBot( thisEntity )
	end
end

-----------------------------------------------------------------------------------------------------

function NecrophosThink()
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
