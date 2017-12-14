race_charge_lua = class({})

function race_charge_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local sound = "Hero_Spirit_Breaker.ChargeOfDarkness.FP"
    local soundChance = 5

    local distance = ability:GetSpecialValueFor("distance")

    if soundChance > RandomInt(1, 100) then
    	EmitSoundOn(sound, caster)
    end

    local distance = 20

    caster.target = caster.target + Vector(distance, 0, 0)
end