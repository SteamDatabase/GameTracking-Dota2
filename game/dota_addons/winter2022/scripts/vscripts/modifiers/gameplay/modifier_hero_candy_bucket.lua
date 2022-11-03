
if modifier_hero_candy_bucket == nil then
	modifier_hero_candy_bucket = class({})
end

------------------------------------------------------------------------------

function modifier_hero_candy_bucket:IsHidden() 
	local bHidden = ( self:GetStackCount() <= 0 )

	return bHidden
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:GetTexture()
	return "hero_candy_bucket"
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:OnCreated( kv )
	if self:GetAbility() ~= nil and self:GetAbility():IsNull() == false then
		self.max_hp_penalty_per_charge = self:GetAbility():GetSpecialValueFor( "max_hp_penalty_per_charge" )
		self.model_scale_penalty_per_charge = self:GetAbility():GetSpecialValueFor( "model_scale_penalty_per_charge" )
		self.model_scale_penalty_max = self:GetAbility():GetSpecialValueFor( "model_scale_penalty_max" )
	end

	self.nPrevCount = 0

	if IsServer() == false then
		self.nParticleFX = -1
	else
		self.fStatCalcInterval = 0.2
		self.nHealthLost = 0
		self.nCurCandy = 0
	end
	local fInterval = 0.05
	self:StartIntervalThink( fInterval )
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:OnRefresh( kv )
	if self.nPrevCount == nil then
		self.nPrevCount = 0
	end

	if IsServer() == false then
		if self.nParticleFX == nil then
			self.nParticleFX = -1
		end
	else
		if self.max_hp_penalty_per_charge == nil and self:GetAbility() ~= nil and self:GetAbility():IsNull() == false then
			self.max_hp_penalty_per_charge = self:GetAbility():GetSpecialValueFor( "max_hp_penalty_per_charge" )
			self.model_scale_penalty_per_charge = self:GetAbility():GetSpecialValueFor( "model_scale_penalty_per_charge" )
			self.model_scale_penalty_max = self:GetAbility():GetSpecialValueFor( "model_scale_penalty_max" )
		end
		self.fStatCalcInterval = 0.2
	end

	local fInterval = 0.05
	self:StartIntervalThink( fInterval )
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
		--MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		--MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
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
	local nCandy = self:GetStackCount()
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
	if IsServer() and not self:GetParent():IsRealHero() then
		if self:GetCaster() ~= nil and self:GetCaster():IsNull() == false then
			self:SetStackCount( self:GetCaster():GetModifierStackCount( "modifier_hero_candy_bucket", nil ) )
		end
	end

	local nCandy = self:GetStackCount()

	if IsServer() == true then
		if self.nLineFX ~= nil then
			local hBucket = GameRules.Winter2022:FindNearestVulnerableCandyBucket( self:GetParent():GetAbsOrigin(), self:GetParent():GetOpposingTeamNumber() )
			if hBucket ~= nil then
				ParticleManager:SetParticleControlEnt( self.nLineFX, 1, hBucket, PATTACH_ABSORIGIN_FOLLOW, nil, hBucket:GetAbsOrigin(), false )
			end
			if self:GetAbility() ~= nil then
				ParticleManager:SetParticleControl( self.nLineFX, 2, Vector( self:GetAbility():IsChanneling() and 1 or 0, 0, 0 ) )
			end
		end

		--[[if self.fNextStatCalcTime == nil or self.fNextStatCalcTime <= GameRules:GetDOTATime( false, true ) then
			-- This is crap, doing it because GetModifierExtraHealthPercentage isn't being called at the right times
			-- Note that our call for that will be constant until *this* value changes, which means
			-- we have control over when the maxhealth changes from candy.
			self.nCurCandy = nCandy

			local nOldHealth = self:GetParent():GetHealth()
			local nOldMax = self:GetParent():GetMaxHealth()

			--printf( "Hero %s: recalculating stats based on candy %d->%d. Old health/max %d/%d", self:GetParent():GetUnitName(), self.nPrevCount, self.nCurCandy, nOldHealth, nOldMax )
			self:GetParent():CalculateStatBonus( false )

			local nNewHealth = self:GetParent():GetHealth()
			local nNewMax = self:GetParent():GetMaxHealth()
			-- something later actually does the clamping? So we have to clamp here.
			nNewHealth = math.min( nNewHealth, nNewMax )

			local szAlive = "alive"
			if self:GetParent():IsAlive() == false then
				szAlive = "dead"
			end
			--printf( "New health/max %d/%d, alive? %s", nNewHealth, nNewMax, szAlive )

			if nNewHealth < nOldHealth then
				-- they're all ints, but let's be safe because why not.
				self.nHealthLost = self.nHealthLost + math.floor( nOldHealth - nNewHealth )
				--printf("Lost health! Old health %d, new health %d, delta %d so total lost now %d", nOldHealth, nNewHealth, nOldHealth - nNewHealth, self.nHealthLost)
			elseif self.nHealthLost > 0 and nNewMax > nOldMax then
				local nHeal = math.min( self.nHealthLost, math.min( nNewMax - nNewHealth, nNewMax - nOldMax ) )
				--printf("Healing back up. Total health lost %d, clamped heal %d (health %d, max %d) so new desired %d", self.nHealthLost, nHeal, nNewHealth, nNewMax, nNewHealth + nHeal)
				self:GetParent():ModifyHealth( math.max( 1, nNewHealth + nHeal ), nil, false, 0 )
				self.nHealthLost = self.nHealthLost - nHeal
			end

			self.fNextStatCalcTime = GameRules:GetDOTATime( false, true ) + self.fStatCalcInterval
			self.nPrevCount = nCandy
		end--]]
	else
		if not self:GetParent():IsRealHero() then
			-- don't show candy count for illusions on the same team to reduce noise
			if self:GetParent():GetTeamNumber() == GetLocalPlayerTeam(0) then
				return
			end
		end

		-- Hide the overhead particle on a transformed monkey king
		if self:GetParent():HasModifier( "modifier_monkey_king_transform" ) then
			ParticleManager:DestroyParticle( self.nParticleFX, true )
			self.nParticleFX = -1
			self.nPrevCount = 0 -- Will force an update when the modifier disappears
			return
		end

		if nCandy == 0 then
			self.nPrevCount = 0
			if self.nParticleFX ~= -1 then
				ParticleManager:DestroyParticle( self.nParticleFX, true )
				self.nParticleFX = -1
			end
		elseif self.nPrevCount ~= nCandy then
			local nStack = nCandy % 10
			local nTensStack = math.floor( nCandy / 10 ) 
			if self.nParticleFX == -1 then
				self.nParticleFX = ParticleManager:CreateParticle( "particles/hw_fx/candy_carrying_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
				--printf( "candy count: %d; created overhead particle", nCandy )
				--self:AddParticle( self.nParticleFX, false, false, 10, true, true )
			end
			ParticleManager:SetParticleControl( self.nParticleFX, 2, Vector( nTensStack, nStack, 0 ) )
			ParticleManager:SetParticleControl( self.nParticleFX, 3, Vector( ( 255 / 255 ), ( 255 / 255 ), ( 255 / 255 ) ) )

			self.nPrevCount = nCandy
		end
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

function modifier_hero_candy_bucket:OnStackCountChanged( nOldStackCount )
	if IsServer() then
		if self:GetParent():IsRealHero() and nOldStackCount == 0 and self:GetStackCount() > 0 and self.nLineFX == nil then
			local hBucket = GameRules.Winter2022:FindNearestVulnerableCandyBucket( self:GetParent():GetAbsOrigin(), self:GetParent():GetOpposingTeamNumber() )
			if hBucket ~= nil then
				self.nLineFX = ParticleManager:CreateParticleForPlayer( "particles/candy/candy_target_line.vpcf", PATTACH_ABSORIGIN, self:GetParent(), self:GetParent():GetPlayerOwner() )
				ParticleManager:SetParticleControlEnt( self.nLineFX, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), false )
				ParticleManager:SetParticleControlEnt( self.nLineFX, 1, hBucket, PATTACH_ABSORIGIN_FOLLOW, nil, hBucket:GetAbsOrigin(), false )
			end
		elseif self:GetStackCount() == 0 and self.nLineFX ~= nil then
			ParticleManager:DestroyParticle( self.nLineFX, false )
			self.nLineFX = nil
		end
	end
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:DropCandy( hAttacker, bThrowToAttacker, nNumCandy )
	if self:GetParent() == nil or self:GetParent():IsRealHero() == false then
		return
	end

	local nCandy = self:GetStackCount()

	if nNumCandy == nil or nNumCandy > nCandy then
		nNumCandy = nCandy
	end

	if nNumCandy == 0 then
		return
	end

	local nPlayerID = self:GetParent():GetPlayerOwnerID()

	-- don't actually drop candy if Rosh kills you
	if hAttacker ~= nil and hAttacker:GetUnitName() == "npc_dota_roshan_diretide" then
		GameRules.Winter2022:ModifyCandyStat("candy_lost", nPlayerID, nNumCandy)
		--print( 'HERO KILLED BY ROSHAN! NOT DROPPING CANDY!' )
		self:GetAbility():SetCandy( 0 )
		return
	end

	--print( '{STATS} candy_lost - Adding ' .. nNumCandy .. ' to PlayerID ' .. nPlayerID )
	GameRules.Winter2022:ModifyCandyStat("candy_dropped", nPlayerID, nNumCandy)

	nNumCandy = math.ceil( nNumCandy * _G.WINTER2022_HERO_CANDY_PORTION_DROP_ON_DEATH )
	local nTotalDroppedCandy = nNumCandy

	-- temporary: try not throwing to attacker
	if bThrowToAttacker ~= true then
		hAttacker = nil
	end
	local nNumBigBags = math.floor( nNumCandy / _G.WINTER2022_CANDY_COUNT_IN_CANDY_BAG )
	if nNumBigBags > 0 then
		nNumCandy = nNumCandy - nNumBigBags * _G.WINTER2022_CANDY_COUNT_IN_CANDY_BAG
		for i = 1, nNumBigBags do
			GameRules.Winter2022:DropCandyAtPosition( self:GetParent():GetAbsOrigin(), self:GetParent(), hAttacker, true, 1.0 )
		end
	end
	for i = 1, nNumCandy do
		GameRules.Winter2022:DropCandyAtPosition( self:GetParent():GetAbsOrigin(), self:GetParent(), hAttacker, false, 1.0 )
	end

	self:GetAbility():SetCandy( math.max( 0 , nCandy - nTotalDroppedCandy ) )
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:GetModifierModelScale( params )
	local fReduction = ( self.model_scale_penalty_per_charge * self:GetStackCount() )
	if fReduction < self.model_scale_penalty_max then
		fReduction = self.model_scale_penalty_max
	end

	return fReduction
