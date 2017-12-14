function Blink(keys)
	local point = keys.target_points[1]
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local difference = point - casterPos
	local ability = keys.ability
	local range = ability:GetLevelSpecialValueFor("blink_range", (ability:GetLevel() - 1))

	if difference:Length2D() > range then
		point = casterPos + (point - casterPos):Normalized() * range
	end
	
	--if we're blinking off the arena, don't allow the blink and refund the mana/cooldown
	if not GridNav:CanFindPath(casterPos, point) then
		ability:EndCooldown()
		caster:GiveMana(ability:GetManaCost(-1))
		return nil
	end

	local sound = "Hero_Antimage.Blink_out"

	EmitSoundOn(sound, caster)
	
	local blinkIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", PATTACH_ABSORIGIN, caster)

	FindClearSpaceForUnit(caster, point, true)
	ProjectileManager:ProjectileDodge(caster)
	
	Timers:CreateTimer(1, 
	function()
		ParticleManager:DestroyParticle( blinkIndex, false )
		return nil
	end)
end