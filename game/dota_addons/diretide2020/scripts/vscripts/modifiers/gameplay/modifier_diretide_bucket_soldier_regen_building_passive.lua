if modifier_diretide_bucket_soldier_regen_building_passive == nil then
modifier_diretide_bucket_soldier_regen_building_passive = class({})
end

------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_regen_building_passive:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_regen_building_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_regen_building_passive:OnCreated( kv )
	if IsServer() == true then
		self:StartIntervalThink( 1 )
		self.hModifier = nil
		self.tSoldiersHitTimes = {}
	end
end

-----------------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_regen_building_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_regen_building_passive:OnTakeDamage( params )
	if IsServer() == false then
		return
	end

	if self.hModifier == nil then
		--printf( "OnTakeDamage - self.hModifier is nil, returning early" )
		return
	end

	if params.unit ~= nil and params.unit:IsNull() == false and params.unit:IsAlive() then
		--printf( "OnTakeDamage - params.unit \"%s\" isn't nil or null or dead", params.unit:GetUnitName() )
		--printf( "#self.hModifier.tSoldiers: %d", #self.hModifier.tSoldiers )
		for k,Soldier in pairs( self.hModifier.tSoldiers ) do
			--printf( "OnTakeDamage - iterating over soldiers in table" )
			if params.unit == Soldier then
				self.tSoldiersHitTimes[ Soldier ] = GameRules:GetDOTATime( false, true )
				--[[
				printf( "------------------------------" )
				printf( "self.tSoldiersHitTimes table: " )
  				PrintTable( self.tSoldiersHitTimes, " -- " )
  				]]
			end
		end
	end

	return 0.0
end

-----------------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_regen_building_passive:OnIntervalThink()
	if IsServer() == false then
		return
	end

	if self.hModifier == nil then
		self.hModifier = self:GetParent():FindModifierByName( "modifier_candy_bucket_soldiers" )
	end
	if self.hModifier == nil then
		return
	end

	for k,Soldier in pairs( self.hModifier.tSoldiers ) do
		--printf( "OnIntervalThink() - iterating over soldiers" )
		if ( self:GetParent():GetOrigin() - Soldier:GetOrigin() ):Length2D() <= self:GetAbility():GetCastRange( self:GetParent():GetOrigin(), Soldier ) then
			--printf( "  soldier is close enough to get healed" )
			if self.tSoldiersHitTimes[ Soldier ] == nil then
				self.tSoldiersHitTimes[ Soldier ] = -1000
				--printf( "  \"self.tSoldiersHitTimes[ Soldier ]\" was nil, so set it to %.1f", self.tSoldiersHitTimes[ Soldier ] )
			else
				--printf( "  \"self.tSoldiersHitTimes[ Soldier ]\" was not nil, and is: %.1f", self.tSoldiersHitTimes[ Soldier ] )
			end

			local flLastHitTime = self.tSoldiersHitTimes[ Soldier ]
			--printf( "  flLastHitTime: %.2f", flLastHitTime )
			if flLastHitTime + self:GetAbility():GetLevelSpecialValueFor( "peace_time", 5.0 ) <= GameRules:GetDOTATime( false, true ) then
				local nHealAmount = math.floor( Soldier:GetMaxHealth() * self:GetAbility():GetLevelSpecialValueFor( "regen_pct_per_second", 5 ) / 100.0 )
				Soldier:Heal( nHealAmount, self:GetParent() )

				--[[
				local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/fish_bones_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, Soldier )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
				]]

				--printf( "  soldier pos: %s", Soldier:GetAbsOrigin() )
				--printf( "    soldier max health: %d", Soldier:GetMaxHealth() )
				--printf( "    healed %s for %d", Soldier:GetUnitName(), nHealAmount )
			end
		end
	end
end
