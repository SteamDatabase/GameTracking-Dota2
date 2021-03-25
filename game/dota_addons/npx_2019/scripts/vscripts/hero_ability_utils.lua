function LearnHeroAbilities( hHero, rgOptions )
	local rgTalents = {}
	local rgNormalAbilitiesWithPriority = {}
	local rgUltimateAbilities = {}

	local rgTalentLevels = { 10, 15, 20, 25 }
	for _,nHeroLevel in pairs( rgTalentLevels ) do
		rgTalents[ nHeroLevel ] = {}
	end

	local rgAbilityPriority = {}
	if rgOptions ~= nil and rgOptions.AbilityPriority ~= nil then
		rgAbilityPriority = rgOptions.AbilityPriority
	end

	local rgTalentSuggestions = {}
	if rgOptions ~= nil and rgOptions.Talents ~= nil then
		rgTalentSuggestions = rgOptions.Talents
	end

	for i = 0, DOTA_MAX_ABILITIES - 1 do
		local hAbility = hHero:GetAbilityByIndex( i )
		if hAbility then
			local nAbilityType = hAbility:GetAbilityType()

			if nAbilityType == ABILITY_TYPE_BASIC then
				local nPriority = i

				for nOrder,strAbility in pairs( rgAbilityPriority ) do
					if strAbility == hAbility:GetAbilityName() then
						nPriority = nPriority + ( 100 * nOrder )
						print (hAbility:GetAbilityName()  .. " has priority " .. nPriority )
						break
					end
				end

				table.insert( rgNormalAbilitiesWithPriority, { Ability = hAbility, Priority = nPriority } )
			elseif nAbilityType == ABILITY_TYPE_ULTIMATE then
				table.insert( rgUltimateAbilities, hAbility )
			elseif nAbilityType == ABILITY_TYPE_ATTRIBUTES then
				for _,nHeroLevel in pairs( rgTalentLevels ) do
					local rgTalentChoices = rgTalents[ nHeroLevel ]
					if #rgTalentChoices < 2 then
						table.insert( rgTalentChoices, hAbility )
						break
					end
				end
			end
		end
	end

	table.sort( rgNormalAbilitiesWithPriority, function( lhs, rhs ) return lhs.Priority > rhs.Priority end )
	local rgNormalAbilities = {}
	for _,rgAbilityAndPriority in pairs( rgNormalAbilitiesWithPriority ) do
		table.insert( rgNormalAbilities, rgAbilityAndPriority.Ability )
	end

	while hHero:GetAbilityPoints() > 0 do
		local bUpgraded = false

		-- Any available talents?
		if not bUpgraded then
			
			for _,nHeroLevel in pairs( rgTalentLevels ) do
				local rgTalentChoices = rgTalents[ nHeroLevel ]
				if hHero:GetLevel() >= nHeroLevel and #rgTalentChoices > 0 then
					local bAlreadyPicked = false
					for _,hTalent in pairs( rgTalentChoices ) do
						if hTalent:GetLevel() > 0 then
							bAlreadyPicked = true
							break;
						end
					end

					if not bAlreadyPicked then
						-- Default to the left talent
						local hAbility = rgTalentChoices[ 1 ]

						-- If the user has provided a suggestion, try to pick that
						local strSuggestion = rgTalentSuggestions[ nHeroLevel ]
						if strSuggestion ~= nil then
							for _,hTalent in pairs( rgTalentChoices ) do
								if hTalent:GetAbilityName() == strSuggestion then
									hAbility = hTalent
									break
								end
							end
						end

						-- print( "Upgrading " .. hAbility:GetAbilityName() )
						hHero:UpgradeAbility( hAbility )
						bUpgraded = true
						break
					end
				end
			end
		end

		-- Upgrade the ultimate?
		if not bUpgraded then 
			for _,hAbility in pairs( rgUltimateAbilities ) do
				if hAbility:CanAbilityBeUpgraded() == ABILITY_CAN_BE_UPGRADED and not hAbility:IsHidden() then
					-- print( "Upgrading " .. hAbility:GetAbilityName() )
					hHero:UpgradeAbility( hAbility )
					bUpgraded = true
					break
				end
			end
		end

		-- Upgrade any normal abilities that don't have any points yet
		if not bUpgraded then

			for _,hAbility in pairs( rgNormalAbilities ) do
				if hAbility:CanAbilityBeUpgraded() == ABILITY_CAN_BE_UPGRADED and hAbility:GetLevel() == 0 and not hAbility:IsHidden() then
					-- print( "Upgrading " .. hAbility:GetAbilityName() )
					hHero:UpgradeAbility( hAbility )
					bUpgraded = true
					break
				end
			end
		end

		-- Upgrade any other normal abilities
		if not bUpgraded then

			for _,hAbility in pairs( rgNormalAbilities ) do
				if hAbility:CanAbilityBeUpgraded() == ABILITY_CAN_BE_UPGRADED and not hAbility:IsHidden() then
					-- print( "Upgrading " .. hAbility:GetAbilityName() )
					hHero:UpgradeAbility( hAbility )
					bUpgraded = true
					break
				end
			end
		end

		if not bUpgraded then
			print( "Failed to spend all ability points when spawning " .. hHero:GetUnitName() )
			break
		end
	end
end

----------------------------------------------------------------------------

function RefreshHeroAbilities( hHero )
	for i = 0,DOTA_MAX_ABILITIES-1 do
		local hAbility = hHero:GetAbilityByIndex( i )
		if hAbility then
			if hAbility:IsRefreshable() then
				hAbility:SetFrozenCooldown( false )
				hAbility:EndCooldown()
				hAbility:RefreshCharges()
			end
		end
	end

	for j = 0,DOTA_ITEM_INVENTORY_SIZE-1 do
		local hItem = hHero:GetItemInSlot( j )
		if hItem then
			if hItem:IsRefreshable() then
				hItem:SetFrozenCooldown( false )
				hItem:EndCooldown()
				hItem:RefreshCharges()
			end
		end
	end

	local hTpScroll = hHero:GetItemInSlot( DOTA_ITEM_TP_SCROLL )
	if hTpScroll then
		if hTpScroll:IsRefreshable() then
			hTpScroll:SetFrozenCooldown( false )
			hTpScroll:EndCooldown()
			hTpScroll:RefreshCharges()
		end
	end
end

----------------------------------------------------------------------------

function RefreshHero( hHero )
	--			 PositiveBuffs, NegativeBuffs, FrameOnly, RemoveStuns, RemoveExceptions
	hHero:Purge( true,		  	true,		   false,	  true,		   false )

	hHero:SetHealth( hHero:GetMaxHealth() )
	hHero:SetMana( hHero:GetMaxMana() )

	hHero:AddNewModifier( hHero, nil, "modifier_invulnerable", { duration = 3.0 } )

	RefreshHeroAbilities( hHero )
end
