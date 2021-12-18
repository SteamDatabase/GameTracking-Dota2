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

		--print( '^^^modifier_aggro_on_damage:OnTakeDamage' )

		-- if we already have an aggro target just ignore
		if hUnit:GetAggroTarget() then
			--print( '^^^modifier_aggro_on_damage:OnTakeDamage - already have an aggro target!' )
			return 0
		end

		-- Is the attacker is not something we can attack ignore it
		local hAttacker = params.attacker
		if hAttacker == nil then
			--print( '^^^modifier_aggro_on_damage:OnTakeDamage - attacker is nil!' )
			return 0
		end

		-- check for aggro override
		local hAggroOverrideBuff = hAttacker:FindModifierByName( "modifier_aghsfort_aggro_override" )
		if hAggroOverrideBuff ~= nil then
			local hAggroOverrideUnit = hAggroOverrideBuff:GetCaster()
			if hAggroOverrideUnit ~= nil and hAggroOverrideUnit:IsNull() == false and hAggroOverrideUnit:IsAlive() then
				--print( 'Overriding aggro target for ' .. hAttacker:GetUnitName() .. ' to ' .. hAggroOverrideUnit:GetUnitName() )
				hAttacker = hAggroOverrideUnit
			end
		end

		--print( 'modifier_aggro_on_damage:OnTakeDamage() - setting SetInitialGoalEntity() to ' .. hAttacker:GetUnitName() )
		self:GetParent():MoveToPositionAggressive( hAttacker:GetAbsOrigin() )

		return 0
	end

	return 0
end
