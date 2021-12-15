
modifier_boss_arc_warden_damage_counter = class({})

-----------------------------------------------------------------------------------------

function modifier_boss_arc_warden_damage_counter:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_boss_arc_warden_damage_counter:OnCreated( kv )
	if IsServer() then

		self.damage_threshold = kv.damage_threshold
		self.damage_counter_tiers = kv.damage_counter_tiers

		self.nDamageTaken = 0
		self.nOverheadParticleTier = 0
		self.nDamagePerTier = self.damage_threshold / self.damage_counter_tiers
		self.fLastReductionTime = GameRules:GetGameTime()

		-- Created overhead particle
		--[[
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
		
		local nTier = math.floor( self.nDamageTaken / self.nDamagePerTier )
		if nTier > self.nOverheadParticleTier then
			self:IncrementOverheadParticle( nTier )
		end
		]]--

		self:StartIntervalThink( 0.1 )

	end
end

-----------------------------------------------------------------------------------------

function modifier_boss_arc_warden_damage_counter:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_boss_arc_warden_damage_counter:OnTakeDamage( params )
	if IsServer() then
		local hAttacker = params.attacker
		local hVictim = params.unit
		if hAttacker ~= nil and hVictim ~= nil then
			if hVictim == self:GetParent() then
				--printf( "OnTakeDamage - hVictim is: %s", hVictim:GetUnitName() )
				self.nDamageTaken = self.nDamageTaken + params.damage

				local nTier = math.floor( self.nDamageTaken / self.nDamagePerTier )

				--[[
				if nTier > self.nOverheadParticleTier then
					self:IncrementOverheadParticle( nTier )
				end
				]]--

				if self.nDamageTaken >= self.damage_threshold then
					self:GetParent():InterruptChannel()
					self:Destroy()
				else
					self:ForceRefresh()
				end

				-- kill zombies that hit us during this phase
				if hAttacker:IsZombie() then
					hAttacker:ForceKill( false )
				end
			end
		end
	end

	return 0
end

-----------------------------------------------------------------------------------------

function modifier_boss_arc_warden_damage_counter:IncrementOverheadParticle( nTier )
	--[[
	local nTiersSinceLastUpdate = nTier - self.nOverheadParticleTier

	for i = 1, nTiersSinceLastUpdate do
		ParticleManager:SetParticleControl( self.nFXIndex, self.nOverheadParticleTier + i, Vector( 1, 0, 0 ) )
	end

	self.nOverheadParticleTier = nTier
	]]--
end
