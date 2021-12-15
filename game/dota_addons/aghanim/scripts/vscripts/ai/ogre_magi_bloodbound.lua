
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	BloodlustAbility = thisEntity:FindAbilityByName( "ogre_magi_bloodlust" )

	thisEntity:SetContextThink( "OgreMagiBloodboundThink", OgreMagiBloodboundThink, 1 )
end

--------------------------------------------------------------------------------

function OgreMagiBloodboundThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if BloodlustAbility ~= nil and BloodlustAbility:IsChanneling() then
		return 0.5
	end

	if BloodlustAbility ~= nil and BloodlustAbility:IsFullyCastable() then
		local friendlies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		for nPass=1,3 do
			for _,friendly in pairs ( friendlies ) do
				if friendly ~= nil and friendly ~= thisEntity and friendly:FindModifierByName( "modifier_ogre_magi_bloodlust" ) == nil then
					if ( nPass == 1 and friendly:GetUnitName() == "npc_dota_creature_bloodbound_bloodseeker" )
							or ( nPass == 2 and friendly:GetUnitName() == "npc_dota_creature_bloodbound_ogre_magi" )
							or ( nPass == 3 ) then
						local fDist = ( friendly:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
						local fCastRange = BloodlustAbility:GetCastRange( thisEntity:GetOrigin(), nil )
						--print( string.format( "fDist == %d, fCastRange == %d", fDist, fCastRange ) )
						if ( fDist <= fCastRange ) and ( friendly:GetAggroTarget() ) then
							return Bloodlust( friendly )
						elseif ( nPass < 3 ) and ( fDist > 400 ) and ( fDist < 900 ) then
							return Approach( friendly )
						end
					end
				end
			end
		end
	end

	local fFuzz = RandomFloat( -0.1, 0.1 ) -- Adds some timing separation to these magi
	return 0.5 + fFuzz
end

--------------------------------------------------------------------------------

function Approach( hUnit )
	--print( "Ogre Magi is approaching unit named " .. hUnit:GetUnitName() )

	local vToUnit = hUnit:GetOrigin() - thisEntity:GetOrigin()
	vToUnit = vToUnit:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToUnit * thisEntity:GetIdealSpeed()
	})

	return 1
end

--------------------------------------------------------------------------------

function Bloodlust( hUnit )
	--print( "Casting bloodlust on " .. hUnit:GetUnitName() )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = BloodlustAbility:entindex(),
		TargetIndex = hUnit:entindex(),	
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------

