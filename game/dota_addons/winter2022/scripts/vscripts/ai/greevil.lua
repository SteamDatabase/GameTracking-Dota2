require( "winter2022_utility_functions" )

local GREEVIL_STATE_SPAWN				= 0
local GREEVIL_STATE_IDLE				= 1
local GREEVIL_STATE_STEAL_FROM_ROSHAN	= 2
local GREEVIL_STATE_LEADER_RUN			= 3
local GREEVIL_STATE_CHASE_LEADER		= 4
local GREEVIL_STATE_FLEE_FROM_DAMAGE 	= 5
local GREEVIL_STATE_BURROW				= 6
local GREEVIL_STATE_ROSHANBOUNCE		= 7
local GREEVIL_STATE_FLEE_RANDOMLY		= 8
local GREEVIL_STATE_STEAL_FROM_WELL		= 9

--------------------------------------------------------------------------------

if CGreevil == nil then
	CGreevil = class({})
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "GreevilThink", GreevilThink, 0.1 )
		thisEntity.AI = CGreevil( thisEntity )

		thisEntity.hEntityHurtGameEvent = ListenToGameEvent( "entity_hurt", Dynamic_Wrap( thisEntity:GetPrivateScriptScope(), 'OnEntityHurt' ), nil )
	end
end

--------------------------------------------------------------------------------

function UpdateOnRemove()
	StopListeningToGameEvent( thisEntity.hEntityHurtGameEvent )
end

--------------------------------------------------------------------------------

function Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_meepo/meepo_burrow_end.vpcf", context )
	--PrecacheResource( "particle", "particles/creatures/catapult/catapult_projectile.vpcf", context )
end

-----------------------------------------------------------------------------------------------------

function GreevilThink()
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

function CGreevil:constructor( me )
	self.me = me

	self.nState = GREVIL_STATE_SPAWN
	self.flKillTime = -1

	self.flRunDuration = 20
	self.flBurrowDuration = 1.0
	self.flChooseNewRunDestinationTime = 3
	self.flLeaderInitialRunIntervalTime = 5

	self.flFleeFromDamageDistance = 800
	self.flFleeDurationMin = 2.0
	self.flFleeDurationMax = 3.0

	self.fLeaderRunDistanceMin = 800
	self.fLeaderRunDistanceMax = 1500

	self.vRoshPitCenter = GameRules.Winter2022.hRoshanPitCenter:GetAbsOrigin()
	self.fValidRangeFromRoshPitMin = 700
	self.fValidRangeFromRoshPitMax = 2500

	self.bIsLeader = false
	if me:GetUnitName() == "npc_dota_greevil_leader" then
		self.bIsLeader = true
		thisEntity:AddNewModifier( thisEntity, nil, "modifier_phased", { duration = -1 } )
	end
	
	--thisEntity:AddNewModifier( thisEntity, nil, "modifier_greevil_has_no_candy", { duration = -1 } )
end

--------------------------------------------------------------------------------

