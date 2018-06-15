
modifier_treasure_chest = class({})

--------------------------------------------------------------------------------

function modifier_treasure_chest:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_treasure_chest:OnCreated( kv )

	if IsServer() then
		self.hRoom = self:GetParent().hTreasureRoom -- we put this on what we knew would be the parent unit before the modifier was added
		self.nTreasureLevel = kv["TreasureLevel"]
		self.nXpReward = kv["XpReward"]
		self.nGoldReward = kv["GoldReward"]
		self.nTreasureType = kv["TreasureType"]
		self.flProgress = 0

	--	printf("treasure level is %d", self.nTreasureLevel)

		self:GetParent():StartGesture( ACT_DOTA_IDLE )
		self:StartIntervalThink( 0.5 )	
		
		--local vFxOrigin = self:GetParent():GetOrigin()
	
	end
end

--------------------------------------------------------------------------------

function modifier_treasure_chest:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

-----------------------------------------------------------------------

function modifier_treasure_chest:OnTakeDamage( params )
	return 0
end

-----------------------------------------------------------------------

function modifier_treasure_chest:OnIntervalThink()
	if IsServer() then

		local bDestroyParticle = false

		if not self.bWasOpened then
			local flOpenDistance = 200.0

			local hEnemies = FindRealLivingEnemyHeroesInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), flOpenDistance )

			local flProgress = 0

			if #hEnemies > 0 then
				local hClosestEnemy = hEnemies[1]

				local hAllHeroes = HeroList:GetAllHeroes()
				local nLivingMembersNearby = 0
				local nLivingMembers = 0
				for _,hHero in pairs(hAllHeroes) do
					if hHero:GetTeamNumber() == hClosestEnemy:GetTeamNumber() and hHero:IsAlive() and hHero:IsRealHero() and not hHero:IsTempestDouble() then
						nLivingMembers = nLivingMembers + 1
						if TableContainsValue(hEnemies, hHero) then
							nLivingMembersNearby = nLivingMembersNearby + 1
						end
					end
				end

				flProgress = nLivingMembersNearby/nLivingMembers	

				if nLivingMembers == nLivingMembersNearby then
					self.hPlayerEnt = hClosestEnemy
					self:OpenTreasure()
				else
					-- TODO: make chest rumble if there are not enough players nearby (needs a better animation)
					--printf("rumbling..")
					--self:GetParent():StartGesture( ACT_DOTA_CAPTURE )
				end
				--printf("progress change %f %f",self.flProgress, flProgress)

				if self.nProgressParticle == nil or self.flProgress > flProgress then
					if self.nProgressParticle ~= nil then
						--printf("recreating particle")
						ParticleManager:DestroyParticle( self.nProgressParticle, false )
						ParticleManager:ReleaseParticleIndex( self.nProgressParticle )
					end
					self.nProgressParticle = ParticleManager:CreateParticle( "particles/econ/generic/generic_progress_meter/generic_progress_circle.vpcf", PATTACH_WORLDORIGIN, self )
					local vChestRingPos = self.hRoom.vRoomCenter
					vChestRingPos.z = self:GetParent():GetAbsOrigin().z + 50;
					ParticleManager:SetParticleControl( self.nProgressParticle, 0, vChestRingPos)
					ParticleManager:SetParticleControl( self.nProgressParticle, 2, Vector( flOpenDistance, 0.5, 1 ) )
				end
				ParticleManager:SetParticleControl( self.nProgressParticle, 1, Vector( flOpenDistance, flProgress, 1 ) )
				
			else
				bDestroyParticle = true
				--printf("setting progress to %f", flProgress)
				--printf("idling..")
				--self:GetParent():StartGesture( ACT_DOTA_IDLE )
			end
			self.flProgress = flProgress

		else 	
			bDestroyParticle = true
			if self.bReadyToDestroy then
				self:Destroy()
			end
		end

		if bDestroyParticle == true and self.nProgressParticle ~= nil then
			ParticleManager:DestroyParticle( self.nProgressParticle, false )
			ParticleManager:ReleaseParticleIndex( self.nProgressParticle )
			self.nProgressParticle = nil
		end	
	end
end

--------------------------------------------------------------------------------

