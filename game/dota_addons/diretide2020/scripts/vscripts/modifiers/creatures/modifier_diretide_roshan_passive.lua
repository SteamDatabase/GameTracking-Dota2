
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
	}

	return state
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:OnCreated( kv )
	if IsServer() then
		self:Reset()
		self:StartIntervalThink( 0.01 )
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

	self:GetParent().nPreservedStackCount = nil

	-- Set immunity
	self:GetParent().vecLastTargets[self:GetParent().hTrickOrTreatTarget] = GameRules:GetDOTATime( false, true ) + DIRETIDE_ROSHAN_HERO_TARGET_IMMUNITY_TIME

	--self:GetParent().hTrickOrTreatTarget:RemoveModifierByName( "modifier_prevent_invisibility" )
	self:GetParent().hTrickOrTreatTarget:RemoveModifierByName( "modifier_truesight" )
	local hPlayer = self:GetParent().hTrickOrTreatTarget:GetPlayerOwner()
	if hPlayer then
		StopSoundEvent( "RoshanTarget.Loop", hPlayer )
	end

	self:GetParent().hTrickOrTreatTarget:RemoveModifierByName( "modifier_provide_roshan_vision" )

	self:GetParent().hTrickOrTreatTarget = nil
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:Reset()
	self:GetParent().bNeedsReset = false

	self.chaseStartTime = nil

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
		if self:GetParent().nPreservedStackCount ~= nil then
			nNewCandyCount = self:GetParent().nPreservedStackCount
		else
			nNewCandyCount = ROSHAN_TRICK_OR_TREAT_BASE_CANDY_COUNT + self:GetCounter()

			local nOurCandy = GameRules.Diretide:GetTeamTotalCandy( self:GetParent().nTrickOrTreatTeam )
			local nTheirCandy = GameRules.Diretide:GetTeamTotalCandy( FlipTeamNumber( self:GetParent().nTrickOrTreatTeam ) )
			if nOurCandy > nTheirCandy then
				nNewCandyCount = nNewCandyCount + math.ceil( ( nOurCandy - nTheirCandy ) * ROSHAN_TRICK_OR_TREAT_SCORE_DIFF_MULTIPLIER )
			end
		end
	end
	self:SetStackCount( nNewCandyCount )
	self:GetParent().nPreservedStackCount = nil

	if self.nParticleFX ~= nil and self.nParticleFX ~= -1 then
		ParticleManager:DestroyParticle( self.nParticleFX, true )
	end

	if self:GetStackCount() > 0 then
		self.nParticleFX = ParticleManager:CreateParticle( "particles/hw_fx/candy_carrying_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		local vWhite = Vector( 1.0, 1.0, 1.0 )
		ParticleManager:SetParticleControl( self.nParticleFX, 3, vWhite )
		self:AddParticle( self.nParticleFX, false, false, -1, false, true )

		self:UpdateFX()
	end

	self:GetParent():RemoveModifierByName( "modifier_roshan_angry" )
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:OnIntervalThink()
	if IsServer() == false then
		return
	end

	if self:GetParent().bNeedsReset == true then
		self:Reset()
	end

	-- Check and apply curse if needed
	self:UpdateCurse( false )

	self:UpdateFX()

	if self.flCurseDelayTimer ~= -1 then
		if GameRules:GetDOTATime( false, true ) > self.flCurseDelayTimer then
			self:ApplyCurse( self.nTeamToCurse )
		end
		return
	end

	if self.flAngerTimer ~= -1 then
		if GameRules:GetDOTATime( false, true ) > self.flAngerTimer then
			self:FinishAngry()
		end
		return
	end
	
	if self.flEatTimer ~= -1 then
		if GameRules:GetDOTATime( false, true ) > self.flEatTimer then
			self:FinishEating()
			return
		else
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
	else
		if self:GetParent().hTrickOrTreatTarget ~= nil and self:GetStackCount() <= 0 then
			self:EatCandy()
			return
		end
	end

	if self:GetParent().nTreatMode ~= nil and ( self:GetParent().nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_REQUEST or self:GetParent().nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_ATTACK ) then
		if self.flEatTimer == -1 and self.flRequestTimer == -1 then
			self:PerformKnockbacks()
		end

		-- if lack a chase time, set it
		if self.chaseStartTime == nil then
			self.chaseStartTime = GameRules:GetDOTATime( false, true )
		end

		-- check for target going bad
		local bReset = false
		-- if it's just busted, bail immediately
		if self:GetParent().hTrickOrTreatTarget == nil or self:GetParent().hTrickOrTreatTarget:IsNull() == true or self:GetParent().hTrickOrTreatTarget:IsAlive() == false then
			bReset = true
		else -- check if it's out of game, and if so wait a bit before resetting
			if self:GetParent().hTrickOrTreatTarget:IsOutOfGame() then
				if self.flOutOfGameTimer == -1 then
					self.flOutOfGameTimer = GameRules:GetDOTATime( false, true ) + _G.DIRETIDE_ROSHAN_SECONDS_TO_WAIT_FOR_OUT_OF_GAME
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
			self:ResetHero()
			self:GetParent().nPreservedStackCount = self:GetStackCount()
			GameRules.Diretide:TrickOrTreatToTeam( self:GetParent().nTrickOrTreatTeam, false )
			self:Reset()
			return
		end
	end

	if self.flRequestTimer == -1 then
		if self:GetParent().nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_REQUEST then
			if self.nParticleFX == -1 then -- should never happen, but... (we call Reset() which recreates this if we're going back to Request mode)
				self.nParticleFX = ParticleManager:CreateParticle( "particles/hw_fx/candy_carrying_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
				local vWhite = Vector( 1.0, 1.0, 1.0 )
				ParticleManager:SetParticleControl( self.nParticleFX, 3, vWhite )
				self:AddParticle( self.nParticleFX, false, false, -1, false, true )
				self:UpdateFX()
			end

			local flDist = ( self:GetParent().hTrickOrTreatTarget:GetAbsOrigin() - self:GetParent():GetAbsOrigin() ):Length2D()
			if flDist < DIRETIDE_ROSHAN_REQUEST_PROXIMITY_DISTANCE then
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
		local nStack = math.mod( self:GetStackCount(), 10 )
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
	self.chaseStartTime = self.chaseStartTime + ROSHAN_TRICK_OR_TREAT_REQUEST_DURATION
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

function modifier_diretide_roshan_passive:ApplyCurse( nTeam )
	if nTeam ~= nil then
		local gameEvent = {}
		gameEvent["teamnumber"] = -1
		if nTeam == DOTA_TEAM_GOODGUYS then
			gameEvent["message"] = "#DOTA_HUD_RoshanCursedGoodTeam_Toast"
		else
			gameEvent["message"] = "#DOTA_HUD_RoshanCursedBadTeam_Toast"
		end
		FireGameEvent( "dota_combat_event_message", gameEvent )

		-- Kick off an event to declare one team is cursed, client-side
		FireGameEvent( "team_cursed", {
			cursed_team = nTeam,
			} )

		EmitAnnouncerSoundForTeam( "RoshanDT.Curse.Stinger", nTeam )
		for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
			if PlayerResource:IsValidPlayerID( nPlayerID ) then
				local nPlayerTeam = PlayerResource:GetTeam( nPlayerID )
				if nPlayerTeam == FlipTeamNumber( nTeam ) then
					EmitSoundOnClient( "RoshanDT.Curse.Enemy", PlayerResource:GetPlayer( nPlayerID ) )
				end
			end
		end

		if self:GetParent().vecCurseTimes == nil then
			self:GetParent().vecCurseTimes = {}
		end
		self:GetParent().vecCurseTimes[nTeam] = GameRules:GetDOTATime( false, true ) + self:GetAbility():GetLevelSpecialValueFor( "CurseDuration", 1 )
		self:UpdateCurse( true )

		-- update treat count
		self:UpdateCounterOnCurse( nTeam )
	end

	local nCurseFX = ParticleManager:CreateParticle( "particles/econ/items/ursa/ursa_ti10/ursa_ti10_earthshock.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( nCurseFX, 1, Vector( 500, 250, 125 ) )
	ParticleManager:ReleaseParticleIndex( nCurseFX )

	self.flCurseDelayTimer = -1
	self.nTeamToCurse = -1
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:FinishAngry()
	--print( "Done pouting!" )

	self.flAngerTimer = -1
	--self:GetParent():FadeGesture( ACT_DOTA_CHANNEL_ABILITY_7 )
	--EmitSoundOn( "RoshanDT.Bellyache", self:GetParent() )
	self:GetParent().nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_RETURN

	self:GetParent():RemoveModifierByName( "modifier_roshan_angry" )

	self:PingPong()
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:EatCandy()
	--print( "Eating my Candy!" )

	GameRules.Diretide:GetTeamAnnouncer( self:GetParent().hTrickOrTreatTarget:GetTeamNumber() ):OnRoshanSatiated( self:GetParent().hTrickOrTreatTarget )

	self.flRequestTimer = -1
	self.flEatTimer = GameRules:GetDOTATime( false, true ) + ROSHAN_TRICK_OR_TREAT_EAT_DURATION
	self:GetParent():StartGesture( ACT_DOTA_CHANNEL_ABILITY_7 )

	self:ResetHero()
	self:GetParent().nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_RETURN

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

	self:PingPong()
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:PingPong()
	local nTargetTeam = ( self:GetParent().nTrickOrTreatTeam == DOTA_TEAM_GOODGUYS and DOTA_TEAM_BADGUYS ) or DOTA_TEAM_GOODGUYS
	--printf( "Done attacking team %d, now attacking other team %d", self:GetParent().nTrickOrTreatTeam, nTargetTeam )
	GameRules.Diretide:TrickOrTreatToTeam( nTargetTeam, true )

	self:Reset()
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
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:OnAttack( params )
	if self:GetParent() == params.attacker and params.target ~= nil and params.target:IsNull() == false then
		params.target:RemoveModifierByName( "modifier_templar_assassin_refraction_absorb" )
	end
	return 0
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:GetModifierProvidesFOWVision( params )
	if params.target ~= nil and ( params.target:GetTeamNumber() == DOTA_TEAM_GOODGUYS or params.target:GetTeamNumber() == DOTA_TEAM_BADGUYS ) then
		return 1
	end
	return 0
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:GetCounter()
	return GameRules.Diretide:GetRoshanRequestCounter( self:GetParent().nTrickOrTreatTeam )
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:UpdateCounterOnCurse( nTeam )
	if DIRETIDE_ROSHAN_RESET_CANDY_ON_KILL == true then
		local nCounter = self:GetCounter()
		if nCounter < 2 then
			self:GetParent().nTrickOrTreatCounter[nTeam] = -1 -- will be set to 0 on next treat
		else
			self:GetParent().nTrickOrTreatCounter[nTeam] = math.floor( nCounter / 2 )
		end
	end
	return 
end


--------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:GetModifierDamageOutgoing_Percentage( params )
	local nPctBuff = self:GetCounter() * self:GetAbility():GetLevelSpecialValueFor( "DamageBonusPctPerTreat", 5 )
	local nRoundNumber = ( GameRules.Diretide and GameRules.Diretide:GetRoundNumber() ) or 1
	return ( nRoundNumber - 1 ) * self:GetAbility():GetLevelSpecialValueFor( "DamageBonusPctBasePerRound", 30 ) + nPctBuff * nRoundNumber
end

--------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:GetModifierMoveSpeedBonus_Percentage( params )
	local nSpeedBuff =  self:GetCounter() * self:GetAbility():GetLevelSpecialValueFor( "MoveSpeedBonusPctPerTreat", 10 )
	if self.chaseStartTime ~= nil then
		nSpeedBuff = math.floor( ( ( 100.0 + nSpeedBuff ) / 100.0 ) * math.max( 0, GameRules:GetDOTATime( false, true ) - self.chaseStartTime ) * self:GetAbility():GetLevelSpecialValueFor( "MoveSpeedBonusPctPerSecond", 5 ) )
	else
	end
	--print( "++++++ Roshan speed buff " .. nSpeedBuff )
	return nSpeedBuff
end

----------------------------------------------------------------------------------------

function modifier_diretide_roshan_passive:OnDeath( params )
	if IsServer() == false then
		return
	end

	if params.unit == self:GetParent().hTrickOrTreatTarget then
		self:ResetHero() -- kills soundloop, modifiers, etc

		--print( "Trick or treat target died." )
		if self:GetParent().nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_REQUEST then
			--print( "Target killed before requesting.. finding a new request target.")
			self:GetParent().nPreservedStackCount = self:GetStackCount()
			GameRules.Diretide:TrickOrTreatToTeam( params.unit:GetTeamNumber(), false )
			self:Reset()
		else
			--print( "Target killed after requesting.")
			GameRules.Diretide:GetTeamAnnouncer( params.unit:GetTeamNumber() ):OnRoshanKill( params.unit )
			self:TargetKilledAfterRequest( params.unit:GetTeamNumber() )
		end
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
		local flDamage = self:GetAbility():GetLevelSpecialValueFor( "KnockbackDamagePerRound", 100 ) * GameRules.Diretide:GetRoundNumber()
		flDamage = flDamage + fBaseDamage
		local flDamageCreeps = self:GetAbility():GetLevelSpecialValueFor( "KnockbackDamagePerRoundCreeps", 10 ) * GameRules.Diretide:GetRoundNumber()
		
		for _, hEnemy in pairs(vecEntities) do
			if hEnemy ~= self:GetParent() and hEnemy:FindModifierByName( "modifier_pangolier_gyroshell_timeout" ) == nil then
				EmitSoundOn( ( hEnemy:IsHero() and "RoshanDT.Stun" ) or "RoshanDT.Stun.Creep", hEnemy )

				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, hEnemy ) -- nil, self:GetCaster()
				ParticleManager:SetParticleControl( nFXIndex, 1, Vector( nTensStack, nStack, 0 ) )
				ParticleManager:SetParticleControl( nFXIndex, 1, Vector( hit_radius, hit_radius, hit_radius ) )
				ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				local vToEnemy = hEnemy:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()
				vToEnemy.z = 0
				local vLoc = hEnemy:GetAbsOrigin() + ( self:GetAbility():GetLevelSpecialValueFor( "KnockbackRadius", 500 ) * vToEnemy:Normalized() )
				vLoc.z = GetGroundHeight( vLoc, hEnemy )

				local kv = {
					vLocX = vLoc.x,
					vLocY = vLoc.y,
					vLocZ = vLoc.z,
					bounce_duration = self:GetAbility():GetLevelSpecialValueFor( "BounceDuration", 1.0 ),
				}
				hEnemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_pangolier_gyroshell_bounce", kv )

				local kv2 = {
					duration = self:GetAbility():GetLevelSpecialValueFor( "BounceDuration", 1.0 ) + self:GetAbility():GetLevelSpecialValueFor( "StunDuration", 1.0 ),
				}
				hEnemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_pangolier_gyroshell_timeout", kv2 )

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

	GridNav:DestroyTreesAroundPoint( self:GetCaster():GetOrigin(), hit_radius, true )
end
