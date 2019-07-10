
function CJungleSpirits:NewSpiritRound()
	if IsServer() then
		print( "New spirit round" )

		EmitGlobalSound( "JungleSpirit.NewRound.Start" )

		self:SpawnOrRespawnBothSpirits()
		self:MarchSpiritDownLaneForTeam( self:GetMarchingSpiritTeam() )
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:SpawnOrRespawnBothSpirits()
	if self._hRadiantSpirit == nil then
		self:SpawnRadiantSpirit()
	elseif self._hRadiantSpirit:IsAlive() == false then
		self:RespawnRadiantSpirit()
	end

	if self._hDireSpirit == nil then
		self:SpawnDireSpirit()
	elseif self._hDireSpirit:IsAlive() == false then
		self:RespawnDireSpirit()
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:SpawnRadiantSpirit()
	if IsServer() then
		--print( "  Spawning Radiant spirit from scratch" )

		self._hRadiantSpirit = CreateUnitByName( "npc_dota_creature_jungle_spirit", RADIANT_SPIRIT_SPAWN_POS, true, nil, nil, DOTA_TEAM_GOODGUYS )
		if self._hRadiantSpirit ~= nil then
			self._hRadiantSpirit:SetUnitCanRespawn( true )
			self._hRadiantSpirit.BranchData = {}
			for i = SPIRIT_BRANCH_JUNGLE,SPIRIT_BRANCH_VOLCANO do
				local branchTable = 
				{
					nCurrentXP = 0,
					nCurrentTier = 0,
				}
				table.insert( self._hRadiantSpirit.BranchData, i, branchTable )
			end

			self:SetSpiritInactive( self._hRadiantSpirit )

			for i=0,DOTA_MAX_ABILITIES-1 do
				local hAbility = self._hRadiantSpirit:GetAbilityByIndex( i )
				while hAbility and hAbility:CanAbilityBeUpgraded() == ABILITY_CAN_BE_UPGRADED do
					hAbility:UpgradeAbility( true )
				end
			end

			-- Adding manually so it doesn't get auto-levelled
			local szAbilityName = "generic_gold_bag_fountain"

			local hNewAbility = self._hRadiantSpirit:AddAbility( szAbilityName )
			if hNewAbility then
				hNewAbility:UpgradeAbility( false )
				--printf( "SpawnRadiantSpirit - adding %s level %d to %s", szAbilityName, hNewAbility:GetLevel(), self._hRadiantSpirit:GetUnitName() )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:SpawnDireSpirit()
	if IsServer() then
		--print( "  Spawning Dire spirit from scratch" )

		self._hDireSpirit = CreateUnitByName( "npc_dota_creature_jungle_spirit", DIRE_SPIRIT_SPAWN_POS, true, nil, nil, DOTA_TEAM_BADGUYS )
		if self._hDireSpirit ~= nil then
			self._hDireSpirit:SetMaterialGroup( "dire" )
			self._hDireSpirit:SetUnitCanRespawn( true )
			self._hDireSpirit.BranchData = {}
			for i = SPIRIT_BRANCH_JUNGLE,SPIRIT_BRANCH_VOLCANO do
				local branchTable = 
				{
					nCurrentXP = 0,
					nCurrentTier = 0,
				}
				table.insert( self._hDireSpirit.BranchData, i, branchTable )
			end

			self:SetSpiritInactive( self._hDireSpirit )

			for i=0,DOTA_MAX_ABILITIES-1 do
				local hAbility = self._hDireSpirit:GetAbilityByIndex( i )
				while hAbility and hAbility:CanAbilityBeUpgraded() == ABILITY_CAN_BE_UPGRADED do
					hAbility:UpgradeAbility( true )
				end
			end

			-- Adding manually so it doesn't get auto-levelled
			local szAbilityName = "generic_gold_bag_fountain"

			local hNewAbility = self._hDireSpirit:AddAbility( szAbilityName )
			if hNewAbility then
				hNewAbility:UpgradeAbility( false )
				--printf( "SpawnRadiantSpirit - adding %s level %d to %s", szAbilityName, hNewAbility:GetLevel(), self._hDireSpirit:GetUnitName() )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:GetSpiritForTeam( nTeam )
	if nTeam == DOTA_TEAM_BADGUYS then
		return self._hDireSpirit
	end

	if nTeam == DOTA_TEAM_GOODGUYS then
		return self._hRadiantSpirit
	end

	return nil
