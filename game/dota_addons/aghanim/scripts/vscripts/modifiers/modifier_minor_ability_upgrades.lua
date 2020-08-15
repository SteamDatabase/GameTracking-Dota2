require( "aghanim_ability_upgrade_constants" )
require( "utility_functions" )


modifier_minor_ability_upgrades = class({})

--------------------------------------------------------------------------------

function modifier_minor_ability_upgrades:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_minor_ability_upgrades:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_minor_ability_upgrades:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_minor_ability_upgrades:OnCreated( kv )
	self.bDirty = true

	if IsServer() then
		ListenToGameEvent( "dota_player_learned_ability", Dynamic_Wrap( modifier_minor_ability_upgrades, "OnPlayerLearnedAbility" ), self )
		CustomNetTables:SetTableValue( "minor_ability_upgrades", tostring( self:GetParent():GetPlayerOwnerID() ), self:GetParent().MinorAbilityUpgrades )
	else
		self:GetParent().MinorAbilityUpgrades = CustomNetTables:GetTableValue( "minor_ability_upgrades", tostring( self:GetParent():GetPlayerOwnerID() ) )
	end
end

--------------------------------------------------------------------------------

function modifier_minor_ability_upgrades:OnRefresh( kv )
	self.bDirty = true

	if IsServer() then
		CustomNetTables:SetTableValue( "minor_ability_upgrades", tostring( self:GetParent():GetPlayerOwnerID() ), self:GetParent().MinorAbilityUpgrades )
	else
		self:GetParent().MinorAbilityUpgrades = CustomNetTables:GetTableValue( "minor_ability_upgrades", tostring( self:GetParent():GetPlayerOwnerID() ) )
	end

	
	if self:GetParent().MinorAbilityUpgrades ~= nil then
		for _,AbilityUpgrade in pairs ( self:GetParent().MinorAbilityUpgrades ) do
			if AbilityUpgrade then
				for _,SpecialValueUpgrade in pairs ( AbilityUpgrade ) do
					if SpecialValueUpgrade and SpecialValueUpgrade[ "cached_result" ] ~= nil then
						SpecialValueUpgrade[ "cached_result" ] = {}
					end
				end
			end
		end
	end
end

-----------------------------------------------------------------------

function modifier_minor_ability_upgrades:OnPlayerLearnedAbility( event )
	if IsServer() then
		if event.PlayerID == self:GetParent():GetPlayerOwnerID() then
			self:ForceRefresh()
		end
	end
end

--------------------------------------------------------------------------------

function  modifier_minor_ability_upgrades:DeclareFunctions( )
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_REDUCTION_CONSTANT,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
	}
	return funcs
end


-----------------------------------------------------------------------

function modifier_minor_ability_upgrades:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end

	local hUpgrades = self:GetParent().MinorAbilityUpgrades
	if hUpgrades == nil then
		hUpgrades = CustomNetTables:GetTableValue( "minor_ability_upgrades", tostring( self:GetParent():GetPlayerOwnerID() ) )
	end
	local szAbilityName = params.ability:GetAbilityName() 
	local szSpecialValueName = params.ability_special_value
	if hUpgrades == nil or hUpgrades[ szAbilityName ] == nil then
		return 0
	end

	if hUpgrades[ szAbilityName ][ szSpecialValueName ] == nil then
		return 0
	end

	return 1
end

-----------------------------------------------------------------------

