
local LINA_BOT_STATE_IDLE					= 0
local LINA_BOT_STATE_TANGO					= 1
local LINA_BOT_STATE_BLADE					= 2

-----------------------------------------------------------------------------------------------------

if CRegenLinaBot == nil then
	CRegenLinaBot = class({})
end

function CRegenLinaBot:constructor( me )
	self.me = me

	self.hAbilityLagunaBlade = self.me:FindAbilityByName( "lina_laguna_blade" )

	self.nBotState = LINA_BOT_STATE_IDLE
end



function CRegenLinaBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

function CRegenLinaBot:BotThink()
	if not IsServer() then
		return
	end

	if not self.me:IsAlive() then
		return
	end

	if GameRules:IsGamePaused() then
		return
	end

	if self.nBotState == LINA_BOT_STATE_IDLE then
        if self.vHome == nil then
            self.vHome = self.me:GetAbsOrigin()
        end

        if ( self.vHome - self.me:GetAbsOrigin() ):Length2D() > 150 then
            ExecuteOrderFromTable( {
                UnitIndex = self.me:entindex(),
                OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
                Position = self.vHome,
                Queue = false,
            } )
            return
        end

        if self.hSingleTango == nil then
            self.hSingleTango = self.me:FindItemInInventory( "item_tango_single" )
            if self.hSingleTango and self.hSingleTango:IsFullyCastable() and self.me:GetHealthPercent() < 100 then
                self:ChangeBotState( LINA_BOT_STATE_TANGO )
                return
            end
        end

	elseif self.nBotState == LINA_BOT_STATE_TANGO then
        if self.hSingleTango == nil or self.hSingleTango:IsNull() or not self.hSingleTango:IsFullyCastable() then
            self:ChangeBotState( LINA_BOT_STATE_IDLE )
            return
        end

        local rgTrees = GridNav:GetAllTreesAroundPoint(self.me:GetOrigin(), 1000, false )
        if #rgTrees > 0 then
            local nearest = TableMinBy( rgTrees, function ( hTree ) return ( self.me:GetAbsOrigin() - hTree:GetAbsOrigin() ):Length2D() end )
            ExecuteOrderFromTable( {
                UnitIndex = self.me:entindex(),
                OrderType = DOTA_UNIT_ORDER_CAST_TARGET_TREE,
                AbilityIndex = self.hSingleTango:entindex(),
                TargetIndex = GetTreeIdForEntityIndex( nearest:entindex() ),
            } )
        end

	elseif self.nBotState == LINA_BOT_STATE_BLADE then
        -- Find Lion
        -- Blade Lion
        -- Idle

	end

end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "LinaThink", LinaThink, 0.25 )
		thisEntity.Bot = CRegenLinaBot( thisEntity )
	end
end

function LinaThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.1
end
