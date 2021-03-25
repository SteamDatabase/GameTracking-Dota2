
local OGRE_BOT_STATE_IDLE					= 0
local OGRE_BOT_STATE_MOVE			= 1
local OGRE_BOT_STATE_INACTIVE					= 2


-----------------------------------------------------------------------------------------------------

if CEulsSetupOgreBot == nil then
	CEulsSetupOgreBot = class({})
end

function CEulsSetupOgreBot:constructor( me )
	self.me = me


	self.hMoveLoc1 = Entities:FindByName( nil, "enemy_waypoint_1" )
	self.hMoveLoc2 = Entities:FindByName( nil, "enemy_waypoint_2" )
	self.hLastMoveLoc = self.hMoveLoc1
	self.me:AddNewModifier(nil, nil, "modifier_fountain_aura_buff", {})

		self.nBotState = OGRE_BOT_STATE_MOVE

end

------------------------------------------------------------------------------------------

function CEulsSetupOgreBot:BotThink()

	if not IsServer() then
		return
	end

	if not self.me:IsAlive() then
		return
	end

	if GameRules:IsGamePaused() then
		return
	end

	if self.me:FindModifierByName("modifier_rod_of_atos_debuff") ~= nil then
		self.me:RemoveModifierByName("modifier_fountain_aura_buff")


		self.nBotState =  OGRE_BOT_STATE_ATTACK
		return 0.5
	end


	if self.nBotState == OGRE_BOT_STATE_IDLE then
		--do nothing

	 elseif self.nBotState == OGRE_BOT_STATE_MOVE then

	 	if  self.me:IsMoving() == false and self.me:FindModifierByName("modifier_jakiro_ice_path_stun") == nil then
		 	if self.hLastMoveLoc == self.hMoveLoc2 then
		 		self.hNextMoveLoc = self.hMoveLoc1
		 	else
		 		self.hNextMoveLoc = self.hMoveLoc2
		 	end


	
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = self.hNextMoveLoc:GetAbsOrigin()
			} )
			self.hLastMoveLoc = self.hNextMoveLoc
		end

		return 0.2
	end
	return 0.2
end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then


	local hTask = GameRules.DotaNPX:GetTask( "root_enemy_hero" )
	if hTask ~= nil and hTask:IsCompleted() == true then
		return -1
	end
		thisEntity:SetContextThink( "CEulsSetupOgreBotThink", CEulsSetupOgreBotThink, 0.5 )
		thisEntity.Bot = CEulsSetupOgreBot( thisEntity )
	end
end

function CEulsSetupOgreBotThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.5
end


