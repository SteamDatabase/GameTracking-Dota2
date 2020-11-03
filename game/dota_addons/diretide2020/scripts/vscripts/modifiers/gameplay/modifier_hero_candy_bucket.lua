
if modifier_hero_candy_bucket == nil then
	modifier_hero_candy_bucket = class({})
end

------------------------------------------------------------------------------

function modifier_hero_candy_bucket:IsHidden() 
	local bHidden = ( self:GetAbility():GetCandy() <= 0 )

	return bHidden
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:GetTexture()
	return "candy_carry_debuff"
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:OnCreated( kv )
	self.max_hp_penalty_per_charge = self:GetAbility():GetSpecialValueFor( "max_hp_penalty_per_charge" )
	self.model_scale_penalty_per_charge = self:GetAbility():GetSpecialValueFor( "model_scale_penalty_per_charge" )
	self.model_scale_penalty_max = self:GetAbility():GetSpecialValueFor( "model_scale_penalty_max" )
	self.nPrevCount = self:GetAbility():GetCandy()

	if IsServer() == true then
		self.fStatCalcInterval = 0.2
		self.nHealthLost = 0
		self.nCurCandy = 0
	else
		self.nParticleFX = -1
	end

	local fInterval = 0.01
	self:StartIntervalThink( fInterval )
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:OnRefresh( kv )
	if self.max_hp_penalty_per_charge == nil then
		self.max_hp_penalty_per_charge = self:GetAbility():GetSpecialValueFor( "max_hp_penalty_per_charge" )
		self.model_scale_penalty_per_charge = self:GetAbility():GetSpecialValueFor( "model_scale_penalty_per_charge" )
		self.model_scale_penalty_max = self:GetAbility():GetSpecialValueFor( "model_scale_penalty_max" )
	end

	if self.nPrevCount == nil then
		self.nPrevCount = self:GetAbility():GetCandy()
	end

	if IsServer() == true then
		self.fStatCalcInterval = 0.2
	else
		if self.nParticleFX == nil then
			self.nParticleFX = -1
		end
	end

	local fInterval = 0.01
	self:StartIntervalThink( fInterval )
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() and params.unit:IsReincarnating() == false then
			self:DropCandy( params.attacker )
			self.nHealthLost = 0
		end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:GetModifierExtraHealthPercentage( params )
	local nCandy = 0
	if IsServer() == true and self.nCurCandy ~= nil then
		nCandy = self.nCurCandy
	else
		nCandy = self:GetAbility():GetCandy()
	end
	-- we use the stored candy value so we have control over when maxhealth changes.
	local nReduction = ( -self.max_hp_penalty_per_charge * nCandy )
	if nReduction < -90 then
		nReduction = -90
	end
	--printf( "self.max_hp_penalty_per_charge: %d, current charges: %d, nReduction: %d", self.max_hp_penalty_per_charge, self:GetAbility():GetCurrentCharges(), nReduction )

	return nReduction
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:OnIntervalThink()
	--printf( "OnIntervalThink; self:GetAbility():GetCurrentCharges(): %d", self:GetAbility():GetCurrentCharges() )
	local nCandy = (self:GetAbility() ~= nil and self:GetAbility():GetCandy() ) or 0
	if IsServer() == true then
		if self.fNextStatCalcTime == nil or self.fNextStatCalcTime <= GameRules:GetDOTATime( false, true ) then
			-- This is crap, doing it because GetModifierExtraHealthPercentage isn't being called at the right times
			-- Note that our call for that will be constant until *this* value changes, which means
			-- we have control over when the maxhealth changes from candy.
			self.nCurCandy = nCandy

			local nOldHealth = self:GetParent():GetHealth()
			local nOldMax = self:GetParent():GetMaxHealth()

			self:GetParent():CalculateStatBonus()

			local nNewHealth = self:GetParent():GetHealth()
			local nNewMax = self:GetParent():GetMaxHealth()
			-- something later actually does the clamping? So we have to clamp here.
			nNewHealth = math.min( nNewHealth, nNewMax )

			if nNewHealth < nOldHealth then
				-- they're all ints, but let's be safe because why not.
				self.nHealthLost = self.nHealthLost + math.floor( nOldHealth - nNewHealth )
				--printf("Lost health! Old health %d, new health %d, delta %d so total lost now %d", nOldHealth, nNewHealth, nOldHealth - nNewHealth, self.nHealthLost)
			elseif self.nHealthLost > 0 and nNewMax > nOldMax then
				local nHeal = math.min( self.nHealthLost, math.min( nNewMax - nNewHealth, nNewMax - nOldMax ) )
				--printf("Healing back up. Total health lost %d, clamped heal %d (health %d, max %d) so new desired %d", self.nHealthLost, nHeal, nNewHealth, nNewMax, nNewHealth + nHeal)
				self:GetParent():ModifyHealth( nNewHealth + nHeal, nil, false, 0 )
				self.nHealthLost = self.nHealthLost - nHeal
			end

			self.fNextStatCalcTime = GameRules:GetDOTATime( false, true ) + self.fStatCalcInterval
			self.nPrevCount = nCandy
		end
	else
		if nCandy == 0 then
			if self.nParticleFX ~= -1 then
				ParticleManager:DestroyParticle( self.nParticleFX, true )
				self.nParticleFX = -1
			end
		else
			local nStack = math.mod( nCandy, 10 )
			local nTensStack = math.floor( nCandy / 10 ) 
			if self.nParticleFX == -1 then
				self.nParticleFX = ParticleManager:CreateParticle( "particles/hw_fx/candy_carrying_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
				--printf( "candy count: %d; created overhead particle", nCandy )
				--self:AddParticle( self.nParticleFX, false, false, 10, true, true )
			end
			ParticleManager:SetParticleControl( self.nParticleFX, 2, Vector( nTensStack, nStack, 0 ) )

			--printf( "candy count: %d; updated overhead particle", nCandy )

			local nTierZeroMin = 1
			local nTierZeroMax = 9
			local nTierOneMin = 10
			local nTierOneMax = 24
			local nTierTwoMin = 25

			local vTierZeroColor = Vector( ( 255 / 255 ), ( 255 / 255 ), ( 255 / 255 ) )
			local vTierOneColor = Vector( ( 98 / 255 ), ( 230 / 255 ), ( 172 / 255 ) )
			local vTierTwoColor = Vector( ( 0 / 255 ), ( 184 / 255 ), ( 107 / 255 ) )

			-- Play a special particle for changing candy tier and colorize the number
			if ( self.nPrevCount < nTierZeroMin or self.nPrevCount > nTierZeroMax ) and nCandy >= nTierZeroMin and nCandy <= nTierZeroMax then
				if self.nPrevCount < nTierZeroMin then
					self:CreateNewTierParticle( "particles/candy/candy_bucket_tier_0.vpcf" )
				end
				--printf( "candy count: %d; updated overhead particle; color: %s", nCandy, vTierZeroColor )
			elseif ( self.nPrevCount < nTierOneMin or self.nPrevCount > nTierOneMax ) and nCandy >= nTierOneMin and nCandy <= nTierOneMax then
				if self.nPrevCount < nTierOneMin then
					self:CreateNewTierParticle( "particles/candy/candy_bucket_tier_1.vpcf" )
				end
				--printf( "candy count: %d; updated overhead particle; color: %s", nCandy, vTierOneColor )
			elseif self.nPrevCount < nTierTwoMin and nCandy >= nTierTwoMin then
				self:CreateNewTierParticle( "particles/candy/candy_bucket_tier_3.vpcf" )
				--printf( "candy count: %d; updated overhead particle; color: %s", nCandy, vTierTwoColor )
			end

			if nCandy < nTierZeroMax then
				ParticleManager:SetParticleControl( self.nParticleFX, 3, vTierZeroColor )
			elseif nCandy < nTierOneMax then
				ParticleManager:SetParticleControl( self.nParticleFX, 3, vTierOneColor )
			else
				ParticleManager:SetParticleControl( self.nParticleFX, 3, vTierTwoColor )
			end
		end

		self.nPrevCount = nCandy
	end
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:CreateNewTierParticle( szParticleName )
	local vPos = self:GetParent():GetAbsOrigin()
	local nDamagedFX = ParticleManager:CreateParticle( szParticleName, PATTACH_CUSTOMORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( nDamagedFX, 0, vPos )
	ParticleManager:ReleaseParticleIndex( nDamagedFX )
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:DropCandy( hAttacker )
	local hBucket = self:GetAbility()
	if hBucket == nil or self:GetParent() == nil or self:GetParent():IsRealHero() == false then
		return
	end

	local nNumCandy = hBucket:GetCandy()

	if nNumCandy == 0 then
		return
	end

	local nPlayerID = self:GetParent():GetPlayerOwnerID()
	--print( '{STATS} candy_lost - Adding ' .. nNumCandy .. ' to PlayerID ' .. nPlayerID )
	GameRules.Diretide.EventMetaData[ nPlayerID ]["candy_lost"] =  GameRules.Diretide.EventMetaData[ nPlayerID ]["candy_lost"] + nNumCandy

	local nNumBigBags = math.floor( nNumCandy / _G.DIRETIDE_CANDY_COUNT_IN_CANDY_BAG )
	if nNumBigBags > 0 then
		nNumCandy = nNumCandy - nNumBigBags * _G.DIRETIDE_CANDY_COUNT_IN_CANDY_BAG
		for i = 1, nNumBigBags do
			GameRules.Diretide:DropCandyAtPosition( self:GetParent():GetAbsOrigin(), self:GetParent(), hAttacker, true, 1.0 )
		end
	end
	for i = 1, nNumCandy do
		GameRules.Diretide:DropCandyAtPosition( self:GetParent():GetAbsOrigin(), self:GetParent(), hAttacker, false, 1.0 )
	end

	hBucket:SetCurrentAbilityCharges( 0 )
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:GetModifierModelScale( params )
	local fReduction = ( self.model_scale_penalty_per_charge * self:GetAbility():GetCandy() )
	if fReduction < self.model_scale_penalty_max then
		fReduction = self.model_scale_penalty_max
	end

	return fReduction
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:OnDestroy()
	if IsServer() == false then
		if self.nParticleFX ~= -1 then
			ParticleManager:DestroyParticle( self.nParticleFX, true )
		end
	end
end