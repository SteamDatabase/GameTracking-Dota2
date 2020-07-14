
modifier_tidehunter_damage_counter = class({})

-----------------------------------------------------------------------------------------

function modifier_tidehunter_damage_counter:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_tidehunter_damage_counter:OnCreated( kv )
	if IsServer() then

		self.damage_threshold = self:GetAbility():GetSpecialValueFor( "damage_threshold" )
		self.damage_counter_tiers = self:GetAbility():GetSpecialValueFor( "damage_counter_tiers" )
		self.time_before_reduction = self:GetAbility():GetSpecialValueFor( "time_before_reduction" )

		self.nRecentDamageTaken = kv.damage or 0
		self.nOverheadParticleTier = 0
		self.nDamagePerTier = self.damage_threshold / self.damage_counter_tiers
		self.fLastDamageTakenTime = GameRules:GetGameTime()
		self.fLastReductionTime = GameRules:GetGameTime()

		-- Created overhead particle
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
		
		local nTier = math.floor( self.nRecentDamageTaken / self.nDamagePerTier )
		if nTier > self.nOverheadParticleTier then
			self:IncrementOverheadParticle( nTier )
		end

		self:StartIntervalThink( 0.1 )

	end
end

-----------------------------------------------------------------------------------------

function modifier_tidehunter_damage_counter:OnIntervalThink()
	if IsServer() then
		-- if it's been at least 2s since the last time I took damage, then reduce my ragebar tier by 1
		if GameRules:GetGameTime() >= self.fLastDamageTakenTime + self.time_before_reduction then
			if GameRules:GetGameTime() >= self.fLastReductionTime + self.time_before_reduction then
				--printf( "It's been at least %.2f secs since the last time I took damage", self.time_before_reduction )
				self.nRecentDamageTaken = self.nRecentDamageTaken - self.nDamagePerTier
				local nTier = math.floor( self.nRecentDamageTaken / self.nDamagePerTier )
				--printf( "  self.nRecentDamageTaken: %d, self.nDamagePerTier: %d, nTier: %d", self.nRecentDamageTaken, self.nDamagePerTier, nTier )

				if nTier < self.nOverheadParticleTier then
					--printf( "  Reduce ragebar -- DecrementOverheadParticle" )
					self:DecrementOverheadParticle( nTier )
				end

				self.fLastReductionTime = GameRules:GetGameTime()
			end
		end
	end
end

-----------------------------------------------------------------------------------------

function modifier_tidehunter_damage_counter:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_tidehunter_damage_counter:OnTakeDamage( params )
	if IsServer() then
		local hAttacker = params.attacker
		local hVictim = params.unit
		local hEntity = self:GetParent()
		local hRavage = hEntity:FindAbilityByName( "tidehunter_ravage" )
		if hAttacker ~= nil and hVictim ~= nil and hVictim == self:GetParent() then
			self.fLastDamageTakenTime = GameRules:GetGameTime()
			--printf( "OnTakeDamage - hVictim is: %s", hVictim:GetUnitName() )
			self.nRecentDamageTaken = self.nRecentDamageTaken + params.damage

			local nTier = math.floor( self.nRecentDamageTaken / self.nDamagePerTier )

			if nTier > self.nOverheadParticleTier then
				self:IncrementOverheadParticle( nTier )
			end

			if self.nRecentDamageTaken >= self.damage_threshold then
				
				self:GetParent():Purge( false, true, false, true, false )
				ParticleManager:CreateParticle( "particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
				EmitSoundOn( "Hero_Tidehunter.KrakenShell", self:GetParent() )

				self:GetParent():Interrupt()

				if not ( hVictim:IsSilenced() or hVictim:IsStunned() or hVictim:IsHexed() or hVictim:IsFrozen() ) then
					ExecuteOrderFromTable({
					    UnitIndex = hVictim:entindex(),
					    OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					    AbilityIndex = hRavage:entindex(),
					    Queue = false,
					})
					self:Destroy()
				end
			else
				self:ForceRefresh()
			end
		end
	end

	return 0
end

-----------------------------------------------------------------------------------------

function modifier_tidehunter_damage_counter:IncrementOverheadParticle( nTier )
	local nTiersSinceLastUpdate = nTier - self.nOverheadParticleTier

	for i = 1, nTiersSinceLastUpdate do
		ParticleManager:SetParticleControl( self.nFXIndex, self.nOverheadParticleTier + i, Vector( 1, 0, 0 ) )
	end

	self.nOverheadParticleTier = nTier
end

-----------------------------------------------------------------------------------------

function modifier_tidehunter_damage_counter:DecrementOverheadParticle( nTier )
	if self.nOverheadParticleTier - 1 > 0 then
		ParticleManager:SetParticleControl( self.nFXIndex, self.nOverheadParticleTier, Vector( 0, 0, 0 ) )
		--printf( "DecrementOverheadParticle - self.nOverheadParticleTier: %d", self.nOverheadParticleTier )
		self.nOverheadParticleTier = nTier
	else
		self:Destroy()
	end
end
