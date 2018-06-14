
item_cavern_bag_of_gold = class({})

--------------------------------------------------------------------------------

function item_cavern_bag_of_gold:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_cavern_bag_of_gold:OnSpellStart()
	if IsServer() then

		--self:GetCaster():EmitSoundParams( "DOTA_Item.FaerieSpark.Activate", 0, 0.5, 0)
		local Heroes = HeroList:GetAllHeroes()
		local HeroesToReward = {}
		for _,Hero in pairs ( Heroes ) do
			if (Hero ~= nil) and Hero:IsRealHero() and (not Hero:IsTempestDouble()) and (Hero:GetTeamNumber() == self:GetCaster():GetTeamNumber()) then
				table.insert( HeroesToReward, Hero )
			end
		end

		if #HeroesToReward >= 1 then
			local nGoldAmount = self.nGoldAmount / #HeroesToReward
			for _,Hero in pairs ( HeroesToReward ) do
				Hero:ModifyGold( nGoldAmount, true, DOTA_ModifyGold_Unspecified)
				SendOverheadEventMessage(Hero:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, Hero, nGoldAmount, nil);
			end
		end

		self:SpendCharge()
	end
end

--------------------------------------------------------------------------------
