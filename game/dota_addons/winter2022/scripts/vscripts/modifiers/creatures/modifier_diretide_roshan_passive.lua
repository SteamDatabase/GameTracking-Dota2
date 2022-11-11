require( "winter2022_utility_functions" )

if modifier_diretide_roshan_passive == nil then
	modifier_diretide_roshan_passive = class( {} ) 
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:IsHidden()
	return true
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:IsPurgable()
	return false
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:RemoveOnDeath()
	return false
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:CheckState()
	if IsServer() == false then
		return
	end

	local bDisarmed = true
	if self:GetParent().nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_ATTACK or self:GetParent().nCandyAttackTeam ~= nil then
		bDisarmed = false
	end

	local bRooted = false
	if self.flRequestTimer ~= -1 then
		bRooted = true
	end

	local bStunned = false
	if self.flEatTimer ~= -1 then
		bStunned = true
	end

	local bUnselectable = false
	if self:GetStackCount() == 0 then
		bUnselectable = true
	end
		
	local state =
	{
		[MODIFIER_STATE_DISARMED] = bDisarmed,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ROOTED] = bRooted,
		[MODIFIER_STATE_STUNNED] = bStunned,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = bUnselectable,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = self:GetParent().nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_NONE,
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_OBSTRUCTIONS] = true,
	}

	return state
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:OnCreated( kv )
	if IsServer() then
		self:Reset()
		self:StartIntervalThink( 0.03 )
	end
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:StopThinking()
	if IsServer() then
		self:GetParent().nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_NONE
		self:Reset()
		self:StartIntervalThink( -1 )
	end
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:UpdateCurse( bApplyFX )
	if self:GetParent().vecCurseTimes ~= nil then
		for nCheckTeam = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
			if self:GetParent().vecCurseTimes[nCheckTeam] ~= nil and self:GetParent().vecCurseTimes[nCheckTeam] > GameRules:GetDOTATime( false, true ) then
				local fDuration = self:GetParent().vecCurseTimes[nCheckTeam] - GameRules:GetDOTATime( false, true )
				local vecAllies = FindUnitsInRadius( nCheckTeam, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
				for _, hAlly in ipairs( vecAllies ) do
					if hAlly:IsRealHero() then
						if hAlly:FindModifierByName( "modifier_diretide_roshan_curse_debuff" ) == nil then
							hAlly:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_diretide_roshan_curse_debuff", { duration = fDuration } )
							
							if bApplyFX then
								local vecStartPos = hAlly:GetAbsOrigin()
								vecStartPos.z = 4000

								local nFXIndex = ParticleManager:CreateParticle( "particles/roshan/roshan_curse/roshan_curse_thundergods_wrath.vpcf", PATTACH_CUSTOMORIGIN, hAlly )
								ParticleManager:SetParticleControl( nFXIndex, 0, vecStartPos )
								ParticleManager:SetParticleControlEnt( nFXIndex, 1, hAlly, PATTACH_POINT_FOLLOW, "attach_hitloc", hAlly:GetAbsOrigin(), true )
								ParticleManager:ReleaseParticleIndex( nFXIndex )
							end
						end
					end
				end
			end
		end
	end
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:ResetHero()
	if self:GetParent().hTrickOrTreatTarget == nil then
		return
	end

	-- Set immunity
	--self:GetParent().vecLastTargets[self:GetParent().hTrickOrTreatTarget] = GameRules:GetDOTATime( false, true ) + DIRETIDE_ROSHAN_HERO_TARGET_IMMUNITY_TIME

	--self:GetParent().hTrickOrTreatTarget:RemoveModifierByName( "modifier_prevent_invisibility" )
	self:GetParent().hTrickOrTreatTarget:RemoveModifierByName( "modifier_truesight" )
	StopGlobalSound( "RoshanTarget.Loop.Ally" )
	StopGlobalSound( "RoshanTarget.Loop.Enemy" )
	
	self:GetParent().hTrickOrTreatTarget:RemoveModifierByName( "modifier_provide_roshan_vision" )

	GameRules.Winter2022:SetTrickOrTreatTarget( nil )
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:Reset()
	self:GetParent().bNeedsReset = false

	self.flPathDist = nil -- force recalc

	if self.flRequestTimer ~= -1 then
		self:GetParent():FadeGesture( ACT_DOTA_CHANNEL_ABILITY_5 )
	end
	self.flRequestTimer = -1

	if self.flEatTimer ~= -1 then
		self:GetParent():FadeGesture( ACT_DOTA_CHANNEL_ABILITY_7 )
	end
	self.flEatTimer = -1

	self.flAngerTimer = -1
	self.flOutOfGameTimer = -1
	self.flCurseDelayTimer = -1

	if self.nFedFX ~= nil and self.nFedFX ~= -1 then
		ParticleManager:DestroyParticle( self.nFedFX, false )
	end

	local nNewCandyCount = 0
	if self:GetParent().hTrickOrTreatTarget ~= nil then
		nNewCandyCount = self:GetCounter()
		-- TODO: add rubber banding to this?
		--GameRules.Winter2022:GetCurrentCandyHeldByTeam( self:GetParent().nTrickOrTreatTeam )
	end
	print( '^^^modifier_diretide_roshan_passive:Reset() - Resetting nCandyCount to ' .. nNewCandyCount )
	self:SetStackCount( nNewCandyCount )

	if self.nParticleFX ~= nil and self.nParticleFX ~= -1 then
		ParticleManager:DestroyParticle( self.nParticleFX, true )
	end

	--[[if self:GetStackCount() > 0 then
		self.nParticleFX = ParticleManager:CreateParticle( "particles/hw_fx/candy_carrying_building_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		local vWhite = Vector( 1.0, 1.0, 1.0 )
		ParticleManager:SetParticleControl( self.nParticleFX, 3, vWhite )
		self:AddParticle( self.nParticleFX, false, false, -1, false, true )

		self:UpdateFX()
	end--]]

	self:GetParent():RemoveModifierByName( "modifier_roshan_angry" )
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:UpdateCandyAskCounter()
	local nNewCandyCount = 0
	if self:GetParent().hTrickOrTreatTarget ~= nil then
		nNewCandyCount = self:GetCounter()
	end
	print( '^^^modifier_diretide_roshan_passive:UpdateCandyAskCounter() - Setting Candy Ask to ' .. nNewCandyCount )
	self:SetStackCount( nNewCandyCount )

	if nNewCandyCount <= 0 and self.flEatTimer == -1 then
		self:ResetHero()		
		GameRules.Winter2022:RoshanRetarget()
	end

	-- interval tick will update the fx
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:AttemptEatCandy( nThrowAmount )
	print( '^^^AttemptEatCandy' )

	self:SetStackCount( math.max( 0, self:GetStackCount() - nThrowAmount ) )
	self:GetParent().bMustAttackTarget = nil

	if self:GetStackCount() <= 0 then
		-- need to make sure we're not already eating
		if self.flEatTimer == -1 then
			if self:GetParent().bCanAttackWell then
				self:EatCandy()
				return true
			end
		end
	end

	return false
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:OnIntervalThink()
	if IsServer() == false then
		return
	end

	if self:GetParent().bNeedsReset == true then
		self:Reset()
	end

	if self:GetParent().nTreatMode ~= _G.ROSHAN_TRICK_OR_TREAT_MODE_NONE then
		self:PerformKnockbacks()
	end

	self:UpdateFX()
	if self.flEatTimer ~= -1 then
		if GameRules:GetDOTATime( false, true ) > self.flEatTimer then
			self:FinishEating()
			return
		end
	end

	if self:GetParent().nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_RETURN then
		local hHighFive = self:GetParent():FindAbilityByName( "seasonal_diretide2020_high_five" )
		if hHighFive and hHighFive:IsCooldownReady() then
			local hEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
			if #hEnemies > 0 then
				for _, hEnemy in pairs( hEnemies ) do
					if hEnemy and hEnemy:FindModifierByName( "modifier_seasonal_diretide2020_high_five_requested" ) then
						hHighFive:CastAbility()
					end
				end
			end
		end
	end

	if self:GetParent().nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_REQUEST or self:GetParent().nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_ATTACK then
		-- if lack a chase time, set it
		if self:GetParent().chaseStartTime == nil then
			self:GetParent().chaseStartTime = GameRules:GetDOTATime( false, true )
		end

		local hTarget = self:GetParent().hTrickOrTreatTarget

		-- check for target going bad
		local bReset = false
		-- if it's just busted, bail immediately
		if hTarget == nil or hTarget:IsNull() == true or hTarget:IsAlive() == false then
			print( "target bad" )
			bReset = true
		elseif hTarget:IsBuilding() then
			self.flPathDist = self:GetPathDist()
			-- if we haven't started hitting the well yet, we will retarget to a hero if they pick up candy.
			if _G.WINTER2022_ROSHAN_ALLOW_RETARGET and self:GetParent().nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_ATTACK then
				local hNewTarget = GameRules.Winter2022:FindRoshanTarget()
				if hNewTarget ~= nil and hNewTarget ~= hTarget then
					print( "^^^found a better building to attack!" )
					bReset = true
				end
			end
		else -- check if it's out of game, and if so wait a bit before resetting
			if hTarget:IsOutOfGame() then
				if self.flOutOfGameTimer == -1 then
					self.flOutOfGameTimer = GameRules:GetDOTATime( false, true ) + _G.WINTER2022_ROSHAN_SECONDS_TO_WAIT_FOR_OUT_OF_GAME
					return
				elseif GameRules:GetDOTATime( false, true ) > self.flOutOfGameTimer then
					bReset = true
				else
					return
				end
			else
				self.flOutOfGameTimer = -1
			end
		end
		if bReset == true then
			print( "Retarget: ROSHAN RESET" )
			self:ResetHero()
			GameRules.Winter2022:DirectStateTransition( _G.WINTER2022_STATE_ROSHAN, false )
			self:Reset()
			return
		end
	end

	if self.flRequestTimer == -1 then
		if self:GetParent().nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_REQUEST then
			--print( '***REQUEST MODE' )
			--[[if self.nParticleFX == -1 then -- should never happen, but... (we call Reset() which recreates this if we're going back to Request mode)
				self.nParticleFX = ParticleManager:CreateParticle( "particles/hw_fx/candy_carrying_building_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
				local vWhite = Vector( 1.0, 1.0, 1.0 )
				ParticleManager:SetParticleControl( self.nParticleFX, 3, vWhite )
				self:AddParticle( self.nParticleFX, false, false, -1, false, true )
				self:UpdateFX()
			end--]]

			local flDist = ( self:GetParent().hTrickOrTreatTarget:GetAbsOrigin() - self:GetParent():GetAbsOrigin() ):Length2D()
			if flDist < WINTER2022_ROSHAN_REQUEST_PROXIMITY_DISTANCE then
				print( '***CLOSE ENOUGH TO REQUEST CANDY' )
				self:RequestCandy()
				return
			end
		end
	else
		self:UpdateFX()

		if GameRules:GetDOTATime( false, true ) > self.flRequestTimer then
			self:FinishRequesting()
			return
		else
			if self:GetParent().hTrickOrTreatTarget ~= nil then
				local vToTarget = self:GetParent().hTrickOrTreatTarget:GetAbsOrigin() - self:GetParent():GetAbsOrigin()
				local vForward = self:GetParent():GetForwardVector()

				--self:GetParent():FaceTowards( vToTarget * 0.01 + vForward * 0.99 )
			end
		end
	end
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:UpdateFX()
	if self.nParticleFX ~= nil and self.nParticleFX ~= -1 then
		local nStack = self:GetStackCount() % 10
		local nTensStack = math.floor( self:GetStackCount() / 10 ) 
			
		ParticleManager:SetParticleControl( self.nParticleFX, 2, Vector( nTensStack, nStack, 0 ) )
	end
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:RequestCandy()
	--print( "Requesting Candy!" )
	self.flRequestTimer = GameRules:GetDOTATime( false, true ) + ROSHAN_TRICK_OR_TREAT_REQUEST_DURATION
	self:GetParent():StartGesture( ACT_DOTA_CHANNEL_ABILITY_5 )
	--EmitSoundOn( "RoshanDT.Beg", self:GetParent() )
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:FinishRequesting()
	--print( "Done Requesting - Attack!" )
	self.flRequestTimer = -1
	-- skip the time we were requesting
	self:GetParent().chaseStartTime = self:GetParent().chaseStartTime + ROSHAN_TRICK_OR_TREAT_REQUEST_DURATION
	self:GetParent().nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_ATTACK
	self:GetParent():FadeGesture( ACT_DOTA_CHANNEL_ABILITY_5 )
	--EmitSoundOn( "RoshanDT.Scream", self:GetParent() )

	self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_roshan_angry", { duration = -1 } )
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:TargetKilledAfterRequest( nTeam )
	self.nTeamToCurse = nTeam

	self:GetParent().nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_NONE

	self:Reset() -- kill FX, reset timers

	-- Apply anim/FX, set timer
	--print( "Pouting!" )
	-- Assert: ROSHAN_TRICK_OR_TREAT_ANGER_DURATION > ROSHAN_TRICK_OR_TREAT_CURSE_DELAY
	self.flAngerTimer = GameRules:GetDOTATime( false, true ) + ROSHAN_TRICK_OR_TREAT_ANGER_DURATION
	self.flCurseDelayTimer = GameRules:GetDOTATime( false, true ) + ROSHAN_TRICK_OR_TREAT_CURSE_DELAY
	self:GetParent():StartGesture( ACT_DOTA_CAST_ABILITY_2 )
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:EatCandy()
	print( "Eating my Candy!" )

	self:GetParent().nNumAsks = ( self:GetParent().nNumAsks or 1 ) + 1

	GameRules.Winter2022:GetTeamAnnouncer( self:GetParent().hTrickOrTreatTarget:GetTeamNumber() ):OnRoshanSatiated( self:GetParent().hTrickOrTreatTarget )

	self.flEatTimer = GameRules:GetDOTATime( false, true ) + ROSHAN_TRICK_OR_TREAT_EAT_DURATION
	self:GetParent():StartGesture( ACT_DOTA_CHANNEL_ABILITY_7 )

	self:ResetHero()
	self:GetParent().nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_NONE

	if self.nParticleFX ~= nil and self.nParticleFX ~= -1 then
		ParticleManager:DestroyParticle( self.nParticleFX, true )
		self.nParticleFX = -1
	end

	self.nFedFX = ParticleManager:CreateParticle( "particles/hw_fx/candy_fed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle( self.nFedFX, false, false, -1, false, false )

	self:GetParent():RemoveModifierByName( "modifier_roshan_angry" )

	--EmitSoundOn( "RoshanDT.Eat", self:GetParent() )
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:FinishEating()
	--print( "Done eating!" )
	self.flEatTimer = -1
	self:GetParent():FadeGesture( ACT_DOTA_CHANNEL_ABILITY_7 )
	--EmitSoundOn( "RoshanDT.Bellyache", self:GetParent() )
	print( "Retarget: EAT FINISH" )
	GameRules.Winter2022:RoshanRetarget()
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

-----------------------------------------------------------------------------

function modifier_diretide_roshan_passive:GetModifierAttackSpeedBonus_Constant( params )
	if IsServer() == false then
		return 0
	end

	local hTarget = self:GetParent().hTrickOrTreatTarget
	if hTarget == nil or hTarget:IsNull() or hTarget:IsBuilding() == false then
		return 0
	end

	return 100
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:OnAttack( params )
	if self:GetParent() == params.attacker and params.target ~= nil and params.target:IsNull() == false then
		params.target:RemoveModifierByName( "modifier_templar_assassin_refraction_absorb" )

		if params.target == self:GetParent().hTrickOrTreatTarget then
			self:GetParent().bMustAttackTarget = nil
		end
	end
	return 0
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:GetModifierProvidesFOWVision( params )
	if IsServer() == false then
		return 0
	end
	if params.target ~= nil and ( params.target:GetTeamNumber() == DOTA_TEAM_GOODGUYS or params.target:GetTeamNumber() == DOTA_TEAM_BADGUYS ) then
		return 1
	end
	return 0
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:GetCounter()
	return GameRules.Winter2022:GetRoshanRequestCounter( self:GetParent().nTrickOrTreatTeam )
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:GetModifierDamageOutgoing_Percentage( params )
	if IsServer() == false then
		return 0
	end

	-- TODO - re-evaluate this wtf
	local nPctBuff = self:GetCounter() * self:GetAbility():GetLevelSpecialValueFor( "DamageBonusPctPerTreat", 5 )
	local nRoundNumber = ( GameRules.Winter2022 and GameRules.Winter2022:GetRoundNumber() ) or 1
	return ( nRoundNumber - 1 ) * self:GetAbility():GetLevelSpecialValueFor( "DamageBonusPctBasePerRound", 30 ) + nPctBuff * nRoundNumber
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:GetModifierIgnoreMovespeedLimit( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:ResetChaseTimer()
	self:GetParent().chaseStartTime = GameRules:GetDOTATime( false, true )
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function modifier_diretide_roshan_passive:GetPathDist()
	local hTarget = self:GetParent().hTrickOrTreatTarget
	if hTarget	~= nil and hTarget:IsNull() == false and hTarget:IsBuilding() then
		local flPathDist = self:GetParent():GetRemainingPathLength()
		--printf( "Roshan path length: %f", flPathDist )
		return flPathDist
	end

	return -1
end

function modifier_diretide_roshan_passive:GetModifierMoveSpeedBonus_Percentage( params )
	local hTarget = self:GetParent().hTrickOrTreatTarget
	if hTarget	~= nil and hTarget:IsNull() == false and hTarget:IsBuilding() then
		local flDist = self.flPathDist or self:GetPathDist()
		if flDist < 0 then
			return 0
		end
		local nBaseSpeed = 300
		local flTimeRemaining = GameRules.Winter2022:StateRemainingTime() - _G.WINTER2022_STATE_ROSHAN_TIME_EXTRA
		if flTimeRemaining < 1 then
			flTimeRemaining = 1
		end
		local flDesiredSpeed = flDist / flTimeRemaining
		local flRatio = flDesiredSpeed / nBaseSpeed
		flRatio = flRatio - 1
		flRatio = flRatio * 100
		return flRatio
	end

	local nSpeedBuff =  0
	if self:GetParent().chaseStartTime ~= nil then
		local flElapsedChaseTime = math.max( 0, GameRules:GetDOTATime( false, true ) - self:GetParent().chaseStartTime )
		nSpeedBuff = flElapsedChaseTime * self:GetAbility():GetLevelSpecialValueFor( "MoveSpeedBonusPctPerSecondChase", 2 )
	end
	--nSpeedBuff = math.floor( nSpeedBuff + GameRules.Winter2022:GetPlayedTime() * self:GetAbility():GetLevelSpecialValueFor( "MoveSpeedBonusPctPerSecondGameTime", 0.1 ) )
	--print( "++++++ Roshan speed buff " .. nSpeedBuff )
	nSpeedBuff = math.min( math.floor( nSpeedBuff ), self:GetAbility():GetLevelSpecialValueFor( "MaxGameTimeSpeedBonusPct", 200 ) )
	--print( "++++++ Roshan final CLAMPED speed buff " .. nSpeedBuff )
	return nSpeedBuff
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:OnDeath( params )
	if IsServer() == false then
		return
	end

	if params.unit == self:GetParent().hTrickOrTreatTarget then
		self:ResetHero() -- kills soundloop, modifiers, etc

		print( "Retarget: Trick or treat target DIED." )
		GameRules.Winter2022:RoshanRetarget()
		self:Reset()
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:GetActivityTranslationModifiers( params )
	local nMode = ROSHAN_TRICK_OR_TREAT_MODE_NONE
	local serverValues = CustomNetTables:GetTableValue( "globals", "values" );
	if serverValues ~= nil and serverValues[ "TrickOrTreatMode" ] ~= nil then
		nMode = serverValues[ "TrickOrTreatMode" ]
	end
	
	if nMode == ROSHAN_TRICK_OR_TREAT_MODE_ATTACK then
		return "sugarrush"
	else
		return "trickortreat"
	end
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:PerformKnockbacks()
	local hit_radius = self:GetAbility():GetLevelSpecialValueFor( "KnockbackHitRadius", 300 )
	local vecEntities = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), hit_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if #vecEntities > 0 then
		local fBaseDamage = self:GetAbility():GetLevelSpecialValueFor( "KnockbackBaseDamage", 75 )
		local flDamage = self:GetAbility():GetLevelSpecialValueFor( "KnockbackDamagePerRound", 100 ) * GameRules.Winter2022:GetRoundNumber()
		flDamage = flDamage + fBaseDamage
		local flDamageCreeps = self:GetAbility():GetLevelSpecialValueFor( "KnockbackDamagePerRoundCreeps", 10 ) * GameRules.Winter2022:GetRoundNumber()

		local flBounceDuration = self:GetAbility():GetLevelSpecialValueFor( "BounceDuration", 1.0 )
		local flStunDuration = self:GetAbility():GetLevelSpecialValueFor( "StunDuration", 1.0 )
		
		for _, hEnemy in pairs(vecEntities) do
			if hEnemy ~= self:GetParent() and hEnemy ~= self:GetParent().hTrickOrTreatTarget and hEnemy:FindModifierByName( "modifier_pangolier_gyroshell_timeout" ) == nil and hEnemy ~= GameRules.Winter2022.hRoshan.hGreevilToEat then
				EmitSoundOn( ( hEnemy:IsHero() and "RoshanDT.Stun" ) or "RoshanDT.Stun.Creep", hEnemy )

				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, hEnemy ) -- nil, self:GetCaster()
				ParticleManager:SetParticleControl( nFXIndex, 1, Vector( nTensStack, nStack, 0 ) )
				ParticleManager:SetParticleControl( nFXIndex, 1, Vector( hit_radius, hit_radius, hit_radius ) )
				ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				local vToEnemy = hEnemy:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()
				vToEnemy.z = 0

				local nKnockbackRadius = self:GetAbility():GetLevelSpecialValueFor( "KnockbackRadius", 500 )
				if IsGreevil( hEnemy ) then
					nKnockbackRadius = self:GetAbility():GetLevelSpecialValueFor( "GreevilKnockbackRadius", 500 )
				end

				local vLoc = hEnemy:GetAbsOrigin() + ( nKnockbackRadius * vToEnemy:Normalized() )
				vLoc.z = GetGroundHeight( vLoc, hEnemy )

				local kv = {
					vLocX = vLoc.x,
					vLocY = vLoc.y,
					vLocZ = vLoc.z,
					bounce_duration = flBounceDuration,
				}
				hEnemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_pangolier_gyroshell_bounce", kv )

				local kv2 = {
					duration = flBounceDuration + flStunDuration,
				}
				hEnemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_pangolier_gyroshell_timeout", kv2 )

				if IsGreevil( hEnemy ) == false or GameRules.Winter2022.m_nState == _G.WINTER2022_STATE_ROSHAN_KILL_GREEVILS then
					local DamageInfo =
					{
						victim = hEnemy,
						attacker = self:GetCaster(),
						ability = self:GetAbility(),
						damage = ( hEnemy:IsHero() and flDamage ) or flDamageCreeps,
						damage_type = DAMAGE_TYPE_MAGICAL,
					}
					ApplyDamage( DamageInfo )
				end
			end
		end
	end

	GridNav:DestroyTreesAroundPoint( self:GetCaster():GetOrigin(), hit_radius, true )
end
