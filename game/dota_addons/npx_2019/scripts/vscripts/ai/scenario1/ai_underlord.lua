
local UNDERLORD_BOT_STATE_IDLE						= 0
local UNDERLORD_BOT_STATE_ATTACK					= 1
local UNDERLORD_BOT_STATE_FIRESTORM					= 2

-----------------------------------------------------------------------------------------------------

if CScenario1UnderlordBot == nil then
	CScenario1UnderlordBot = class({})
end

function CScenario1UnderlordBot:constructor( me )
	self.me = me
	self.hAbilityFirestorm = self.me:FindAbilityByName( "abyssal_underlord_firestorm" )	
	self.nBotState = UNDERLORD_BOT_STATE_IDLE
	self.hAttackTarget = nil
end



function CScenario1UnderlordBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

function CScenario1UnderlordBot:BotThink()

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

	if self.nBotState == UNDERLORD_BOT_STATE_IDLE then
	
		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		if #Heroes > 0 then
			self.hAttackTarget = Heroes[1]
			self:ChangeBotState( UNDERLORD_BOT_STATE_ATTACK )
		end
	
	elseif self.nBotState == UNDERLORD_BOT_STATE_ATTACK then
		
		if not self.hAttackTarget:IsAlive() then
			self:ChangeBotState( UNDERLORD_BOT_STATE_IDLE )
		end
		
		self:AttackTarget( self.hAttackTarget )			
		
		if self.hAbilityFirestorm and self.hAbilityFirestorm:IsFullyCastable() then
			local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
			if #Heroes > 0 then
				self:ChangeBotState( UNDERLORD_BOT_STATE_FIRESTORM )
			end
		end

	elseif self.nBotState == UNDERLORD_BOT_STATE_FIRESTORM then
		
		ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.hAbilityFirestorm:entindex(),
				Position = self.hAttackTarget:GetAbsOrigin(),
			} )
		
		if self.hAbilityFirestorm and not self.hAbilityFirestorm:IsFullyCastable() then
			self:ChangeBotState( UNDERLORD_BOT_STATE_ATTACK )
		end
	end
end

function CScenario1UnderlordBot:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
	} )

end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "Scenario1UnderlordThink", Scenario1UnderlordThink, 0.25 )

		thisEntity.Bot = CScenario1UnderlordBot( thisEntity )
		

	end
end

function Scenario1UnderlordThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.1
end


