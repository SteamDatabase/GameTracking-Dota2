
require( "ai/boss_base" )
require( "utility_functions" )

--------------------------------------------------------------------------------

if CBossArcWarden == nil then
	CBossArcWarden = class( {}, {}, CBossBase )
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		thisEntity.AI = CBossArcWarden( thisEntity, 1.0 )
	end
end

--------------------------------------------------------------------------------

_G.BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK = 0
_G.BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK_SLOW = 1
_G.BOSS_ARC_WARDEN_COMBAT_PHASE_MAGNETIC_FIELD = 2
_G.BOSS_ARC_WARDEN_COMBAT_PHASE_SPARK_WRAITH_MISSILE = 3
_G.BOSS_ARC_WARDEN_COMBAT_PHASE_GLEIPNIR = 4
_G.BOSS_ARC_WARDEN_COMBAT_PHASE_BLINK = 5

--------------------------------------------------------------------------------

function CBossArcWarden:constructor( hUnit, flInterval )
	CBossBase.constructor( self, hUnit, flInterval )

	self.bIsClone = false

	self.PHASE_COMBAT = 1
	self.PHASE_RANGED_ATTACKS = 2
	self.PHASE_TRANSITION_TO_BLINK_TO_CENTER = 3
	self.PHASE_TRANSITION_TO_CHANNEL = 4
	self.PHASE_BEGIN_CHANNEL_METEOR = 5
	self.PHASE_CHANNELING_METEOR = 6
	self.PHASE_TEMPEST_DOUBLE = 7

	self:Initialize()
end

--------------------------------------------------------------------------------

function CBossArcWarden:SetIsClone( bIsClone )
	print( 'CBossArcWarden:SetIsClone( bIsClone )!!!' )
	self.bIsClone = bIsClone

	if bIsClone then
		-- don't use the ascension scaling for the clones in this fight
		thisEntity:RemoveAbility( "ability_ascension" )
		thisEntity:RemoveModifierByName( "modifier_ascension" )
	end

	self:RefillCombatQueue()
end

--------------------------------------------------------------------------------

function CBossArcWarden:Initialize()
	print( 'CBossArcWarden:Initialize()' )
	self.nPhase = self.PHASE_COMBAT

	-- ascension scaling
	self.vRangedAttackDelay = { 0.7, 0.675, 0.65, 0.625, 0.6 }
	self.vRangedAttackSlowDelay = { 2.5, 2.4, 2.3, 2.2, 2.1 }

	self.UltHealthTrigger = 80
	self.UltHealthTriggerProgressive = 20

	self.GleipnirHealthPercentTrigger = 50

	self.fUltTimerDuration = 35
	self.fUltTimer = GameRules:GetGameTime() + 999999999999

	self.nMaxClonesInitial = 2
	self.nMaxClones = self.nMaxClonesInitial
	self.nMaxClonesProgressive = 0.5
	self.nMaxClonesAbsoluteMax = 4

	self.fTimePerShardInitial = 6
	self.fTimePerShard = self.fTimePerShardInitial
	self.fTimePerShardProgressive = 0.5
	self.fTimePerShardMin = 4

	self.nDamageThresholdPct = 10

	self.SPARK_WRAITH_MAZE_RING_DISTANCE = 385

	self.SparkWraithMazeData =
	{
		{
			distance = self.SPARK_WRAITH_MAZE_RING_DISTANCE * 1,
			num = 5,
			num_missing = 2,
			rotation_speed = 20,
		},
		{
			distance = self.SPARK_WRAITH_MAZE_RING_DISTANCE * 2,
			num = 11,
			num_missing = 4,
			rotation_speed = 16,
		},
		{
			distance = self.SPARK_WRAITH_MAZE_RING_DISTANCE * 3,
			num = 17,
			num_missing = 7,
			rotation_speed = 12,
		},
		{
			distance = self.SPARK_WRAITH_MAZE_RING_DISTANCE * 4,
			num = 24,
			num_missing = 14,
			rotation_speed = 8,
		},
	}

	self.fPhaseTime_TransitionToBlink = 0.5
	self.fPhaseTime_TransitionToChannelMeteor = 0.5
	self.fPhaseTime_BeginChannelMeteor = 1
	self.fPlayerDisabledTime = self.fPhaseTime_TransitionToBlink + self.fPhaseTime_TransitionToChannelMeteor + self.fPhaseTime_BeginChannelMeteor + 0.5

	self:RefillCombatQueue()

	self.me:SetThink( "OnBossArcWardenThink", self, "OnBossArcWardenThink", self.flDefaultInterval )
end


--------------------------------------------------------------------------------

function CBossArcWarden:Reset()
	print( 'CBossArcWarden:Reset()' )

	self:Initialize()

	self.me:Interrupt()
	self.me:Heal( 99999999, nil )
	self.nLastHealthPct = 10000

	self:RemoveSparkWraiths()
	self:RemoveMagneticFields()
	self:RemoveTempestDoubles()
	self.me:RemoveModifierByName( 'modifier_boss_arc_warden_shard_counter' )
	self.me:RemoveModifierByName( 'modifier_boss_arc_warden_damage_counter' )
