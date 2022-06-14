
local SVEN_BOT_STATE_IDLE						= 0
local SVEN_BOT_STATE_ATTACK						= 1
local SVEN_BOT_STATE_TP							= 2 

-----------------------------------------------------------------------------------------------------

if CStatusEffectsSvenBot == nil then
	CStatusEffectsSvenBot = class({})
end

function CStatusEffectsSvenBot:constructor( me )
	self.me = me

	self.nBotState = SVEN_BOT_STATE_IDLE
	self.hAttackTarget = nil

	for _,hTower in ipairs( Entities:FindAllByClassname( "ent_dota_fountain" ) ) do
		if hTower:GetTeam() == me:GetTeam() then
			self.hTpLocation = hTower
			break
		end
	end

	self.hTownPortalItem = nil

end

-----------------------------------------------------------------------------------------------------

function CStatusEffectsSvenBot:StartAI()
	if self.nBotState ~= SVEN_BOT_STATE_IDLE then
		return
	end

	self.nBotState = SVEN_BOT_STATE_ATTACK
end

-----------------------------------------------------------------------------------------------------

function CStatusEffectsSvenBot:FindBestTarget()
	local Heroes = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), self.me, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	if #Heroes > 0 then
		for _,hHero in pairs( Heroes ) do
			if hHero:GetUnitName() == "npc_dota_hero_dark_seer" then
				self.hAttackTarget = hHero
				return
			end
		end
	end
	return nil
end

function CStatusEffectsSvenBot:BotThink()
	if not self.me:IsAlive() then
		return
	end
	if self.nBotState == SVEN_BOT_STATE_INACTIVE then
			if self.hAttackTarget ~= nil then
				UTIL_Remove(self.hAttackTarget )
			end
			self.me:RemoveSelf()
		return -1
	elseif self.nBotState == SVEN_BOT_STATE_IDLE then
		self.nBotState =  SVEN_BOT_STATE_ATTACK 
	end


	if self.hTownPortalItem == nil then
		self.hTownPortalItem = self.me:FindItemInInventory( "item_tpscroll" )
		if self.hTownPortalItem then
			self.hTownPortalItem:EndCooldown()
		end
	end

	if self.hAttackTarget == nil then
		self:FindBestTarget()
	end

	if self.nBotState == SVEN_BOT_STATE_ATTACK then

		if not self.hAttackTarget:IsAlive() then
			self.nBotState = SVEN_BOT_STATE_TP 
			return
		else 		

			if self.hAttackTarget == nil then
				self:FindBestTarget()
			end

	  		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = self.hAttackTarget:entindex()
			} )
			return
	  	end
	end

	if self.nBotState == SVEN_BOT_STATE_TP then
		if self.hTownPortalItem ~= nil and self.hTownPortalItem:IsNull() == false then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.hTownPortalItem:entindex(),
				Position = self.hTpLocation:GetAbsOrigin(),
			} )
		end
		
		if self.hTownPortalItem and self.hTownPortalItem:IsNull() == false and not self.hTownPortalItem:IsFullyCastable() and not self.hTownPortalItem:IsChanneling() then
			self.nBotState = SVEN_BOT_STATE_INACTIVE	
			return -1
		end
	end
end

function CStatusEffectsSvenBot:MoveToLocation( vPos )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vPos,
		Queue = true,
	} )
end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "StatusEffectsSvenBot", StatusEffectsSvenBot, 0.5 )
		thisEntity.Bot = CStatusEffectsSvenBot( thisEntity )
	end
end

function StatusEffectsSvenBot()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.5
end