end

--------------------------------------------------------------------------------

function CJungleSpirits:RespawnRadiantSpirit()
	--print( "  Respawning Radiant spirit" )
	self._hRadiantSpirit:SetInitialGoalEntity( nil )
	self._hRadiantSpirit:SetAbsOrigin( RADIANT_SPIRIT_SPAWN_POS )
	self._hRadiantSpirit:RespawnUnit()

	self:SetSpiritInactive( self._hRadiantSpirit )
end

--------------------------------------------------------------------------------

function CJungleSpirits:RespawnDireSpirit()
	--print( "  Respawning Dire spirit" )
	self._hDireSpirit:SetInitialGoalEntity( nil )
	self._hDireSpirit:SetAbsOrigin( DIRE_SPIRIT_SPAWN_POS )
	self._hDireSpirit:RespawnUnit()
	self._hDireSpirit:SetMaterialGroup( "dire" )

	self:SetSpiritInactive( self._hDireSpirit )
end

--------------------------------------------------------------------------------

function CJungleSpirits:MarchSpiritDownLaneForTeam( nTeam )
	local hSpirit = nil
	local szPathSuffix = nil

	if nTeam == DOTA_TEAM_GOODGUYS then
		hSpirit = self._hRadiantSpirit
		szPathSuffix = "goodguys_1"
	else
		hSpirit = self._hDireSpirit
		szPathSuffix = "badguys_1"
	end

	self:SetSpiritActive( hSpirit )

	hSpirit:AddNewModifier( hSpirit, nil, "modifier_jungle_spirit_marching", { duration = SPIRIT_LIFETIME_PER_MARCH } )
	hSpirit.start_time = GameRules:GetGameTime();

	if not self.szMarchPath then
		print( "ERROR - MarchSpiritDownLaneForTeam: self.szMarchPath is nil.  This is likely because you are using the NewRound devcommand before the game has started." )
		return
	end

	local szFirstPathCorner = self.szMarchPath .. szPathSuffix
	local hWaypoint = Entities:FindByName( nil, szFirstPathCorner )
	if hWaypoint ~= nil then
		--print( "  " .. hSpirit:GetUnitName() .. " initial goal entity set to: " .. szFirstPathCorner )
		hSpirit:SetInitialGoalEntity( hWaypoint )

		self:CreateNewRoundMessage( nTeam, self.szLaneToMarchOn )

		self.EventQueue = CEventQueue()
		self.EventQueue:AddEvent( ANNOUNCER_MARCH_DELAY,
			function()
				self:FireAnnouncerMorokaiMarch_PerTeam( nTeam )
			end
		)
	end

	self._nMarchesStarted = self._nMarchesStarted + 1

	self:SetNextMarchingSpiritTeam()
end

--------------------------------------------------------------------------------

function CJungleSpirits:CreateNewRoundMessage( team, szLaneName )
	--print( "CreateNewRoundMessage" )

	local szLaneDisplayName = szLaneName

	if szLaneName == "top" then
		szLaneDisplayName = "top"
	elseif szLaneName == "mid" then
		szLaneDisplayName = "middle"
	elseif szLaneName == "bot" then
		szLaneDisplayName = "bottom"
	end


	local gameEvent = {}
	gameEvent[ "locstring_value" ] = szLaneDisplayName
	--gameEvent[ "player_id" ] = -1
	gameEvent[ "teamnumber" ] = -1 --team

	if team == DOTA_TEAM_GOODGUYS then
		gameEvent[ "message" ] = "#JungleSpirits_NewMarchRadiant"
		EmitGlobalSound( "JungleSpirit.NewRound.Radiant" )
	else
		gameEvent[ "message" ] = "#JungleSpirits_NewMarchDire"
		EmitGlobalSound( "JungleSpirit.NewRound.Dire" )
	end

	FireGameEvent( "dota_combat_event_message", gameEvent )