end

--------------------------------------------------------------------------------

function CBossArcWarden:SetEncounter( hEncounter )
	CBossBase.SetEncounter( self, hEncounter )

	local HomePosition = hEncounter:GetRoom():FindAllEntitiesInRoomByName( "home_position" )
	if #HomePosition > 0 then
		print( 'CBossArcWarden:SetEncounter( hEncounter ) - found home position!' )
		self.vHomePosition = HomePosition[1]:GetAbsOrigin()
		print( 'CBossArcWarden:SetEncounter( hEncounter ) - Home position: ' .. self.vHomePosition.x .. ', ' .. self.vHomePosition.y .. ', ' .. self.vHomePosition.z )
	end

	self.GlimpsePositions = {}
	local GlimpsePositions = hEncounter:GetRoom():FindAllEntitiesInRoomByName( "glimpse_position" )
	for _,hEnt in pairs ( GlimpsePositions ) do
		table.insert( self.GlimpsePositions, hEnt:GetAbsOrigin() )
	end
end

--------------------------------------------------------------------------------

function CBossArcWarden:RandomizeCooldown( hAbility )
	if hAbility then
		local fCooldown = hAbility:GetCooldown( -1 )
		hAbility:StartCooldown( RandomFloat( 0, fCooldown ) )
	end
end

--------------------------------------------------------------------------------

