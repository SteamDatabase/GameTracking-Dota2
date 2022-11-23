
LinkLuaModifier( "modifier_eaten_by_roshan", "modifiers/gameplay/modifier_eaten_by_roshan", LUA_MODIFIER_MOTION_NONE )

local EAT_GREEVIL_STATE_NONE = -1
local EAT_GREEVIL_START = 0
local EAT_GREEVIL_ATTACK = 1 -- begin animating
local EAT_GREEVIL_GRAB = 2 -- attach greevil to roshan
local EAT_GREEVIL_EAT = 3 -- hide and kill greevil
local EAT_GREEVIL_EJECT_FILLING = 4 -- kill greevil
local EAT_GREEVIL_FINISH = 5

local EatGreevilStateTime = {}
EatGreevilStateTime[EAT_GREEVIL_START] = 0
EatGreevilStateTime[EAT_GREEVIL_ATTACK] = 0.4
EatGreevilStateTime[EAT_GREEVIL_GRAB] = 1.56
EatGreevilStateTime[EAT_GREEVIL_EAT] = 1.36
EatGreevilStateTime[EAT_GREEVIL_EJECT_FILLING] = 0.866
EatGreevilStateTime[EAT_GREEVIL_FINISH] = 0
local flEatGreevilTotalTime = 4.2
local ROAR_TIME_MIN = 5
local ROAR_TIME_MAX = 10
local ROAR_DURATION = 3.86
local SKIP_ROAR_CHANCE = 0.75

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.bActive = true
	thisEntity.nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_NONE
	thisEntity.vHomePos = nil
	thisEntity.nCandyAttackTeam = nil
	thisEntity.vRadiantBucketPos = GameRules.Winter2022.vRadiantHomeBucketLocs[1]
	thisEntity.vDireBucketPos = GameRules.Winter2022.vDireHomeBucketLocs[1]

	thisEntity.nEatGreevilState = EAT_GREEVIL_STATE_NONE
	thisEntity.hGreevilToEat = nil
	thisEntity.flEatGreevilStateTime = 0
	thisEntity.nGreevilsEaten = 0
	thisEntity.flRoarTime = 0
	thisEntity:SetShouldComputeRemainingPathLength( true )
	thisEntity:SetContextThink( "RoshanThink", RoshanThink, 0.25 )
end

function RoshanThink()
	if thisEntity == nil or thisEntity:IsNull() or thisEntity:IsAlive() == false or thisEntity.bActive == false then
		return -1
	end
	if thisEntity.vHomePos == nil then
		thisEntity.vHomePos = thisEntity:GetAbsOrigin()
	end

	if thisEntity.nCandyAttackTeam ~= nil then
		return CandyAttack( thisEntity.nCandyAttackTeam )
	end

	if thisEntity.nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_NONE then
		return 0.25
	end

	if thisEntity.nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_WAKE_UP then
		thisEntity:Stop()
		thisEntity:StartGesture( ACT_DOTA_CHANNEL_END_ABILITY_1 )

		thisEntity:AddNewModifier(nil, nil, "modifier_rooted", { duration = 2.87 } )
		thisEntity.nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_GREEVILS
		return 2.87

	elseif thisEntity.nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_GREEVILS then
		-- select greevil to eat
		if thisEntity.nEatGreevilState == EAT_GREEVIL_STATE_NONE then
			thisEntity:FadeGesture( ACT_DOTA_CHANNEL_END_ABILITY_1 )
			hGreevilToEat = FindBestGreevilTarget()
			if hGreevilToEat == nil or hGreevilToEat:IsNull() then
				-- BRAD - removing this advancement of state - this can rarely happen when all greevils have died and new ones haven't been backfilled yet
				-- just waiting a bit is fine here, he should find a new greevil as soon as it's backfilled
				--thisEntity.nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_ATTACK
				return 0.25
			end

			--print("EAT GREEVIL DEBUG: Greevil found")
			thisEntity.hGreevilToEat = hGreevilToEat
			thisEntity.nEatGreevilState = EAT_GREEVIL_START
			thisEntity.flEatGreevilStateTime = GameRules:GetDOTATime(false, true)
			-- set roar time in the future
			thisEntity.flRoarTime = GameRules:GetDOTATime( false, true ) + RandomFloat( ROAR_TIME_MIN, ROAR_TIME_MAX )
		end

		-- move to greevil
		if thisEntity.nEatGreevilState == EAT_GREEVIL_START and EnsureValidGreevil() then
			local flDist = ( thisEntity.hGreevilToEat:GetAbsOrigin() - thisEntity:GetAbsOrigin() ):Length2D()
			if flDist > WINTER2022_ROSHAN_REQUEST_PROXIMITY_DISTANCE then
				--print("EAT GREEVIL DEBUG: Moving to greevil")
				ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
					TargetIndex = thisEntity.hGreevilToEat:entindex(),
					Queue = false,
				})

				if GameRules:GetDOTATime( false, true ) > thisEntity.flRoarTime then
					--print("EAT GREEVIL DEBUG: roar")
					local hAbility = thisEntity:FindAbilityByName( "roshan_deafening_blast" )
					if hAbility ~= nil then
						--print( 'EXECUTE DEAFENING BLAST!' )
						ExecuteOrderFromTable({
							UnitIndex = thisEntity:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
							AbilityIndex = hAbility:entindex(),
							Queue = false,
						})

						-- clear greevil target and go back to the top of the state machine
						thisEntity.nEatGreevilState = EAT_GREEVIL_STATE_NONE
						thisEntity.hGreevilToEat = nil
				
						return ROAR_DURATION
					end
				end

				return 0.25
			end
		end

		-- nom
		return HandleEatGreevil()
	end

	if thisEntity.hTrickOrTreatTarget == nil then
		print( '***ROSH - TRICK OR TREAT TARGET IS NIL - RETURNING HOME' )
		return ReturnHome()
	end

	thisEntity.hTrickOrTreatTarget:RemoveModifierByName( "modifier_smoke_of_deceit" )

	if thisEntity.nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_REQUEST then
		if thisEntity.flTargetSwitchPauseTimer == nil or GameRules:GetDOTATime( false, true ) > thisEntity.flTargetSwitchPauseTimer then
			return GoToTarget( thisEntity.hTrickOrTreatTarget )
		else
			return 0.25
		end
	end

	if thisEntity.nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_ATTACK then
		return AttackTarget( thisEntity.hTrickOrTreatTarget )
	end

	print( '***ROSH - FALL THROUGH - RETURNING HOME' )
	return ReturnHome()
