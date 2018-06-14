
require("units/ai/ai_cavern_shared")

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:SetContextThink( "EnigmaThink", EnigmaThink, 1 )
end

--------------------------------------------------------------------------------

function EnigmaThink()
	local flEarlyReturn = InitialRoomMobLogic( thisEntity )
	if flEarlyReturn == nil then
		return nil
	elseif flEarlyReturn > 0 then
		return flEarlyReturn
	end

	local hClosestPlayer = GetClosestPlayerInRoomOrReturnToSpawn( thisEntity )
	if hClosestPlayer == nil then
		return 1
	end

	local hTarget = nil 

	if thisEntity.fLastLaughAttempt == nil or GameRules:GetGameTime() > ( thisEntity.fLastLaughAttempt + VOICE_LINE_COOLDOWN ) then
		local nRandomInt = RandomInt( 0, 10 )
		-- Bit wonky that we're calling these inside a Think
		if nRandomInt == 9 then
			GameRules.Cavern:FireLaugh( thisEntity )
		elseif nRandomInt == 10 then
			GameRules.Cavern:FireTaunt( thisEntity )
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

