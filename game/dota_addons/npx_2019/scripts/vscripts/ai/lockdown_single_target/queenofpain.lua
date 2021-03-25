
local QUEENOFPAIN_BOT_STATE_IDLE = 0
local QUEENOFPAIN_BOT_STATE_MOVE_TO_RUNE = 1
local QUEENOFPAIN_BOT_STATE_BLINK = 2
local QUEENOFPAIN_BOT_STATE_RUN_AWAY = 3

-----------------------------------------------------------------------------------------------------

if CLockdownScenarioQueenOfPainBot == nil then
	CLockdownScenarioQueenOfPainBot = class({})
end

--------------------------------------------------------------------------------

function CLockdownScenarioQueenOfPainBot:constructor( me )
	self.me = me
	self.hBlinkAbility = self.me:FindAbilityByName( "queenofpain_blink" )	
	self.nBotState = QUEENOFPAIN_BOT_STATE_IDLE

	self.hBlinkLoc = Entities:FindByName( nil, "blink_location" )
	ScriptAssert( self.hBlinkLoc ~= nil, "self.hBlinkLoc is nil!" )

	self.hEscapeLoc = Entities:FindByName( nil, "escape_location" )
	ScriptAssert( self.hEscapeLoc ~= nil, "self.hEscapeLoc is nil!" )

	self.me:AddNewModifier( self.me, nil, "modifier_disable_healing", { duration = -1 } )
	--self.me:SetHealth( self.me:GetMaxHealth() * 0.35 )

	-- Why isn't the scenario doing all this?
	for i = 1, 3 do
		if self.me:GetAbilityPoints() > 0 then
			local hAbility = self.me:FindAbilityByName( "queenofpain_blink" )
			if hAbility ~= nil then
				self.me:UpgradeAbility( hAbility )
			else
				printf( "Failed to find ability %s to upgrade it", hAbility:GetAbilityName() )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CLockdownScenarioQueenOfPainBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

--------------------------------------------------------------------------------

function CLockdownScenarioQueenOfPainBot:BotThink()
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

	if not self.bHealthInitialized then
		self.bHealthInitialized = true

		self.me:SetHealth( self.me:GetMaxHealth() * 0.75 )
	end

	if self.nBotState == QUEENOFPAIN_BOT_STATE_IDLE then
		if GameRules.DotaNPX:IsTaskComplete( "moving_past_drow" ) then
			self:ChangeBotState( QUEENOFPAIN_BOT_STATE_MOVE_TO_RUNE )

			return 0.01
		end

		if self.fTimeSectionStarted == nil then
			self.fTimeSectionStarted = GameRules:GetGameTime()
		end

		if self.fTimeSectionStarted ~= nil then
			local fGracePeriodForPlayer = 3.0
			if ( GameRules:GetGameTime() > ( self.fTimeSectionStarted + fGracePeriodForPlayer ) ) then
				self:ChangeBotState( QUEENOFPAIN_BOT_STATE_MOVE_TO_RUNE )

				return 0.1
			end

			return 0.1
		end

		return 0.25
	elseif self.nBotState == QUEENOFPAIN_BOT_STATE_MOVE_TO_RUNE then
		if not self.bRuneCommandGiven then
			self.bRuneCommandGiven = true

			local hBountyRune = Entities:FindByClassname( nil, "dota_item_rune" )
			if hBountyRune then
				printf( "QoP is moving to %s at %s", tostring( hBountyRune ), hBountyRune:GetAbsOrigin() )
				ExecuteOrderFromTable( {
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_PICKUP_RUNE,
					TargetIndex = hBountyRune:entindex()
				} )
			else
				-- Backup plan is just go to bounty rune's location (player could've picked up rune before chaining into next task in expected way)
				local hBountyRuneLoc = Entities:FindByName( nil, "bounty_rune_location" )
				if hBountyRuneLoc then
					ExecuteOrderFromTable( {
						UnitIndex = self.me:entindex(),
						OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
						Position = hBountyRuneLoc:GetAbsOrigin(),
						Queue = true,
					} )
				end
			end

			return 0.25
		end

		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		if #Heroes > 0 then
			self:ChangeBotState( QUEENOFPAIN_BOT_STATE_BLINK )

			return 0.75
		end

		return 0.5
	elseif self.nBotState == QUEENOFPAIN_BOT_STATE_BLINK then
		-- Try to cast blink towards a loc that helps me escape
		if self.hBlinkAbility:IsCooldownReady() then
			local vBlinkPos = self.hBlinkLoc:GetAbsOrigin()
			printf( "Cast blink on %s", vBlinkPos )
			self.me:CastAbilityOnPosition( self.hBlinkLoc:GetAbsOrigin(), self.hBlinkAbility, -1 )

			return 1.0
		else
			self:ChangeBotState( QUEENOFPAIN_BOT_STATE_RUN_AWAY )

			return 0.5
		end

		return 0.5
	elseif self.nBotState == QUEENOFPAIN_BOT_STATE_RUN_AWAY then
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = self.hEscapeLoc:GetAbsOrigin(),
			Queue = true,
		} )

		return 0.5
	end

	return 0.5
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "LockdownScenarioQueenOfPainThink", LockdownScenarioQueenOfPainThink, 0.25 )

		thisEntity.Bot = CLockdownScenarioQueenOfPainBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function LockdownScenarioQueenOfPainThink()
	if IsServer() == false then
		return -1
	end

	return thisEntity.Bot:BotThink()
end

--------------------------------------------------------------------------------
