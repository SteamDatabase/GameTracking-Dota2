
require( "utility_functions" )

modifier_boss_clockwerk_battery_assault = class({})

---------------------------------------------------------------------------

function modifier_boss_clockwerk_battery_assault:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_clockwerk_battery_assault:OnCreated( kv )
	self.search_radius = self:GetAbility():GetSpecialValueFor( "search_radius" )
	self.interval = self:GetAbility():GetSpecialValueFor( "interval" )
	self.thinker_delay = self:GetAbility():GetSpecialValueFor( "thinker_delay" )

	if IsServer() then
		EmitSoundOn( "Boss_Clockwerk.Battery_Assault", self:GetCaster() )

		self:StartIntervalThink( self.interval )
	end
end

--------------------------------------------------------------------------------

function modifier_boss_clockwerk_battery_assault:OnIntervalThink()
	if not IsServer() then
		return -1
	end

	local enemies = Util_FindEnemiesAroundUnit( self:GetCaster(), self.search_radius, true )

	local vThinkerPos = nil

	if #enemies > 0 then
		local hRandomEnemy = enemies[ RandomInt( 1, #enemies ) ]
		vThinkerPos = hRandomEnemy:GetAbsOrigin()
	else
		local nMinRadius = 200
		vThinkerPos = GetRandomPathablePositionWithin( self:GetCaster():GetAbsOrigin(), self.search_radius, nMinRadius )
	end

	if vThinkerPos == nil then
		vthinkerPos = self:GetCaster():GetAbsOrigin()
	end

	local kv = { duration = self.thinker_delay }
	CreateModifierThinker( self:GetCaster(), self:GetAbility(),
		"modifier_boss_clockwerk_battery_assault_thinker", kv,
		vThinkerPos, self:GetCaster():GetTeamNumber(), false
	)
end

--------------------------------------------------------------------------------

function modifier_boss_clockwerk_battery_assault:OnDestroy()
	if IsServer() then
		StopSoundOn( "Boss_Clockwerk.Battery_Assault", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------
