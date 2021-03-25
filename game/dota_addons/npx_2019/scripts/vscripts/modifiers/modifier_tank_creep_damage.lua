modifier_tank_creep_damage = class({})

--------------------------------------------------------------------------------

function modifier_tank_creep_damage:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_tank_creep_damage:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_tank_creep_damage:OnCreated( kv )
	
end

--------------------------------------------------------------------------------

function modifier_tank_creep_damage:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	}

	return funcs
end


function modifier_tank_creep_damage:GetModifierTotal_ConstantBlock( params )
	local hAttacker = params.attacker
	if hAttacker then
		if hAttacker:GetUnitName() ~="npc_dota_hero_sniper" then
			return 10000
		else
			return 0
		end
	end	
	return 0
end
