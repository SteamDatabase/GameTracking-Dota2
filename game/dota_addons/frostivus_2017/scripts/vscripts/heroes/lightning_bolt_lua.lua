lightning_bolt_lua = class({})

function lightning_bolt_lua:OnSpellStart()
	local caster = self:GetCaster()
    local ability = self
    local target = self:GetCursorPosition()
    local sound = "Hero_Zuus.LightningBolt"
    local particle = "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf"
    local particleHeight = 2000
    local targetPoint = self:GetCursorPosition()

    local true_sight_radius = ability:GetSpecialValueFor("true_sight_radius")
    local true_sight_duration = ability:GetSpecialValueFor("true_sight_duration")

    EmitSoundOn(sound, caster)
	
	local particle = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, Vector(targetPoint.x,targetPoint.y,particleHeight))
	ParticleManager:SetParticleControl(particle, 1, targetPoint)
	ParticleManager:SetParticleControl(particle, 2, targetPoint)

	--create a dummy at the targeted location that has truesight
	local unit = CreateUnitByName("npc_dummy_unit", target, false, caster, caster, caster:GetTeam())
	unit:AddNewModifier(caster, ability, "modifier_truesight_aura", {radius = true_sight_radius})
	unit:AddNoDraw()

	Timers:CreateTimer(true_sight_duration, function()
		unit:ForceKill(false)
	end)
end