function modifier_minor_ability_upgrades:GetModifierOverrideAbilitySpecialValue( params )
	local hUpgrades = self:GetParent().MinorAbilityUpgrades
	if hUpgrades == nil then
		hUpgrades = CustomNetTables:GetTableValue( "minor_ability_upgrades", tostring( self:GetParent():GetPlayerOwnerID() ) )
	end
	local szAbilityName = params.ability:GetAbilityName() 
	local szSpecialValueName = params.ability_special_value
	local nSpecialLevel = params.ability_special_level
	if hUpgrades == nil or hUpgrades[ szAbilityName ] == nil then
		return 0
	end

	local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )
	local SpecialValueUpgrades = hUpgrades[ szAbilityName ][ szSpecialValueName ]

	if SpecialValueUpgrades ~= nil then		
		if self.bDirty == false and SpecialValueUpgrades[ "cached_result" ] ~= nil and SpecialValueUpgrades[ "cached_result" ][ nSpecialLevel ] ~= nil then
			return SpecialValueUpgrades[ "cached_result" ][ nSpecialLevel ]
		end

		local flAddResult = 0
		local flMulResult = 1.0
		
		for _,Upgrade in pairs ( SpecialValueUpgrades ) do
			if Upgrade[ "operator" ] == MINOR_ABILITY_UPGRADE_OP_ADD then
				flAddResult = flAddResult + Upgrade[ "value" ]
			end
			if Upgrade[ "operator" ] == MINOR_ABILITY_UPGRADE_OP_MUL then
				--print( "BEFORE: " .. szSpecialValueName .. " flMulResult: " .. flMulResult )
					
				flMulResult = flMulResult * ( 1.0 + ( Upgrade[ "value" ] / 100.0 ) )
			
				--print( szSpecialValueName .. " flMulResult: " .. flMulResult )
			end
		end

		--print( "Before Final " .. szSpecialValueName .. " flMulResult: " .. flMulResult )
		--flMulResult = ( 1.0 + ( 1.0 - flMulResult ) / 100.0 )
		--print( "Final " .. szSpecialValueName .. " flMulResult: " .. flMulResult )

		local flResult = ( flBaseValue + flAddResult ) * flMulResult
		if SpecialValueUpgrades[ "cached_result" ] == nil then
			SpecialValueUpgrades[ "cached_result" ] = {}
		end
		SpecialValueUpgrades[ "cached_result" ][ nSpecialLevel ] = flResult
		self.bDirty = false
		return flResult
	
	end

	return flBaseValue
end

-----------------------------------------------------------------------

function modifier_minor_ability_upgrades:EnsureCachedResult( CooldownUpgrades )
	if CooldownUpgrades[ "cached_result" ] == nil then
		CooldownUpgrades[ "cached_result" ] = {}
	end
	if CooldownUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_ADD ] == nil then
		CooldownUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_ADD ] = {}
	end
	if CooldownUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_MUL ] == nil then
		CooldownUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_MUL ] = {}
	end
end

-----------------------------------------------------------------------

function modifier_minor_ability_upgrades:GetModifierCooldownReduction_Constant( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end

	local hUpgrades = self:GetParent().MinorAbilityUpgrades
	if hUpgrades == nil then
		hUpgrades = CustomNetTables:GetTableValue( "minor_ability_upgrades", tostring( self:GetParent():GetPlayerOwnerID() ) )
	end

	local szAbilityName = params.ability:GetAbilityName() 
	local nSpecialLevel = params.ability_special_level
	if hUpgrades == nil or hUpgrades[ szAbilityName ] == nil or nSpecialLevel == nil then
		return 0
	end

	local flResult = 0
	local CooldownUpgrades = hUpgrades[ szAbilityName ][ "cooldown" ]
	if CooldownUpgrades ~= nil then
		if self.bDirty == false and CooldownUpgrades[ "cached_result" ] ~= nil and CooldownUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_ADD ] ~= nil and CooldownUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_ADD ][ nSpecialLevel ] ~= nil then
			return CooldownUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_ADD ][ nSpecialLevel ]
		end

		for _,Upgrade in pairs ( CooldownUpgrades ) do
			if Upgrade[ "operator" ] == MINOR_ABILITY_UPGRADE_OP_ADD then
				flResult = flResult + Upgrade[ "value" ]
			end
		end

		self:EnsureCachedResult( CooldownUpgrades )
		CooldownUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_ADD ][ nSpecialLevel ] = flResult
		return flResult
	end
	return flResult
end

-----------------------------------------------------------------------

function modifier_minor_ability_upgrades:GetModifierPercentageCooldown( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end

	local hUpgrades = self:GetParent().MinorAbilityUpgrades
	if hUpgrades == nil then
		hUpgrades = CustomNetTables:GetTableValue( "minor_ability_upgrades", tostring( self:GetParent():GetPlayerOwnerID() ) )
	end

	local szAbilityName = params.ability:GetAbilityName() 
	local nSpecialLevel = params.ability_special_level
	if hUpgrades == nil or hUpgrades[ szAbilityName ] == nil or nSpecialLevel == nil then
		return 0
	end

	local flResult = 0.0
	local CooldownUpgrades = hUpgrades[ szAbilityName ][ "cooldown" ]
	if CooldownUpgrades ~= nil then
		if self.bDirty == false and CooldownUpgrades[ "cached_result" ] ~= nil and CooldownUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_MUL ] ~= nil and CooldownUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_MUL ][ nSpecialLevel ] ~= nil then
			return CooldownUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_MUL ][ nSpecialLevel ]
		end

		flResult = 1.0

		for _,Upgrade in pairs ( CooldownUpgrades ) do
			if Upgrade[ "operator" ] == MINOR_ABILITY_UPGRADE_OP_MUL then
				flResult = flResult * ( 1.0 - ( Upgrade[ "value" ] / 100.0 ) )
			end
		end

		flResult = ( 1.0 - flResult ) * 100

		--print( "cooldown result:" .. flResult )

		self:EnsureCachedResult( CooldownUpgrades )
		CooldownUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_MUL ][ nSpecialLevel ] = flResult
		self.bDirty = false
	end
	return flResult
