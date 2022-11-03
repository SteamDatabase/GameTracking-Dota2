if modifier_creature_buff_dynamic == nil then
modifier_creature_buff_dynamic = class({})
end

------------------------------------------------------------------------------

function modifier_creature_buff_dynamic:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_creature_buff_dynamic:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_creature_buff_dynamic:OnCreated( kv )
	self:OnRefresh( kv )
	if IsServer() then
		self:StartIntervalThink( 2.0 )
	end
end

--------------------------------------------------------------------------------

function modifier_creature_buff_dynamic:OnRefresh( kv )
	self.flARMOR_BONUS = 0
	self.nSTATUS_RESIST_BASE = 0
	self.nSTATUS_RESIST_BONUS = 0
	self.flMODEL_SCALE = 0
	self.flAverageDamage = 0
	self.nBUCKET_COUNT = 0

	if IsServer() then
		self.flARMOR_BONUS = _G.WINTER2022_BUCKET_SOLDIERS_ROUND_ARMOR_BONUS
		self.nSTATUS_RESIST_BASE = _G.WINTER2022_BUCKET_SOLDIERS_ROUND_STATUS_RESIST_BASE
		self.nSTATUS_RESIST_BONUS = _G.WINTER2022_BUCKET_SOLDIERS_ROUND_STATUS_RESIST_BONUS
		self.flMODEL_SCALE = _G.WINTER2022_BUCKET_SOLDIERS_HOME_BUCKET_MODEL_SCALE_MULTIPLIER
		self.nBUCKET_COUNT = _G.WINTER2022_BUCKET_COUNT
		self.flAverageDamage = ( self:GetParent():GetBaseDamageMin() + self:GetParent():GetBaseDamageMax() ) / 2 
	else
		local serverConstants = CustomNetTables:GetTableValue( "globals", "constants" )
		self.flPREGAME_TIME = 0
		if serverConstants ~= nil then
			self.flPREGAME_TIME = serverConstants[ "WINTER2022_PREGAME_TIME" ]
			self.flARMOR_BONUS = serverConstants[ "WINTER2022_BUCKET_SOLDIERS_ROUND_ARMOR_BONUS" ]
			self.nSTATUS_RESIST_BASE = serverConstants[ "WINTER2022_BUCKET_SOLDIERS_ROUND_STATUS_RESIST_BASE" ]
			self.nSTATUS_RESIST_BONUS = serverConstants[ "WINTER2022_BUCKET_SOLDIERS_ROUND_STATUS_RESIST_BONUS" ]
			self.flMODEL_SCALE = serverConstants[ "WINTER2022_BUCKET_SOLDIERS_HOME_BUCKET_MODEL_SCALE_MULTIPLIER" ]
			self.nBUCKET_COUNT = serverConstants[ "WINTER2022_BUCKET_COUNT" ]
		end
		self.flAverageDamage = ( self:GetParent():GetDamageMin() + self:GetParent():GetDamageMax() ) / 2 
	end

end

--------------------------------------------------------------------------------

function modifier_creature_buff_dynamic:OnIntervalThink()
	if IsServer() == false then
		return
	end
	self:GetParent():CalculateGenericBonuses()

	local nDisableResist = self.nSTATUS_RESIST_BASE + self.nSTATUS_RESIST_BONUS * self:GetBaseBuffLevel()
	self:GetParent():SetDisableResistance(nDisableResist)
	self:GetParent():SetUltimateDisableResistance(nDisableResist)
end

--------------------------------------------------------------------------------

function modifier_creature_buff_dynamic:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_creature_buff_dynamic:GetNumBucketsRemaining( bEnemyTeam )
	if bEnemyTeam == nil then bEnemyTeam = false end

	local nNumBucketsRemaining = self.nBUCKET_COUNT
	local nTeamNumber = self:GetParent():GetTeamNumber()
	if bEnemyTeam then nTeamNumber = FlipTeamNumber(nTeamNumber) end

	if IsServer() then
		nNumBucketsRemaining = GameRules.Winter2022:GetRemainingCandyBuckets( nTeamNumber )
	else
		local serverValues = CustomNetTables:GetTableValue( "globals", "values" )
		if serverValues ~= nil then
			if nTeamNumber == DOTA_TEAM_GOODGUYS then
				nNumBucketsRemaining = serverValues[ "NumBucketsRadiant" ]
			elseif nTeamNumber == DOTA_TEAM_BADGUYS then
				nNumBucketsRemaining = serverValues[ "NumBucketsDire" ]
			end
		end
	end

	return nNumBucketsRemaining
end

--------------------------------------------------------------------------------

function modifier_creature_buff_dynamic:GetModifierExtraHealthPercentage( params )
	return math.floor( self:GetBuffLevel() * 100 )
end

--------------------------------------------------------------------------------

function modifier_creature_buff_dynamic:GetModifierPhysicalArmorBonus( params )
	local nBase = self:GetBaseBuffLevel()
	return math.floor( self.flARMOR_BONUS * nBase )
end

--------------------------------------------------------------------------------

function modifier_creature_buff_dynamic:GetModifierModelScale( params )
	return 1.0 + self.flMODEL_SCALE * self:GetBaseBuffLevel()
end

--------------------------------------------------------------------------------

function modifier_creature_buff_dynamic:GetModifierPreAttack_BonusDamage( params )
	local nBonus = math.floor( self.flAverageDamage * self:GetBuffLevel() )
	--print( ( ( IsServer() and "Server: " ) or "Client: " ) .. nBonus .. " with avdmg " .. self.flAverageDamage .. " at level " .. self:GetBuffLevel() )
	return nBonus
end

--------------------------------------------------------------------------------

function modifier_creature_buff_dynamic:GetBaseBuffLevel()
	local nRemainingBuckets = self:GetNumBucketsRemaining()
	local nEnemyRemainingBuckets = self:GetNumBucketsRemaining(true)
	local nBuffLevel = ( self.nBUCKET_COUNT - nRemainingBuckets + math.max( 0, nEnemyRemainingBuckets - nRemainingBuckets ) )
	if self:GetStackCount() > 1 then
		nBuffLevel = nBuffLevel + 1
	end
	return nBuffLevel
end

--------------------------------------------------------------------------------

function modifier_creature_buff_dynamic:GetBuffLevel()
	local nBase = self:GetBaseBuffLevel()
	return math.max( 0, nBase + nBase * nBase * 0.1 )
end
