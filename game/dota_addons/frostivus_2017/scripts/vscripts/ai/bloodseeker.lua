function Spawn()
	thisEntity.rupture = thisEntity:FindAbilityByName("aoe_rupture_lua")
	thisEntity.castPosition = Entities:FindByName(nil, "race_left_boundary"):GetAbsOrigin()
	thisEntity:SetContextThink( "AIThink", AIThink, .1 )
end

function AIThink()
	if not thisEntity then return end
	if not thisEntity:IsAlive() then
    	return
    end
	if GameRules:IsGamePaused() then
		return 0.1
	end
	
	return CastRupture()
end

function CastRupture()
	local duration = RandomFloat(.5, 5)
	thisEntity.ruptureDuration = duration

	thisEntity:CastAbilityOnPosition(thisEntity.castPosition, thisEntity.rupture, -1)

	-- amount of time to wait after rupture wears off
	local ruptureDownTime = duration + RandomFloat(.5, 5)

	return ruptureDownTime
end