end

--------------------------------------------------------------------------------

function CJungleSpirits:CreateSpiritGainedLevelMessage( team, nLevel )
	local gameEvent = {}
	gameEvent[ "locstring_value" ] = nLevel
	gameEvent[ "teamnumber" ] = team
	gameEvent[ "message" ] = "#JungleSpirits_CreatureGainedLevel"
	FireGameEvent( "dota_combat_event_message", gameEvent )
end

--------------------------------------------------------------------------------

function CJungleSpirits:IsSpiritActive( hSpirit )
	if hSpirit == nil then
		return false
	end
	return hSpirit.bIsActive
end

--------------------------------------------------------------------------------

function CJungleSpirits:SetSpiritActive( hSpirit )
	if hSpirit == nil then
		return
	end

	hSpirit:RemoveModifierByName( "modifier_jungle_spirit_inactive" )

	hSpirit.bIsActive = true
end

--------------------------------------------------------------------------------

function CJungleSpirits:SetSpiritInactive( hSpirit )
	hSpirit.bIsActive = false
	if hSpirit:HasModifier( "modifier_jungle_spirit_inactive" ) == false then
		hSpirit:AddNewModifier( hSpirit, nil, "modifier_jungle_spirit_inactive", { duration = -1 } )
	end

	if hSpirit:IsAlive() == false then
		local fDelay = SPIRIT_DEATH_TIMER - 0.5

		self.EventQueue = CEventQueue()
		self.EventQueue:AddEvent( fDelay,
			function()
				self:HealAndMoveHome( hSpirit )
			end
		)
	else
		self:HealAndMoveHome( hSpirit )
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:HealAndMoveHome( hSpirit )
	hSpirit:Heal( hSpirit:GetMaxHealth(), hSpirit )

	if hSpirit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		FindClearSpaceForUnit( hSpirit, RADIANT_SPIRIT_SPAWN_POS, true )
	else
		FindClearSpaceForUnit( hSpirit, DIRE_SPIRIT_SPAWN_POS, true )
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:GetMarchingSpiritTeam()
	return self._nNextMarchingSpiritTeam
end

--------------------------------------------------------------------------------

function CJungleSpirits:SetNextMarchingSpiritTeam()
	-- After every pair of marches, reroll to see which beast should go first in the next cycle
	if self._nNextMarchingSpiritTeam == nil or self._nMarchesStarted % 2 == 0 then
		local bRadiantFirst = RandomFloat( 0, 1 ) >= 0.5
		if bRadiantFirst then
			self._nNextMarchingSpiritTeam = DOTA_TEAM_GOODGUYS
		else
			self._nNextMarchingSpiritTeam = DOTA_TEAM_BADGUYS
		end

		return
	else
		if self._nNextMarchingSpiritTeam == DOTA_TEAM_GOODGUYS then
			self._nNextMarchingSpiritTeam = DOTA_TEAM_BADGUYS
		else
			self._nNextMarchingSpiritTeam = DOTA_TEAM_GOODGUYS
		end
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:GetMySpiritLevelDisadvantage( hUnit )
	local nDisadvantage = nil

	local nMyBeastLevel = nil
	local nEnemyBeastLevel = nil

	if hUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		nMyBeastLevel = self._hRadiantSpirit:GetLevel()
		nEnemyBeastLevel = self._hDireSpirit:GetLevel()
	elseif hUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		nMyBeastLevel = self._hDireSpirit:GetLevel()
		nEnemyBeastLevel = self._hRadiantSpirit:GetLevel()
	else
		return 0
	end

	if nMyBeastLevel < nEnemyBeastLevel then
		nDisadvantage = nEnemyBeastLevel - nMyBeastLevel
		if nDisadvantage > HIGHEST_BEAST_DISADVANTAGE then
			nDisadvantage = HIGHEST_BEAST_DISADVANTAGE
		end
	else
		nDisadvantage = 0
	end

	return nDisadvantage
end

--------------------------------------------------------------------------------

