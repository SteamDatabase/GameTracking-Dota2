--[[ Events ]]

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
function CLastHitTrainer:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	--print( "OnGameRulesStateChange: " .. nNewState )

	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		--print( "OnGameRulesStateChange: Hero Selection" )

	elseif nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		--print( "OnGameRulesStateChange: Pre Game" )

	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "OnGameRulesStateChange: Game In Progress" )
		--CustomGameEventManager:Send_ServerToAllClients( "mode_started", {} )

	end
end

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
function CLastHitTrainer:OnEntityKilled(event)
	local killer = EntIndexToHScript( event.entindex_attacker )
	local victim = EntIndexToHScript( event.entindex_killed )

	killer = killer:GetOwner() or killer

	if not victim:IsRealHero() then
		self.m_NetTableStats.m_TotalCreepDeaths = self.m_NetTableStats.m_TotalCreepDeaths + 1
	end

	if victim:GetTeamNumber() == DOTA_TEAM_BADGUYS and not killer:IsPlayer() then
		-- Last-hit streak is over, reset the counter
		self.m_NetTableStats.m_CurrentLastHitStreakCount = 0
	end

	local killed = EntIndexToHScript( event.entindex_killed )

	-- Denies don't have their own event.
	if killer:GetTeam() == killed:GetTeam() and killer:IsPlayer() then
		self:OnDeny( victim )
	end

	local nLastHitsPlusDenies = self.m_NetTableStats.m_LastHitCount + self.m_NetTableStats.m_DenyCount
	self.m_NetTableStats.m_TotalLastHitOrDenyPct = nLastHitsPlusDenies / self.m_NetTableStats.m_TotalCreepDeaths

	self:SendStatisticsToClient()
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CLastHitTrainer:OnNPCSpawned( event )
	spawnedUnit = EntIndexToHScript( event.entindex )

	if not self.m_hPlayerHero then
		if spawnedUnit:IsRealHero() and spawnedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			self.m_hPlayerHero = spawnedUnit
		end
	end

	spawnedUnit:SetDeathXP( 0 )
end

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
function CLastHitTrainer:InitializePlayerHero()
	if not self.m_hPlayerHero then
		return
	end

	self.m_hPlayerHero:SetAbilityPoints( 0 )

	local nAbilities = self.m_hPlayerHero:GetAbilityCount()
	for i = 0, nAbilities do
		local hAbility = self.m_hPlayerHero:GetAbilityByIndex( i )
		if not hAbility then
			break
		end

		-- Reset all abilities to 0 first.  Some may have been quickly levelled before the OnThink tick.
		if hAbility:GetLevel() > 0 then
			hAbility:SetLevel( 0 )
		end

		self:AllowSpecificAbilities( hAbility )
	end

	-- Remove pre-existing items, e.g. tp scroll
	for i = 0, 15 do
		local item = self.m_hPlayerHero:GetItemInSlot( i )
		if item then
			self.m_hPlayerHero:RemoveItem( item )
		end
	end

	-- Boost starting damage slightly
	for i = 0, 1 do
		self.m_hPlayerHero:AddItemByName( "item_faerie_fire" )
	end

	local nFullHP = self.m_hPlayerHero:GetMaxHealth()
	self.m_hPlayerHero:SetHealth( nFullHP )
end

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
function CLastHitTrainer:AllowSpecificAbilities( hAbility )
	if not hAbility then
		return
	end

	if hAbility:GetAbilityName() == "lone_druid_spirit_bear" then
		hAbility:SetLevel( 1 )
	elseif hAbility:GetAbilityName() == "troll_warlord_berserkers_rage" then
		hAbility:SetLevel( 1 )
	end
