modifier_breakable_container = class({})

--------------------------------------------------------------------------------

function modifier_breakable_container:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_breakable_container:CanParentBeAutoAttacked()
	return false
end

--------------------------------------------------------------------------------

function modifier_breakable_container:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_breakable_container:OnCreated( kv )
	if IsServer() then
		self.hEncounter = self:GetParent().hEncounter -- unit was given this prior to modifier being added

		if not self.hEncounter then
			print( "modifier_breakable_container - ERROR: self.hEncounter is nil" )
			self:Destroy()
			return
		end

		self.hRoom = self.hEncounter.hRoom

		if not self.hRoom then
			print( "modifier_breakable_container - ERROR: self.hRoom is nil" )
			self:Destroy()
			return
		end

		self.nRoomLevel = self.hRoom:GetRoomLevel()

		self.GoldMin = { 75, 150, 225, 300, 375, 450 } 
		self.GoldMax = { 125, 250, 375, 500, 625, 750 }
	end
end

--------------------------------------------------------------------------------

function modifier_breakable_container:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_ROOTED] = true
		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
		state[MODIFIER_STATE_BLIND] = true
		state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
	end

	return state
end

--------------------------------------------------------------------------------

function modifier_breakable_container:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_breakable_container:GetModifierProvidesFOWVision( params )
	return 1
end

-----------------------------------------------------------------------

function modifier_breakable_container:OnDeath( params )
	if IsServer() then
		if ( params.unit == self:GetParent() ) then
			if self:GetParent():GetUnitName() == "npc_dota_crate" then
				if RandomInt( 0, 1 ) >= 0.3 then
					EmitSoundOn( "Cavern.SmashCrateShort", self:GetParent() )
				else
					EmitSoundOn( "Cavern.SmashCrateLong", self:GetParent() )
				end
			end

			self:ChooseBreakableSurprise( params.attacker )
		end
	end
end

-----------------------------------------------------------------------

function modifier_breakable_container:ChooseBreakableSurprise( hAttacker )
	-- Note: hAttacker can be nil

	local hParent = self:GetParent()
	assert( hParent ~= nil, "modifier_breakable_container - ERROR: hParent is nil" )

	hParent.nRewardSpawnDist = 32

	if hParent.CommonItems == nil then
		if self.nRoomLevel <= 2 then
			hParent.CommonItems =
			{
				"item_health_potion",
				"item_mana_potion",
			}
		else
			hParent.CommonItems =
			{
				"item_health_potion",
				"item_mana_potion",
			}
		end
	end

	if hParent.RareItems == nil then
		if self.nRoomLevel <= 1 then
			hParent.RareItems =
			{
				"item_tome_of_knowledge_cavern",
				"item_cavern_dynamite",
				"item_cavern_dynamite",
			}
		elseif self.nRoomLevel >= 4 then
			hParent.RareItems =
			{	
				"item_cavern_treasure_tier1",
				"item_tome_of_knowledge_cavern",
				"item_cavern_dynamite",
				"item_cavern_dynamite",
				"item_cavern_dynamite",
			}
		else
			hParent.RareItems =
			{	
				"item_tome_of_knowledge_cavern",
				"item_cavern_dynamite",
				"item_cavern_dynamite",
			}
		end
	end

	if hParent.Enemies == nil then
		hParent.Enemies =
		{
			level_2 =
			{
				"npc_dota_cavern_life_stealer",
			},

			level_3 =
			{
				"npc_dota_cavern_life_stealer",
			},

			level_4 =
			{
				"npc_dota_cavern_life_stealer",
			},
		}
	end

	if hParent.nMinGold == nil then
		hParent.nMinGold = self.GoldMin[ self.nRoomLevel ]
	end

	if hParent.nMaxGold == nil then
		hParent.nMaxGold = self.GoldMax[ self.nRoomLevel ]
	end

	if hParent.fCommonItemChance == nil then
		hParent.fCommonItemChance = 0.15
	end

	if hParent.fRareItemChance == nil then
		hParent.fRareItemChance = 0.05
	end

	if hParent.fGoldChance == nil then
		hParent.fGoldChance = 0.4
	end

	if hParent.fEnemyChance == nil then
		hParent.fEnemyChance = 0.04
	end

	local fCommonItemThreshold = 1 - hParent.fCommonItemChance
	local fRareItemThreshold = fCommonItemThreshold - hParent.fRareItemChance
	local fGoldThreshold = fRareItemThreshold - hParent.fGoldChance
	local fEnemyThreshold = fGoldThreshold - hParent.fEnemyChance

	---------------------------------------------------------------
	-- Devtest start: Use this to bypass all the random rolls below
	---------------------------------------------------------------
	local bDevTest = false
	if bDevTest then
		self:CreateBreakableContainerEnemy( hAttacker, hParent )
		return
	end
	---------------------------------------------------------------
	-- Devtest end
	---------------------------------------------------------------

	local fRandRoll = RandomFloat( 0, 1 )

	--[[
	print( "----------------------------------------" )
	print( string.format( "fRandRoll: %.2f", fRandRoll ) )
	print( string.format( "fCommonItemThreshold: %.2f", fCommonItemThreshold ) )
	print( string.format( "fRareItemThreshold: %.2f", fRareItemThreshold ) )
	print( string.format( "fGoldThreshold: %.2f", fGoldThreshold ) )
	print( string.format( "fEnemyThreshold: %.2f", fEnemyThreshold ) )
	]]

	if fRandRoll >= fCommonItemThreshold then
		self:CreateBreakableContainerCommonItemDrop( hAttacker )
		--print( string.format( "fRandRoll (%.2f) >= fCommonItemThreshold (%.2f)", fRandRoll, fCommonItemThreshold ) )
		return
	elseif fRandRoll >= fRareItemThreshold then
		self:CreateBreakableContainerRareItemDrop( hAttacker )
		--print( string.format( "fRandRoll (%.2f) >= fRareItemThreshold (%.2f)", fRandRoll, fRareItemThreshold ) )
		return
	elseif fRandRoll >= fGoldThreshold then
		--print( string.format( "fRandRoll (%.2f) >= fGoldThreshold (%.2f)", fRandRoll, fGoldThreshold ) )
		self:CreateBreakableContainerGoldDrop( hAttacker )
		return
	elseif fRandRoll >= fEnemyThreshold then
		--print( string.format( "fRandRoll (%.2f) >= fEnemyThreshold (%.2f)", fRandRoll, fEnemyThreshold ) )
		self:CreateBreakableContainerEnemy( hAttacker )
		return
	else
		-- Create nothing
		--print( string.format( "breakable container didn't create anything, fRandRoll was %.2f", fRandRoll ) )
	end
