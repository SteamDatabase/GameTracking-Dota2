
modifier_room_monster_sleep = class({})

--------------------------------------------------------------------------------

function modifier_room_monster_sleep:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_room_monster_sleep:OnCreated( kv )
	if IsServer() then
		self.iWakeRange = 500
		self:StartIntervalThink( 1 )
	end
end

--------------------------------------------------------------------------------

function modifier_room_monster_sleep:CheckState()
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

function modifier_room_monster_sleep:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

-----------------------------------------------------------------------
function modifier_room_monster_sleep:GetEffectName()
    return "particles/generic_gameplay/generic_sleep.vpcf"
end

--------------------------------------------------------------------------------

function modifier_room_monster_sleep:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
--------------------------------------------------------------------------------

function modifier_room_monster_sleep:OnAttacked( params )
	if IsServer() then
		if params.target == self:GetParent() then
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_room_monster_sleep:OnTakeDamage( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			self:Destroy()
		end
	end

	return 0
end
-----------------------------------------------------------------------------

function modifier_room_monster_sleep:OnIntervalThink()
	if IsServer() then
	local hEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.iWakeRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		if #hEnemies > 0 then
			self:Destroy()
		end

	end
end


--------------------------------------------------------------------------------

function modifier_room_monster_sleep:OnDestroy()
	if not IsServer() then
		return
	end

	local hAllies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	for _, hAlly in pairs( hAllies ) do
		if hAlly:HasModifier( "modifier_room_monster_sleep" ) then
			hAlly:RemoveModifierByName( "modifier_room_monster_sleep" )
		end
	end
end

--------------------------------------------------------------------------------