end

--------------------------------------------------------------------------------

function modifier_hero_candy_bucket:OnDestroy()
	if IsServer() == true then
		return
	end

	if self.nParticleFX ~= -1 then
		ParticleManager:DestroyParticle( self.nParticleFX, true )
	end
end

-----------------------------------------------------------------------------

function modifier_hero_candy_bucket:OnAttackLanded( params )
	if IsServer() == false then
		return
	end

	local hVictim = params.target
	if hVictim == nil or hVictim:IsNull() or ( hVictim ~= self:GetParent() ) then
		return
	end

	local hAttacker = params.attacker
	if ( hAttacker == nil ) or hAttacker:IsNull() or ( hAttacker ~= GameRules.Winter2022.hRoshan ) then
		return
	end

	if not self:GetParent():IsRealHero() then 
		return
	end

	local nCandy = self:GetStackCount()
	local nCandyToRemove = WINTER2022_ROSHAN_CANDY_TAKEN_PER_HIT

	if nCandy < nCandyToRemove then
		nCandyToRemove = nCandy
	end

	if nCandyToRemove > 0 then
		self:GetAbility():SetCandy( nCandy - nCandyToRemove )
		local nPlayerID = self:GetParent():GetPlayerOwnerID()

		GameRules.Winter2022:ModifyCandyStat("candy_lost", nPlayerID, nCandyToRemove)

		printf( "Hero Candy: removed %d candy", nCandyToRemove )
	end

	local nHealthToRemove = GameRules.Winter2022:GetRoshanDamageAmount()

	local DamageInfo =
	{
		victim = self:GetParent(),
		attacker = hAttacker,
		ability = nil,
		damage = nHealthToRemove,
		damage_type = DAMAGE_TYPE_PURE,
	}
	ApplyDamage( DamageInfo )
end