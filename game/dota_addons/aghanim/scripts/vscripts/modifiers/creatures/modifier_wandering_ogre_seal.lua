
require( "utility_functions" )

modifier_wandering_ogre_seal = class({})

--------------------------------------------------------------------------------

function modifier_wandering_ogre_seal:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_wandering_ogre_seal:IsHidden()
	return true
end

--------------------------------------------------------------------------------

--[[
function modifier_wandering_ogre_seal:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
]]

--------------------------------------------------------------------------------

function modifier_wandering_ogre_seal:OnCreated( kv )
	if IsServer() then
		self.max_wander_range = self:GetAbility():GetSpecialValueFor( "max_wander_range" )
		self.min_wander_range = self:GetAbility():GetSpecialValueFor( "min_wander_range" )
		self.move_interval = self:GetAbility():GetSpecialValueFor( "move_interval" )

		local flNow = GameRules:GetGameTime()

		self:StartIntervalThink( 1 )
	end
end

--------------------------------------------------------------------------------

function modifier_wandering_ogre_seal:OnIntervalThink()
	if IsServer() then
		local hUnit = self:GetParent()

		local flNow = GameRules:GetGameTime()

		if self.flNextMoveTime == nil or ( flNow > self.flNextMoveTime ) then
			local vGoalPosition = GetRandomPathablePositionWithin( hUnit:GetAbsOrigin(), self.max_wander_range, self.min_wander_range )

			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = vGoalPosition
			})
			self.flNextMoveTime = flNow + self.move_interval
		end
	end
end

--------------------------------------------------------------------------------

--[[
function modifier_wandering_ogre_seal:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_wandering_ogre_seal:OnTakeDamage( params )
	if IsServer() then
		-- make Penguins do 1 damage to me?

		local hUnit = params.unit
		if hUnit == self:GetParent() then
			local flDamage = params.damage
			if flDamage <= 0 then
				return
			end

			EmitSoundOn( "GingerRoshan.LowPitchGrunt", hUnit )
		end
	end

	return 0
end
]]

--------------------------------------------------------------------------------

function modifier_wandering_ogre_seal:CheckState()
	local state = {}
	if IsServer() then
		state =
		{
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
			[MODIFIER_STATE_DISARMED] = true,
		}
	end
	
	return state
end

--------------------------------------------------------------------------------
