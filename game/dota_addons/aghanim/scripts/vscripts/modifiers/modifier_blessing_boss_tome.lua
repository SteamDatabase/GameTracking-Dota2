require( "modifiers/modifier_blessing_base" )

modifier_blessing_boss_tome = class( modifier_blessing_base )

-----------------------------------------------------------------------

function modifier_blessing_boss_tome:GrantReward()
	local hHero = self:GetParent()
	if hHero ~= nil then
		for i = 1, math.floor( self:GetStackCount() / 5 ) do
			local nAttribute = RandomInt(0, 2)
			if nAttribute == 0 then
				GrantItemDropToHero( hHero, "item_book_of_boss_beating_strength" )
			elseif nAttribute == 1 then
				GrantItemDropToHero( hHero, "item_book_of_boss_beating_agility" )
			else
				GrantItemDropToHero( hHero, "item_book_of_boss_beating_intelligence" )
			end
		end
	end
end