function modifier_treasure_chest:GetFixedDayVision( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_treasure_chest:GetFixedNightVision( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_treasure_chest:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_ATTACK_IMMUNE] = true
		state[MODIFIER_STATE_ROOTED] = true
		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
		state[MODIFIER_STATE_BLIND] = true
		state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
		state[MODIFIER_STATE_INVULNERABLE] = true
		state[MODIFIER_STATE_UNSELECTABLE] = true
		state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	end
	
	return state
end

--------------------------------------------------------------------------------

function modifier_treasure_chest:OpenTreasure()
	self:GetParent():AddEffects( EF_NODRAW ) -- hide this model, we'll kill the unit later.  add another unit for the visual of the anim

	local szTreasureUnit = "npc_treasure_chest_anim"
	if self.nTreasureType == CAVERN_TREASURE_TYPE_SPECIAL then
		szTreasureUnit = "npc_special_treasure_chest_anim"
	end

	local hChestWithAnim = CreateUnitByName( szTreasureUnit, self.hRoom.vRoomCenter + RandomVector( 1 * self.nTreasureLevel ), true, nil, nil, DOTA_TEAM_BADGUYS )
	if hChestWithAnim ~= nil then
		hChestWithAnim:SetForwardVector( Vector( 0, 1, 0 ) )
		hChestWithAnim:SetModelScale( self:GetParent():GetModelScale() )
		hChestWithAnim:AddNewModifier( hChestWithAnim, nil, "modifier_treasure_chest_anim", { duration = -1 } )
	end

	self:GetParent():StartGesture( ACT_DOTA_PRESENT_ITEM )
	self:OnTreasureOpen( self.hPlayerEnt, self:GetParent() )
	self.bWasOpened = true
	self.hPlayerEnt = nil

	self.fTimeChestOpened = GameRules:GetGameTime()

	EmitSoundOn( "SpecialTreasure.Open", self:GetParent() )
end

--------------------------------------------------------------------------------

function modifier_treasure_chest:OnTreasureOpen( hPlayerHero, hTreasureEnt )
	self:ChooseTreasureRewards( hPlayerHero, hTreasureEnt )
end

--------------------------------------------------------------------

function modifier_treasure_chest:ChooseTreasureRewards( hPlayerHero, hTreasureEnt )
	if self.hRoom == nil then
		print( "ChooseTreasureRewards - ERROR: self.hRoom is nil" )
		return
	end

	self.EventQueue = CEventQueue()

	self.LootDistMin = { 75, 100, 150, 200, 300, 300 } 
	self.LootDistMax = { 200, 250, 300, 400, 500, 500 }

	local CommonChestCheeseChances = { 0, 0.003, 0.009, 1 }
	local SpecialChestCheeseChances = { 0, 0.12, 0.36, 1 }

	local TreasureLevelDrops =
	{
		{ 1, 0, 0 }, -- tier 1
		{ 2, 1, 1 }, -- tier 2
		{ 3, 2, 2 }, -- etc
		{ 4, 3, 3 },
		{ 5, 4, 4 }
	}
	local ItemDropChances = { 0.8, 0.4, 0.2 }

	self.flSpawnTime = RandomFloat( 0.25, 0.75 )

	hTreasureEnt.nRewardSpawnDistMin = self.LootDistMin[self.nTreasureLevel]
	hTreasureEnt.nRewardSpawnDistMax = self.LootDistMax[self.nTreasureLevel]	

	local nTotalGold = self.nGoldReward
	local flDynamiteChance = 0.13
	local fCheeseChance = CommonChestCheeseChances[ self.nTreasureLevel ]

	if self.nTreasureType == CAVERN_TREASURE_TYPE_SPECIAL then
		nTotalGold = nTotalGold * 2
		flDynamiteChance = 0.75
		ItemDropChances = { 1.0, 0.8, 0.4 }
		fCheeseChance = SpecialChestCheeseChances[ self.nTreasureLevel ]
	end

	--printf("Opening a Level %d (Type: %d) Chest rewarding %d gold and %d XP", self.nTreasureType, self.nTreasureLevel, nTotalGold, self.nXpReward)

	local ItemDrops = {}

	if RandomFloat( 0, 1 ) > ( 1 - flDynamiteChance ) then
		table.insert( ItemDrops, "item_cavern_dynamite" )
	end

	if GameRules.Cavern.bBigCheeseDropped == false then
		if RandomFloat( 0, 1 ) > ( 1 - fCheeseChance ) then
			table.insert( ItemDrops, "item_big_cheese_cavern" )
			GameRules.Cavern.bBigCheeseDropped = true
		end
	end

	table.insert( ItemDrops, "item_health_potion" )
	table.insert( ItemDrops, "item_mana_potion" )

	for i = 1,3 do
		local nTreasureLevel = TreasureLevelDrops[self.nTreasureLevel][i]

		local fRandRoll = RandomFloat( 0, 1 )	

		local szLevel = "level_" .. nTreasureLevel

		local fItemChance = ItemDropChances[ i ]

		if fRandRoll >= ( 1 - fItemChance ) then
			local Items = _G.TreasureChestItemRewards[ szLevel ]	
			local nRandomIndex = RandomInt( 1, #Items )
			local szItemName = Items[ nRandomIndex ]
			table.insert( ItemDrops, szItemName )
		end
	end

	if nTotalGold > 0 then 

		if RandomFloat( 0, 1 ) < 0.025 then
			self:CreateChickenDrop( self.nTreasureLevel, hPlayerHero, hTreasureEnt, 2*nTotalGold )
			self:CreateTreasureGoldDrop( self.nTreasureLevel, hPlayerHero, hTreasureEnt, nTotalGold / 2 )
		else
			self:CreateTreasureGoldDrop( self.nTreasureLevel, hPlayerHero, hTreasureEnt, nTotalGold )
		end

	end

	local nCheeseWedges = self.hRoom:GetRoomLevel()
	if self.nTreasureType == CAVERN_TREASURE_TYPE_SPECIAL then
		nCheeseWedges = math.min(nCheeseWedges+1, 4)
	end

	self:CreateTreasureCheeseDrop( self.nTreasureLevel, hPlayerHero, hTreasureEnt, nCheeseWedges)

	for _,ItemName in pairs(ItemDrops) do
		self:CreateTreasureItemDrop( self.nTreasureLevel, hPlayerHero, hTreasureEnt, ItemName )
	end	
	
	self.EventQueue:AddEvent( self.flSpawnTime, function(self) self:ApplyXpReward( hPlayerHero ) end, self )

	self.EventQueue:AddEvent( self.flSpawnTime, function(self) 
		self.bReadyToDestroy = true 
	end, self )
end


function modifier_treasure_chest:CreateChickenDrop( nTreasureLevel, hPlayerHero, hTreasureEnt, nTotalGold )

	if hTreasureEnt == nil then
		print( "modifier_treasure_chest:CreateChickenDrop - ERROR: hTreasureEnt is nil" )
		return
	end

	if hTreasureEnt:IsNull() then
		print( "modifier_treasure_chest:CreateChickenDrop - ERROR: hTreasureEnt is null (deleted)" )
		return
	end

	local gameEvent = {}
	gameEvent["player_id"] = hPlayerHero:GetPlayerID()
	gameEvent["teamnumber"] = hPlayerHero:GetTeamNumber()
	gameEvent["message"] = "#Cavern_FoundChestChickens"
	FireGameEvent( "dota_combat_event_message", gameEvent )

	if GameRules.Cavern ~= nil then
		GameRules.Cavern:OnChickenTreasureDiscovered( hPlayerHero:GetTeamNumber() )
	end

	local nChickenGold = 0

	while nChickenGold < nTotalGold do
		self.EventQueue:AddEvent( self.flSpawnTime ,  
		function(self, nChickenGold)
			if nChickenGold == 0 then
				EmitSoundOn("Cavern.ChickenChase", self:GetParent() )
			end
			self.hRoom.ActiveEncounter:SpawnNonCreepByName( "npc_dota_creature_small_bonus_chicken", self:GetParent():GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
		end, self, nChickenGold)
		self.flSpawnTime = self.flSpawnTime + RandomFloat(0.1, 0.2)
		nChickenGold = nChickenGold + 150
	end
	
end


---------------------------------------------------------------------------

function modifier_treasure_chest:CreateTreasureItemDrop( nTreasureLevel, hPlayerHero, hTreasureEnt, szItemName )

	self.EventQueue:AddEvent( self.flSpawnTime, 
	function(self, nTreasureLevel, hPlayerHero, hTreasureEnt, szItemName)
		if hTreasureEnt == nil then
			print( "modifier_treasure_chest:CreateTreasureItemDrop - ERROR: hTreasureEnt is nil" )
			return
		end

		if hTreasureEnt:IsNull() then
			print( "modifier_treasure_chest:CreateTreasureItemDrop - ERROR: hTreasureEnt is null (deleted)" )
			return
		end

		--printf("Dropping item: %s", szItemName)
		local bShowCombatEventMessage = true

		local newItem = CreateItem( szItemName, nil, nil )
		if newItem == nil or newItem:IsNull() then
			printf( "modifier_treasure_chest:CreateTreasureItemDrop - ERROR: Failed to create item %s", szItemName )
			return
		end

		newItem:SetPurchaseTime( -10 ) -- prevent immediate selling for full price

		local drop = CreateItemOnPositionForLaunch( hTreasureEnt:GetAbsOrigin(), newItem )
		local vPos = self:GetChestRewardSpawnPos( hTreasureEnt )

		-- Keep item's hang time proportional with height, operating with baseline of 300 units and 1.0 seconds
		local nHeight = RandomInt( 300, 400 )
		local fMult = nHeight / 300
		local fTime = 1.0 * fMult

		if newItem:GetAbilityName() == "item_health_potion" or newItem:GetAbilityName() == "item_mana_potion" then
			newItem:LaunchLootInitialHeight( true, 0, nHeight, fTime, vPos )
			bShowCombatEventMessage = false
		else
			newItem:LaunchLootInitialHeight( false, 0, nHeight, fTime, vPos )
		end

		-- todo get a unique sound
		EmitSoundOn( "Dungeon.TreasureItemDrop", hTreasureEnt )

		if bShowCombatEventMessage == true then
			local gameEvent = {}
			gameEvent["player_id"] = hPlayerHero:GetPlayerID()
			gameEvent["teamnumber"] = hPlayerHero:GetTeamNumber()
			gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_" .. newItem:GetAbilityName()
			gameEvent["message"] = "#Cavern_FoundChestItem"
			FireGameEvent( "dota_combat_event_message", gameEvent )
		end

	end
	, self, nTreasureLevel, hPlayerHero, hTreasureEnt, szItemName)

	self.flSpawnTime = self.flSpawnTime + RandomFloat(0.1, 0.4)
end

---------------------------------------------------------------------------
function modifier_treasure_chest:CreateTreasureCheeseDrop( nTreasureLevel, hPlayerHero, hTreasureEnt, nCheeseAmounts )

	self.EventQueue:AddEvent( self.flSpawnTime, 
	function(self, nTreasureLevel, hPlayerHero, hTreasureEnt, szItemName)

		local CheeseProbs = { 0.55, 0.65, 0.75, 0.95, 1, 1 }

		for i=1,nCheeseAmounts do
			if RandomFloat(0,1) < CheeseProbs[i] then
				local vPos = self:GetChestRewardSpawnPos( hTreasureEnt )
				local newItem = CreateItem( "item_cavern_treasure_tier1", nil, nil )
				local drop = CreateItemOnPositionSync( hTreasureEnt:GetAbsOrigin(), newItem )
				newItem:SetForwardVector( RandomVector(1) )
				newItem:LaunchLoot( false, 300, 0.75, vPos )
				local nBattlePointAmount = CAVERN_BP_REWARD_TREASURE[newItem:GetAbilityName()]	
				self.nCheeseWedgesDropped = self.nCheeseWedgesDropped + 1
				self.flSpawnTime = self.flSpawnTime + RandomFloat(0.1, 0.4)
			end
		end

		if self.nCheeseWedgesDropped > 0 then
			local gameEvent = {}
			gameEvent["player_id"] = hPlayerHero:GetPlayerID()
			gameEvent["teamnumber"] = hPlayerHero:GetTeamNumber()
			gameEvent["int_value"] = self.nCheeseWedgesDropped
			gameEvent["message"] = "#Cavern_FoundChestCheese"	
			FireGameEvent( "dota_combat_event_message", gameEvent )
		end
	end
	, self, nTreasureLevel, hPlayerHero, hTreasureEnt, nCheeseAmounts)

end

function modifier_treasure_chest:CreateTreasureGoldDrop( nTreasureLevel, hPlayerHero, hTreasureEnt, nGoldToDrop )

	local BagDenominations = { 60, 90, 180, 300, 900, 1200, 1800 }

	local gameEvent = {}
	gameEvent["player_id"] = hPlayerHero:GetPlayerID()
	gameEvent["teamnumber"] = hPlayerHero:GetTeamNumber()
	gameEvent["int_value"] = nGoldToDrop
	gameEvent["message"] = "#Cavern_FoundChestGold"
	FireGameEvent( "dota_combat_event_message", gameEvent )

	self.nCheeseWedgesDropped = 0

	while nGoldToDrop > 0 do

		if nGoldToDrop >= BagDenominations[6] then
			nBagGold = BagDenominations[ RandomInt(1,6) ]
		elseif nGoldToDrop >= BagDenominations[5] then
			nBagGold = BagDenominations[ RandomInt(1,5) ]
		elseif nGoldToDrop >= BagDenominations[4] then
			nBagGold = BagDenominations[ RandomInt(1,4) ]
		elseif nGoldToDrop >= BagDenominations[3] then
			nBagGold = BagDenominations[ RandomInt(1,3) ]
		elseif nGoldToDrop >= BagDenominations[2] then
			nBagGold = BagDenominations[ RandomInt(1,2)]
		else
			nBagGold = BagDenominations[1]
		end

		nGoldToDrop = nGoldToDrop - nBagGold

		self.EventQueue:AddEvent( self.flSpawnTime, 
		function(self, nTreasureLevel, hTreasureEnt, nBagGold)

			if not hTreasureEnt or hTreasureEnt:IsNull() then
				printf( "modifier_treasure_chest:CreateTreasureDropGold - ERROR: Failed to drop gold bag on entity %s", hTreasureEnt )
				return
			end	
	
			LaunchGoldBag( nBagGold, hTreasureEnt:GetAbsOrigin(), vPos)
	
			EmitSoundOn( "Dungeon.TreasureItemDrop", hTreasureEnt )

		end
		,self, nTreasureLevel, hTreasureEnt, nBagGold)
		self.flSpawnTime = self.flSpawnTime + RandomFloat(0.05, 0.15)
	end
end

---------------------------------------------------------------------------

function modifier_treasure_chest:ApplyXpReward( hPlayerHero )
	local HeroesToReward = {}
	local nRewardTeam = hPlayerHero:GetTeamNumber()
	for _,Hero in pairs( HeroList:GetAllHeroes() ) do
		if (Hero ~= nil) and Hero:IsRealHero() and (not Hero:IsTempestDouble()) and (Hero:GetTeamNumber() == nRewardTeam) then
			--printf("adding reward hero %s %s", Hero, Hero:GetName())
			table.insert( HeroesToReward, Hero )
		end
	end

	if #HeroesToReward < 1 then
		return
	end

	local nXPToGive = self.nXpReward  / #HeroesToReward
	for _,Hero in pairs ( HeroesToReward ) do
		Hero:AddExperience( nXPToGive, DOTA_ModifyXP_Unspecified, false, false )
		SendOverheadEventMessage(Hero:GetPlayerOwner(), OVERHEAD_ALERT_XP, Hero, nXPToGive, nil);
	end
end

---------------------------------------------------------------------------

function modifier_treasure_chest:GetChestRewardSpawnPos( hTreasureEnt )
	local vPos = hTreasureEnt:GetAbsOrigin() + RandomVector( RandomInt(hTreasureEnt.nRewardSpawnDistMin,hTreasureEnt.nRewardSpawnDistMax) )

	local nAttempts = 0
	while ( ( not GridNav:CanFindPath( hTreasureEnt:GetOrigin(), vPos ) ) and ( nAttempts < 5 ) ) do
		vPos = hTreasureEnt:GetOrigin() + RandomVector( RandomInt(hTreasureEnt.nRewardSpawnDistMin,hTreasureEnt.nRewardSpawnDistMax) )
		nAttempts = nAttempts + 1

		if nAttempts >= 5 then
			vPos = hTreasureEnt:GetOrigin()
		end
	end

	return vPos
end


---------------------------------------------------------------------------

function modifier_treasure_chest:OnDestroy()
	if IsServer() then
		if self:GetParent() ~= nil and not self:GetParent():IsNull() then
			UTIL_Remove( self:GetParent() )
		end
	end
end

---------------------------------------------------------------------------
