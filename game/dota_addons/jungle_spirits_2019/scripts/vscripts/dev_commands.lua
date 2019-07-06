
function CJungleSpirits:ForceNewSpiritRound()
	if IsServer() then
		print( "Forcing new spirit round" )
		self:NewSpiritRound()
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:ForceSpawnGem()
	self._fNextGemTime = GameRules:GetGameTime() + GEM_SPAWN_WARNING_TIME

	self:WarnGemSpawn()
end

--------------------------------------------------------------------------------

function CJungleSpirits:ForceSpawnGemImmediate()
	self:SpawnGem()
end

--------------------------------------------------------------------------------

function CJungleSpirits:GiveGems( szCmdName, szGainAmount )
	local nGainAmount = tonumber( szGainAmount )
	if nGainAmount == nil or nGainAmount < 1 then
		nGainAmount = 200
	end

	print( "Increasing all players' gem counts by " .. nGainAmount )

	local hAllHeroes = HeroList:GetAllHeroes()
	for _, hHero in ipairs( hAllHeroes ) do
		if hHero ~= nil then
			if hHero:IsRealHero() and hHero:IsOwnedByAnyPlayer() and hHero:IsClone() == false and hHero:IsTempestDouble() == false then
				local hSpiritGemModifier = hHero:FindModifierByName( "modifier_spirit_gem" )
				if hSpiritGemModifier ~= nil then
					local nNewStackCount = hSpiritGemModifier:GetStackCount() + nGainAmount
					hSpiritGemModifier:SetStackCount( nNewStackCount )
				else
					hHero:AddNewModifier( hHero, nil, "modifier_spirit_gem", { duration = -1 } )
					hSpiritGemModifier = hHero:FindModifierByName( "modifier_spirit_gem" )

					if hSpiritGemModifier ~= nil then
						local nNewStackCount = hSpiritGemModifier:GetStackCount() + nGainAmount
						hSpiritGemModifier:SetStackCount( nNewStackCount )
						local netTable = {}
						netTable["gems_count"] = hSpiritGemModifier:GetStackCount()
						CustomNetTables:SetTableValue( "jungle_spirits_gems_info", tostring( hHero:entindex() ), netTable )
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:ToggleSpiritManualControl( szCmdName )
	local hAllJungleSpirits = Entities:FindAllByClassname( "npc_dota_creature_jungle_spirit" )

	if self._bManualControl == false then
		self._bManualControl = true
		local nPlayerID = 0
		for _, hJungleSpirit in pairs( hAllJungleSpirits ) do
			if self:IsSpiritActive( hJungleSpirit ) == false then
				self:SetSpiritActive( hJungleSpirit )
			end
			hJungleSpirit:SetInitialGoalEntity( nil )
			hJungleSpirit:Interrupt()
			hJungleSpirit:SetForceAttackTarget( nil )
			hJungleSpirit:SetControllableByPlayer( nPlayerID, true )
		end
		printf( "ToggleSpiritManualControl - set to ON" )
	else
		self._bManualControl = false
		for _, hJungleSpirit in pairs( hAllJungleSpirits ) do
			hJungleSpirit:SetControllableByPlayer( -1, false )
			hJungleSpirit:SetInitialGoalEntity( nil )
			hJungleSpirit:Interrupt()
			hJungleSpirit:SetForceAttackTarget( nil )
			if self:IsSpiritActive( hJungleSpirit ) then
				self:SetSpiritInactive( hJungleSpirit )
			end
		end
		printf( "ToggleSpiritManualControl - set to OFF" )
	end
end

--------------------------------------------------------------------------------
