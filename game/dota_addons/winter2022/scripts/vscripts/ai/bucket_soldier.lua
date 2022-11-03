local BUCKET_SOLDIER_STATE_IDLE				= 0
local BUCKET_SOLDIER_STATE_ATTACKING		= 1
local BUCKET_SOLDIER_STATE_LEASHED			= 2
local BUCKET_SOLDIER_STATE_SCREAM_ATTACK	= 3

--------------------------------------------------------------------------------

if CBucketSoldier == nil then
	CBucketSoldier = class({})
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:SetContextThink( "BucketSoldierThink", BucketSoldierThink, 0.1 )
	thisEntity.AI = CBucketSoldier( thisEntity )
end

-----------------------------------------------------------------------------------------------------

function BucketSoldierThink()
	if IsServer() == false then
		return -1
	end

	local fThinkTime = thisEntity.AI:BotThink()
	if fThinkTime then
		return fThinkTime
	end

	return 0.1
end

-----------------------------------------------------------------------------------------------------

function CBucketSoldier:constructor( me )
	self.me = me

	self.flNextPatrolTime = GameRules:GetGameTime() + 2.0
	self.flMaxLeashTime = nil
	self.nState = BUCKET_SOLDIER_STATE_IDLE
	self.hAbilityScream = self.me:FindAbilityByName( "diretide_bucket_soldier_scream" )
	self.hAttackTarget = nil
end

-----------------------------------------------------------------------------------------------------

function CBucketSoldier:ChangeBotState( nNewState )
	if self.nState ~= nNewState then
		if nNewState == BUCKET_SOLDIER_STATE_IDLE then
			-- always refresh patrol time when we enter idle state
			self.flNextPatrolTime = GameRules:GetGameTime() + 2.0
		elseif nNewState == BUCKET_SOLDIER_STATE_LEASHED then
			self:LeashToBucket()
		elseif self.nState ~= BUCKET_SOLDIER_STATE_SCREAM_ATTACK and nNewState == BUCKET_SOLDIER_STATE_ATTACKING then
			if self.hAttackTarget ~= nil and self.hAttackTarget:IsNull() == false and self.hAttackTarget:IsRealHero() then
				local hAnnouncer = GameRules.Winter2022:GetTeamAnnouncer( self.me:GetTeamNumber() )
				if hAnnouncer ~= nil then
					hAnnouncer:OnTaffyGuardianAggro()
				end
			end
		end
	end

	self.nState = nNewState
end

--------------------------------------------------------------------------------

function CBucketSoldier:BotThink()
	if self.me == nil or self.me:IsNull() or ( not self.me:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if not IsServer() then
		return
	end

	if self.vInitialSpawnPos == nil then
		if self.hBucket ~= nil then
			--print( 'GOLEM USING BUCKET POS!' )
			self.vInitialSpawnPos = self.hBucket:GetAbsOrigin()
		else
			self.vInitialSpawnPos = self.me:GetAbsOrigin()
		end
	end

	--print( 'Bucket Soldier think - state is ' .. tonumber( self.nState ) )

	if self.nState == BUCKET_SOLDIER_STATE_IDLE then
		if self:ShouldLeash() == true then
			self:ChangeBotState( BUCKET_SOLDIER_STATE_LEASHED )
			return 0.1
		end

		local hTarget = self:FindBestTarget()
		if hTarget ~= nil then
			self.hAttackTarget = hTarget
			self:ChangeBotState( BUCKET_SOLDIER_STATE_ATTACKING )
			return 0.1
		end

		if GameRules:GetGameTime() > self.flNextPatrolTime then
			-- give a patrol order and set the next patrol time
			--print( 'PATROLING!' )
			local flWaitTime = self:PatrolBucket()
			self.flNextPatrolTime = GameRules:GetGameTime() + flWaitTime
		end

	elseif self.nState == BUCKET_SOLDIER_STATE_ATTACKING then
		if self:ShouldLeash() == true then
			self:ChangeBotState( BUCKET_SOLDIER_STATE_LEASHED )
			return 0.1
		end

		-- special case - if the current target is valid but NOT a real hero, we should update the targeting to attempt to find a better hero target to stick to
		-- otherwise we're going to stick to the initial aggro'd target until it goes bad, then loop back into IDLE state to find a new one
		if self.hAttackTarget ~= nil and self.hAttackTarget:IsNull() == false and self.hAttackTarget:IsRealHero() == false then
			self.hAttackTarget = self:FindBestTarget()
		end

		if self.hAttackTarget == nil or self.hAttackTarget:IsNull() == true or self.hAttackTarget:IsAlive() == false then
			--print( 'TARGET WENT BAD - RETURNING TO IDLE' )

			self:ChangeBotState( BUCKET_SOLDIER_STATE_IDLE )
			return 0.1
		end

		self:AttackTarget( self.hAttackTarget )
		--print( 'ATTACKING TARGET! ' .. self.hAttackTarget:GetUnitName() )

		if self.hAbilityScream and self.hAbilityScream:IsFullyCastable() then
			self:ChangeBotState( BUCKET_SOLDIER_STATE_SCREAM_ATTACK )
		end

	elseif self.nState == BUCKET_SOLDIER_STATE_LEASHED then
		if GameRules:GetGameTime() > self.flMaxLeashTime then
			self:ChangeBotState( BUCKET_SOLDIER_STATE_IDLE )
			return 0.1
		end

		local flDist = ( self.vLeashDestination - self.me:GetAbsOrigin() ):Length2D()
		if flDist < 200 then
			self:ChangeBotState( BUCKET_SOLDIER_STATE_IDLE )
			return 0.1
		end

		-- if we're leashing back but we're pretty close to the bucket, then start looking for aggro targets
		flDist = ( self.vInitialSpawnPos - self.me:GetAbsOrigin() ):Length2D()
		if flDist < WINTER2022_BUCKET_SOLDIER_LEASHING_REACTIVATE_RANGE then
			local hTarget = self:FindBestTarget()
			if hTarget ~= nil then
				self.hAttackTarget = hTarget
				self:ChangeBotState( BUCKET_SOLDIER_STATE_ATTACKING )
				return 0.1
			end
		end

		ExecuteOrderFromTable({
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = self.vLeashDestination,
			Queue = false,
		})
	
	elseif self.nState == BUCKET_SOLDIER_STATE_SCREAM_ATTACK then
		if self:ShouldLeash() == true then
			self:ChangeBotState( BUCKET_SOLDIER_STATE_LEASHED )
			return 0.1
		end

		if self.hAttackTarget == nil or self.hAttackTarget:IsNull() == true or self.hAttackTarget:IsAlive() == false then
			self:ChangeBotState( BUCKET_SOLDIER_STATE_IDLE )
		end

		if self.hAbilityScream == nil then
			self:ChangeBotState( BUCKET_SOLDIER_STATE_IDLE )
		end
		
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hAbilityScream:entindex(),
			Position = self.hAttackTarget:GetAbsOrigin(),
		} )
		
		if not self.hAbilityScream:IsFullyCastable() then
			self:ChangeBotState( BUCKET_SOLDIER_STATE_ATTACKING )
		end
	end

	return 0.1
