
local LION_BOT_STATE_IDLE					= 0
local LION_BOT_STATE_FINGER					= 1
local LION_BOT_STATE_BLINK					= 2

-----------------------------------------------------------------------------------------------------

if CRegenLionBot == nil then
	CRegenLionBot = class({})
end

function CRegenLionBot:constructor( me )
	self.me = me

	self.hAbilityFingerOfDeath = self.me:FindAbilityByName( "lion_finger_of_death" )

	local Heroes = FindUnitsInRadius( self.me:GetTeam(), self.me:GetOrigin(), self.me, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
	for _,hHero in pairs( Heroes ) do
		if hHero:GetUnitName() == "npc_dota_hero_viper" then
			self.hViper = hHero
		end
	end

	self.nBotState = LION_BOT_STATE_IDLE
end



function CRegenLionBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

function CRegenLionBot:BotThink()
	if not IsServer() then
		return
	end

	if not self.me:IsAlive() then
		return
	end

	if GameRules:IsGamePaused() then
		return
	end

	if self.nBotState == LION_BOT_STATE_IDLE then
        if self.bHasCast ~= true and self.hAbilityFingerOfDeath and self.hAbilityFingerOfDeath:IsFullyCastable() then
			self:ChangeBotState( LION_BOT_STATE_FINGER )
			return
        end

	elseif self.nBotState == LION_BOT_STATE_FINGER then
        if self.hAbilityFingerOfDeath == nil or self.hAbilityFingerOfDeath:IsNull() then
            self:ChangeBotState( LION_BOT_STATE_IDLE )
            return
        end

		if not self.hAbilityFingerOfDeath:IsFullyCastable() then
			self.bHasCast = true
            self:ChangeBotState( LION_BOT_STATE_BLINK )
            return
		end

		self.hViper:MakeVisibleToTeam( self.me:GetTeam(), 10.0 )

		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			AbilityIndex = self.hAbilityFingerOfDeath:entindex(),
			TargetIndex = self.hViper:entindex(),
		} )

	elseif self.nBotState == LION_BOT_STATE_BLINK then
		print( "BLINK" )
		local hBlinkDaggar = self.me:FindItemInInventory( "item_blink" )
		local hBlinkTarget = Entities:FindByName( nil, "enemy_blink_location" )
        if hBlinkDaggar == nil or hBlinkDaggar:IsNull() or hBlinkTarget == nil or (self.me:GetAbsOrigin() - hBlinkTarget:GetAbsOrigin()):Length2D() < 100 then
            UTIL_Remove( self.me )
            return
        end

		if not hBlinkDaggar:IsFullyCastable() then
			hBlinkDaggar:EndCooldown()
            return
		end

		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = hBlinkDaggar:entindex(),
			Position = hBlinkTarget:GetAbsOrigin(),
		} )
	end

end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "LinaThink", LinaThink, 0.25 )
		thisEntity.Bot = CRegenLionBot( thisEntity )
	end
end

function LinaThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.1
end
