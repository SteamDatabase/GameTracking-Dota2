require( "aghanim_utility_functions" )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	-- Fuzz up the initial think time so they're not just a big clump
	local flInitialThinkTime = RandomFloat(1, 4)
	thisEntity:SetContextThink( "BabyDragonThink", BabyDragonThink, flInitialThinkTime )
end

--------------------------------------------------------------------------------

function BabyDragonThink()
	return UnitRescueThinker( thisEntity )
end