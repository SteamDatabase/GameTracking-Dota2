
modifier_shroomling_sleep = class({})

--------------------------------------------------------------------------------

function modifier_shroomling_sleep:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_shroomling_sleep:CanParentBeAutoAttacked()
	return false
end

--------------------------------------------------------------------------------

function modifier_shroomling_sleep:OnCreated( kv )
	if IsServer() then
		--print( 'modifier_shroomling_sleep:OnCreated()' )
		self.nWakeRange = 200
		self:StartIntervalThink( 1 )
	end
end

--------------------------------------------------------------------------------

function modifier_shroomling_sleep:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_ROOTED] = true
		state[MODIFIER_STATE_BLIND] = true
		state[MODIFIER_STATE_STUNNED] = true
		state[MODIFIER_STATE_SILENCED] = true
	end

	return state
end

--------------------------------------------------------------------------------

function modifier_shroomling_sleep:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_shroomling_sleep:GetEffectName()
    return "particles/generic_gameplay/generic_sleep.vpcf"
end

--------------------------------------------------------------------------------

function modifier_shroomling_sleep:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-----------------------------------------------------------------------------

function modifier_shroomling_sleep:OnDurationExpired( params )
	--print( 'modifier_shroomling_sleep:OnDurationExpired' )
	if IsServer() then
		self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_shroomling_weakened", { duration = -1.0 } )
	end

	return 0
end

--------------------------------------------------------------------------------
--[[
function modifier_shroomling_sleep:OnDestroy()
	if IsServer() then
	end
end
--]]
--------------------------------------------------------------------------------

function modifier_shroomling_sleep:OnAttacked( params )
	if IsServer() then
		if params.target == self:GetParent() then
			self:Destroy()
			self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_shroomling_enrage", { duration = -1.0 } )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_shroomling_sleep:OnTakeDamage( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			self:Destroy()
			self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_shroomling_enrage", { duration = -1.0 } )
		end
	end

	return 0
end

-----------------------------------------------------------------------------

function modifier_shroomling_sleep:OnIntervalThink()
	if IsServer() then
		-- don't wake up while we are still invulnerable
		local hInvulnBuff = self:GetParent():FindModifierByName( "modifier_invulnerable" )
		if hInvulnBuff ~= nil then
			--print( 'modifier_shroomling_sleep:OnIntervalThink() - shroom is currently invulnerable - skipping wakeup check!' )
			return
		end

		local hEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.nWakeRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		--print( 'modifier_shroomling_sleep:OnIntervalThink() found enemies = ' .. #hEnemies )
		if #hEnemies > 0 then
			self:Destroy()
			self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_shroomling_enrage", { duration = -1.0 } )
		end
	end
end

--------------------------------------------------------------------------------

--[[
function modifier_shroomling_sleep:OnDestroy()
	if not IsServer() then
		return
	end

	local hAllies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	for _, hAlly in pairs( hAllies ) do
		if hAlly:HasModifier( "modifier_shroomling_sleep" ) then
			hAlly:RemoveModifierByName( "modifier_shroomling_sleep" )
		end
	end
end
--]]
--------------------------------------------------------------------------------

