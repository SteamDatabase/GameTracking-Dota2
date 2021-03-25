
-----------------------------------------------------------------------------------------------------

if CStackingScenarioAlchemistBot == nil then
	CStackingScenarioAlchemistBot = class({})
end

--------------------------------------------------------------------------------

function CStackingScenarioAlchemistBot:constructor( me )
	self.me = me
	self.bMovedToStart = false
	self.hAbilityAcidSpray = self.me:FindAbilityByName( "alchemist_acid_spray" )
	self.hAttackTarget = nil
	self.nIdleCounter = 0
	self.nRetreatTime = 30
	self.hInitialMoveLoc = Entities:FindByName( nil, "neutral_location_1" )

	printf( "alchemistBot::constructor" )
end

--------------------------------------------------------------------------------

function CStackingScenarioAlchemistBot:BotThink()
	--print( "Thinking" )
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


	local Creeps = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self.me:GetOrigin(), self.me, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )
	if #Creeps > 0 then
		self.hAttackTarget = Creeps[1]
		self:AttackTarget( self.hAttackTarget )
	else
		--print("No heroes found")
		self.nIdleCounter = self.nIdleCounter + 1
		if self.bMovedToStart == false then
			self:MoveToStart()
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "AlchemistThink", AlchemistThink, 0.25 )

		thisEntity.Bot = CStackingScenarioAlchemistBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function AlchemistThink()
	if IsServer() == false then
		return -1
	end

	return thisEntity.Bot:BotThink()
end

--------------------------------------------------------------------------------

function CStackingScenarioAlchemistBot:AttackTarget( hTarget )
	if self.hAbilityAcidSpray and self.hAbilityAcidSpray:IsFullyCastable() then
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hAbilityAcidSpray:entindex(),
			Position = self.hInitialMoveLoc:GetAbsOrigin(),
		} )
	else
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = hTarget:entindex(),
		} )
	end
end

--------------------------------------------------------------------------------

function CStackingScenarioAlchemistBot:MoveToStart()
	self.bMovedToStart = true
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.hInitialMoveLoc:GetAbsOrigin(),
		Queue = true,
	} )
end

--------------------------------------------------------------------------------
