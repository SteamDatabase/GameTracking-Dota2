
---------------------------------------------------------------------------------

function ActivatePlayerLight( trigger )
	local hActivator = trigger.activator
	local team = trigger.activator:GetTeam()
	local szTriggerName = thisEntity:GetName()
	local entindex = trigger.activator:GetEntityIndex()
	local gamemode = GameRules.Dungeon

	if hActivator and hActivator:IsRealHero() then
		hActivator:AddNewModifier( nil, nil, "modifier_player_light", { duration = -1 } )
	end
end

---------------------------------------------------------------------------------

function DeactivatePlayerLight( trigger )
	local hActivator = trigger.activator
	local team = trigger.activator:GetTeam()
	local szTriggerName = thisEntity:GetName()
	local entindex = trigger.activator:GetEntityIndex()
	local gamemode = GameRules.Dungeon

	if hActivator and hActivator:IsRealHero() then
		hActivator:RemoveModifierByName( "modifier_player_light" )
		if hActivator.nLightParticleID then
			ParticleManager:DestroyParticle( hActivator.nLightParticleID, false )
			hActivator.nLightParticleID = nil
		end
	end
end

---------------------------------------------------------------------------------

