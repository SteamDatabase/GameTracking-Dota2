
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:AddNewModifier( nil, nil, "modifier_invulnerable", { duration = -1 } )
	thisEntity:AddNewModifier( nil, nil, "modifier_rooted", { duration = -1 } )
end

--------------------------------------------------------------------------------

