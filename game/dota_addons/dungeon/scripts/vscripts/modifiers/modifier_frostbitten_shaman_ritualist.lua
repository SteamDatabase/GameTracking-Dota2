
modifier_frostbitten_shaman_ritualist = class({})

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_ritualist:IsHidden()
	return true
end

-----------------------------------------------------------------------------

--[[
function modifier_frostbitten_shaman_ritualist:GetEffectName()
	return "particles/act_2/frostbitten_shaman_repel_ritualist.vpcf"
end
]]

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_ritualist:OnCreated( kv )
	if not IsServer() then
		return
	end

	self:GetParent():SetAttackCapability( DOTA_UNIT_CAP_NO_ATTACK )
	self:GetParent():AddNewModifier( nil, nil, "modifier_disable_aggro", { duration = -1 } )
end

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_ritualist:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}	
	return funcs
end

--------------------------------------------------------------------------------

function modifier_frostbitten_shaman_ritualist:OnAttacked( params )
	if IsServer() then
		if params.target == self:GetParent() then
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_frostbitten_shaman_ritualist:OnTakeDamage( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			self:Destroy()
		end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_frostbitten_shaman_ritualist:OnDestroy()
	if not IsServer() then
		return
	end

	self:GetParent():SetAttackCapability( DOTA_UNIT_CAP_RANGED_ATTACK )
	self:GetParent():RemoveModifierByName( "modifier_disable_aggro" )

	-- Wake up our nearby ritual buddies
	local hAllies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	for _, hAlly in pairs( hAllies ) do
		if hAlly:HasModifier( "modifier_frostbitten_shaman_ritualist" ) then
			hAlly:RemoveModifierByName( "modifier_frostbitten_shaman_ritualist" )
			hAlly:RemoveModifierByName( "modifier_disable_aggro" )
		end
	end
end

--------------------------------------------------------------------------------

