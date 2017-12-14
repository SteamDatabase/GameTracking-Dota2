shapeshift_boar_lua = class({})
LinkLuaModifier("modifier_shapeshift_bear", "heroes/shapeshift_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shapeshift_boar", "heroes/shapeshift_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shapeshift_hawk", "heroes/shapeshift_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shapeshift", "heroes/shapeshift_lua.lua", LUA_MODIFIER_MOTION_NONE)

function shapeshift_boar_lua:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
	    local ability = self
	    local casterPosition = caster:GetAbsOrigin()
	    local sound = "Hero_LoneDruid.TrueForm.Cast"
	    local particle = "particles/abilities/lone_druid_true_form.vpcf"
	    local model = "models/heroes/beastmaster/beastmaster_beast.vmdl"

	    local transformationTime = ability:GetSpecialValueFor("transformation_time")

		local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(particle_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", casterPosition, true)
		ParticleManager:SetParticleControlEnt(particle_fx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", casterPosition, true)
		ParticleManager:SetParticleControlEnt(particle_fx, 2, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", casterPosition, true)
		ParticleManager:SetParticleControlEnt(particle_fx, 3, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", casterPosition, true)

		caster:AddNewModifier(caster, ability, "modifier_shapeshift", {duration = transformationTime})

	    -- caster:SetOriginalModel(model)
	    -- caster:SetModel(model)
	    caster:SetModelScale(1)
	    caster:SetUnitName("npc_dota_beastmaster_boar")
	    caster:SetBaseMoveSpeed(330)
	    caster:SetBaseAttackTime(1.6)
	    caster:SetBaseDamageMin(31)
	    caster:SetBaseDamageMax(35)
	    caster:SetPhysicalArmorBaseValue(15)
	    caster:SetBaseMagicalResistanceValue(50)
	    caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	    --caster:SetRangedProjectileName("particles/units/heroes/hero_beastmaster/beastmaster_boar_attack.vpcf")

	    caster:AddAbility("custom_boar_poison"):UpgradeAbility(true)

	    TryToRemoveAbility(caster, "arcane_bolt_lua")
	    TryToRemoveAbility(caster, "custom_entangling_roots")
	    TryToRemoveAbility(caster, "lone_druid_rabid_lua")	  

	    caster:AddNewModifier(caster, ability, "modifier_shapeshift_boar", {})
	    caster:RemoveModifierByName("modifier_shapeshift_hawk")
	    caster:RemoveModifierByName("modifier_shapeshift_bear")

	    PutTransformsOnCooldown(caster, ability)

	    EmitSoundOn(sound, caster)
	end
end

shapeshift_bear_lua = class({})

function shapeshift_bear_lua:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
	    local ability = self
	    local casterPosition = caster:GetAbsOrigin()
	    local sound = "Hero_LoneDruid.TrueForm.Cast"
	    local particle = "particles/abilities/lone_druid_true_form.vpcf"
	    local model = "models/heroes/lone_druid/spirit_bear.vmdl"

	    local transformationTime = ability:GetSpecialValueFor("transformation_time")  

	    local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(particle_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", casterPosition, true)
		ParticleManager:SetParticleControlEnt(particle_fx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", casterPosition, true)
		ParticleManager:SetParticleControlEnt(particle_fx, 2, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", casterPosition, true)
		ParticleManager:SetParticleControlEnt(particle_fx, 3, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", casterPosition, true)

		caster:AddNewModifier(caster, ability, "modifier_shapeshift", {duration = transformationTime})

	    -- caster:SetOriginalModel(model)
	    -- caster:SetModel(model)
	    caster:SetModelScale(1)
	    caster:SetUnitName("npc_dota_lone_druid_bear1")
	    caster:SetBaseMoveSpeed(270)
	    caster:SetBaseAttackTime(2.6)
	    caster:SetBaseDamageMin(42)
	    caster:SetBaseDamageMax(46)
	    caster:SetPhysicalArmorBaseValue(70)
	    caster:SetBaseMagicalResistanceValue(0)
	    caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)

	    caster:AddAbility("lone_druid_rabid_lua"):UpgradeAbility(true)
	    caster:AddAbility("custom_entangling_roots"):UpgradeAbility(true)

	    TryToRemoveAbility(caster, "arcane_bolt_lua")
	    TryToRemoveAbility(caster, "custom_boar_poison")

	    caster:AddNewModifier(caster, ability, "modifier_shapeshift_bear", {})
	    caster:RemoveModifierByName("modifier_shapeshift_hawk")
	    caster:RemoveModifierByName("modifier_shapeshift_boar")

	    PutTransformsOnCooldown(caster, ability)

	    EmitSoundOn(sound, caster)
	end
end

shapeshift_hawk_lua = class({})

function shapeshift_hawk_lua:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
	    local ability = self
	    local casterPosition = caster:GetAbsOrigin()
	    local sound = "Hero_LoneDruid.TrueForm.Cast"
	    local particle = "particles/abilities/lone_druid_true_form.vpcf"
	    local model = "models/heroes/beastmaster/beastmaster_bird.vmdl"

	    local transformationTime = ability:GetSpecialValueFor("transformation_time")  

	    local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(particle_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", casterPosition, true)
		ParticleManager:SetParticleControlEnt(particle_fx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", casterPosition, true)
		ParticleManager:SetParticleControlEnt(particle_fx, 2, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", casterPosition, true)
		ParticleManager:SetParticleControlEnt(particle_fx, 3, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", casterPosition, true)

		caster:AddNewModifier(caster, ability, "modifier_shapeshift", {duration = transformationTime})

	    -- caster:SetOriginalModel(model)
	    -- caster:SetModel(model)
	    caster:SetModelScale(1.5)
	    caster:SetUnitName("npc_dota_beastmaster_hawk_1")
	    caster:SetBaseMoveSpeed(420)
	    caster:SetBaseAttackTime(1.1)
	    caster:SetBaseDamageMin(1)
	    caster:SetBaseDamageMax(1)
	    caster:SetPhysicalArmorBaseValue(0)
	    caster:SetBaseMagicalResistanceValue(0)
	    caster:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)

	    caster:AddAbility("arcane_bolt_lua"):UpgradeAbility(true)

	    TryToRemoveAbility(caster, "custom_entangling_roots")
	    TryToRemoveAbility(caster, "lone_druid_rabid_lua")
	    TryToRemoveAbility(caster, "custom_boar_poison")

	    caster:AddNewModifier(caster, ability, "modifier_shapeshift_hawk", {})
	    caster:RemoveModifierByName("modifier_shapeshift_bear")
	    caster:RemoveModifierByName("modifier_shapeshift_boar")

	    PutTransformsOnCooldown(caster, ability)

	    EmitSoundOn(sound, caster)
	end
end

modifier_shapeshift_bear = class({})

function modifier_shapeshift_bear:DeclareFunctions()
    local funcs =
    {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_MODEL_CHANGE,
    }
    return funcs
end

function modifier_shapeshift_bear:GetModifierAttackRangeBonus()
	return -400
end

function modifier_shapeshift_bear:IsHidden()
	return true
end

function modifier_shapeshift_bear:GetModifierModelChange()

	return "models/heroes/lone_druid/spirit_bear.vmdl"
end

modifier_shapeshift_boar = class({})

function modifier_shapeshift_boar:DeclareFunctions()
    local funcs = 
    {MODIFIER_PROPERTY_MODEL_CHANGE}
    return funcs
end

function modifier_shapeshift_boar:GetModifierModelChange()
	return "models/heroes/beastmaster/beastmaster_beast.vmdl"
end

function modifier_shapeshift_boar:IsHidden()
	return true
end

modifier_shapeshift_hawk = class({})

function modifier_shapeshift_hawk:DeclareFunctions()
    local funcs = {MODIFIER_PROPERTY_MODEL_CHANGE}
    return funcs
end

function modifier_shapeshift_hawk:GetModifierModelChange()
	return "models/heroes/beastmaster/beastmaster_bird.vmdl"
end

function modifier_shapeshift_hawk:IsHidden()
	return true
end

modifier_shapeshift = class({})

function modifier_shapeshift:CheckState()
    local state = {
    [MODIFIER_STATE_STUNNED] = true,
    }
 
    return state
end

function modifier_shapeshift:IsHidden()
	return true
end

-----------------------------------------------------------
function PutTransformsOnCooldown(caster, ability)
	local cooldownTime = 3
	caster:FindAbilityByName("shapeshift_boar_lua"):SetActivated(true)
	caster:FindAbilityByName("shapeshift_hawk_lua"):SetActivated(true)
	caster:FindAbilityByName("shapeshift_bear_lua"):SetActivated(true)

	-- caster:FindAbilityByName("shapeshift_boar_lua"):StartCooldown(cooldownTime)
	-- caster:FindAbilityByName("shapeshift_hawk_lua"):StartCooldown(cooldownTime)
	-- caster:FindAbilityByName("shapeshift_bear_lua"):StartCooldown(cooldownTime)

	ability:SetActivated(false)
end

function TryToRemoveAbility(unit, abilityName)
	local ability = unit:FindAbilityByName(abilityName)
	if ability then
		unit:RemoveAbility(abilityName)
	end
end