end

function FindBestGreevilTarget()
	--print( 'FINDING BEST GREEVIL TARGET!' )
	local hBestGreevil = nil
	--local flBestDistance = 999999999

	local hCreatures = Entities:FindAllByClassname( "npc_dota_creature" )
	local hGreevils = {}
	local nCount = 0
	for i=#hCreatures,1,-1 do
		if hCreatures[i] ~= nil and hCreatures[i]:IsNull() == false and hCreatures[i]:IsAlive() and IsGreevil( hCreatures[i], false ) then
			nCount = nCount + 1
			--[[local flDist = Dist2D( thisEntity:GetAbsOrigin(), hCreatures[i]:GetAbsOrigin() )
			if flDist < flBestDistance then
				flBestDistance = flDist
				hBestGreevil = hCreatures[i]
				--print( 'FOUND A CLOSER GREEVIL ' .. flBestDistance )
			end--]]
			hGreevils[ nCount ] = hCreatures[i]
		end
	end

	if nCount > 0 then
		hBestGreevil = hGreevils[ RandomInt( 1, nCount ) ]
	end

	return hBestGreevil
end

function CandyAttack( nTeamToAttack )
	local vAttackPos = nil
	if nTeamToAttack == DOTA_TEAM_GOODGUYS then
		vAttackPos = thisEntity.vRadiantBucketPos
	else
		vAttackPos = thisEntity.vDireBucketPos
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = vAttackPos,
		Queue = false,
	})
	return 5.0
end

function GoToTarget( hTarget )
	if hTarget == nil then
		return 0.25
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
		TargetIndex = hTarget:entindex(),
		Queue = false,
	})

	return 0.25
end

function AttackTarget( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
		Queue = false,
	})

	return 0.25
end

function GoToSleep()

	GameRules.Winter2022:GetGlobalAnnouncer():OnRoshanSleep()

	local hAbility = thisEntity:FindAbilityByName( "roshan_go_to_sleep" )
	if hAbility ~= nil then
		print( 'EXECUTE GO TO SLEEP!' )
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = hAbility:entindex(),
			Queue = false,
		})
	end
end

function ReturnHome()
	local flDistToHome = ( thisEntity.vHomePos - thisEntity:GetAbsOrigin() ):Length2D() 
	if flDistToHome < 50.0 then
		thisEntity.nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_NONE
		GameRules.Winter2022:StateTransition()

		GoToSleep()

		return 0.25
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity.vHomePos,
		Queue = false,
	})

	return 0.25
end

function OrderStop()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_STOP,
		Queue = false,
	})
	
	return 0.25
end

function HandleEatGreevil()
	local flCurrentTime = GameRules:GetDOTATime(false, true)
	local flStateTime = flCurrentTime - thisEntity.flEatGreevilStateTime

	if EatGreevilStateTime[thisEntity.nEatGreevilState] == nil then
		--print("EAT GREEVIL DEBUG: EatGreevilStateTime is nil for state"..thisEntity.nEatGreevilState..". This should never happen")
		thisEntity.nEatGreevilState = EAT_GREEVIL_STATE_NONE
		thisEntity.hGreevilToEat = nil
		return 0.25
	end

	if flStateTime >= EatGreevilStateTime[thisEntity.nEatGreevilState] then
		thisEntity.nEatGreevilState = thisEntity.nEatGreevilState + 1

		thisEntity.flEatGreevilStateTime = flCurrentTime
		
		--print("EAT GREEVIL DEBUG: State Changed to "..thisEntity.nEatGreevilState)
		EnterEatGreevilState()
	end

	return 0.1
