require( "ai/ai_shared" )

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end

	AbilityDoom = thisEntity:FindAbilityByName( "doomling_doom" )
	local fInitialDelay = RandomFloat( 0, 1.5 ) -- separating out the timing of all the ranged creeps' thinks
	thisEntity:SetContextThink( "DoomlingThink", DoomlingThink, fInitialDelay )
end

function DoomlingThink()
	if thisEntity == nil or thisEntity:IsNull() or ( thisEntity:IsAlive() == false ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	--printf("abilitydoom is %s, %s", AbilityDoom:IsFullyCastable(), AbilityDoom:GetCastRange())
	if AbilityDoom and AbilityDoom:IsFullyCastable() then
		local nDoomStackCount = 10
		local hEnemies = GetVisibleEnemyHeroesInRange( thisEntity, AbilityDoom:GetCastRange())
		local hTarget = GetRandomUnique( hEnemies )
		if hTarget and hTarget:IsAlive() and hTarget:FindModifierByName("modifier_doom_bringer_doom") == nil then
			hImpendingDoom = hTarget:FindModifierByName("modifier_impending_doom")

			if hImpendingDoom and hImpendingDoom:GetStackCount() >= nDoomStackCount then 
				local fNow = GameRules:GetGameTime()
				local flLastAllyCastTime = LastAllyCastTime( thisEntity, AbilityDoom, AbilityDoom:GetCastRange() + 200, hTarget )
				if ( fNow - flLastAllyCastTime ) > ( 0.2 ) then
					CastTargetedAbility( thisEntity, hTarget, AbilityDoom )
					UpdateLastCastTime( thisEntity, AbilityDoom, hTarget )
					EmitSoundOn( "Hero_DoomBringer.Doom", hTarget )
				end
			end
		end
	end

	return 0.5
end