end

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
function CLastHitTrainer:OnLastHit( event )
	local victim = EntIndexToHScript( event.EntKilled )

	increment(self.m_NetTableStats, 'm_LastHitCount')
	self:IncrementLastHitStreakCount()

	if victim:GetClassname() == "npc_dota_creep_lane" then
		local nGold = victim:GetGoldBounty()
		if victim:IsRangedAttacker() then
			increment( self.m_NetTableStats, "m_nRangedCreepsKilled" )
			self.m_NetTableStats[ "m_nGoldFromRangedCreeps" ] = self.m_NetTableStats[ "m_nGoldFromRangedCreeps" ] + nGold
		else
			increment( self.m_NetTableStats, "m_nMeleeCreepsKilled" )
			self.m_NetTableStats[ "m_nGoldFromMeleeCreeps" ] = self.m_NetTableStats[ "m_nGoldFromMeleeCreeps" ] + nGold
		end
	end

	self:UpdateScoreForDenyOrLastHit("m_LastHitBaseValue")
end

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
function CLastHitTrainer:IncrementLastHitStreakCount()
	increment(self.m_NetTableStats, "m_CurrentLastHitStreakCount")

	self.m_NetTableStats.m_HighestLastHitStreakCount = max(self.m_NetTableStats.m_HighestLastHitStreakCount, self.m_NetTableStats.m_CurrentLastHitStreakCount)

	if not self.m_hPlayerHero then
		return
	end

	local nCurrentStreak = self.m_NetTableStats.m_CurrentLastHitStreakCount
	self:PlayLastHitStreakSound( nCurrentStreak )

	local vColor = self.m_vColorTier1
	if nCurrentStreak >= 3 and nCurrentStreak < 6 then
		vColor = self.m_vColorTier1
	elseif nCurrentStreak >= 6 and nCurrentStreak < 9 then
		vColor = self.m_vColorTier2
	elseif nCurrentStreak >= 9 and nCurrentStreak < 12 then
		vColor = self.m_vColorTier3
	elseif nCurrentStreak >= 12 and nCurrentStreak < 15 then
		vColor = self.m_vColorTier4
	elseif nCurrentStreak >= 15 and nCurrentStreak < 18 then
		vColor = self.m_vColorTier5
	elseif nCurrentStreak >= 18 and nCurrentStreak < 21 then
		vColor = self.m_vColorTier6
	elseif nCurrentStreak >= 21 and nCurrentStreak < 24 then
		vColor = self.m_vColorTier7
	elseif nCurrentStreak >= 24 then
		vColor = self.m_vColorTier8
	end

	--[[
		Cp 1: ( message_index, 0, 0)
		0 – streak
		1 – denied
		2 – good
		3 – great
		4 – perfect
	]]

	-- Play a "good, great, perfect" type of msg
	local nMsgIndex = 2
	local nMsgSize = 70
	
	if nCurrentStreak < 9 then
		nMsgIndex = 2 -- "Good"
		nMsgSize = 70
	elseif nCurrentStreak >= 9 and nCurrentStreak < 15 then
		nMsgIndex = 3 -- "Great !"
		nMsgSize = 85
	elseif nCurrentStreak >= 15 then
		nMsgIndex = 4 -- "Perfect !!"
		nMsgSize = 100
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/newplayer_fx/last_hit_message.vpcf", PATTACH_OVERHEAD_FOLLOW, self.m_hPlayerHero )
	ParticleManager:SetParticleControl( nFXIndex, 0, self.m_hPlayerHero:GetAbsOrigin() + Vector( 0, 150, 0 ) )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( nMsgIndex, nMsgSize, 0 ) )
	ParticleManager:SetParticleControl( nFXIndex, 15, vColor ) -- color
	ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) ) -- whether to use color
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	if nCurrentStreak >= 3 and ( nCurrentStreak % 3 == 0 ) then
		-- Play a streak message
		local nFXIndex = ParticleManager:CreateParticle( "particles/newplayer_fx/last_hit_streak.vpcf", PATTACH_OVERHEAD_FOLLOW, self.m_hPlayerHero )
		ParticleManager:SetParticleControl( nFXIndex, 0, self.m_hPlayerHero:GetAbsOrigin() + Vector( 0, 150, 0 ) )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 0, nCurrentStreak, 0 ) )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 2, 0, 0 ) ) -- # of digits
		ParticleManager:SetParticleControl( nFXIndex, 15, vColor ) -- color
		ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) ) -- whether to use color
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		--[[
	else
		-- Play a "good, great, perfect" type of msg
		local nMsgIndex = RandomInt( 2, 4 )

		local nFXIndex = ParticleManager:CreateParticle( "particles/newplayer_fx/last_hit_message.vpcf", PATTACH_OVERHEAD_FOLLOW, self.m_hPlayerHero )
		ParticleManager:SetParticleControl( nFXIndex, 0, self.m_hPlayerHero:GetAbsOrigin() + Vector( 0, 150, 0 ) )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( nMsgIndex, 100, 0 ) ) -- ( message_index, radius, 0 )
		ParticleManager:SetParticleControl( nFXIndex, 15, vColor ) -- color
		ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) ) -- whether to use color
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		]]
	end