end

function EnterEatGreevilState()
	if thisEntity.nEatGreevilState == EAT_GREEVIL_ATTACK then
		if EnsureValidGreevil() then
			--print("EAT GREEVIL DEBUG: attack")
			thisEntity:Stop()
			thisEntity:StartGesture( ACT_DOTA_CAST_ABILITY_6 )

			thisEntity:AddNewModifier(nil, nil, "modifier_rooted", { duration = flEatGreevilTotalTime } )
			thisEntity.hGreevilToEat:AddNewModifier(nil, nil, "modifier_eaten_by_roshan", {} )

			EmitSoundOn( "Roshan.Preattack", GameRules.Winter2022.hRoshan )
		end
	elseif thisEntity.nEatGreevilState == EAT_GREEVIL_GRAB then
		if EnsureValidGreevil() then
			--print("EAT GREEVIL DEBUG: grab")
			thisEntity.hGreevilToEat:FollowEntityMerge(thisEntity, "attach_attack2")
			thisEntity.hGreevilToEat:StartGesture( ACT_DOTA_CHANNEL_ABILITY_1 )
			EmitSoundOn( "Roshan.Grab.Greevil", GameRules.Winter2022.hRoshan )
		end
	elseif thisEntity.nEatGreevilState == EAT_GREEVIL_EAT then
		if EnsureValidGreevil() then
			--print("EAT GREEVIL DEBUG: nom")

			local hFillingBuff = thisEntity.hGreevilToEat:FindModifierByName( "modifier_greevil_filling" )
			if hFillingBuff then
				local vColor = WINTER2022_GREEVIL_FILLING_COLORS[ hFillingBuff:GetFillingType() ]
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/greevils/greevil_blood.vpcf", PATTACH_CUSTOMORIGIN, item )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, GameRules.Winter2022.hRoshan, PATTACH_POINT_FOLLOW, "attach_hitloc", GameRules.Winter2022.hRoshan:GetAbsOrigin(), true )
				ParticleManager:SetParticleControl( nFXIndex, 1, GameRules.Winter2022.hRoshan:GetAbsOrigin() )
				ParticleManager:SetParticleControlForward( nFXIndex, 1, -GameRules.Winter2022.hRoshan:GetForwardVector() )
				ParticleManager:SetParticleControl( nFXIndex, 10, vColor )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
	
			EmitSoundOn( "Roshan.Eat.Greevil", GameRules.Winter2022.hRoshan )

			thisEntity.hGreevilToEat:FollowEntity(nil, false)
			thisEntity.hGreevilToEat:AddEffects( EF_NODRAW )
		end
	elseif thisEntity.nEatGreevilState == EAT_GREEVIL_EJECT_FILLING then
		if EnsureValidGreevil() then
			--print("EAT GREEVIL DEBUG: eject filling")

			local hFillingBuff = thisEntity.hGreevilToEat:FindModifierByName( "modifier_greevil_filling" )
			if hFillingBuff then
				hFillingBuff:EjectFilling( true, thisEntity )

				local vColor = WINTER2022_GREEVIL_FILLING_COLORS[ hFillingBuff:GetFillingType() ]
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/greevils/greevil_blood_spit.vpcf", PATTACH_CUSTOMORIGIN, item )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, GameRules.Winter2022.hRoshan, PATTACH_POINT_FOLLOW, "attach_hitloc", GameRules.Winter2022.hRoshan:GetAbsOrigin(), true )
				ParticleManager:SetParticleControl( nFXIndex, 1, GameRules.Winter2022.hRoshan:GetAbsOrigin() )
				ParticleManager:SetParticleControlForward( nFXIndex, 1, -GameRules.Winter2022.hRoshan:GetForwardVector() )
				ParticleManager:SetParticleControl( nFXIndex, 10, vColor )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
		
				EmitSoundOn( "Roshan.Greevil.Splatter", GameRules.Winter2022.hRoshan )
			end			
			thisEntity.hGreevilToEat:ForceKill(false)
			thisEntity.hGreevilToEat = nil
			thisEntity.nGreevilsEaten = thisEntity.nGreevilsEaten + 1
		end
	elseif thisEntity.nEatGreevilState == EAT_GREEVIL_FINISH then
		--print("EAT GREEVIL DEBUG: done!")

		thisEntity:RemoveModifierByName( "modifier_rooted" )
		thisEntity:FadeGesture( ACT_DOTA_CAST_ABILITY_6 )
		thisEntity.nEatGreevilState = EAT_GREEVIL_STATE_NONE
	end
end

function EnsureValidGreevil()
	if thisEntity.hGreevilToEat == nil or thisEntity.hGreevilToEat:IsNull() or not thisEntity.hGreevilToEat:IsAlive() then
		thisEntity:RemoveModifierByName( "modifier_rooted" )
		thisEntity.nEatGreevilState = EAT_GREEVIL_STATE_NONE
		return false
	end
	return true
end