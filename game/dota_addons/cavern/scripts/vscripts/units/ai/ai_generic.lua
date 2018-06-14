require("units/ai/ai_cavern_shared")

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:SetContextThink( "GenericThink", GenericThink, 1 )

end

--------------------------------------------------------------------------------

function GenericThink()
	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	local flEarlyReturn = InitialRoomMobLogic( thisEntity )
	if flEarlyReturn == nil then 
		return nil
	end

	if flEarlyReturn > 0 then 
		return flEarlyReturn
	end

	local hClosestPlayer = GetClosestPlayerInRoomOrReturnToSpawn( thisEntity )

	if hClosestPlayer == nil then
		return 0.5
	end


	local fFuzz = RandomFloat( -0.1, 0.1 ) -- Adds some timing separation
	
	return 0.5 + fFuzz

end

--------------------------------------------------------------------------------