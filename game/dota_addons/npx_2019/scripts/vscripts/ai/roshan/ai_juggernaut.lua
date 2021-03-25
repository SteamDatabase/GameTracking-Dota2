
local JUGGERNAUT_BOT_STATE_INTRO				= 0
local JUGGERNAUT_BOT_STATE_IDLE					= 1
local JUGGERNAUT_BOT_STATE_ATTACK				= 2
local JUGGERNAUT_BOT_STATE_OMNISLASH			= 3

-----------------------------------------------------------------------------------------------------

if CRoshanJuggernautBot == nil then
	CRoshanJuggernautBot = class({})
end

-----------------------------------------------------------------------------------------------------

function CRoshanJuggernautBot:constructor( me )
	self.me = me
	self.hAbilityOmnislash = self.me:FindAbilityByName( "juggernaut_omni_slash" )
	if self.hAbilityOmnislash == nil then
		print( 'JUGG BOT - failed to find omnislash!' )
	end
	self.nBotState = JUGGERNAUT_BOT_STATE_INTRO
	self.hAttackTarget = nil
end

-----------------------------------------------------------------------------------------------------

function CRoshanJuggernautBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

-----------------------------------------------------------------------------------------------------

function CRoshanJuggernautBot:BotThink()

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

	if self.nBotState == JUGGERNAUT_BOT_STATE_INTRO then

		local hAttackPosition = Entities:FindByName( nil, "juggernaut_attack_pos" )
		if hAttackPosition ~= nil then

			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = hAttackPosition:GetAbsOrigin(),
				Queue = false,
			} )

			self:ChangeBotState( JUGGERNAUT_BOT_STATE_IDLE )
		end
	
	elseif self.nBotState == JUGGERNAUT_BOT_STATE_IDLE then
		local hHero = self:FindBestTarget()
		if hHero ~= nil then
			self.hAttackTarget = hHero
			self:ChangeBotState( JUGGERNAUT_BOT_STATE_ATTACK )
		end

	elseif self.nBotState == JUGGERNAUT_BOT_STATE_ATTACK then

		if self.hAttackTarget == nil or self.hAttackTarget:IsAlive() == false then
			self:ChangeBotState( JUGGERNAUT_BOT_STATE_IDLE )
		end

		print( 'JUGG BOT - ATTACKING TARGET! ' .. self.hAttackTarget:GetUnitName() )
		self:AttackTarget( self.hAttackTarget )

		local hHero = self:FindBestTarget()
		if hHero ~= nil then
			self.hAttackTarget = hHero

			print( 'JUGG BOT - Checking omnislash for castability - ' .. tostring( self.hAbilityOmnislash:IsFullyCastable() ) )
			if self.hAbilityOmnislash and self.hAbilityOmnislash:IsFullyCastable() then
				print('JUGG BOT - going for omni')
				self:ChangeBotState( JUGGERNAUT_BOT_STATE_OMNISLASH )
			end
		end

	elseif self.nBotState == JUGGERNAUT_BOT_STATE_OMNISLASH then

		if self.hAbilityOmnislash == nil then
			print('JUGG BOT - omni is nil!')
			self:ChangeBotState( JUGGERNAUT_BOT_STATE_IDLE )
		end

		print( 'JUGG BOT - omni on ' .. self.hAttackTarget:GetUnitName() )

		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			AbilityIndex = self.hAbilityOmnislash:entindex(),
			TargetIndex = self.hAttackTarget:entindex(),
		} )
		
		if not self.hAbilityOmnislash:IsFullyCastable() then
			self:ChangeBotState( JUGGERNAUT_BOT_STATE_ATTACK )
		end

	end
end

-----------------------------------------------------------------------------------------------------

function CRoshanJuggernautBot:FindBestTarget()
	local Heroes = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), self.me, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	if #Heroes > 0 then
		-- prioritize ursa
		for _,hHero in pairs( Heroes ) do
			if hHero:GetUnitName() == "npc_dota_hero_ursa" then
				print( 'JUGG BOT - FOUND URSA')
				return hHero
			end
		end

		-- attack first target in the list as a fallback
		print( 'JUGG BOT - NO URSA FOUND - ATTACKING ' .. Heroes[1]:GetUnitName() )
		return Heroes[1]
	end

	return nil
end
-----------------------------------------------------------------------------------------------------

function CRoshanJuggernautBot:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
	} )

end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "JuggernautThink", JuggernautThink, 0.25 )
		thisEntity.Bot = CRoshanJuggernautBot( thisEntity )
	end
end

-----------------------------------------------------------------------------------------------------

function JuggernautThink()
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
