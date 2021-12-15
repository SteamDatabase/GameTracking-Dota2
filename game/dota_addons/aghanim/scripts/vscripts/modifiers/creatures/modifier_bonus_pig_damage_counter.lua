
modifier_bonus_pig_damage_counter = class({})

-----------------------------------------------------------------------------------------

function modifier_bonus_pig_damage_counter:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_bonus_pig_damage_counter:OnCreated( kv )
	if IsServer() then
		local flTickRate = 0.1

		-- Gold
		self:GetParent().nBagsDropped = 0
		self.total_gold = self:GetAbility():GetSpecialValueFor( "total_gold" )
		self.time_limit = self:GetAbility():GetSpecialValueFor( "time_limit" )
		self.gold_bag_duration = self:GetAbility():GetSpecialValueFor( "gold_bag_duration" )

		-- Damage
		self.flAccumDamage = 0
		self.damage_threshold_pct_of_max = self:GetAbility():GetSpecialValueFor( "damage_threshold_pct_of_max" )
		self.damage_counter_tiers = self:GetAbility():GetSpecialValueFor( "damage_counter_tiers" )
		self.time_before_reduction = self:GetAbility():GetSpecialValueFor( "time_before_reduction" )

		self.nRecentDamageTaken = kv.damage or 0
		self.nOverheadParticleTier = 0
		self.nDamageThreshold = self:GetParent():GetMaxHealth() * ( self.damage_threshold_pct_of_max / 100 )
		self.nDamagePerTier = self.nDamageThreshold / self.damage_counter_tiers
		self.fLastDamageTakenTime = GameRules:GetGameTime()

		-- Calculate reduction. Desire is that it will take the pig (time_before_reduction) seconds
		-- to go from its max level of damage to no longer at the damage threshold.
		-- and then it will reduce one threshold per (time_before_reduction).
		self.nReductionPerTick = self.nDamagePerTier / self.time_before_reduction * flTickRate
		self.nRecentDamageCap = self.nDamageThreshold + self.nDamagePerTier - 1 -- because we floor, later, so keep this one less than an extra tier

		printf( "self.nDamageThreshold: %d; self.nDamagePerTier: %d, cap %d, reduction %d", self.nDamageThreshold, self.nDamagePerTier, self.nRecentDamageCap, self.nReductionPerTick )

		local nInitialTier = 0
		self:IncrementOverheadParticle( nInitialTier )

		-- Gold Time
		self.flExpireTime = GameRules:GetGameTime() + self.time_limit

		self:StartIntervalThink( flTickRate )
	end
end

-----------------------------------------------------------------------------------------

function modifier_bonus_pig_damage_counter:OnIntervalThink()
	if IsServer() then
		-- If some time has passed since I took damage, then reduce my ragebar tier by 1
		if GameRules:GetGameTime() >= self.fLastDamageTakenTime + self.time_before_reduction then
			--printf( "It's been at least %.2f secs since the last time I took damage", self.time_before_reduction )
			self.nRecentDamageTaken = math.max( 0, self.nRecentDamageTaken - self.nReductionPerTick )
			local nTier = math.floor( self.nRecentDamageTaken / self.nDamagePerTier )
			--printf( "  self.nRecentDamageTaken: %d, self.nDamagePerTier: %d, nTier: %d", self.nRecentDamageTaken, self.nDamagePerTier, nTier )

			if nTier < self.nOverheadParticleTier then
				--printf( "  Reduce ragebar -- DecrementOverheadParticle" )
				self:DecrementOverheadParticle( nTier )
				-- Reduce model scale
				local hBonusPig = self:GetParent()
				local flScale = hBonusPig:GetModelScale()
				if flScale > 1.5 then
					hBonusPig:SetModelScale( math.max( 1.5, flScale - 0.2 ) )
				end
			end
		end
	end
end

-----------------------------------------------------------------------------------------

