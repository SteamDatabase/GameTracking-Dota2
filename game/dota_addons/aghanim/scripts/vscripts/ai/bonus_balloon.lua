--[[ Bonus Balloon AI ]]

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:SetInitialGoalEntity( nil )
	thisEntity:SetContextThink( "BonusBalloonThink", BonusBalloonThink, 0.5 )

end

--------------------------------------------------------------------------------------------------------

function BonusBalloonThink()
	--print( "Bonus Balloon Thinking" )
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity:GetInitialGoalEntity() == nil then
		local hWaypoint = Entities:FindByClassnameNearest( "path_track", thisEntity:GetOrigin(), 500.0 )
		if hWaypoint ~= nil then
			--print( "Patrolling to " .. hWaypoint:GetName() )
			thisEntity:SetInitialGoalEntity( hWaypoint )
		end
	end
	
	return 0.5
end

--------------------------------------------------------------------------------------------------------