end

-----------------------------------------------------------------------------------------

function CBucketSoldier:LeashToBucket()
	self.vLeashDestination = self.vInitialSpawnPos + RandomVector( RandomInt( 50, WINTER2022_BUCKET_SOLDIER_MAINTAIN_RANGE ) )
	--DebugDrawSphere( self.vLeashDestination, Vector(255,0,0), 0.8, 50, false, 0.75 )
	self.flMaxLeashTime = GameRules:GetGameTime() + WINTER2022_BUCKET_SOLDIER_MAX_LEASH_TIME
end

-----------------------------------------------------------------------------------------------------

function CBucketSoldier:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
	} )
end

-----------------------------------------------------------------------------------------

function CBucketSoldier:PatrolBucket()
	local vTargetPos = self.vInitialSpawnPos + RandomVector( RandomInt( 50, WINTER2022_BUCKET_SOLDIER_MAINTAIN_RANGE ) )
	local flDist = ( vTargetPos - self.me:GetAbsOrigin() ):Length2D()

	ExecuteOrderFromTable({
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = vTargetPos,
		Queue = false,
	})

	local fSleepTime = ( flDist / self.me:GetIdealSpeed() ) + RandomInt( 3.0, 10.0 )
	--print( '***BUCKET SOLDIER PATROL N WAIT FOR ' .. fSleepTime )

	return fSleepTime
end

-----------------------------------------------------------------------------------------

function CBucketSoldier:FindBestTarget()
	--local fSearchRadius = self.me:GetAcquisitionRange()
	local fSearchRadius = WINTER2022_BUCKET_SOLDIER_AGGRO_RANGE
	local vSearchOrigin = self.me:GetAbsOrigin()
	if self.hBucket ~= nil and self.hBucket:IsNull() == false and self.hBucket:IsAlive() == true then
		--print( 'GOLEM USING BUCKET POS FOR AGGRO!' )
		vSearchOrigin = self.hBucket:GetAbsOrigin()
	end

	--DebugDrawSphere( vSearchOrigin, Vector(255,255,0), 0.8, fSearchRadius, false, 0.75 )

	local Units = FindUnitsInRadius( self.me:GetTeamNumber(), vSearchOrigin, self.me, fSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	--print( 'FOUND SOME HEREOES? ' .. #Units )
	local hBestNonHero = nil
	if #Units > 0 then
		-- prioritize heroes
		for _,hUnit in pairs( Units ) do
			if hUnit ~= nil and hUnit:IsNull() == false and hUnit:GetTeam() ~= DOTA_TEAM_NEUTRALS and hUnit:IsAlive() and hUnit:IsInvulnerable() == false then
				if hUnit:IsRealHero() then
					--print( 'BEST UNIT = ' .. hUnit:GetUnitName() )
					return hUnit
				else
					if hBestNonHero == nil then
						hBestNonHero = hUnit
					end
				end
			end
		end
	end

	return hBestNonHero
end

-----------------------------------------------------------------------------------------

function CBucketSoldier:ShouldLeash()
	local flDist = ( self.vInitialSpawnPos - self.me:GetAbsOrigin() ):Length2D()
	--DebugDrawSphere( self.vInitialSpawnPos, Vector(128,128,0), 0.8, WINTER2022_BUCKET_SOLDIER_LEASH_RANGE, false, 0.2 )	
	if flDist > WINTER2022_BUCKET_SOLDIER_LEASH_RANGE then
		return true
	end

	return false
end
