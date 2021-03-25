
local MIRANA_BOT_STATE_IDLE					= 0
local MIRANA_BOT_STATE_CAST_ARROW			= 1
local MIRANA_BOT_STATE_CAST_LEAP			= 2
local MIRANA_BOT_STATE_TP					= 3
local MIRANA_BOT_STATE_INACTIVE				= 4


-----------------------------------------------------------------------------------------------------

if CDodgingMiranaBot == nil then
	CDodgingMiranaBot = class({})
end

function CDodgingMiranaBot:constructor( me )
	self.me = me

	self.hAbilityArrow = self.me:FindAbilityByName( "mirana_arrow" )
	self.hAbilityLeap = self.me:FindAbilityByName( "mirana_leap" )

	self.hLeapLoc_1 = Entities:FindByName( nil, "enemy_spawn_location" )
	self.hLeapLoc_2 = Entities:FindByName( nil, "enemy_spawn_location_2" )
	self.hLeapLoc_3 = Entities:FindByName( nil, "enemy_spawn_location_3" )
	self.hLastLeapLoc = Entities:FindByName( nil, "enemy_spawn_location" )
	self.hFirstArrowLoc = Entities:FindByName( nil, "first_arrow_location" )
	self.nArrowsFired = 0
	self.nBotState = MIRANA_BOT_STATE_IDLE

	self.me:AddNewModifier(nil, nil, "modifier_fountain_aura_buff", {})



	for _,hTower in ipairs( Entities:FindAllByClassname( "ent_dota_fountain" ) ) do
		if hTower:GetTeam() == me:GetTeam() then
			self.hTpLocation = hTower
			break
		end
	end

	self.hTownPortalItem = nil

end


function CDodgingMiranaBot:BotThink()

	if not IsServer() then
		return
	end

	if not self.me:IsAlive() then
		return
	end

	if GameRules:IsGamePaused() then
		return
	end


	if self.nBotState == MIRANA_BOT_STATE_INACTIVE then
		print ("REEMOVING SEEELFS")
		self.me:RemoveSelf()
		return -1
	end


	if self.hTownPortalItem == nil then
		self.hTownPortalItem = self.me:FindItemInInventory( "item_tpscroll" )
		if self.hTownPortalItem then
			self.hTownPortalItem:EndCooldown()
		end
	end

	local hTask = GameRules.DotaNPX:GetTask( "dodge_all_arrows" )
	if hTask ~= nil and hTask:IsCompleted() == true then
		self.nBotState = MIRANA_BOT_STATE_TP
	end

	self.me:SetHealth( self.me:GetMaxHealth() )


	if self.nBotState == MIRANA_BOT_STATE_IDLE then

		local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )
		if #Heroes > 0 then
			self.hAttackTarget = Heroes[1]
			self.nBotState = MIRANA_BOT_STATE_CAST_ARROW
		else
			self.nBotState = MIRANA_BOT_STATE_IDLE
		end


	elseif self.nBotState == MIRANA_BOT_STATE_CAST_ARROW then
		self.hAbilityArrow:EndCooldown()		
		if self.hAbilityArrow ~= nil and self.hAbilityArrow:GetLevel() > 0 and self.hAbilityArrow:IsFullyCastable() then

			local TargetLoc = self.hAttackTarget:GetAbsOrigin()
			if self.nArrowsFired == 0 then 
				TargetLoc = self.hFirstArrowLoc:GetAbsOrigin() --// miss the first arrow
			end

				ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.hAbilityArrow:entindex(),
				Position = TargetLoc
			} )
			self.nArrowsFired = self.nArrowsFired + 1
			self.nBotState = MIRANA_BOT_STATE_CAST_LEAP
			self.hAbilityArrow:RefundManaCost()
		end

		return 2

	 elseif self.nBotState == MIRANA_BOT_STATE_CAST_LEAP then

	 	if self.hLastLeapLoc == self.hLeapLoc_2 or self.hLastLeapLoc == self.hLeapLoc_3 then
	 		self.hNextLeapLoc = self.hLeapLoc_1
	 	else 
	 		local i = RandomInt(1,2)
	 		if i == 1 then
		 		self.hNextLeapLoc = self.hLeapLoc_3
		 	else
		 		self.hNextLeapLoc = self.hLeapLoc_2
		 	end
	 	end

	 	local bHasCastLeap = false
	 	local vDirection = self.hNextLeapLoc:GetAbsOrigin() - self.me:GetAbsOrigin()

	 	self.me:SetForwardVector(vDirection)
	 	self.hAbilityLeap:EndCooldown()
	 	self.hAbilityLeap:RefreshCharges()

		if self.hAbilityLeap and self.hAbilityLeap:IsFullyCastable() and bHasCastLeap == false then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.hAbilityLeap:entindex()
			} )
			self.nBotState = MIRANA_BOT_STATE_CAST_ARROW
		end
		self.hAbilityLeap:RefundManaCost()
		self.hLastLeapLoc = self.hNextLeapLoc

		return 1
	elseif self.nBotState == MIRANA_BOT_STATE_TP then
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hTownPortalItem:entindex(),
			Position = self.hTpLocation:GetAbsOrigin(),
		} )
		
		if self.hTownPortalItem and not self.hTownPortalItem:IsFullyCastable() and not self.hTownPortalItem:IsChanneling() then
			self.nBotState = MIRANA_BOT_STATE_INACTIVE
			return -1
		end
	end
	return 1
end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "CDodgingMiranaBotThink", CDodgingMiranaBotThink, 1 )

		thisEntity.Bot = CDodgingMiranaBot( thisEntity )
	end
end

function CDodgingMiranaBotThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 1
end