function CBossArcWarden:RefillCombatQueue()
	local vRotations = {}
	if self.bIsClone == false then
		print( 'REFILLING BOSS COMBAT QUEUE')

		-- no mag field, 3x attack then blink away
		local vRotation1 = 
		{
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK_SLOW,
			BOSS_ARC_WARDEN_COMBAT_PHASE_BLINK,
		}

		local vRotation2 =
		{
			BOSS_ARC_WARDEN_COMBAT_PHASE_MAGNETIC_FIELD,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK_SLOW,
			BOSS_ARC_WARDEN_COMBAT_PHASE_BLINK,
		}

		local vRotation3 =
		{
			BOSS_ARC_WARDEN_COMBAT_PHASE_MAGNETIC_FIELD,
			BOSS_ARC_WARDEN_COMBAT_PHASE_SPARK_WRAITH_MISSILE,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK_SLOW,
			BOSS_ARC_WARDEN_COMBAT_PHASE_BLINK,
		}

		local vRotation3alt =
		{
			BOSS_ARC_WARDEN_COMBAT_PHASE_MAGNETIC_FIELD,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK_SLOW,
			BOSS_ARC_WARDEN_COMBAT_PHASE_SPARK_WRAITH_MISSILE,
			BOSS_ARC_WARDEN_COMBAT_PHASE_BLINK,
		}

		-- full rotation
		local vRotation4 = 
		{
			BOSS_ARC_WARDEN_COMBAT_PHASE_MAGNETIC_FIELD,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK_SLOW,
			BOSS_ARC_WARDEN_COMBAT_PHASE_SPARK_WRAITH_MISSILE,
			BOSS_ARC_WARDEN_COMBAT_PHASE_BLINK,
		}

		------------- gleipnir rotations ------------------

		-- no mag field gleipnir plus one slow attack
		local vRotation5 = 
		{
			BOSS_ARC_WARDEN_COMBAT_PHASE_GLEIPNIR,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK_SLOW,
			BOSS_ARC_WARDEN_COMBAT_PHASE_BLINK,
		}

		-- gleipnir plus ranged attacks
		local vRotation6 = 
		{
			BOSS_ARC_WARDEN_COMBAT_PHASE_GLEIPNIR,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK_SLOW,
			BOSS_ARC_WARDEN_COMBAT_PHASE_BLINK,
		}

		-- full rotation with gleipnir
		local vRotation7 = 
		{
			BOSS_ARC_WARDEN_COMBAT_PHASE_MAGNETIC_FIELD,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK_SLOW,
			BOSS_ARC_WARDEN_COMBAT_PHASE_GLEIPNIR,
			BOSS_ARC_WARDEN_COMBAT_PHASE_SPARK_WRAITH_MISSILE,
			BOSS_ARC_WARDEN_COMBAT_PHASE_BLINK,
		}

		if self.me:GetHealthPercent() > self.GleipnirHealthPercentTrigger then
			table.insert( vRotations, vRotation1 )
			table.insert( vRotations, vRotation2 )
			table.insert( vRotations, vRotation3 )
			table.insert( vRotations, vRotation3alt )
			table.insert( vRotations, vRotation4 )
		else
			table.insert( vRotations, vRotation2 )
			table.insert( vRotations, vRotation3 )
			table.insert( vRotations, vRotation3alt )
			print( 'LOW HEALTH - USING THE GLEIPNIR ROTATIONS!' )
			table.insert( vRotations, vRotation5 )
			table.insert( vRotations, vRotation6 )
			table.insert( vRotations, vRotation7 )
		end

	else
		print( 'REFILLING CLONE COMBAT QUEUE')
		-- clone - simpler patterns
		local vRotation1 = 
		{
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK_SLOW,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK_SLOW,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK_SLOW,
			BOSS_ARC_WARDEN_COMBAT_PHASE_BLINK,
		}

		local vRotation2 = 
		{
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK_SLOW,
			BOSS_ARC_WARDEN_COMBAT_PHASE_BLINK,
		}

		local vRotation3 = 
		{
			BOSS_ARC_WARDEN_COMBAT_PHASE_MAGNETIC_FIELD,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK_SLOW,
			BOSS_ARC_WARDEN_COMBAT_PHASE_BLINK,
		}

		local vRotation4 = 
		{
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK_SLOW,
		}

		table.insert( vRotations, vRotation1 )
		table.insert( vRotations, vRotation2 )
		table.insert( vRotations, vRotation3 )
		table.insert( vRotations, vRotation4 )
	end

	if #vRotations == 0 then
		-- fallback case
		self.vecCombatQueue =
		{
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK,
			BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK_SLOW,
			BOSS_ARC_WARDEN_COMBAT_PHASE_BLINK,
		}
	else
		self.vecCombatQueue = deepcopy( vRotations[ RandomInt(1,#vRotations) ] )
	end
end

--------------------------------------------------------------------------------

function CBossArcWarden:SetupAbilitiesAndItems()
	CBossBase.SetupAbilitiesAndItems( self )

	print( 'CBossArcWarden:SetupAbilitiesAndItems()' )

	self.hBlink = self.me:FindAbilityByName( "arc_warden_boss_blink" )
	if self.hBlink ~= nil then
		self.hBlink.Evaluate = self.EvaluateBlink
		self.AbilityPriority[ self.hBlink:GetAbilityName() ] = 9
	end

	self.hMagneticField = self.me:FindAbilityByName( "aghsfort_arc_warden_boss_magnetic_field" )
	if self.hMagneticField ~= nil then
		--self.fDissimilatePhaseDuration = self.hMagneticField:GetSpecialValueFor( "phase_duration" )
		--self.fPctOfPhaseForSelection = self.hMagneticField:GetSpecialValueFor( "pct_of_phase_for_selection" )
		--local first_ring_distance_offset = self.hMagneticField:GetSpecialValueFor( "first_ring_distance_offset" )
		--local damage_radius = self.hMagneticField:GetSpecialValueFor( "damage_radius" )
		--self.fDissimilateFullRadius = first_ring_distance_offset + damage_radius

		self.hMagneticField.Evaluate = self.EvaluateMagneticField
		self.AbilityPriority[ self.hMagneticField:GetAbilityName() ] = 3
	end

	self.hSparkWraithUlt = self.me:FindAbilityByName( "aghsfort_arc_warden_boss_spark_wraith_ult" )
	-- we don't cast the ult but we use it for a different set of tuning vars in the abilities file
	--[[if self.hSparkWraithUlt ~= nil then
		self.hSparkWraithUlt.Evaluate = self.EvaluateSparkWraithUlt
		self.AbilityPriority[ self.hSparkWraithUlt:GetAbilityName() ] = 4
	end]]--

	self.hTempestDouble = self.me:FindAbilityByName( "aghsfort_arc_warden_boss_tempest_double" )
	if self.hTempestDouble ~= nil then
		self.hTempestDouble.Evaluate = self.EvaluateTempestDouble
		self.AbilityPriority[ self.hTempestDouble:GetAbilityName() ] = 2
	end

	self.hChannelMeteor = self.me:FindAbilityByName( "arc_warden_boss_channel_meteor" )
	if self.hChannelMeteor ~= nil then
		self.hChannelMeteor.Evaluate = self.EvaluateChannelMeteor
		self.AbilityPriority[ self.hChannelMeteor:GetAbilityName() ] = 7
	end

	self.hRangedAttack = self.me:FindAbilityByName( "arc_warden_boss_ranged_attack" )
	if self.hRangedAttack ~= nil then
		self.hRangedAttack.Evaluate = self.EvaluateRangedAttack
		self.AbilityPriority[ self.hRangedAttack:GetAbilityName() ] = 20
	end

	self.hGleipnir = self.me:FindAbilityByName( "aghsfort_arc_warden_boss_gleipnir" )
	if self.hGleipnir ~= nil then
		self.hGleipnir.Evaluate = self.EvaluateGleipnir
		self.AbilityPriority[ self.hGleipnir:GetAbilityName() ] = 9
	end

	self.hSparkWraithMissile = self.me:FindAbilityByName( "aghsfort_arc_warden_boss_spark_wraith_missile" )
	if self.hSparkWraithMissile ~= nil then
		self.hSparkWraithMissile.Evaluate = self.EvaluateSparkWraithMissile
		self.AbilityPriority[ self.hSparkWraithMissile:GetAbilityName() ] = 5
	end

end

--------------------------------------------------------------------------------

function CBossArcWarden:OnHealthPercentThreshold( nPct )
	CBossBase.OnHealthPercentThreshold( self, nPct )

	-- clones don't transition to the ult
	if self.bIsClone == true then
		return
	end

	if nPct < self.UltHealthTrigger and self.nPhase == self.PHASE_COMBAT then
		print( 'HEALTH TRIGGER MET DURING COMBAT - TRIGGERING ULT' )
		self:TriggerUltSequence()
	end
end

--------------------------------------------------------------------------------

function CBossArcWarden:TriggerUltSequence()
	self:RemoveMagneticFields()

	self.fDelayTimer = GameRules:GetGameTime() + self.fPhaseTime_TransitionToBlink
	self:ChangePhase( self.PHASE_TRANSITION_TO_BLINK_TO_CENTER )
end

--------------------------------------------------------------------------------

function CBossArcWarden:BlinkToHomePosition()
	local nFXStart = ParticleManager:CreateParticle( "particles/items_fx/blink_dagger_start.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXStart, 0, self.me:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( nFXStart )

	FindClearSpaceForUnit( self.me, self.vHomePosition, true )
	ProjectileManager:ProjectileDodge( self.me )
	self.me:Interrupt()
	self.me:FaceTowards( self.Encounter:GetMeteor():GetAbsOrigin() )

	EmitSoundOn( "DOTA_Item.BlinkDagger.Activate", self.me )

	local nFXEnd = ParticleManager:CreateParticle( "particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.me )
	ParticleManager:ReleaseParticleIndex( nFXEnd )
end

--------------------------------------------------------------------------------
 
function CBossArcWarden:OnBossArcWardenThink()

	if self.nPhase == self.PHASE_COMBAT then
		if self.fUltTimer < GameRules:GetGameTime() then
			-- clones don't transition to the ult
			if self.bIsClone == false then
				print( '^^^CBossArcWarden:OnBossArcWardenThink() - ULT TIMER EXPIRED - moving to BLINK TO CENTER' )

				self:TriggerUltSequence()
				return 0.01
			end
		end

		if #self.vecCombatQueue == 0 then
			print( '^^^COMBAT QUEUE IS EMPTY! REFILLING for ' .. self.me:GetUnitName() )
			self:RefillCombatQueue()
		end

	elseif self.nPhase == self.PHASE_TRANSITION_TO_BLINK_TO_CENTER then
		if self.fDelayTimer < GameRules:GetGameTime() then
			print( '^^^CBossArcWarden:OnBossArcWardenThink() - DELAY EXPIRED - moving to TRANSITION TO CHANNEL')

			self:BlinkToHomePosition()

			self.fDelayTimer = GameRules:GetGameTime() + self.fPhaseTime_TransitionToChannelMeteor
			self:ChangePhase( self.PHASE_TRANSITION_TO_CHANNEL )
		else
			--print( '^^^CBossArcWarden:OnBossArcWardenThink() - PHASE_TRANSITION_TO_BLINK_TO_CENTER - WAITING FOR PHASE DELAY TIMER ' .. ( self.fDelayTimer - GameRules:GetGameTime() ) )
		end
		return 0.01

	elseif self.nPhase == self.PHASE_TRANSITION_TO_CHANNEL then
		if self.fDelayTimer < GameRules:GetGameTime() then
			print( '^^^CBossArcWarden:OnBossArcWardenThink() - DELAY EXPIRED - moving to BEGIN CHANNEL METEOR')

			local vMeteorPos = self.Encounter:GetMeteor():GetAbsOrigin()
			--[[ disabling shockwave to see if it's necessary
			-- create the shockwave to push players away
			local kv = 
			{
				radius = 2500,
				speed = 1000,
				knockback_duration = 1.0,
				knockback_distance = 1000,
			}
			CreateModifierThinker( self.me, nil, "modifier_aghsfort_arc_warden_boss_meteor_shockwave_thinker", kv, vMeteorPos, self.me:GetTeamNumber(), false )
			]]--

			-- add our damage tracker
			local kv =
			{
				damage_threshold = self.me:GetMaxHealth() / self.nDamageThresholdPct,
				damage_counter_tiers = 6,
				duration = self.hChannelMeteor:GetChannelTime(),
			}
			self.me:AddNewModifier( self.me, self.hChannelMeteor, "modifier_boss_arc_warden_damage_counter", kv )

			-- add shard counter
			print( 'ADDING SHARD COUNTER - time per shard = ' .. self.fTimePerShard .. ', max stacks = ' .. self.nMaxClones )
			vMeteorPos = vMeteorPos + Vector( 0, 0, 150 )
			local kv2 =
			{
				time_per_stack = self.fTimePerShard,
				max_stacks = self.nMaxClones,
				duration = -1,
				x = vMeteorPos.x,
				y = vMeteorPos.y,
				z = vMeteorPos.z,
			}
			local hShardCounter = self.me:AddNewModifier( self.me, self.hChannelMeteor, "modifier_boss_arc_warden_shard_counter", kv2 )
			hShardCounter.hMeteor = self.Encounter:GetMeteor()

			EmitSoundOn( 'ArcWardenBoss.MeteorChannel', self.me )

			self:CreateSparkWraithMaze()

			self.fDelayTimer = GameRules:GetGameTime() + self.fPhaseTime_BeginChannelMeteor
			self:ChangePhase( self.PHASE_BEGIN_CHANNEL_METEOR )
		else
			self.me:FaceTowards( self.Encounter:GetMeteor():GetAbsOrigin() )
			--print( '^^^CBossArcWarden:OnBossArcWardenThink() - PHASE_TRANSITION_TO_CHANNEL - WAITING FOR PHASE DELAY TIMER ' .. ( self.fDelayTimer - GameRules:GetGameTime() ) )
		end
		return 0.01

	elseif self.nPhase == self.PHASE_BEGIN_CHANNEL_METEOR then
		if self.fDelayTimer < GameRules:GetGameTime() then
			print( '^^^CBossArcWarden:OnBossArcWardenThink() - DELAY EXPIRED - moving to CHANNEL METEOR')
			
			self:ChangePhase( self.PHASE_CHANNELING_METEOR )
		end
		return 0.01

	elseif self.nPhase == self.PHASE_CHANNELING_METEOR then
		
		local hCounter = self.me:FindModifierByName( 'modifier_boss_arc_warden_damage_counter' )
		if hCounter == nil then
			StopSoundOn( 'ArcWardenBoss.MeteorChannel', self.me )

			print( '^^^CBossArcWarden:OnBossArcWardenThink() - DAMAGE COUNTER BROKEN OR EXPIRED - moving to TEMPEST DOUBLE')
			self:ChangePhase( self.PHASE_TEMPEST_DOUBLE )
		end
		return 0.01
	end

	return self:OnBaseThink()
end

--------------------------------------------------------------------------------

function CBossArcWarden:OnFirstSeen()
	CBossBase.OnFirstSeen( self )
end

--------------------------------------------------------------------------------

function CBossArcWarden:ChangePhase( nNewPhase )
	print( '^^^CBossArcWarden:ChangePhase( nNewPhase ) == ' .. nNewPhase )

	if nNewPhase == self.PHASE_COMBAT then
		if self.bIsClone == false then
			self.fUltTimer = GameRules:GetGameTime() + self.fUltTimerDuration
			print( 'COMBAT TIME! Setting ult timer to ' .. self.fUltTimer )
			-- set new health trigger
			self.UltHealthTrigger = self.me:GetHealthPercent() - self.UltHealthTriggerProgressive
			print( 'Current health percent = ' .. self.me:GetHealthPercent() .. '% - Setting new health percent trigger to ' .. self.UltHealthTrigger .. '%' )
		end
		self:RefillCombatQueue()

	elseif nNewPhase == self.PHASE_TRANSITION_TO_BLINK_TO_CENTER then
		self:RemoveSparkWraiths()
		self:RemoveMagneticFields()

	elseif nNewPhase == self.PHASE_BEGIN_CHANNEL_METEOR then
		if self.hChannelMeteor then
			self.hChannelMeteor:EndCooldown()
		end

	elseif nNewPhase == self.PHASE_CHANNELING_METEOR then

	elseif nNewPhase == self.PHASE_TEMPEST_DOUBLE then
		
		if self.hTempestDouble then
			self.hTempestDouble:EndCooldown()
		end

		self:RemoveSparkWraiths()
	end

	self.nPhase = nNewPhase
end

--------------------------------------------------------------------------------

function CBossArcWarden:EvaluateMagneticField()
	if self.nPhase ~= self.PHASE_COMBAT then
		return nil
	end

	if self.vecCombatQueue == nil or #self.vecCombatQueue == 0 then
		return nil
	end

	local Order = nil
	if self.vecCombatQueue[1] == BOSS_ARC_WARDEN_COMBAT_PHASE_MAGNETIC_FIELD then
		table.remove( self.vecCombatQueue, 1 )
		print( self.me:GetUnitName() .. ' ***REMOVING Magnetic Field FROM COMBAT QUEUE' )

		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = self.me:GetAbsOrigin(),
			AbilityIndex = self.hMagneticField:entindex(),
			Queue = false,
		}

		--Order.flOrderInterval = GetSpellCastTime( self.hMagneticField )
		Order.flOrderInterval = 0.75
		Order.name = 'Magentic Field'
	end

	return Order
end

--------------------------------------------------------------------------------

function CBossArcWarden:EvaluateSparkWraithMissile()
	if self.nPhase ~= self.PHASE_COMBAT then
		return nil
	end

	if self.vecCombatQueue == nil or #self.vecCombatQueue == 0 then
		return nil
	end

	local Order = nil
	if self.vecCombatQueue[1] == BOSS_ARC_WARDEN_COMBAT_PHASE_SPARK_WRAITH_MISSILE then
		table.remove( self.vecCombatQueue, 1 )
		print( self.me:GetUnitName() .. ' ***REMOVING Spark Wraith Missile FROM COMBAT QUEUE' )

		local enemies = FindUnitsInRadius( self.hSparkWraithMissile:GetCaster():GetTeamNumber(), self.hSparkWraithMissile:GetCaster():GetOrigin(), self.hSparkWraithMissile:GetCaster(), GetTryToUseSpellRange( self.hSparkWraithMissile:GetCaster(), self.hSparkWraithMissile ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		local vecConnectedPlayers = GameRules.Aghanim:GetConnectedPlayers()
		-- don't launch this attack when there's only 1 hero remaining! (hack to allow it when only 1 player is connected for testing purposes)
		if #enemies == 0 or ( #enemies == 1 and #vecConnectedPlayers > 1 ) then
			print( 'SKIPPING SPARK WRAITH MISSILE LAUNCH due to 0 or 1 enemies remaining' )
			return nil
		end

		-- start from the farthest enemy
		for i = #enemies, 1, -1 do
			local hEnemy = enemies[i]
			local hTargetBuff = hEnemy:FindModifierByName( 'modifier_aghsfort_arc_warden_boss_spark_wraith_missile_target')
			if hTargetBuff == nil then
				-- no missile targeting this enemy currently
				Order =
				{
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = hEnemy:entindex(),
					AbilityIndex = self.hSparkWraithMissile:entindex(),
					Queue = false,
				}
				Order.flOrderInterval = GetSpellCastTime( self.hSparkWraithMissile ) + 0.5
				Order.name = 'Spark Wraith Missile'
				--print( 'ORDER INTERVAL for Missile is ' .. Order.flOrderInterval )
				return Order
			else
				print( 'ENEMY IS ALREADY TARGETED BY A SPARK WRAITH MISSILE - SKIPPING OVER ' .. hEnemy:GetUnitName() )
			end
		end
	end

	return nil
end

--------------------------------------------------------------------------------

function CBossArcWarden:EvaluateGleipnir()
	if self.nPhase ~= self.PHASE_COMBAT then
		return nil
	end

	if self.vecCombatQueue == nil or #self.vecCombatQueue == 0 then
		return nil
	end

	local Order = nil
	if self.vecCombatQueue[1] == BOSS_ARC_WARDEN_COMBAT_PHASE_GLEIPNIR then
		table.remove( self.vecCombatQueue, 1 )
		print( self.me:GetUnitName() .. ' ***REMOVING Gleipnir FROM COMBAT QUEUE' )

		local Enemies = shallowcopy( self.hPlayerHeroes )
		local nSearchRadius = self.hGleipnir:GetCastRange()
		printf( 'EvaluateGleipnir - nSearchRadius == %d', nSearchRadius )
		Enemies = GetEnemyHeroesInRange( thisEntity, nSearchRadius )

		if #Enemies >= 1 then
			local hRandomEnemy = Enemies[ RandomInt( 1, #Enemies ) ]
			local vTargetLocation = hRandomEnemy:GetAbsOrigin()
			if vTargetLocation ~= nil then
				Order =
				{
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					Position = vTargetLocation,
					AbilityIndex = self.hGleipnir:entindex(),
					Queue = false,
				}
				Order.flOrderInterval = GetSpellCastTime( self.hGleipnir ) + 0.5
				Order.name = 'Gleipnir'
				--print( 'ORDER INTERVAL for Gleipnir is ' .. Order.flOrderInterval )
			end
		end
	end

	return Order
end

--------------------------------------------------------------------------------

function CBossArcWarden:EvaluateTempestDouble()
	if self.nPhase ~= self.PHASE_TEMPEST_DOUBLE then
		return nil
	end

	local nNumDoubles
	local hCounter = self.me:FindModifierByName( 'modifier_boss_arc_warden_shard_counter' )
	if hCounter ~= nil then
		nNumDoubles = hCounter:GetStackCount() + 1
	else
		print( 'ERROR - CBossArcWarden:EvaluateTempestDouble() - could not find modifier_boss_arc_warden_shard_counter. Setting doubles to 2 as a fallback' )
		nNumDoubles = 2
	end

	self.hTempestDouble:SetNumDoubles( nNumDoubles )

	self.me:RemoveModifierByName( 'modifier_boss_arc_warden_shard_counter' )

	local Order =
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = self.hTempestDouble:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hTempestDouble ) + 1.0
	Order.name = 'Tempest Double'

	-- level up our ult for the next time!
	self.nMaxClones = math.min( self.nMaxClones + self.nMaxClonesProgressive, self.nMaxClonesAbsoluteMax )
	self.fTimePerShard = math.max( self.fTimePerShard - self.fTimePerShardProgressive, self.fTimePerShardMin )
	print( 'LEVELING UP THE ULT! Max Clones = ' .. self.nMaxClones .. ', and Time per Shard = ' .. self.fTimePerShard )

	self:ChangePhase( self.PHASE_COMBAT )

	return Order
end

--------------------------------------------------------------------------------

function CBossArcWarden:EvaluateRangedAttack()
	if self.nPhase ~= self.PHASE_COMBAT then
		return nil
	end

	if self.vecCombatQueue == nil or #self.vecCombatQueue == 0 then
		return nil
	end

	--print( 'CBossArcWarden:EvaluateRangedAttack()' )

	local Order = nil
	if self.vecCombatQueue[1] == BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK or
	   self.vecCombatQueue[1] == BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK_SLOW then
	   	local bSlowAttack = false
	   	if self.vecCombatQueue[1] == BOSS_ARC_WARDEN_COMBAT_PHASE_RANGED_ATTACK_SLOW then
	   		bSlowAttack = true
	   	end
		table.remove( self.vecCombatQueue, 1 )
		print( self.me:GetUnitName() .. ' ***REMOVING Ranged Attack FROM COMBAT QUEUE' )

		local enemies = FindUnitsInRadius( self.hRangedAttack:GetCaster():GetTeamNumber(), self.hRangedAttack:GetCaster():GetOrigin(), self.hRangedAttack:GetCaster(), GetTryToUseSpellRange( self.hRangedAttack:GetCaster(), self.hRangedAttack ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if #enemies == 0 then
			print( '***RANGED ATTACK FAILED TO FIND A TARGET')
			return nil
		end

		-- select random enemy
		hTarget = enemies[RandomInt(1, #enemies)]

		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = hTarget:GetAbsOrigin(),
			AbilityIndex = self.hRangedAttack:entindex(),
			Queue = false,
		}

		local nAscension = GameRules.Aghanim:GetAscensionLevel() + 1

		Order.name = 'Ranged Attack'
		Order.flOrderInterval = self.vRangedAttackDelay[ nAscension ]
		if bSlowAttack == true then
			Order.flOrderInterval = self.vRangedAttackSlowDelay[ nAscension ]
		end
		--print( 'RANGED ATTACK ORDER TIME = ' .. Order.flOrderInterval )
	end

	return Order
end	


--------------------------------------------------------------------------------

function CBossArcWarden:EvaluateBlink()
	if self.nPhase ~= self.PHASE_COMBAT then
		return nil
	end

	--if self.me:IsRooted() then
	--	print( 'CBossArcWarden:EvaluateBlink() - CANNOT BLINK WHILE ROOTED - going to try later')
	--	return nil
	--end

	if self.vecCombatQueue == nil or #self.vecCombatQueue == 0 then
		return nil
	end

	local Order = nil
	if self.vecCombatQueue[1] == BOSS_ARC_WARDEN_COMBAT_PHASE_BLINK then
		table.remove( self.vecCombatQueue, 1 )
		print( self.me:GetUnitName() .. ' ***REMOVING Blink FROM COMBAT QUEUE' )

		local vPos = nil
		if self.nPhase == self.PHASE_COMBAT then
			-- standard blink during combat
			vPos = self.Encounter:GetOpenTeleportPositionForEnt( self.me )
		end

		if vPos == nil then
			print( 'ERROR - CBossArcWarden:EvaluateBlink() - vPos is nil!' )
			return nil
		end

		print( 'CBossArcWarden:EvaluateBlink() - returning valid Blink order to position: ' .. vPos.x .. ', ' .. vPos.y .. ', ' .. vPos.z )
		Order = 
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = vPos,
			AbilityIndex = self.hBlink:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = 3.0
		Order.name = 'Blink'
		print( 'BLINK ORDER TIME = ' .. Order.flOrderInterval .. ' - Game Time = ' .. GameRules:GetGameTime() )
	end

	return Order
end

--------------------------------------------------------------------------------

function CBossArcWarden:EvaluateChannelMeteor()
	if self.nPhase ~= self.PHASE_BEGIN_CHANNEL_METEOR then
		return nil
	end
end	

--------------------------------------------------------------------------------

function CBossArcWarden:CreateSparkWraithMaze()
	local hMeteor = self.Encounter:GetMeteor()
	local vCenterPos = hMeteor:GetAbsOrigin()

	local kv = 
	{
		spark_damage = self.hSparkWraithUlt:GetSpecialValueFor( "spark_damage" ),
		duration = self.hSparkWraithUlt:GetSpecialValueFor( "duration" ),
		original = true,
		radius = self.hSparkWraithUlt:GetSpecialValueFor( "radius" ),
		wraith_speed = self.hSparkWraithUlt:GetSpecialValueFor( "wraith_speed" ),
		activation_delay = self.hSparkWraithUlt:GetSpecialValueFor( "activation_delay" ),
		scepter_activation_delay = self.hSparkWraithUlt:GetSpecialValueFor( "scepter_activation_delay" ),
		think_interval = self.hSparkWraithUlt:GetSpecialValueFor( "think_interval" ),
		wraith_vision_radius = self.hSparkWraithUlt:GetSpecialValueFor( "wraith_vision_radius" ),
		mini_stun_duration = self.hSparkWraithUlt:GetSpecialValueFor( "mini_stun_duration" ),
		move_speed_slow_pct = self.hSparkWraithUlt:GetSpecialValueFor( "move_speed_slow_pct" ),
		rotation_center_x = vCenterPos.x,
		rotation_center_y = vCenterPos.y,
		rotation_center_z = vCenterPos.z,
		push_distance = self.hSparkWraithUlt:GetSpecialValueFor( "push_distance" ),
		push_duration = self.hSparkWraithUlt:GetSpecialValueFor( "push_duration" ),
	}

	print( 'Creating Spark Wraith Maze!' )
	local rotation_direction = 1

	for _, SparkWraithData in ipairs( self.SparkWraithMazeData ) do
		local fDegreesBetweenWraiths = 360 / SparkWraithData.num
		local startAngle = VectorAngles( Vector( 1, 0, 0 ) )
		--print( 'Degrees Between Wraiths = ' .. fDegreesBetweenWraiths )

		kv.rotation_speed = SparkWraithData.rotation_speed
		kv.rotation_direction = rotation_direction

		local SparkWraithsToSummon = {}
		for i=1, SparkWraithData.num do
			local Angle = QAngle( 0, startAngle.y + ( fDegreesBetweenWraiths * (i-1) ), 0 )
			local vDir = AnglesToVector( Angle )
			local vSpawnPos = vCenterPos + ( vDir * SparkWraithData.distance )
			vSpawnPos = GetGroundPosition( vSpawnPos, nil )
			--print( 'ADDING WRAITH AT POSITION: ' .. vSpawnPos.x .. ', ' .. vSpawnPos.y .. ', ' .. vSpawnPos.z )
			table.insert( SparkWraithsToSummon, vSpawnPos )
		end

		-- remove the proper number of positions
		for i=1, SparkWraithData.num_missing do
			local n = RandomInt( 1, #SparkWraithsToSummon )
			table.remove( SparkWraithsToSummon, n )
		end

		for _, v in ipairs( SparkWraithsToSummon ) do
			local hThinker = CreateModifierThinker( self.me, self.hSparkWraithUlt, "modifier_aghsfort_arc_warden_boss_spark_wraith_thinker", kv, v, self.me:GetTeamNumber(), false )
			hThinker:AddNewModifier( hThinker, nil, "modifier_provide_vision", { duration = -1 } )
		end

		rotation_direction = rotation_direction * -1
	end

	--local hCounter = self.me:FindModifierByName( 'modifier_boss_arc_warden_shard_counter' )
	--if hCounter then
	--	hCounter:CreateSparkWraithMaze( self.SparkWraithsToSummon, kv, self.me, self.hSparkWraithUlt )
	--end

	--for _,vPos in ipairs( self.SparkWraithsToSummon ) do
	--	CreateModifierThinker( self.me, self.hSparkWraithUlt, "modifier_aghsfort_arc_warden_boss_spark_wraith_thinker", kv, vPos, self.me:GetTeamNumber(), false )
	--end
end

--------------------------------------------------------------------------------

function CBossArcWarden:OnBossUsedAbility( szAbilityName )
	CBossBase.OnBossUsedAbility( self, szAbilityName )
end

--------------------------------------------------------------------------------

function CBossArcWarden:RemoveMagneticFields()
	local hThinkers = Entities:FindAllByClassname( "npc_dota_thinker" )

	--print( 'CBossArcWarden:RemoveMagneticFields()' )
	for i=#hThinkers,1,-1 do
		if hThinkers[i]:HasModifier( "modifier_aghsfort_arc_warden_boss_magnetic_field_thinker_evasion" ) or  hThinkers[i]:HasModifier( "modifier_aghsfort_arc_warden_boss_magnetic_field_thinker_evasion" ) then
			--print( 'Removing a Magnetic Field!' )
			UTIL_Remove( hThinkers[i] )
		end
	end

	self.me:RemoveModifierByName( "modifier_aghsfort_arc_warden_boss_magnetic_field_attack_speed" )
end

--------------------------------------------------------------------------------

function CBossArcWarden:RemoveSparkWraiths()
	local hThinkers = Entities:FindAllByClassname( "npc_dota_thinker" )

	--print( 'CBossArcWarden:RemoveSparkWraiths()' )
	for i=#hThinkers,1,-1 do
		if hThinkers[i]:HasModifier( "modifier_aghsfort_arc_warden_boss_spark_wraith_thinker" ) then
			--print( 'Removing a Spark Wraith!' )
			UTIL_Remove( hThinkers[i] )
		end
	end
end

--------------------------------------------------------------------------------

function CBossArcWarden:RemoveTempestDoubles()
	local hClones = Entities:FindAllByClassname( "npc_dota_creature" )

	--print( 'CBossArcWarden:RemoveTempestDoubles()' )
	for i=#hClones,1,-1 do
		if hClones[i] ~= nil and hClones[i]:IsNull() == false and hClones[i]:IsAlive() and hClones[i]:GetUnitName() == "npc_dota_aghsfort_arc_warden_boss_clone" then
			--print( 'Removing a Clone!' )
			hClones[i]:ForceKill( false )
		end
	end
end
