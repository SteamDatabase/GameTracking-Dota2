require( "ai/shared" )
require( "ai/ai_core" )

--------------------------------------------------------------------------------
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	
	thisEntity.hInfernalBlade = thisEntity:FindAbilityByName( "creature_doom_infernal_blade" )

	thisEntity:SetContextThink( "DoomThink", DoomThink, 1 )
end

--------------------------------------------------------------------------------

function Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_debuff.vpcf", context )
end

--------------------------------------------------------------------------------

function DoomThink()

	local flNow = GameRules:GetGameTime()

	if thisEntity.hInfernalBlade and thisEntity.hInfernalBlade:IsFullyCastable() then
		local hHeroes = GetEnemyHeroesInRange( thisEntity, 300 )

		if #hHeroes > 0 then
			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = hHeroes[1]:entindex(),
				AbilityIndex = thisEntity.hInfernalBlade:entindex(),
				Queue = false,
			})
		end

	else
		thisEntity.flLastAggroSwitch = thisEntity.flLastAggroSwitch and thisEntity.flLastAggroSwitch or 0
	
		local hTarget = AICore:ClosestEnemyHeroInRange( thisEntity, 9000 )

		if (flNow - thisEntity.flLastAggroSwitch) > 2 then
			AttackTargetOrder( thisEntity, hTarget )
			thisEntity.flLastAggroSwitch = flNow
		end
	end

	return 0.25
end

--------------------------------------------------------------------------------