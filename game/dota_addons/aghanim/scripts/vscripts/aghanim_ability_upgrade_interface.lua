--------------------------------------------------------------------------------

function CAghanim:OnAbilityUpgradeButtonClicked( eventSourceIndex, data )
	-- Grants the
	local nPlayerID = data["PlayerID"]
	local szAbilityName = data["AbilityName"]
	local bIsLevelReward = data["LevelReward"]
	--print ("OnAbilityUpgradeButtonClicked", nPlayerID, szAbilityName, bIsLevelReward, self.bTestingAbilityUpgrades)
	if bIsLevelReward == true or self.bTestingAbilityUpgrades == true then
		if nPlayerID ~= nil and szAbilityName ~= nil then
			local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hPlayerHero ~= nil then
				CustomGameEventManager:Send_ServerToAllClients( "special_ability_upgrades_button_clicked", data )
				if ( hPlayerHero:FindAbilityByName(szAbilityName) ~= nil ) then 
					-- Only grant an ability once (can be changed if necessary)
					hPlayerHero:RemoveAbility(szAbilityName)
					--print ("Removing ability:", szAbilityName)
				else 				
					local hNewAbility = hPlayerHero:AddAbility( szAbilityName )
					if ( hNewAbility ) then
						-- Grants and upgrades the ability
						hNewAbility:UpgradeAbility( false )
						--print ("Adding new ability", szAbilityName)
						if hPlayerHero.MajorAbilityUpgrades == nil then 
							hPlayerHero.MajorAbilityUpgrades = {}
						end

						local newUpgrade = {}
						newUpgrade[ "ability_upgrade_name" ] = szAbilityName

						local AbilityKV = hNewAbility:GetAbilityKeyValues()
						if AbilityKV then 
							local szMatchName = AbilityKV[ "AbilityParentName" ] 
							if szMatchName == nil then 
								szMatchName = AbilityKV[ "AbilityTextureName" ]
							end
							--print( "searching for " .. szMatchName )
							for i = 0, hPlayerHero:GetAbilityCount() do 
								local hAbility = hPlayerHero:GetAbilityByIndex( i )
								if hAbility and hAbility:GetMaxLevel() > 1 then 

									if string.find( hAbility:GetAbilityName(), szMatchName )  then 
										newUpgrade[ "ability_parent_name" ] = hAbility:GetAbilityName()
										--print( "found parent ability " .. hAbility:GetAbilityName() )
										break
									end
								end
							end						
						end					

						table.insert( hPlayerHero.MajorAbilityUpgrades, newUpgrade )

						CustomNetTables:SetTableValue( "major_ability_upgrades", tostring( hPlayerHero:GetPlayerOwnerID() ), hPlayerHero.MajorAbilityUpgrades )

					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CAghanim:TestAbilityUpgradesUICC ( cmdName, bVisible )
	-- Enables the button to open the dev upgrade UI
	print ("TestAbilityUpgradesUI Enabled ")

	self.bTestingAbilityUpgrades = true
	CustomGameEventManager:Send_ServerToAllClients( "special_ability_upgrades_enabled", {} )
    
end
