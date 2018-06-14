
item_cavern_treasure = class({})

item_cavern_treasure_tier1 = item_cavern_treasure
item_cavern_treasure_tier2 = item_cavern_treasure
item_cavern_treasure_tier3 = item_cavern_treasure
item_big_cheese_cavern = item_cavern_treasure

--------------------------------------------------------------------------------

function item_cavern_treasure:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_cavern_treasure:OnSpellStart()
	if IsServer() then

		self:GetCaster():EmitSoundParams( "DOTA_Item.FaerieSpark.Activate", 0, 0.5, 0)
		local Heroes = HeroList:GetAllHeroes()
		local HeroesToReward = {}
		for _,Hero in pairs ( Heroes ) do
			if (Hero ~= nil) and Hero:IsRealHero() and (not Hero:IsTempestDouble()) and (Hero:GetTeamNumber() == self:GetCaster():GetTeamNumber()) then
				table.insert( HeroesToReward, Hero )
			end
		end

		if #HeroesToReward >= 1 then
			local nGoldAmount = self:GetSpecialValueFor( "gold_amount" ) / #HeroesToReward

			local nBattlePointAmount = CAVERN_BP_REWARD_TREASURE[self:GetAbilityName()]

			for _,Hero in pairs ( HeroesToReward ) do
				Hero:ModifyGold( nGoldAmount, true, DOTA_ModifyGold_Unspecified)
				SendOverheadEventMessage(Hero:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, Hero, nGoldAmount, nil);
			end

			local bBigCheese = self:GetAbilityName() == "item_big_cheese_cavern";

			
			if bBigCheese then
				GameRules.Cavern:OnBigCheeseTaken( self:GetCaster():GetTeamNumber() )
				GameRules.Cavern:OnBattlePointsEarned( self:GetCaster():GetTeamNumber(), nBattlePointAmount, "points_big_cheese" )
			else
				GameRules.Cavern:OnBattlePointsEarned( self:GetCaster():GetTeamNumber(), nBattlePointAmount, "points_small_cheese" )
			end
		end

		self:SpendCharge()

	end
end

--------------------------------------------------------------------------------