end

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
function CLastHitTrainer:PlayLastHitStreakSound( nCurrentStreak )
	-- If round lasts 3 mins, max last hit streak is ~24
	if nCurrentStreak == 3 then
		EmitAnnouncerSound( "announcer_killing_spree_announcer_kill_spree_01" )
	end
	if nCurrentStreak == 6 then
		EmitAnnouncerSound( "announcer_killing_spree_announcer_kill_dominate_01" )
	end
	if nCurrentStreak == 9 then
		EmitAnnouncerSound( "announcer_killing_spree_announcer_kill_mega_01" )
	end
	if nCurrentStreak == 12 then
		EmitAnnouncerSound( "announcer_killing_spree_announcer_kill_unstop_01" )
	end
	if nCurrentStreak == 15 then
		EmitAnnouncerSound( "announcer_killing_spree_announcer_kill_wicked_01" )
	end
	if nCurrentStreak == 18 then
		EmitAnnouncerSound( "announcer_killing_spree_announcer_kill_monster_01" )
	end
	if nCurrentStreak == 21 then
		EmitAnnouncerSound( "announcer_killing_spree_announcer_kill_godlike_01" )
	end
	if nCurrentStreak >= 24 then
		EmitAnnouncerSound( "announcer_killing_spree_announcer_kill_holy_01" )
	end
end

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
function CLastHitTrainer:OnDeny( victim )
	increment(self.m_NetTableStats, "m_DenyCount")

	if victim:GetClassname() == "npc_dota_creep_lane" then
		if victim:IsRangedAttacker() then
			increment( self.m_NetTableStats, "m_nRangedCreepsDenied" )
		else
			increment( self.m_NetTableStats, "m_nMeleeCreepsDenied" )
		end
	end

	-- Play a "Denied" message
	local nMsgSize = 70

	local nFXIndex = ParticleManager:CreateParticle( "particles/newplayer_fx/last_hit_message.vpcf", PATTACH_OVERHEAD_FOLLOW, self.m_hPlayerHero )
	ParticleManager:SetParticleControl( nFXIndex, 0, self.m_hPlayerHero:GetAbsOrigin() + Vector( 0, 150, 0 ) )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, nMsgSize, 0 ) )
	ParticleManager:SetParticleControl( nFXIndex, 15, Vector( 0, 130, 255 ) ) -- color
	ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) ) -- whether to use color
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	self:UpdateScoreForDenyOrLastHit("m_DenyBaseValue")
end

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
function CLastHitTrainer:UpdateScoreForDenyOrLastHit(baseValueKey)

	local incrementValue = gScoreValue[baseValueKey]

	increment(self.m_NetTableStats, "m_Score", incrementValue)
	self:SendStatisticsToClient()
end

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
function CLastHitTrainer:SendStatisticsToClient()
	CustomNetTables:SetTableValue( "last_hit_trainer_stats", "stats", self.m_NetTableStats )
end

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
function CLastHitTrainer:OnRoundEnded()
	CustomGameEventManager:Send_ServerToAllClients( "round_ended", {} )

	self:DestroyCurrentRound()
	--self:SetupNextRound()

	EmitGlobalSound( "RoundEnd" )

	gGameInfo.m_bIsOverTime = false
	CustomNetTables:SetTableValue( "last_hit_trainer_gameinfo", "gameinfo", gGameInfo )
