earth_spirit_kick_lua = class({})

function earth_spirit_kick_lua:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
	    local ability = self
	    local target = self:GetCursorTarget()
	    local targetPos = target:GetAbsOrigin()
        local casterPos = caster:GetAbsOrigin()
	    local sound = "Hero_EarthSpirit.BoulderSmash.Cast"
	    local soundImpact = "Hero_EarthSpirit.BoulderSmash.Target"

	    if target:GetUnitName() ~= "earth_spirit_soccer_ball" then
	    	print("Kicking something other than soccer ball")
	    	return
	    end

	    EmitSoundOn(sound, caster)
	    EmitSoundOn(soundImpact, caster)

        local kick_force = ability:GetSpecialValueFor("kick_force")
 
        local direction = (targetPos - casterPos):Normalized()
        local speed = kick_force
 
        target.velocity = direction
        target.speed = speed
	end
end
