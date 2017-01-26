
--Meteor
local s_nGhostWalkHPPct = 50.0

function CheckToCastMeteor( caster, ability )
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
	if #enemies == 0 or enemies == nil then
		return false
	end

	return true
end

function CastMeteor( caster, ability )
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, ability:GetCastRange( nil, nil ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
	if #enemies > 0 then
		local hTarget = nil
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil then
				if enemy:IsStunned() and not enemy:IsInvulnerable() then
					hTarget = enemy
				end

				if enemy:IsInvulnerable() then
					local hTornado = enemy:FindModifierByName( "modifier_invoker_tornado" )
					if hTornado ~= nil and hTornado:GetElapsedTime() > 1.8 then
						hTarget = enemy
					end

					local hEuls = enemy:FindModifierByName( "modifier_eul_cyclone" )
					if hEuls ~= nil and hEuls:GetElapsedTime() > 1.8 then
						hTarget = enemy
					end
				end
			end
		end

		if hTarget ~= nil then
			ExecuteOrderFromTable({
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				Position = hTarget:GetOrigin(),
				AbilityIndex = ability:entindex()
				})
		end
	end
end

--SunStrike

function CheckToCastSunStrike( caster, ability )
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
	if #enemies == 0 or enemies == nil then
		return false
	end

	return true
end

function CastSunStrike( caster, ability )
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
	if #enemies > 0 then
		local hTarget = nil
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil then
				if enemy:IsStunned() and not enemy:IsInvulnerable() then
					hTarget = enemy
				end

				local hTornado = enemy:FindModifierByName( "modifier_invoker_tornado" )
				if hTornado ~= nil and hTornado:GetElapsedTime() > 1.8 then
					hTarget = enemy
				end

				local hEuls = enemy:FindModifierByName( "modifier_eul_cyclone" )
				if hEuls ~= nil and hEuls:GetElapsedTime() > 1.8 then
					hTarget = enemy
				end
			end
		end

		if hTarget ~= nil and ability:IsFullyCastable() then
			ExecuteOrderFromTable({
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				Position = hTarget:GetOrigin(),
				AbilityIndex = ability:entindex()
			})

			EmitSoundOnLocationForAllies( hTarget:GetOrigin(), "Hero_Invoker.SunStrike.Charge", hTarget )

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_WORLDORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, hTarget:GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 50, 1, 1 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
	end
end

--Ice Wall

function CheckToCastIceWall( caster, ability )
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	if #enemies == 0 or enemies == nil then
		return false
	end

	return true
end

function CastIceWall( caster, ability )
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	if #enemies > 0 then
		ExecuteOrderFromTable({
		UnitIndex = caster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = ability:entindex(),
		})
	end
end

-- Forged Spirit

function CheckToCastForgedSpirit( caster, ability )
	return ability:IsFullyCastable()
end


function CastForgedSpirit( caster, ability )
	ExecuteOrderFromTable({
		UnitIndex = caster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = ability:entindex()
	})
end

-- Euls

function CheckToCastEuls( caster, ability ) 
	if ability:IsFullyCastable() == false then
		return false
	end

	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	if #enemies == 0 or enemies == nil then
		return false
	end

	if caster:IsStunned() and #enemies > 2 then
		return true
	end

	return true
end

function CastEuls( caster, ability ) 
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	if #enemies == 0 or enemies == nil then
		return false
	end

	local hTarget = nil
	for _,enemy in pairs( enemies ) do
		if enemy ~= nil then
			if RandomInt( 0, 1 ) == 1 then
				hTarget = enemy
			end
		end
	end

	if caster:IsStunned() and #enemies > 2 then
		hTarget = caster
	end

 	if hTarget ~= nil then
		ExecuteOrderFromTable({
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				AbilityIndex = ability:entindex(),
				TargetIndex = hTarget:entindex()
			})
	end
end

-- Blink

function CheckToCastBlink( caster, ability )
	if ability:IsFullyCastable() == false then
		return false
	end

	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	if #enemies > 2 then
		return true
	end

	return true
end

function CastBlink( caster, ability )
	local vLocation = caster:GetOrigin()
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), vLocation, caster, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	
	if caster:GetHealthPercent() > 50 then
		if #enemies > 2 then
			local enemy = enemies[RandomInt( 1,#enemies)]
			if enemy ~= nil then
				vLocation = enemy:GetOrigin()
			end
		end
	else
		local friendlies = FindUnitsInRadius( caster:GetTeamNumber(), vLocation, caster, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #friendlies > 0 then
			local friendly = friendlies[1]
			if friendly ~= nil then
				vLocation = friendly:GetOrigin()
			end
		end
	end
	
	if vLocation ~= caster:GetOrigin() then
		ExecuteOrderFromTable({
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = vLocation,
			AbilityIndex = ability:entindex()
			})
	end
end

-- ColdSnap

function CheckToCastColdSnap( caster, ability )
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	if #enemies == 0 or enemies == nil then
		return false
	end

	return true
end

function CastColdSnap( caster, ability )
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	if #enemies > 0 then
		ExecuteOrderFromTable({
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			AbilityIndex = ability:entindex(),
			TargetIndex = enemies[1]:entindex()
		})
	end
end

-- Sheep

function CheckToCastSheep( caster, ability )
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	if #enemies == 0 or enemies == nil then
		return false
	end

	return ability:IsFullyCastable() 
end

function CastSheep( caster, ability )
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	if #enemies > 0 then
		ExecuteOrderFromTable({
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			AbilityIndex = ability:entindex(),
			TargetIndex = enemies[1]:entindex()
		})
	end
end

--Tornado

function CheckToCastTornado( caster, ability )
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, 2400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	if #enemies == 0 or enemies == nil then
		return false
	end

	return true
end

function CastTornado( caster, ability )
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, 2400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	if #enemies > 0 then
		ExecuteOrderFromTable({
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = enemies[1]:GetOrigin(),
			AbilityIndex = ability:entindex()
		})
	end
end

--GhostWalk

function CheckToCastGhostWalk( caster, ability )
	local nHealthPct = caster:GetHealthPercent()
	if nHealthPct > s_nGhostWalkHPPct then
		return false
	end
	
	return true
end

function CastGhostWalk( caster, ability )
	ExecuteOrderFromTable({
		UnitIndex = caster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = ability:entindex()
	})

	ExecuteOrderFromTable({
		UnitIndex = caster:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = Vector( 2183, -333, 320 ) + RandomVector( 2500 )
	})
end

-- Phase Boots

function CheckToCastPhase( caster, ability )
	return ability:IsFullyCastable()
end

function CastPhase( caster, ability )
	ExecuteOrderFromTable({
		UnitIndex = caster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = ability:entindex()
	})
end

--ForceStaff

function CheckToCastForce( caster, ability )
	return ability:IsFullyCastable()
end

function CastForce( caster, ability )
	ExecuteOrderFromTable({
		UnitIndex = caster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = caster:entindex(),
		AbilityIndex = ability:entindex()
	})
end

--Alacrity

function CheckToCastAlacrity( caster, ability )
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	if #enemies == 0 or enemies == nil then
		return false
	end

	return true
end

function CastAlacrity( caster, ability )
	ExecuteOrderFromTable({
		UnitIndex = caster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = ability:entindex(),
		TargetIndex = caster:entindex()
	})
end

--EMP

function CheckToCastEMP( caster, ability )
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	if #enemies == 0 or enemies == nil then
		return false
	end

	return true
end

function CastEMP( caster, ability )
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	if #enemies > 0 then
		ExecuteOrderFromTable({
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = enemies[1]:GetOrigin(),
			AbilityIndex = ability:entindex(),
			TargetIndex = caster:entindex()
		})
	end
end


--Deafening Blast

function CheckToCastDeafeningBlast( caster, ability )
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	if #enemies > 2 then
		return true
	end

	return false
end

function CastDeafeningBlast( caster, ability )
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	if #enemies > 2 then
		ExecuteOrderFromTable({
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = caster:GetOrigin() + ( caster:GetForwardVector() * 50 ),
			AbilityIndex = ability:entindex(),
			TargetIndex = caster:entindex()
		})
	end
end













