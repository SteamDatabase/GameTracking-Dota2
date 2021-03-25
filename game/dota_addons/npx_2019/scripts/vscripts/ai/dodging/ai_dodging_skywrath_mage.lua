
local SKYWRATH_BOT_STATE_IDLE					= 0
local SKYWRATH_BOT_STATE_CAST_BOLT				= 1
local SKYWRATH_BOT_STATE_CAST_SEAL				= 2
local SKYWRATH_BOT_STATE_TP						= 3

-----------------------------------------------------------------------------------------------------

if CDodgingSkywrathBot == nil then
	CDodgingSkywrathBot = class({})
end

function CDodgingSkywrathBot:constructor( me )
	self.me = me

	self.hAbilityArcaneBolt = self.me:FindAbilityByName( "skywrath_mage_arcane_bolt" )
	self.hAbilityAncientSeal = self.me:FindAbilityByName( "skywrath_mage_ancient_seal" )
	self.nBotState = SKYWRATH_BOT_STATE_IDLE

	self.me:AddNewModifier(nil, nil, "modifier_fountain_aura_buff", {})
	self.bHasCastSeal = false
	self.LastBoltTime = GameRules:GetGameTime() - 10


	for _,hTower in ipairs( Entities:FindAllByClassname( "npc_dota_tower" ) ) do
		if hTower:GetTeam() == me:GetTeam() then
			self.hTpLocation = hTower
			break
		end
	end

	self.hTownPortalItem = nil

	self.hAbilityAncientSeal:SetLevel(4)
end


function CDodgingSkywrathBot:BotThink()


	if not IsServer() then
		return
	end

	if not self.me:IsAlive() then
		return
	end

	if GameRules:IsGamePaused() then
		return
	end

	if self.hTownPortalItem == nil then
		self.hTownPortalItem = self.me:FindItemInInventory( "item_tpscroll" )
		if self.hTownPortalItem then
			self.hTownPortalItem:EndCooldown()
		end
	end


	local hTask = GameRules.DotaNPX:GetTask( "dodge_all_bolts" )
	if hTask ~= nil and hTask:IsCompleted() == true then
		self.nBotState = SKYWRATH_BOT_STATE_TP
	end


	if self.nBotState == SKYWRATH_BOT_STATE_IDLE then

	local Heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.me:GetOrigin(), self.me, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )
		if #Heroes > 0 then
			self.hAttackTarget = Heroes[1]
			self.nBotState = SKYWRATH_BOT_STATE_CAST_SEAL
		else
			return 1
		end

	elseif self.nBotState == SKYWRATH_BOT_STATE_CAST_SEAL then

			if self.hAbilityAncientSeal ~= nil and self.hAbilityAncientSeal:GetLevel() > 0 and self.hAbilityAncientSeal:IsFullyCastable() and self.bHasCastSeal == false then
				ExecuteOrderFromTable( {
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					AbilityIndex = self.hAbilityAncientSeal:entindex(),
					TargetIndex = self.hAttackTarget:entindex(),
				} )
				self.bHasCastSeal = true
				self.hAbilityAncientSeal:RefundManaCost()
				self.nBotState = SKYWRATH_BOT_STATE_CAST_BOLT
			end

			return 0.2

	elseif self.nBotState == SKYWRATH_BOT_STATE_CAST_BOLT then

		if self.hAbilityArcaneBolt ~= nil and self.hAbilityArcaneBolt:IsFullyCastable() and GameRules:GetGameTime() >= self.LastBoltTime + 7.5 then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				AbilityIndex = self.hAbilityArcaneBolt:entindex(),
				TargetIndex = self.hAttackTarget:entindex(),
				Queue = false
			} )

			self.hAbilityArcaneBolt:RefundManaCost()
			self.LastBoltTime = GameRules:GetGameTime() 
		end
		return 0.5

	elseif self.nBotState == SKYWRATH_BOT_STATE_TP then
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hTownPortalItem:entindex(),
			Position = self.hTpLocation:GetAbsOrigin(),
		} )
		
		if self.hTownPortalItem and not self.hTownPortalItem:IsFullyCastable() and not self.hTownPortalItem:IsChanneling() then
			self.nBotState = SKYWRATH_BOT_STATE_IDLE
			return -1
		end
	end
	return 0.5
end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "DodgingSkywrathBotThink", DodgingSkywrathBotThink, 0.25 )

		thisEntity.Bot = CDodgingSkywrathBot( thisEntity )
	end
end

function DodgingSkywrathBotThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.1
end


