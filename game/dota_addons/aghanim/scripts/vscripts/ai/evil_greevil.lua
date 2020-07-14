
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	AttachEffects()

	thisEntity.vInitialSpawnPos = nil
	thisEntity.bInitialized = false
	local retreatPoints = Entities:FindAllByName( "retreat_point" )
	if retreatPoints == nil then
		print( "*** WARNING: This AI requires info_targets named retreat_point in the map " .. thisEntity.Encounter:GetRoom():GetName() )
		return
	end
	local happyPlaceIndex =  RandomInt( 1, #retreatPoints )
	thisEntity.vRetreatPoint = retreatPoints[ happyPlaceIndex ]:GetAbsOrigin()

	thisEntity.imprisonAbility = thisEntity:FindAbilityByName( "obsidian_destroyer_astral_imprisonment" )
	thisEntity:SetContextThink( "EvilGreevilThink", EvilGreevilThink, 0.1 )
end

--------------------------------------------------------------------------------

function AttachEffects()
	--local effect_name = "particles/units/unit_greevil/greevil_blackhole.vpcf"
	local effect_name = "particles/creatures/greevil/greevil_prison_bottom_ring.vpcf"
	local effect = ParticleManager:CreateParticle( effect_name, PATTACH_POINT_FOLLOW, thisEntity )
	ParticleManager:SetParticleControlEnt( effect, 0, thisEntity, PATTACH_POINT_FOLLOW, nil, thisEntity:GetOrigin(), true )
	--[[
	local right_eyeTable = 
		{
			origin = "0 0 0",
			angles = "0 0 0",
			targetname = "eye_model",
			model = "models/particle/mesh/slumbering_terror_eyes.vmdl",
			scales = "0.5 0.5 0.5",
		}
	local hRightEye = SpawnEntityFromTableSynchronous( "prop_dynamic", right_eyeTable )
	hRightEye:SetParent( thisEntity, "attach_eye_r" )
	local left_eyeTable = 
		{
			origin = "0 0 0",
			angles = "0 0 0",
			targetname = "eye_model",
			model = "models/particle/mesh/slumbering_terror_eyes.vmdl",
			scales = "0.5 0.5 0.5",
		}
	local hLeftEye = SpawnEntityFromTableSynchronous( "prop_dynamic", left_eyeTable )
	hLeftEye:SetParent( thisEntity, "attach_eye_l" )
	]]
end

--------------------------------------------------------------------------------

function EvilGreevilThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #enemies > 0 then
		--print("Enemy is near")
		local target = enemies[1]
		if thisEntity.imprisonAbility ~= nil and thisEntity.imprisonAbility:IsCooldownReady() then
			return CastImprison( target )
		end
	end
	if not thisEntity.bInitialized then
		thisEntity.vInitialSpawnPos = thisEntity:GetAbsOrigin()
		thisEntity.bInitialized = true
	end
	local vPos = thisEntity:GetAbsOrigin()
	local difference = vPos - thisEntity.vInitialSpawnPos
	local distance = difference:Length()
	if distance < 25 then
		--print("Move to retreat point")
		--RunAround( thisEntity.vRetreatPoint )
		thisEntity:MoveToPosition( thisEntity.vRetreatPoint )
	elseif distance > 150 then
		--print("Move to home")
		--RunAround( thisEntity.vInitialSpawnPos )
		thisEntity:MoveToPosition( thisEntity.vInitialSpawnPos )
	end

	return .1
end

--------------------------------------------------------------------------------

function CastImprison( target )
	--print("Casting Astral Imprisonment")
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 1.3 } )
	local difference = target:GetAbsOrigin() - thisEntity:GetAbsOrigin()
	local distance = difference:Length()
	if distance < thisEntity.imprisonAbility:GetCastRange() then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			TargetIndex = target:entindex(),
			AbilityIndex = thisEntity.imprisonAbility:entindex(),
			Queue = false,
		})
	else
		print("Enemy escaped")
		print(distance)
	end

	return 1
end

--------------------------------------------------------------------------------

function RunAround( position )
	local destination = position
	ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = destination
		})

	return 1
end

--------------------------------------------------------------------------------