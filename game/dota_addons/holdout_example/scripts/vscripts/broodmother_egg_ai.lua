--[[
Broodmother Egg Hatching Logic
]]

function Spawn( entityKeyValues )
	ABILITY_hatch_broodmother = thisEntity:FindAbilityByName( "creature_hatch_broodmother")
	TIME_TO_HATCH = GameRules:GetGameTime() + ABILITY_hatch_broodmother:GetCooldown( 0 )
	thisEntity:SetContextThink( "WaitToHatch", WaitToHatch, 0.25 )
end


function WaitToHatch()
	if not thisEntity:IsAlive() then
		local nFXIndex = ParticleManager:CreateParticle( "veil_of_discord", PATTACH_ABSORIGIN, thisEntity )
		ParticleManager:SetParticleControl( nFXIndex, 0, thisEntity:GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		return
	end

	local now = GameRules:GetGameTime()
	if now < TIME_TO_HATCH then
		return RandomFloat( 0.1, 0.3 )
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = ABILITY_hatch_broodmother:entindex()
	})
end