end

-----------------------------------------------------------------------

function modifier_minor_ability_upgrades:GetModifierManacostReduction_Constant( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end

	local hUpgrades = self:GetParent().MinorAbilityUpgrades
	if hUpgrades == nil then
		hUpgrades = CustomNetTables:GetTableValue( "minor_ability_upgrades", tostring( self:GetParent():GetPlayerOwnerID() ) )
	end

	local szAbilityName = params.ability:GetAbilityName() 
	local nSpecialLevel = params.ability_special_level
	if hUpgrades == nil or hUpgrades[ szAbilityName ] == nil or nSpecialLevel == nil then
		return 0
	end

	local flResult = 0
	local ManaCostUpgrades = hUpgrades[ szAbilityName ][ "mana_cost" ]
	if ManaCostUpgrades ~= nil then
		if self.bDirty == false and ManaCostUpgrades[ "cached_result" ] ~= nil and ManaCostUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_ADD ] ~= nil and ManaCostUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_ADD ][ nSpecialLevel ] ~= nil then
			-- if IsServer() then
			-- 	print( "S: cached result for:" .. "mana_cost" .. " at " .. nSpecialLevel )
			-- 	PrintTable( ManaCostUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_ADD ], "SSS: " )
			-- else
			-- 	print( "C: cached result for:" .. "mana_cost" .. " at " .. nSpecialLevel )
			-- 	PrintTable( ManaCostUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_ADD ], "CCC: " )
			-- end
			--print( "CACHED VALUE for " .. szAbilityName .. ":" .. ManaCostUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_ADD ][ nSpecialLevel ] )
			return ManaCostUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_ADD ][ nSpecialLevel ]
		end

		for _,Upgrade in pairs ( ManaCostUpgrades ) do
			if Upgrade[ "operator" ] == MINOR_ABILITY_UPGRADE_OP_ADD then
				flResult = flResult + Upgrade[ "value" ]
			end
		end

		self:EnsureCachedResult( ManaCostUpgrades )
		ManaCostUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_ADD ][ nSpecialLevel ] = flResult

		self.bDirty = false
	end
	--print( "First run of func: " .. flResult )
	return flResult
end

-----------------------------------------------------------------------

function modifier_minor_ability_upgrades:GetModifierPercentageManacostStacking( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end

	local hUpgrades = self:GetParent().MinorAbilityUpgrades
	if hUpgrades == nil then
		hUpgrades = CustomNetTables:GetTableValue( "minor_ability_upgrades", tostring( self:GetParent():GetPlayerOwnerID() ) )
	end


	local szAbilityName = params.ability:GetAbilityName() 
	local nSpecialLevel = params.ability_special_level
	if hUpgrades == nil or hUpgrades[ szAbilityName ] == nil or nSpecialLevel == nil then
		return 0
	end

	if nSpecialLevel == nil then
		print( "** Missing special level for " .. szAbilityName )
		return 0
	end

	local flResult = 0
	local ManaCostUpgrades = hUpgrades[ szAbilityName ][ "mana_cost" ]
	if ManaCostUpgrades ~= nil then
		if self.bDirty == false and ManaCostUpgrades[ "cached_result" ] ~= nil and ManaCostUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_MUL ] ~= nil and ManaCostUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_MUL ][ nSpecialLevel ] ~= nil then
			return ManaCostUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_MUL ][ nSpecialLevel ]
		end

		flResult = 1.0

		for _,Upgrade in pairs ( ManaCostUpgrades ) do
			if Upgrade[ "operator" ] == MINOR_ABILITY_UPGRADE_OP_MUL then
				flResult = flResult * ( 1.0 - ( Upgrade[ "value" ] / 100.0 ) )
			end
		end

		flResult = ( 1.0 - flResult ) * 100
		--print( "mana cost result:" .. flResult )
		self:EnsureCachedResult( ManaCostUpgrades )
		ManaCostUpgrades[ "cached_result" ][ MINOR_ABILITY_UPGRADE_OP_MUL ][ nSpecialLevel ] = flResult
		self.bDirty = false
	end
	return flResult
end