function CGreevil:BotThink()
	if self.me == nil or self.me:IsNull() or ( not self.me:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if not IsServer() then
		return
	end

	if self.nState == GREVIL_STATE_SPAWN then
		local nFXindex = ParticleManager:CreateParticle( "particles/units/heroes/hero_meepo/meepo_burrow_end.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( nFXindex, 0, self.me:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXindex )

		self.nState = GREEVIL_STATE_IDLE
			
	elseif self.nState == GREEVIL_STATE_IDLE then
		-- go to rosh pit
		self:ExecuteMoveToRoshPitOrder()

		--print( '^GREEVIL - GOING TO STEAL CANDY' )
		self.nState = GREEVIL_STATE_STEAL_FROM_ROSHAN

	elseif self.nState == GREEVIL_STATE_STEAL_FROM_ROSHAN then
		-- wait till we arrive at rosh pit

		local flDist = ( self.vStealCandyDestination - self.me:GetAbsOrigin() ):Length2D()
		if flDist < 200 then
			EmitSoundOn( "Greevil.StealCandy.Yoink", self.me )

			--thisEntity:RemoveModifierByName("modifier_greevil_has_no_candy")

			if self.bIsLeader == true then
				--print( '^GREEVIL LEADER - STARTING TO RUN' )
				local nNumRadiantBuckets = GameRules.Winter2022:GetRemainingCandyBuckets( DOTA_TEAM_GOODGUYS )
				local nNumDireBuckets = GameRules.Winter2022:GetRemainingCandyBuckets( DOTA_TEAM_BADGUYS )

				-- run towards the losing side if possible
				if nNumRadiantBuckets > nNumDireBuckets then
					print( 'RADIANT IS AHEAD! GREEVIL LEADER RUNNING TO DIRE SIDE!' )
					self.vInitialRunPosition = GameRules.Winter2022.vGreevilFleeLocsDireFavored[ RandomInt( 1, #GameRules.Winter2022.vGreevilFleeLocsDireFavored ) ]
				elseif nNumDireBuckets > nNumRadiantBuckets then
					print( 'DIRE IS AHEAD! GREEVIL LEADER RUNNING TO RADIANT SIDE!' )
					self.vInitialRunPosition = GameRules.Winter2022.vGreevilFleeLocsRadiantFavored[ RandomInt( 1, #GameRules.Winter2022.vGreevilFleeLocsRadiantFavored ) ]
				else
					-- run randomly in a tie
					print( 'TIE! GREEVIL LEADER IS RUNNING RANDOMLY!' )
					self.vInitialRunPosition = GameRules.Winter2022.vGreevilFleeLocs[ RandomInt( 1, #GameRules.Winter2022.vGreevilFleeLocs ) ]
				end

				--DebugDrawSphere( self.vInitialRunPosition, Vector(0,0,255), 0.8, 200, false, self.flLeaderInitialRunIntervalTime )

				ExecuteOrderFromTable({
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
					Position = self.vInitialRunPosition,
					Queue = false,
				})

				self.nState = GREEVIL_STATE_LEADER_RUN
				return self.flLeaderInitialRunIntervalTime	-- a bit longer to ensure that we get to the appropriate point
			else
				--print( '^GREEVIL - GOING TO CHASE THE LEADER' )
				self:ChaseLeader()
				self.nState = GREEVIL_STATE_CHASE_LEADER
				return self.flChooseNewRunDestinationTime
			end
		else
			self:ExecuteMoveToRoshPitOrder()
		end

	elseif self.nState == GREEVIL_STATE_LEADER_RUN then
		--DebugDrawSphere( self.vRoshPitCenter, Vector(255,0,0), 0.8, self.fValidRangeFromRoshPitMin, false, 0.75 )
		--DebugDrawSphere( self.vRoshPitCenter, Vector(0,255,0), 0.8, self.fValidRangeFromRoshPitMax, false, 1.0 )

		--DebugDrawSphere( self.me:GetAbsOrigin(), Vector(255,0,0), 0.8, self.fLeaderRunDistanceMin, false, 0.75 )
		--DebugDrawSphere( self.me:GetAbsOrigin(), Vector(0,0,255), 0.8, self.fLeaderRunDistanceMax, false, 1.0 )

		local vRunPosition = GetRandomPathablePositionWithin( self.me:GetAbsOrigin(), self.fLeaderRunDistanceMax, self.fLeaderRunDistanceMin, self.vRoshPitCenter, self.fValidRangeFromRoshPitMin, self.fValidRangeFromRoshPitMax )
		if vRunPosition == nil then
			-- fall back to our initial run position if we fail to find a good run loc
			vRunPosition = self.vInitialRunPosition
		end

		ExecuteOrderFromTable({
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = vRunPosition,
			Queue = false,
		})

		--print( '^GREEVIL - CHOOSING NEW DESTINATION' )
		return self.flChooseNewRunDestinationTime

	elseif self.nState == GREEVIL_STATE_CHASE_LEADER then
		self:ChaseLeader()
		return self.flChooseNewRunDestinationTime

	elseif self.nState == GREEVIL_STATE_FLEE_FROM_DAMAGE then

		local bChaseLeader = false
		local flDist = ( self.vFleePosition - self.me:GetAbsOrigin() ):Length2D()
		--print( '^DISTANCE TO FLEE POSITION = ' .. flDist )
		if flDist < 200 then
			--print( '^GREEVIL MADE IT TO FLEE POSITION! TIME TO FIND THE LEADER AGAIN' )
			bChaseLeader = true
		elseif GameRules:GetGameTime() > self.flFleeTime then
			--print( '^GREEVIL TIMED OUT RUNNING FROM DAMAGE! TIME TO FIND THE LEADER AGAIN' )
			bChaseLeader = true
		end

		if bChaseLeader == true then
			self:ChaseLeader()
			self.nState = GREEVIL_STATE_CHASE_LEADER
			return self.flChooseNewRunDestinationTime
		end

		ExecuteOrderFromTable({
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = self.vFleePosition,
			Queue = false,
		})

		return 0.1

	elseif self.nState == GREEVIL_STATE_ROSHANBOUNCE then
		if GameRules:GetGameTime() > self.flBurrowTime then
			self:Burrow()
		end

	elseif self.nState == GREEVIL_STATE_BURROW then

		if GameRules:GetGameTime() > self.flKillTime then
			print( '^GREEVIL - BURROW FINISHED - TIME TO DIE' )
			local hFilling = self.me:FindModifierByName( "modifier_greevil_filling" )
			if hFilling ~= nil then
				hFilling:SetFillingEjected( true )
			end
			self.me:AddEffects( EF_NODRAW )
			self.me:AddNewModifier( self.me, nil, "modifier_kill", { duration = 0.1 } )	-- ForceKill() here was making a one-frame pop that looked bad
			return -1
		end

		return 0.1

	elseif self.nState == GREEVIL_STATE_FLEE_RANDOMLY then
		--print( '^GREEVIL - FLEEING RANDOMLY' )
		--DebugDrawSphere( self.vRoshPitCenter, Vector(255,0,0), 0.8, self.fValidRangeFromRoshPitMin, false, 0.75 )
		--DebugDrawSphere( self.vRoshPitCenter, Vector(0,255,0), 0.8, self.fValidRangeFromRoshPitMax, false, 1.0 )

		--DebugDrawSphere( self.me:GetAbsOrigin(), Vector(255,0,0), 0.8, self.fLeaderRunDistanceMin, false, 0.75 )
		--DebugDrawSphere( self.me:GetAbsOrigin(), Vector(0,0,255), 0.8, self.fLeaderRunDistanceMax, false, 1.0 )

		if self:ChaseLeader() == true then
			--print( '^^^RUNNING TO LEADER!' )
			self.nState = GREEVIL_STATE_CHASE_LEADER
			return self.flChooseNewRunDestinationTime
		end

		local vRunPosition = GetRandomPathablePositionWithin( self.me:GetAbsOrigin(), self.fLeaderRunDistanceMax, self.fLeaderRunDistanceMin, self.vRoshPitCenter, self.fValidRangeFromRoshPitMin, self.fValidRangeFromRoshPitMax )
		if vRunPosition == nil then
			-- fall back to our initial run position if we fail to find a good run loc
			vRunPosition = self.vInitialRunPosition
		end

		ExecuteOrderFromTable({
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = vRunPosition,
			Queue = false,
		})

		return self.flChooseNewRunDestinationTime
	
	elseif self.nState == GREEVIL_STATE_STEAL_FROM_WELL then

		self:FleeRandomly()
		return 0.1
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CGreevil:ExecuteMoveToRoshPitOrder()
	if GameRules.Winter2022.hRoshanSpawner == nil then
		print( "ERROR: no Roshan Spawner found!" )
		return -1
	end

	self.vStealCandyDestination = GameRules.Winter2022.vGreevilCandyStealLocation

	ExecuteOrderFromTable({
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.vStealCandyDestination,
		Queue = false,
	})
end

--------------------------------------------------------------------------------

function CGreevil:Burrow()
	-- bail if we were already burrowing
	if self.nState == GREEVIL_STATE_BURROW then
		return
	end

	-- make sure we're not leashed by slark
	self.me:RemoveModifierByName( "modifier_aghsfort_slark_pounce_leash" )

	ExecuteOrderFromTable({
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_HOLD_POSITION,
		Position = self.me:GetOrigin()
	})

	self.me:StartGesture( ACT_DOTA_CAST_ABILITY_1 )

	local nFXindex = ParticleManager:CreateParticle( "particles/units/heroes/hero_meepo/meepo_burrow_end.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( nFXindex, 0, self.me:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( nFXindex )

	EmitSoundOn( "Greevil.Burrow.In", self.me );

	self.flKillTime = GameRules:GetGameTime() + self.flBurrowDuration
	self.nState = GREEVIL_STATE_BURROW
	-- reset our thinker so that we can die on time
	self.me:SetContextThink( "GreevilThink", GreevilThink, 0.1 )
end

--------------------------------------------------------------------------------

function CGreevil:RoshanBounce( flTime )
	-- bail if we were already bouncing or burrowing
	if self.nState == GREEVIL_STATE_BURROW or self.nState == GREEVIL_STATE_ROSHANBOUNCE then
		return
	end

	-- make sure we're not leashed by slark
	self.me:RemoveModifierByName( "modifier_aghsfort_slark_pounce_leash" )

	self.flBurrowTime = GameRules:GetGameTime() + flTime
	self.nState = GREEVIL_STATE_ROSHANBOUNCE
	-- reset our thinker so that we can start to Burrow on time
	self.me:SetContextThink( "GreevilThink", GreevilThink, 0.1 )
end

--------------------------------------------------------------------------------

function CGreevil:ChaseLeader()
	if self.hLeader == nil then
		local hCreatures = Entities:FindAllByClassname( "npc_dota_creature" )

		for i=#hCreatures,1,-1 do
			if hCreatures[i] ~= nil and hCreatures[i]:IsNull() == false and hCreatures[i]:IsAlive() and hCreatures[i]:GetUnitName() == "npc_dota_greevil_leader" then
				--print( '^GREEVIL FOUND A VALID LEADER!' )
				self.hLeader = hCreatures[i]
			end
		end
	end

	if self.hLeader == nil or self.hLeader:IsNull() == true or self.hLeader:IsAlive() == false then
		--print( 'ERROR - ^GREEVIL CANNOT FIND A VALID LEADER!' )
		return false
	end

	ExecuteOrderFromTable({
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
		TargetIndex = self.hLeader:entindex()
	})

	return true
end

--------------------------------------------------------------------------------

function CGreevil:FleeFromDamage( hAttacker )

	-- only react to damage if you are chasing the leader
	if self.nState ~= GREEVIL_STATE_CHASE_LEADER then
		--print( '^GREEVIL IS NOT CHASING THE LEADER - IGNORING DAMAGE!' )
		return
	end

	if hAttacker ~= nil and hAttacker:IsNull() == false and hAttacker:IsAlive() == true then
		--print( '^GREEVIL FLEEING TO LOCATION' )
		local vDir = self.me:GetAbsOrigin() - hAttacker:GetAbsOrigin()
		vDir = vDir.Normalized( vDir )

		self.vFleePosition = self.me:GetAbsOrigin() + ( vDir * self.flFleeFromDamageDistance )

		local fTestDistFromRoshPit = ( self.vFleePosition - self.vRoshPitCenter ):Length2D()
		--DebugDrawSphere( self.vFleePosition, Vector(255,0,0), 0.8, self.fLeaderRunDistanceMin, false, 0.75 )
		--DebugDrawSphere( self.vFleePosition, Vector(0,0,255), 0.8, 200, false, 1.0 )

		if fTestDistFromRoshPit < self.fValidRangeFromRoshPitMin or fTestDistFromRoshPit > self.fValidRangeFromRoshPitMax then
			-- invalid loc - just run to the leader's current position
			--print( '^^^INVALID FLEE FROM DAMAGE POSITION!' )
			if self:ChaseLeader() == true then
				--print( '^^^RUNNING TO LEADER!' )
				self.nState = GREEVIL_STATE_CHASE_LEADER
				return
			end

			-- cannot chase leader right now - just run back into the pit
			--print( '^^^NO LEADER FOUND - RUNNING TO ROSH PIT!' )
			self.vFleePosition = self.vRoshPitCenter
		end

		ExecuteOrderFromTable({
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = self.vFleePosition,
			Queue = false,
		})

		--DebugDrawSphere( self.vRoshPitCenter, Vector(255,0,0), 0.8, self.fValidRangeFromRoshPitMin, false, 0.75 )
		--DebugDrawSphere( self.vRoshPitCenter, Vector(0,255,0), 0.8, self.fValidRangeFromRoshPitMax, false, 1.0 )

		self.flFleeTime = GameRules:GetGameTime() + RandomFloat( self.flFleeDurationMin, self.flFleeDurationMax )
		self.nState = GREEVIL_STATE_FLEE_FROM_DAMAGE
	end
end

--------------------------------------------------------------------------------

function OnEntityHurt( event )
	local hVictim = nil
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end

	if hVictim ~= thisEntity then
		return
	end

	--print( '^GREEVIL HURT!' )

	if thisEntity.AI ~= nil and thisEntity.AI.bIsLeader == true then
		--print( '^GREEVIL LEADER IGNORING DAMAGE' )
		return
	end

	local hAttacker = nil
	if event.entindex_attacker ~= nil then
		hAttacker = EntIndexToHScript( event.entindex_attacker )
	end

	if hAttacker ~= nil and hAttacker:IsNull() == false and hAttacker:IsOwnedByAnyPlayer() == true then
		thisEntity.AI:FleeFromDamage( hAttacker )
	end
end

--------------------------------------------------------------------------------

function CGreevil:FleeRandomly()
	-- grab a solid fallback location
	--print( '^^^CGreevil:FleeRandomly()' )
	self.vInitialRunPosition = GameRules.Winter2022.vGreevilFleeLocs[ RandomInt( 1, #GameRules.Winter2022.vGreevilFleeLocs ) ]
	self.nState = GREEVIL_STATE_FLEE_RANDOMLY
	self.me:SetContextThink( "GreevilThink", GreevilThink, 0.1 )
end

--------------------------------------------------------------------------------

function CGreevil:SetStateChaseLeader()
	self.nState = GREEVIL_STATE_CHASE_LEADER
	self.me:SetContextThink( "GreevilThink", GreevilThink, 0.1 )
end

--------------------------------------------------------------------------------

function CGreevil:SetStateStealFromWell( hBuilding )
	self.nState = GREEVIL_STATE_STEAL_FROM_WELL

	EmitSoundOn( "Greevil.StealCandy.Yoink", self.me )
	EmitSoundOn( "Greevil.StealCandy.Laugh", self.me )

	local vKnockbackPos = hBuilding:GetAbsOrigin()
	local fKnockbackDuration = 1.0 * RandomFloat( 0.8, 1.2 )
	local fKnockbackDistance = 300
	local fKnockbackHeight = 250

	local kv =
	{
		center_x = vKnockbackPos.x,
		center_y = vKnockbackPos.y,
		center_z = vKnockbackPos.z,
		should_stun = true,
		duration = fKnockbackDuration,
		knockback_duration = fKnockbackDuration,
		knockback_distance = fKnockbackDistance,
		knockback_height = fKnockbackHeight,
	}

	local vKnockbackDir = self.me:GetAbsOrigin() - vKnockbackPos
	vKnockbackDir = vKnockbackDir:Normalized()
	local angles = VectorAngles( vKnockbackDir )
	self.me:SetAngles( angles.x, angles.y, angles.z )

	self.me:AddNewModifier( nil, nil, "modifier_knockback", kv )

	self.me:SetContextThink( "GreevilThink", GreevilThink, fKnockbackDuration )
end