end

---------------------------------------------------------------------------

function modifier_breakable_container:CreateBreakableContainerCommonItemDrop( hAttacker )
	local hParent = self:GetParent()
	assert( hParent ~= nil, "modifier_breakable_container - ERROR: hParent is nil" )

	if hParent and hParent.CommonItems ~= nil then
		local nRandomIndex = RandomInt( 1, #hParent.CommonItems )
		local newItem = CreateItem( hParent.CommonItems[ nRandomIndex ], nil, nil )
		local drop = CreateItemOnPositionForLaunch( hParent:GetAbsOrigin(), newItem )

		local vPos = self:GetBreakableRewardSpawnPos( hParent )

		if newItem:GetAbilityName() == "item_health_potion" or newItem:GetAbilityName() == "item_mana_potion" then
			newItem:LaunchLootInitialHeight( true, 0, 100, 0.5, vPos )
		else
			newItem:LaunchLootInitialHeight( false, 0, 100, 0.5, vPos )
		end

		EmitSoundOn( "Dungeon.TreasureItemDrop", hParent )
	end
end

---------------------------------------------------------------------------

function modifier_breakable_container:CreateBreakableContainerRareItemDrop( hAttacker )
	local hParent = self:GetParent()
	assert( hParent ~= nil, "modifier_breakable_container - ERROR: hParent is nil" )

	if hParent and hParent.RareItems ~= nil then
		local nRandomIndex = RandomInt( 1, #hParent.RareItems )
		local newItem = CreateItem( hParent.RareItems[ nRandomIndex ], nil, nil )
		local drop = CreateItemOnPositionForLaunch( hParent:GetAbsOrigin(), newItem )

		local vPos = self:GetBreakableRewardSpawnPos( hParent )

		newItem:LaunchLootInitialHeight( false, 0, 100, 0.5, vPos )

		EmitSoundOn( "Dungeon.TreasureItemDrop", hParent )
	end
end

---------------------------------------------------------------------------

function modifier_breakable_container:CreateBreakableContainerGoldDrop( hAttacker )
	local hParent = self:GetParent()
	assert( hParent ~= nil, "modifier_breakable_container - ERROR: hParent is nil" )

	local nGoldToDrop = RandomInt( hParent.nMinGold, hParent.nMaxGold )

	if nGoldToDrop > 0 then
		LaunchGoldBag( nGoldToDrop, self:GetBreakableRewardSpawnPos( hParent ) )
		EmitSoundOn( "Dungeon.TreasureItemDrop", hParent )
	end
end

---------------------------------------------------------------------------

function modifier_breakable_container:CreateBreakableContainerEnemy( hAttacker )
	local hParent = self:GetParent()
	assert( hParent ~= nil, "modifier_breakable_container - ERROR: hParent is nil" )

	local szLevel = "level_" .. self.nRoomLevel

	if hParent and hParent.Enemies ~= nil and hParent.Enemies[ szLevel ] ~= nil then
		local nRandomIndex = RandomInt( 1, #hParent.Enemies[ szLevel ] )
		local szUnit = hParent.Enemies[ szLevel ][ nRandomIndex ]

		local vSpawnPoint = hParent:GetAbsOrigin()
		local hUnit = self.hEncounter:SpawnNonCreepByName( szUnit, vSpawnPoint, true, nil, nil, DOTA_TEAM_BADGUYS )
		hUnit.nRoomLevel = self.nRoomLevel

		if hUnit then
			EmitSoundOn( "CagedMenace.CrateExit", hUnit )
			if hAttacker then
				hUnit:FaceTowards( hAttacker:GetOrigin() )
			end
		end
	end
end

---------------------------------------------------------------------------

function modifier_breakable_container:GetBreakableRewardSpawnPos()
	local hParent = self:GetParent()
	assert( hParent ~= nil, "modifier_breakable_container - ERROR: hParent is nil" )

	local vPos = hParent:GetAbsOrigin() + RandomVector( hParent.nRewardSpawnDist )

	local nAttempts = 0
	while ( ( not GridNav:CanFindPath( hParent:GetOrigin(), vPos ) ) and ( nAttempts < 5 ) ) do
		vPos = hParent:GetOrigin() + RandomVector( hParent.nRewardSpawnDist )
		nAttempts = nAttempts + 1

		if nAttempts >= 5 then
			vPos = hParent:GetOrigin()
		end
	end

	return vPos
end

---------------------------------------------------------------------------

