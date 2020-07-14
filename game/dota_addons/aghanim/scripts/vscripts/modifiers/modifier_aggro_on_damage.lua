LinkLuaModifier( "modifier_detect_invisible", "modifiers/modifier_detect_invisible", LUA_MODIFIER_MOTION_NONE )

modifier_aggro_on_damage = class({})

--------------------------------------------------------------------------------

function modifier_aggro_on_damage:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_aggro_on_damage:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_aggro_on_damage:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_aggro_on_damage:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_aggro_on_damage:OnTakeDamage( params )
	if IsServer() then
		-- Are we being attacked?
		local hUnit = params.unit
		if hUnit ~= self:GetParent() then
			return 0
		end

		-- if we already have an aggro target just ignore
		if hUnit:GetAggroTarget() then
			return 0
		end

		-- Is the attacker is not something we can attack ignore it
		local hAttacker = params.attacker
		if hAttacker == nil then
			return 0
		end

		--print( 'modifier_aggro_on_damage:OnTakeDamage() - setting SetInitialGoalEntity() to ' .. hAttacker:GetUnitName() )
		self:GetParent():SetInitialGoalEntity( hAttacker )

		return 0
	end

	return 0
end
