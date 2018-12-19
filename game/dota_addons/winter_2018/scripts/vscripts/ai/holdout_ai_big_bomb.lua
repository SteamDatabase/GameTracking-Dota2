require( "ai/ai_shared" )
require( "event_queue" )

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end

	thisEntity.EventQueue = CEventQueue()

	thisEntity.hExplode = thisEntity:FindAbilityByName( "creature_big_bomb_explode" )
	local fInitialDelay = RandomFloat( 0, 1.5 ) -- separating out the timing of all the ranged creeps' thinks
	thisEntity:SetContextThink( "BigBombThink", BigBombThink, fInitialDelay )
	thisEntity._hAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
end

function BigBombThink()
	local flNow = GameRules:GetGameTime()
	local flDistFromAncient = (thisEntity._hAncient:GetOrigin() - thisEntity:GetOrigin()):Length2D()

	AttackTargetOrder( thisEntity, thisEntity._hAncient )

	if( flDistFromAncient <= 430 ) then
		CastExplode(thisEntity)
	end
	return 0.5
end

function CastExplode( hCaster )
	--printf("DIE DIE DIE!")
	local hAbility = hCaster.hExplode
	ExecuteOrderFromTable({
		UnitIndex = hCaster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		Position = vPosition,
		AbilityIndex = hAbility:entindex(),
		Queue = false,
	})
	return 0.5
end