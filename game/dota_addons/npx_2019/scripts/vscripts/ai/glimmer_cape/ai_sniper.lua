local SNIPER_BOT_STATE_INTRO				= 1
local SNIPER_BOT_STATE_IDLE					= 2
local SNIPER_BOT_STATE_ATTACK				= 3

-----------------------------------------------------------------------------------------------------

if CGlimmerCapeSniperBot == nil then
	CGlimmerCapeSniperBot = class({})
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeSniperBot:constructor( me )
	self.me = me
	self.nBotState = SNIPER_BOT_STATE_INTRO
	self.hAttackTarget = nil

	self.bReapersScythed = false

	-- turn off regen until we get hit by the scythe
	self.me:AddNewModifier( self.me, nil, "modifier_disable_healing", { duration = -1 } )	
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeSniperBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeSniperBot:BotThink()

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

	if self.bReapersScythed == false then
		local hScythMod = self.me:FindModifierByName( "modifier_necrolyte_reapers_scythe" )
		if hScythMod then
			self.bReapersScythed = true
			-- turn healing back on after we eat the scythe so that we can satanic back up
			self.me:RemoveModifierByName( "modifier_disable_healing" )
		end
	end
	
	if self.nBotState == SNIPER_BOT_STATE_INTRO then

		local hMovePos = Entities:FindByName( nil, "sniper_move_pos" )
		if hMovePos ~= nil then

			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = hMovePos:GetAbsOrigin(),
				Queue = false,
			} )

			self:ChangeBotState( SNIPER_BOT_STATE_IDLE )
		end

	elseif self.nBotState == SNIPER_BOT_STATE_IDLE then

		local hHero = self:FindSpecificTarget()
		if hHero ~= nil then
			self.hAttackTarget = hHero
			self:ChangeBotState( SNIPER_BOT_STATE_ATTACK )
		end
	
	elseif self.nBotState == SNIPER_BOT_STATE_ATTACK then

		if self.hAttackTarget == nil or self.hAttackTarget:IsNull() == true or self.hAttackTarget:IsAlive() == false then		
			self.hAttackTarget = nil
			self:ChangeBotState( SNIPER_BOT_STATE_IDLE )
		end

		self:AttackTarget( self.hAttackTarget )

		if self.bReapersScythed == true then
			local hItemSatanic = FindItemByName( self.me, "item_satanic" )
			if hItemSatanic == nil then
				print( 'ERROR - Sniper missing his satanic' )
			end

			if hItemSatanic and hItemSatanic:IsFullyCastable() then
				ExecuteOrderFromTable( {
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = hItemSatanic:entindex(),
				} )
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeSniperBot:AttackTarget( hTarget )
	if hTarget == nil then
		return
	end
	
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
	} )

end

-----------------------------------------------------------------------------------------------------

function CGlimmerCapeSniperBot:FindSpecificTarget()
	local szPrioritizedHeroName = "npc_dota_hero_necrolyte"

	local Heroes = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), self.me, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	if #Heroes > 0 then
		print( 'SNIPER BOT - found ' .. #Heroes )
		-- prioritize the proper hero
		for _,hHero in pairs( Heroes ) do
			print( 'HERO NAME = ' .. hHero:GetUnitName() .. ' prioritized hero name is ' .. szPrioritizedHeroName )
			if hHero:GetUnitName() == szPrioritizedHeroName then
				print( 'FOUND PRIORITIZED HERO ' .. szPrioritizedHeroName )
				return hHero
			end
		end
	end

	return nil
end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "SniperThink", SniperThink, 0.25 )
		thisEntity.Bot = CGlimmerCapeSniperBot( thisEntity )
	end
end

-----------------------------------------------------------------------------------------------------

function SniperThink()
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
