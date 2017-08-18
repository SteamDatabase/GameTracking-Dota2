
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	Pounce = thisEntity:FindAbilityByName( "slark_pounce" )

	thisEntity:SetContextThink( "ReefCrawlerThink", ReefCrawlerThink, 0.5 )
end

--------------------------------------------------------------------------------

function ReefCrawlerThink()
	if ( not thisEntity ) or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity:GetAggroTarget() == nil then
		return 1
	end

	if Pounce ~= nil and Pounce:IsFullyCastable() then
		local flDist = (thisEntity:GetAggroTarget():GetOrigin() - thisEntity:GetOrigin()):Length2D()
		if flDist < 525 then
			return CastPounce()
		end
	end
	return 1
end

--------------------------------------------------------------------------------


function CastPounce()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = Pounce:entindex(),
		Queue = false,
	})
	
	return 0.8
end
