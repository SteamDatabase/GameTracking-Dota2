require( "ai/boss_base" )

--------------------------------------------------------------------------------

if CBossAmoeba == nil then
	CBossAmoeba = class( {}, {}, CBossBase )
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		--print( 'AMOEBA SPAWNING! name = ' .. thisEntity:GetUnitName() )
		thisEntity.AI = CBossAmoeba( thisEntity, 1.0 )
	end
end

--------------------------------------------------------------------------------

function CBossAmoeba:constructor( hUnit, flInterval )
	CBossBase.constructor( self, hUnit, flInterval )

	self.me:SetThink( "OnBossAmoebaThink", self, "OnBossAmoebaThink", self.flDefaultInterval )
end

--------------------------------------------------------------------------------

function CBossAmoeba:SetupAbilitiesAndItems()
	CBossBase.SetupAbilitiesAndItems( self )

	self.hBlobSuck = self.me:FindAbilityByName( "amoeba_blob_suck_boss" )
	if self.hBlobSuck == nil then
		self.hBlobSuck = self.me:FindAbilityByName( "amoeba_blob_suck_large" )
	end
	if self.hBlobSuck == nil then
		self.hBlobSuck = self.me:FindAbilityByName( "amoeba_blob_suck_medium" )
	end
	if self.hBlobSuck == nil then
		self.hBlobSuck = self.me:FindAbilityByName( "amoeba_blob_suck_small" )
	end
	if self.hBlobSuck ~= nil then
		self.hBlobSuck.Evaluate = self.EvaluateBlobSuck
		self.AbilityPriority[ self.hBlobSuck:GetAbilityName() ] = 1
	else
		print( 'ERROR: missing BLOB SUCK ability!' )
	end

	self.hBlobLaunch = self.me:FindAbilityByName( "amoeba_blob_launch_boss" )
	if self.hBlobLaunch == nil then
		self.hBlobLaunch = self.me:FindAbilityByName( "amoeba_blob_launch_large" )
	end
	if self.hBlobLaunch == nil then
		self.hBlobLaunch = self.me:FindAbilityByName( "amoeba_blob_launch_medium" )
	end
	if self.hBlobLaunch == nil then
		self.hBlobLaunch = self.me:FindAbilityByName( "amoeba_blob_launch_small" )
	end
	if self.hBlobLaunch ~= nil then
		self.hBlobLaunch.Evaluate = self.EvaluateBlobLaunch
		self.AbilityPriority[ self.hBlobLaunch:GetAbilityName() ] = 4
	else
		print( 'ERROR: missing BLOB LAUNCH ability!' )
	end

	if self.hBlobLaunch ~= nil then
		RandomizeAbilityCooldown( self.hBlobLaunch )
	end


	self.hBlobJumpSplatter = self.me:FindAbilityByName( "amoeba_boss_jump_splatter_boss" )
	if self.hBlobJumpSplatter == nil then
		self.hBlobJumpSplatter = self.me:FindAbilityByName( "amoeba_boss_jump_splatter_large" )
	end
	if self.hBlobJumpSplatter == nil then
		self.hBlobJumpSplatter = self.me:FindAbilityByName( "amoeba_boss_jump_splatter_medium" )
	end
	if self.hBlobJumpSplatter == nil then
		self.hBlobJumpSplatter = self.me:FindAbilityByName( "amoeba_boss_jump_splatter_small" )
	end
	if self.hBlobJumpSplatter == nil then
		self.hBlobJumpSplatter = self.me:FindAbilityByName( "amoeba_boss_jump_splatter_baby" )
	end
	if self.hBlobJumpSplatter ~= nil then
		self.hBlobJumpSplatter.Evaluate = self.EvaluateBlobJumpSplatter
		self.AbilityPriority[ self.hBlobJumpSplatter:GetAbilityName() ] = 4
	else
		print( 'ERROR: missing BLOB SPLATTER ability!' )
	end

	if self.hBlobJumpSplatter ~= nil then
		RandomizeAbilityCooldown( self.hBlobJumpSplatter )
	end
end

--------------------------------------------------------------------------------
 
function CBossAmoeba:OnBossAmoebaThink()
	return self:OnBaseThink()
end

--------------------------------------------------------------------------------

function CBossAmoeba:OnFirstSeen()
	CBossBase.OnFirstSeen( self )
end

--------------------------------------------------------------------------------

function CBossAmoeba:OnHealthPercentThreshold( nPct )
	CBossBase.OnHealthPercentThreshold( self, nPct )
end

--------------------------------------------------------------------------------

function CBossAmoeba:EvaluateBlobSuck()
	local hDeathExplosionBuff = self.me:FindModifierByName( "modifier_amoeba_boss_death_explosion" )
	if hDeathExplosionBuff ~= nil then
		print( "SKIPPING AMOEBA SUCK ABILITY SINCE WE'RE DYING" )
		return nil
	end

	local Order = nil
	print( '^^^CBossAmoeba:EvaluateBlobSuck()' )
	if self.Encounter ~= nil and self.Encounter:CanAmoebaCastBlobSuck( self.me ) == true then
		print( 'READY TO CAST BLOB SUCK!' )
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hBlobSuck:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = self.hBlobSuck:GetChannelTime()
	end

	return Order
end

--------------------------------------------------------------------------------

function CBossAmoeba:EvaluateBlobLaunch()
	local hDeathExplosionBuff = self.me:FindModifierByName( "modifier_amoeba_boss_death_explosion" )
	if hDeathExplosionBuff ~= nil then
		print( "SKIPPING AMOEBA BLOB LAUNCH ABILITY SINCE WE'RE DYING" )
		return nil
	end

	--print( '^^^CBossAmoeba:EvaluateBlobLaunch()' )
	local hTarget = GetBestUnitTarget( self.hBlobLaunch )

	local Order = nil
	if hTarget ~= nil then
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = hTarget:GetOrigin(),
			AbilityIndex = self.hBlobLaunch:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hBlobLaunch )
		--print( 'Found a target for Blob Launch! sleeping for ' .. Order.flOrderInterval )
	else
		--print( 'No target found for Blob Launch!' )
	end

	return Order
end

--------------------------------------------------------------------------------

function CBossAmoeba:EvaluateBlobJumpSplatter()
	local hDeathExplosionBuff = self.me:FindModifierByName( "modifier_amoeba_boss_death_explosion" )
	if hDeathExplosionBuff ~= nil then
		print( "SKIPPING AMOEBA JUMP ABILITY SINCE WE'RE DYING" )
		return nil
	end

	--print( '^^^CBossAmoeba:EvaluateBlobJumpSplatter()' )
	local hTarget = GetBestUnitTarget( self.hBlobJumpSplatter )

	local Order = nil
	if hTarget ~= nil then
		
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = hTarget:GetOrigin(),
			AbilityIndex = self.hBlobJumpSplatter:entindex(),
			Queue = false,
		}
		--Order.flOrderInterval = GetSpellCastTime( self.hBlobJumpSplatter )
		Order.flOrderInterval = 1.5
		--print( 'Found a target for Jump Splatter! sleeping for ' .. Order.flOrderInterval )
	else
		--print( 'No target found for Jump Splatter!' )
	end

	return Order
end

