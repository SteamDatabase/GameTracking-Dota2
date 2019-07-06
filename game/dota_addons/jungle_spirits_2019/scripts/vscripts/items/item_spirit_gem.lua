
item_spirit_gem = class({})
item_spirit_gem_medium = item_spirit_gem
item_spirit_gem_big = item_spirit_gem

--------------------------------------------------------------------------------

function item_spirit_gem:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_spirit_gem:CanUnitPickUp(hUnit)
	if hUnit:IsIllusion() or not hUnit:IsRealHero() then
		return false
	end

	return true
end

--------------------------------------------------------------------------------

function item_spirit_gem:Spawn( kv )
	if IsServer() then
		--print( "item_spirit_gem spawned" )
	end
end

--------------------------------------------------------------------------------

function item_spirit_gem:OnSpellStart()
	if IsServer() then
		if self:GetCaster() and self:GetCaster():IsRealHero() then
			local hHero = self:GetCaster()
			local nDisadvantage = GameRules.JungleSpirits:GetMySpiritLevelDisadvantage( hHero )

			local nGems = self:GetCurrentCharges()

			local nAdvLow = 0
			local nAdvHigh = HIGHEST_BEAST_DISADVANTAGE
			-- Remap a value in the range [A,B] to [C,D].
			local fMultiplier = RemapVal( nDisadvantage, nAdvLow, nAdvHigh, MIN_ESSENCE_MULTIPLIER, MAX_ESSENCE_MULTIPLIER )
			local nNewGemCount = math.floor( nGems * fMultiplier )

			self:SetCurrentCharges( nNewGemCount )

			--[[
			print( "item_spirit_gem:OnSpellStart() - beast level disadvantage is " .. nDisadvantage )
			print( "   nGems: " .. nGems )
			print( "   nAdvLow: " .. nAdvLow )
			print( "   nAdvHigh: " .. nAdvHigh )
			print( "   fMultiplier: " .. fMultiplier )
			print( "   nNewGemCount: " .. nNewGemCount )
			]]
			

			local nPlayerID = self:GetCaster():GetPlayerOwnerID()
			GameRules.JungleSpirits.EventMetaData[ nPlayerID ]["essence_gathered"] =  GameRules.JungleSpirits.EventMetaData[ nPlayerID ]["essence_gathered"] + nNewGemCount

			EmitSoundOn( "JungleSpirit.GemsResource.Pickup", self:GetCaster() )

			local nFXIndex = ParticleManager:CreateParticle( "particles/jungle_spirit/jungle_spirit_essence_pickup.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local hSpiritGemModifier = self:GetCaster():FindModifierByName( "modifier_spirit_gem" )
			if hSpiritGemModifier ~= nil then
			-- If we're at Max Essence Cap, heal the hero instead for the gemcount amount
				if hSpiritGemModifier:GetStackCount() >= MAX_ESSENCE_CAP then
					hHero:Heal( nGems, self )
					hHero:GiveMana( nGems )
					SendOverheadEventMessage( self:GetCaster():GetPlayerOwner(), OVERHEAD_ALERT_HEAL, hHero, nGems, nil )
					SendOverheadEventMessage( self:GetCaster():GetPlayerOwner(), OVERHEAD_ALERT_MANA_ADD, hHero,nGems, nil )
					self:Destroy()				
					return
				end

				local nNewStackCount = hSpiritGemModifier:GetStackCount() + nGems
				hSpiritGemModifier:SetStackCount( nNewStackCount )
			else
				self:GetCaster():AddNewModifier( self:GetCaster(), nil, "modifier_spirit_gem", { duration = -1 } )
				hSpiritGemModifier = self:GetCaster():FindModifierByName( "modifier_spirit_gem" )

				if hSpiritGemModifier ~= nil then
					local nNewStackCount = hSpiritGemModifier:GetStackCount() + nGems
					hSpiritGemModifier:SetStackCount( nNewStackCount )
					local netTable = {}
					netTable["gems_count"] = hSpiritGemModifier:GetStackCount()
					CustomNetTables:SetTableValue( "jungle_spirits_gems_info", tostring( self:GetCaster():entindex() ), netTable )
				end
			end

			--[[local hSpiritGemModifier = self:GetCaster():FindModifierByName( "modifier_spirit_gem" )
			if hSpiritGemModifier == nil then
				self:GetCaster():AddNewModifier( hHero, nil, "modifier_spirit_gem", { duration = -1 } )
			end
			local hSpiritGemModifier = self:GetCaster():FindModifierByName( "modifier_spirit_gem" )

			if self:GetCurrentCharges() > 0 and hSpiritGemModifier ~= nil then
				for i = 0, self:GetCurrentCharges() - 1 do
					hSpiritGemModifier:IncrementStackCount()
				end
			end
			--]]

			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------
