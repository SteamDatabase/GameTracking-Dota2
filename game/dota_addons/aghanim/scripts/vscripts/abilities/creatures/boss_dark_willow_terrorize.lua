boss_dark_willow_terrorize = class({})

----------------------------------------------------

function boss_dark_willow_terrorize:Precache( context )
end

----------------------------------------------------

function boss_dark_willow_terrorize:OnAbilityPhaseStart()
	if IsServer() == false then 
		return true
	end
	return true
end

----------------------------------------------------

function boss_dark_willow_terrorize:OnAbilityPhaseInterrupted()
	if IsServer() == false then 
		return
	end
end

----------------------------------------------------

function boss_dark_willow_terrorize:OnSpellStart()
	if IsServer() == false then 
		return
	end
end