end

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
function CLastHitTrainer:OnThink()
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		print( "Reached post-game, stop OnThink" )
		return nil
	end

	if not self.m_hPlayerHero then
		return 0.1
	end

	if not self.m_bPlayerInitialized then
		self:InitializePlayerHero()
		self.m_bPlayerInitialized = true
	end

	if gGameInfo.m_fRoundStartTime and ( gGameInfo.m_fRoundStartTime ~= -1 ) then
		-- We're playing a round
		local fRoundEndTime = ( gGameInfo.m_fRoundStartTime + gGameInfo.m_fRoundDuration )

		if ( GameRules:GetGameTime() >= ( self.m_fTimeLastCreepsSpawned + self.m_SPAWN_WAVE_INTERVAL ) ) then
			self:SpawnLaneCreeps()
		end

		local nIntenseAudioDuration = 17
		if ( not self.m_bPlayingIntenseAudio ) and ( ( GameRules:GetGameTime() + nIntenseAudioDuration ) >= fRoundEndTime ) then
			-- Not much time left in the round
			EmitGlobalSound( "RoundNearlyOver" )
			self.m_bPlayingIntenseAudio = true
		end

		if GameRules:GetGameTime() >= ( gGameInfo.m_fRoundStartTime + gGameInfo.m_fRoundDuration ) then
			if self:AreAnyCreepsAlive() == false then
				self:OnRoundEnded()
			else
				gGameInfo.m_bIsOverTime = true
				CustomNetTables:SetTableValue( "last_hit_trainer_gameinfo", "gameinfo", gGameInfo )
			end
		end
	end

	return 0.1
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CLastHitTrainer:AreAnyCreepsAlive()
	local hLaneCreeps = Entities:FindAllByClassname( "npc_dota_creep_lane" )
	for _, hCreep in pairs( hLaneCreeps ) do
		if hCreep and hCreep:IsAlive() then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------
-- ButtonEvent
--------------------------------------------------------------------------------
function CLastHitTrainer:OnRoundStartButtonPressed( eventSourceIndex, data )
	if data.str ~= "first_round" then
		self:DestroyCurrentRound()
	end

	self:SetupNextRound()
end

--------------------------------------------------------------------------------
-- ButtonEvent
--------------------------------------------------------------------------------
function CLastHitTrainer:OnNewHeroButtonPressed( eventSourceIndex )
	--self:DestroyCurrentRound()
	--GameRules:ResetToHeroSelection()

	SendToServerConsole( "dota_launch_custom_game last_hit_trainer last_hit_trainer" )
end

--------------------------------------------------------------------------------
-- ButtonEvent
--------------------------------------------------------------------------------
function CLastHitTrainer:OnLeaveButtonPressed( eventSourceIndex )
	SendToServerConsole( "disconnect" )
end

--------------------------------------------------------------------------------
-- ButtonEvent
--------------------------------------------------------------------------------
function CLastHitTrainer:SwitchToNewHero( eventSourceIndex, data )
	local nHeroID = tonumber( data.str )
	local sHeroClass = DOTAGameManager:GetHeroUnitNameByID( nHeroID )

	local nPlayerID = self.m_hPlayerHero:GetPlayerID()
	PrecacheUnitByNameAsync( sHeroClass, function() self:CreateNewHero( spawnGroupID, sHeroClass, nPlayerID ) end, nPlayerID )
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CLastHitTrainer:CreateNewHero( spawnGroupID, sHeroClass, nPlayerID )
	--print( "spawnGroupID is " .. tostring( spawnGroupID ) )

	PlayerResource:ReplaceHeroWith( nPlayerID, sHeroClass, 0, 0 )

	local hPlayer = PlayerResource:GetPlayer( nPlayerID )
	self.m_hPlayerHero = hPlayer:GetAssignedHero()

	self:DestroyCurrentRound()
	self:SetupNextRound()
end

