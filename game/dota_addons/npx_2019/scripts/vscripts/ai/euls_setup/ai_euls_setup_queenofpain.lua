
local QUEENOFPAIN_BOT_STATE_IDLE = 0
local QUEENOFPAIN_BOT_STATE_BLINK = 1
local QUEENOFPAIN_BOT_STATE_POST_BLINK = 2

-----------------------------------------------------------------------------------------------------

if CEulsSetupQueenOfPainBot == nil then
	CEulsSetupQueenOfPainBot = class({})
end

--------------------------------------------------------------------------------

function CEulsSetupQueenOfPainBot:constructor( me )
	self.me = me
	self.bHasBlinked = false
	self.hBlinkAbility = self.me:FindAbilityByName( "queenofpain_blink" )	
	self.nBotState = QUEENOFPAIN_BOT_STATE_IDLE

	self.hBountyRune = Entities:FindByClassname( nil, "dota_item_rune" )
	ScriptAssert( self.hBountyRune ~= nil, "self.hBountyRune is nil!" )

	self.hBlinkLoc = Entities:FindByName( nil, "blink_location" )
	ScriptAssert( self.hBlinkLoc ~= nil, "self.hBlinkLoc is nil!" )

	self.hEscapeLoc = Entities:FindByName( nil, "escape_location" )
	ScriptAssert( self.hBlinkLoc ~= nil, "self.hEscapeLoc is nil!" )

	self.me:SetHealth( self.me:GetMaxHealth() * 0.25 )

	self.nPlayerUsedAbilityListener = ListenToGameEvent( "dota_player_used_ability", Dynamic_Wrap( CEulsSetupQueenOfPainBot, "OnPlayerUsedAbility" ), self )

	LearnHeroAbilities( self.me, {} )

end

--------------------------------------------------------------------------------
function CEulsSetupQueenOfPainBot:OnPlayerUsedAbility( event )
	if event.PlayerID == nil then
		return
	end

	if  event.abilityname == "item_rod_of_atos" then
		-- Don't try to blink out of an atos
		--self:ChangeBotState( QUEENOFPAIN_BOT_STATE_BLINK )
		return
	end

	if self.bHasBlinked == false  then
		if  self.hBlinkLoc ~= nil and self.hBlinkAbility ~= nil then
			local vBlinkPos = self.hBlinkLoc:GetAbsOrigin()
			if self.hBlinkAbility:IsFullyCastable() then
				self.bHasBlinked = true
				ExecuteOrderFromTable({
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					Position = self.hBlinkLoc:GetAbsOrigin(),
					AbilityIndex = self.hBlinkAbility:entindex()
				})
			end
		end
	end
end

--------------------------------------------------------------------------------

function CEulsSetupQueenOfPainBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

--------------------------------------------------------------------------------

function CEulsSetupQueenOfPainBot:BotThink()
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

	if self.nBotState == QUEENOFPAIN_BOT_STATE_IDLE then
		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 850, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		if #Heroes > 0 then
			--self:ChangeBotState( QUEENOFPAIN_BOT_STATE_BLINK )
		end
	 	local vDirection = (self.hBlinkLoc:GetAbsOrigin() - self.me:GetAbsOrigin()):Normalized()

	 	local vMovePos = self.me:GetAbsOrigin() + vDirection * 10

		if not self.bInitialized then
			self.bInitialized = true

			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = vMovePos
			} )
		end
		return 0.1
	elseif self.nBotState == QUEENOFPAIN_BOT_STATE_BLINK then
		-- Try to cast blink towards a loc that helps me escape
		printf ("casting Blink")
		if self.hBlinkLoc ~= nil then
			local vBlinkPos = self.hBlinkLoc:GetAbsOrigin()


			if self.hBlinkAbility and self.hBlinkAbility:IsFullyCastable() then
				printf( "Cast blink on %s", vBlinkPos )
				ExecuteOrderFromTable({
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					Position = self.hBlinkLoc:GetAbsOrigin(),
					AbilityIndex = self.hBlinkAbility:entindex()
				})
			end

			if self.hBlinkAbility:IsCooldownReady() == false then
				self:ChangeBotState( QUEENOFPAIN_BOT_STATE_POST_BLINK )
				printf( "ChangingBotState to QUEENOFPAIN_BOT_STATE_POST_BLINK" )

			end
		end
	elseif self.nBotState == QUEENOFPAIN_BOT_STATE_POST_BLINK and self.hBountyRune ~= nil then
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_PICKUP_RUNE,
			TargetIndex = self.hBountyRune:entindex()
		} )
	end
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "EulsSetupQueenOfPainThink", EulsSetupQueenOfPainThink, 0.25 )

		thisEntity.Bot = CEulsSetupQueenOfPainBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function EulsSetupQueenOfPainThink()
	if IsServer() == false then
		return -1
	end
	local hBountyRune = Entities:FindByClassname( nil, "dota_item_rune" )
	if hBountyRune == nil then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.5 -- queenofpain_blink's castpoint is 0.33, this think was getting slammed to 0.1 and interrupting it
end

--------------------------------------------------------------------------------