function modifier_bonus_pig_damage_counter:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_bonus_pig_damage_counter:OnTakeDamage( params )
	if IsServer() then
		local hAttacker = params.attacker
		local hVictim = params.unit
		if hAttacker ~= nil and hVictim ~= nil and hVictim == self:GetParent() then
			local hBonusPig = hVictim

			self.fLastDamageTakenTime = GameRules:GetGameTime()
			self.nRecentDamageTaken = math.floor( math.min( self.nRecentDamageCap, self.nRecentDamageTaken + params.damage ) )
			printf( "OnTakeDamage - hVictim is: %s, recent damage %d from add damage %f", hVictim:GetUnitName(), self.nRecentDamageTaken, params.damage )

			local nTier = math.floor( self.nRecentDamageTaken / self.nDamagePerTier )

			if nTier > self.nOverheadParticleTier then
				self:IncrementOverheadParticle( nTier )
				-- Increase model scale
				local flScale = hBonusPig:GetModelScale()
				if flScale < 2.7 then
					hBonusPig:SetModelScale( math.min( 2.7, flScale + 0.2 ) )
				end
			end

			if self.nRecentDamageTaken >= self.nDamageThreshold and params.damage > 0 then
				--self:GetParent():ForceKill( false )
				--self:Destroy()
				local newItem = CreateItem( "item_bag_of_gold", nil, nil )
				local nGoldAmount = 25
				local nAdjustedAmount = math.ceil( nGoldAmount * GameRules.Aghanim:GetGoldModifier() / 100 )
				newItem:SetPurchaseTime( 0 )
				newItem:SetCurrentCharges( nAdjustedAmount )
						
				local drop = CreateItemOnPositionSync( hVictim:GetAbsOrigin(), newItem )
				local dropTarget = FindPathablePositionNearby( hVictim:GetAbsOrigin(), 50, 250 )
				newItem:LaunchLoot( true, 300, 0.75, dropTarget )
				newItem:SetLifeTime( self.gold_bag_duration )

					
					
				self.flAccumDamage = self.flAccumDamage + params.damage
				self.flAccumDamage = self.flAccumDamage - 100
				self:GetParent().nBagsDropped = self:GetParent().nBagsDropped + 1
				self.total_gold = self.total_gold - 20
				if self.total_gold <= 0 then
					--self:TeleportOut()
					self:GetParent():ForceKill( false )
					self:Destroy()
				end
			end
		end
	end

	return 0
end

function modifier_bonus_pig_damage_counter:CheckParticle()
	if self.nFXIndex == nil then
		-- Create overhead particle
		local vPos = Vector( 0, 0, 0 )
		self.nFXIndex = ParticleManager:CreateParticle( "particles/creatures/lifestealer/lifestealer_damage_counter_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, vPos )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, vPos )
		ParticleManager:SetParticleControl( self.nFXIndex, 2, vPos )
		ParticleManager:SetParticleControl( self.nFXIndex, 3, vPos )
		ParticleManager:SetParticleControl( self.nFXIndex, 4, vPos )
		ParticleManager:SetParticleControl( self.nFXIndex, 5, vPos )
		ParticleManager:SetParticleControl( self.nFXIndex, 6, vPos )
		ParticleManager:SetParticleControl( self.nFXIndex, 7, vPos )
		ParticleManager:SetParticleControl( self.nFXIndex, 8, Vector( 1, 0, 0 ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 9, Vector( 2, 0, 0 ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 10, Vector( 3, 0, 0 ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 11, Vector( 4, 0, 0 ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 12, Vector( 5, 0, 0 ) )
		self:AddParticle( self.nFXIndex, false, false, -1, false, true )
	end
end

-----------------------------------------------------------------------------------------

function modifier_bonus_pig_damage_counter:IncrementOverheadParticle( nTier )
	nTier = math.min( 6, nTier )
	local nTiersSinceLastUpdate = nTier - self.nOverheadParticleTier
	if nTiersSinceLastUpdate == 0 then
		return
	end

	self:CheckParticle()

	for i = 1, nTiersSinceLastUpdate do
		ParticleManager:SetParticleControl( self.nFXIndex, self.nOverheadParticleTier + i, Vector( 1, 0, 0 ) )
	end

	self.nOverheadParticleTier = nTier
end

-----------------------------------------------------------------------------------------

function modifier_bonus_pig_damage_counter:DecrementOverheadParticle( nTier )
	if nTier > 0 then
		if nTier < self.nOverheadParticleTier then
			self:CheckParticle()

			for i = nTier + 1, self.nOverheadParticleTier do
				ParticleManager:SetParticleControl( self.nFXIndex, i, Vector( 0, 0, 0 ) )
			end
		end
	else
		if self.nFXIndex ~= nil then
			ParticleManager:DestroyParticle( self.nFXIndex, false )
			self.nFXIndex = nil
		end
	end

	self.nOverheadParticleTier = math.max( 0, nTier )
end