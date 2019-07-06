
-- @note: Ideally this file and all but one of the other item_spirit_gem_*.lua files would not
-- exist, but life is short and I'm seeing shenanigans when trying to share a single file
-- across the three gem item variants

item_spirit_gem_small = class({})

--------------------------------------------------------------------------------

function item_spirit_gem_small:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_spirit_gem_small:CanUnitPickUp(hUnit)
	if hUnit:IsIllusion() or not hUnit:IsRealHero() then
		return false
	end

	return true
end

--------------------------------------------------------------------------------

function item_spirit_gem_small:Spawn( kv )
	if IsServer() then
		--print( "item_spirit_gem_small spawned" )
	end
end

--------------------------------------------------------------------------------

function item_spirit_gem_small:OnSpellStart()
	if IsServer() then
		if self:GetCaster() and self:GetCaster():IsRealHero() then
			local nDisadvantage = GameRules.JungleSpirits:GetMySpiritLevelDisadvantage( self:GetCaster() )

			local nGems = self:GetCurrentCharges()

			local nAdvLow = 0
			local nAdvHigh = HIGHEST_BEAST_DISADVANTAGE
			-- Remap a value in the range [A,B] to [C,D].
			local fMultiplier = RemapVal( nDisadvantage, nAdvLow, nAdvHigh, MIN_ESSENCE_MULTIPLIER, MAX_ESSENCE_MULTIPLIER )
			local nNewGemCount = math.floor( nGems * fMultiplier )

			self:SetCurrentCharges( nNewGemCount )

			--[[
			print( "item_spirit_gem_small:OnSpellStart() - beast level disadvantage is " .. nDisadvantage )
			print( "   nGems: " .. nGems )
			print( "   nAdvLow: " .. nAdvLow )
			print( "   nAdvHigh: " .. nAdvHigh )
			print( "   fMultiplier: " .. fMultiplier )
			print( "   nNewGemCount: " .. nNewGemCount )
			]]

			local nPlayerID = self:GetCaster():GetPlayerOwnerID()
			GameRules.JungleSpirits.EventMetaData[ nPlayerID ]["essence_gathered"] =  GameRules.JungleSpirits.EventMetaData[ nPlayerID ]["essence_gathered"] + nNewGemCount

			EmitSoundOn( "JungleSpirit.GemsResource.Pickup", self:GetCaster() )

			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/fish_bones_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local szGemModifier = "modifier_spirit_gem"

			local hSpiritGemModifier = self:GetCaster():FindModifierByName( szGemModifier )
			if hSpiritGemModifier == nil then 
				--printf( "item_spirit_gem_small: Could not find \"%s\" on \"%s\". Re-creating the associated ability.", szGemModifier, self:GetCaster():GetUnitName() )

				GameRules.JungleSpirits:AddSpiritGemAbilityToUnit( self:GetCaster() )
				hSpiritGemModifier = self:GetCaster():FindModifierByName( szGemModifier )
			end

			if self:GetCurrentCharges() > 0 and hSpiritGemModifier ~= nil then
				for i = 0, self:GetCurrentCharges() - 1 do
					hSpiritGemModifier:IncrementStackCount()
				end
			end

			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------
