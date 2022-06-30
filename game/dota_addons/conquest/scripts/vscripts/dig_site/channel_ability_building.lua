-- Hero Ability - Channeling ability that allows heroes to dig for neutral items at Dig Sites

channel_ability_building = class({})

LinkLuaModifier( "modifier_channel_ability_building", "dig_site/modifier_channel_ability_building", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dig_site_passive", "dig_site/modifier_dig_site_passive", LUA_MODIFIER_MOTION_VERTICAL )
LinkLuaModifier( "modifier_dig_site_cooldown", "dig_site/modifier_dig_site_cooldown", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function channel_ability_building:Precache( context )
end

--------------------------------------------------------------------------------

function channel_ability_building:IsCosmetic()
	return true
end

--------------------------------------------------------------------------------

function channel_ability_building:GetCastRangeBonus()
	return 0
end

--------------------------------------------------------------------------------

function channel_ability_building:OnAbilityPhaseStart()
	if IsServer() == false then
		return true
	end

	if self:GetCaster() then
		self:GetCaster():EmitSound( "SeasonalConsumable.TI9.Shovel.Dig" )
	end

    self.hDigSite = self:GetCursorTarget()
    self.hDigSiteCooldown = self.hDigSite:FindModifierByName( "modifier_dig_site_cooldown" )

    if (self.hDigSite == nil or self.hDigSite:IsNull() or self.hDigSiteCooldown ~= nil ) then
		print( "channel_ability_building - Dig Site on cooldown")
        return false
    end

    if self:GetCaster():GetTeamNumber() ~= self.hDigSite:GetTeamNumber() then
		print( "channel_ability_building - Dig Site not controlled")
        return false
    end

    local kv = {}
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_channel_ability_building", kv )
	
	local vFwd = self:GetCursorTarget():GetOrigin() - self:GetCaster():GetOrigin()
	vFwd.z = 0.0
	vFwd = vFwd:Normalized()

	local vChannelPos = self:GetCaster():GetOrigin()
	vChannelPos = vChannelPos + vFwd * 100
	vChannelPos.z = GetGroundHeight(vChannelPos, nil)

	self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti9/shovel_dig.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( self.nFXIndex, 0, vChannelPos )
	ParticleManager:SetParticleControlForward( self.nFXIndex, 0, vFwd )

    return true
end

--------------------------------------------------------------------------------

function channel_ability_building:OnAbilityPhaseInterrupted()
	if IsServer() then
		if self:GetCaster() then
			self:GetCaster():RemoveModifierByName( "modifier_channel_ability_building" )
			self:GetCaster():StopSound( "SeasonalConsumable.TI9.Shovel.Dig" )
		end

		ParticleManager:DestroyParticle(self.nFXIndex, false)
	end
end


--------------------------------------------------------------------------------

function channel_ability_building:OnChannelThink( flInterval )
	if IsServer() then
        -- Interrupted if someone else finishes digging first
        -- Interrupted if point 3 is captured while digging
        self.hDigSiteCooldown = self.hDigSite:FindModifierByName( "modifier_dig_site_cooldown" )
        if (self.hDigSiteCooldown ~= nil or self:GetCaster():GetTeamNumber() ~= self.hDigSite:GetTeamNumber()) then
            EndChannel( true )
			self:GetCaster():RemoveModifierByName( "modifier_channel_ability_building" )
			print("channel_ability_building - Cast interrupted")
			return
        end

        -- TODO: Pop out other loot mid-channel? That way loot is still used in game, and there's still benefit to partial channel
	end
end

--------------------------------------------------------------------------------

function channel_ability_building:OnChannelFinish( bInterrupted )
    if not bInterrupted then
    	if self:GetCaster() then
    		self:GetCaster():StopSound( "SeasonalConsumable.TI9.Shovel.Dig" )
    	end

        local nCasterTeam = self:GetCaster():GetTeamNumber()
        local nStartingTier = 5 - totalMilestones
		if nCasterTeam == DOTA_TEAM_GOODGUYS then
			nStartingTier = nStartingTier + radiantMilestoneBonus
		elseif nCasterTeam == DOTA_TEAM_BADGUYS then
			nStartingTier = nStartingTier + direMilestoneBonus
		end

		-- Reduce tier if 5 of this tier was already granted
		local nTier = nStartingTier
		while nTier > 1 and CConquestGameMode:GetNeutralItemDropCount(nCasterTeam, nTier) >= 5 do
			nTier = nTier - 1
		end

		local hHeroForDrop = self:GetCaster()
		local bSpawnedNeutralItem = false
		if CConquestGameMode:GetNeutralItemDropCount(nCasterTeam, nTier) < 5 then
			local szItemToDrop = GetPotentialNeutralItemDrop( nTier, nCasterTeam )
			if hHeroForDrop ~= nil and szItemToDrop ~= nil then
				print("Attempting to drop tier "..nTier.." neutral item for team "..nCasterTeam)
				local hItemPhysical = DropNeutralItemAtPositionForHero( szItemToDrop, self.hDigSite:GetAbsOrigin(), hHeroForDrop, nTier, true )
				if hItemPhysical ~= nil then
					-- Drop Neutral already does this - hItem:GetContainedItem():LaunchLootInitialHeight( false, 0, 200, 0.75, hHeroForDrop:GetAbsOrigin() )
					hItemPhysical.nHeroPlayerID = hHeroForDrop:GetPlayerOwnerID()
					hItemPhysical.nTeam = nCasterTeam
					hItemPhysical.nTier = nTier
					hItemPhysical:GetContainedItem().nNeutralItemTeamNumber = nCasterTeam
					bSpawnedNeutralItem = true
					table.insert(m_vecDroppedNeutralItems, hItemPhysical)
				end
			end
		end

		-- Bonus loot if we had to drop a tier
		--[[
		if nTier < nStartingTier then
			CConquestGameMode:HandleLootItemDrop(hHeroForDrop, self.hDigSite:GetAbsOrigin(), hHeroForDrop:GetAbsOrigin() + RandomVector( RandomFloat( 100, 250 ) ), true)
		end
		]]

		-- If no neutrals spawned at all, give a random loot item instead
		if hHeroForDrop ~= nil and bSpawnedNeutralItem == false then
			print("Attempting to drop loot for team "..nCasterTeam)
			CConquestGameMode:HandleLootItemDrop(hHeroForDrop, self.hDigSite:GetAbsOrigin(), hHeroForDrop:GetAbsOrigin(), true)
		end

		self.hDigSite:AddNewModifier( self.hDigSite, self, "modifier_dig_site_cooldown", kv)
    end

	self:GetCaster():RemoveModifierByName( "modifier_channel_ability_building" )

	ParticleManager:DestroyParticle(self.nFXIndex, false)
end

--------------------------------------------------------------------------------

function channel_ability_building:IsCosmetic( hEnt )
	return true
end

--------------------------------------------------------------------------------

function channel_ability_building:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function channel_ability_building:IsStealable()
	return false
end

--------------------------------------------------------------------------------

function channel_ability_building:IsHiddenAbilityCastable()
	return true
end

--------------------------------------------------------------------------------

function channel_ability_building:OtherAbilitiesAlwaysInterruptChanneling()
	return true
end

--------------------------------------------------------------------------------

function channel_ability_building:CastFilterResultTarget( hTarget )
	if hTarget == nil or hTarget:GetUnitName() ~= "npc_dota_dig_site" then
		return UF_FAIL_CUSTOM
	end

	if hTarget:HasModifier( "modifier_dig_site_cooldown" ) then
		return UF_FAIL_CUSTOM
	end
	
	if self:GetCaster():GetTeamNumber() ~= hTarget:GetTeamNumber() then
		return UF_FAIL_CUSTOM
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function channel_ability_building:GetCustomCastErrorTarget( hTarget )
	if hTarget:HasModifier( "modifier_dig_site_cooldown" ) then
		return "#dota_hud_error_dig_site_cooldown"
	end
	
	return "#dota_hud_error_dig_site_unowned"
end

--------------------------------------------------------------------------------

function channel_ability_building:OnSpellStart()

end

