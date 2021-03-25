
local SF_BOT_STATE_IDLE							= 0
local SF_BOT_STATE_ATTACK						= 1
local SF_BOT_STATE_REQUIEM						= 2

-----------------------------------------------------------------------------------------------------

if CSvenScenarioShadowFiendBot == nil then
	CSvenScenarioShadowFiendBot = class({})
end

function CSvenScenarioShadowFiendBot:constructor( me )
	self.me = me
	self.hAbilityRequiem = self.me:FindAbilityByName( "nevermore_requiem" )
	self.hAbilityNecromastery = self.me:FindAbilityByName( "nevermore_requiem" )
	self.nBotState = SF_BOT_STATE_IDLE
	self.hAttackTarget = nil
end



function CSvenScenarioShadowFiendBot:ChangeBotState( nNewState )
	-- print( "Mirana changing from state " .. self.nBotState .. " to " .. nNewState )
	self.nBotState = nNewState
end

function CSvenScenarioShadowFiendBot:BotThink()

	if self.nBotState == SF_BOT_STATE_IDLE then
		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		if #Heroes > 0 then
			self.hAttackTarget = Heroes[1]
			self:ChangeBotState( SF_BOT_STATE_ATTACK )
		end
		local hBuff = self.me:FindModifierByName( "modifier_nevermore_necromastery" )
		if hBuff and hBuff:GetStackCount() < 15 then
			hBuff:SetStackCount(15)			
		end
	elseif self.nBotState == SF_BOT_STATE_ATTACK then
		if not self.hAttackTarget:IsAlive() then
			self:ChangeBotState( SF_BOT_STATE_IDLE )
		end
		self:AttackTarget( self.hAttackTarget )			
		if self.hAbilityRequiem and self.hAbilityRequiem:IsFullyCastable() then
			local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
			if #Heroes > 0 then
				self:ChangeBotState( SF_BOT_STATE_REQUIEM )
			end
		end
	elseif self.nBotState == SF_BOT_STATE_REQUIEM then
		ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.hAbilityRequiem:entindex()
			} )
		if self.hAbilityRequiem and not self.hAbilityRequiem:IsFullyCastable() then
			self:ChangeBotState( SF_BOT_STATE_ATTACK )
		else
			local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
			if #Heroes == 0 then
				ExecuteOrderFromTable( {
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_STOP,
				} )
				self:ChangeBotState( SF_BOT_STATE_ATTACK )
			end
		end
	end
end

function CSvenScenarioShadowFiendBot:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
	} )

end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "SvenScenarioShadowFiendThink", SvenScenarioShadowFiendThink, 0.25 )

		thisEntity.Bot = CSvenScenarioShadowFiendBot( thisEntity )
		

	end
end

function SvenScenarioShadowFiendThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.1
end


