require( "ai/shared" )

LinkLuaModifier( "modifier_shroomling_enrage", "modifiers/creatures/modifier_shroomling_enrage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shroomling_sleep", "modifiers/creatures/modifier_shroomling_sleep", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function Precache( context )
   PrecacheResource( "particle", "particles/items2_fx/mask_of_madness.vpcf", context )
   PrecacheResource( "particle", "particles/generic_gameplay/generic_sleep.vpcf", context )
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

--	thisEntity.nShackledHeroSearchRadius = 900
--	thisEntity.hForceAttackTarget = nil

	thisEntity:AddNewModifier( thisEntity, nil, "modifier_shroomling_sleep", { duration = -1.0 } )

	-- mushrooms are 100% off limits for a bit after spawning
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_invulnerable", { duration = 1.5 } )

--	thisEntity:SetContextThink( "ShroomlingThink", ShroomlingThink, 1 )
end

--[[
function ShroomlingThink()
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity:IsAlive() == false then
		return 1
	end

	if thisEntity.hForceAttackTarget ~= nil then
		local hShackleDebuff = thisEntity.hForceAttackTarget:FindModifierByName( "modifier_aghsfort_shadow_shaman_shackles" )

		if thisEntity.hForceAttackTarget:IsAlive() == false or hShackleDebuff == nil then
			-- force attack target is dead or it's alive and the shackle has ended
			thisEntity:RemoveModifierByName( "modifier_shroomling_enrage" )
			thisEntity:AddNewModifier( thisEntity, nil, "modifier_shroomling_sleep", { duration = -1.0 } )			
			thisEntity.hForceAttackTarget = nil
			return 1
		end

		-- target is still valid and shackled so have at it
		AttackTargetOrder( thisEntity, thisEntity.hForceAttackTarget )
		return 1
	end

	local enemies = GetEnemyHeroesInRange( thisEntity, thisEntity.nShackledHeroSearchRadius )

	if #enemies == 0 then
		return 1
	end

	for _,enemy in pairs( enemies ) do
		if enemy ~= nil and enemy:IsAlive() then
			local hShackleDebuff = enemy:FindModifierByName( "modifier_aghsfort_shadow_shaman_shackles" )
			if hShackleDebuff ~= nil then
				thisEntity.hForceAttackTarget = enemy

				thisEntity:RemoveModifierByName( "modifier_shroomling_sleep" )
				thisEntity:AddNewModifier( thisEntity, nil, "modifier_shroomling_enrage", { duration = -1.0 } )

				--print( 'Shroomling Attacking!' )
				AttackTargetOrder( thisEntity, enemy )
				return 1
			end
		end
	end

	return 0.5
end
--]]