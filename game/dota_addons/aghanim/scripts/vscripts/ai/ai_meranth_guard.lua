
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:SetContextThink( "MeranthGuardThink", MeranthGuardThink, 0.5 )
end

--------------------------------------------------------------------------------

function MeranthGuardThink()
	if ( not thisEntity ) or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	if ( not thisEntity.bAcqRangeModified ) and thisEntity.hMaster then
		SetAggroRange( thisEntity, 6000 )
	end
end

--------------------------------------------------------------------------------

