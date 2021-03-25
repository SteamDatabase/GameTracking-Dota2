
local BM_BOT_STATE_IDLE							= 0
local BM_BOT_STATE_SWING						= 1

-----------------------------------------------------------------------------------------------------

if CBeastMasterOpenDoorBot == nil then
	CBeastMasterOpenDoorBot = class({})
end

function CBeastMasterOpenDoorBot:constructor( me )
	self.me = me
	self.hWildAxes = self.me:FindAbilityByName( "beastmaster_wild_axes" )
	self.nBotState = BM_BOT_STATE_IDLE
	self.hAttackTarget = nil
	self.bCastedAxes = false
end



function CBeastMasterOpenDoorBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

function CBeastMasterOpenDoorBot:BotThink()

	if self.nBotState == BM_BOT_STATE_IDLE and not self.bCastedAxes then
		local Heroes = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self.me:GetOrigin(), self.me, 300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		if #Heroes > 1 then			
			self:ChangeBotState( BM_BOT_STATE_SWING )
		end
	elseif self.nBotState == BM_BOT_STATE_SWING then
		if self.hWildAxes and self.hWildAxes:IsFullyCastable() then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.hWildAxes:entindex(),
				Position = Vector( -3135, -2048, 292 ),

			} )
			self:ChangeBotState( BM_BOT_STATE_IDLE )
			self.bCastedAxes = true
		end
	end
end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "BeastMasterOpenDoorThink", BeastMasterOpenDoorThink, 0.25 )

		thisEntity.Bot = CBeastMasterOpenDoorBot( thisEntity )
		

	end
end

function BeastMasterOpenDoorThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.1
end


