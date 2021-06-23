

if modifier_hero_meteor_shard_pouch_buff == nil then
	modifier_hero_meteor_shard_pouch_buff = class({})
end

-----------------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_buff:constructor()
	self.nBonusDamage = 0
	self.nSpellAmp = 0
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_buff:IsHidden()
	return false 
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_buff:IsPurgable()
	return false
end


--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_buff:OnCreated( kv )
	self.move_speed_pct_per_stack = self:GetAbility():GetSpecialValueFor( "move_speed_pct_per_stack" )
	self.health_drain_pct_per_stack = self:GetAbility():GetSpecialValueFor( "health_drain_pct_per_stack" )
	self.lifesteal_pct_per_stack = self:GetAbility():GetSpecialValueFor( "lifesteal_pct_per_stack" )
	self.damage_pct_per_stack = self:GetAbility():GetSpecialValueFor( "damage_pct_per_stack" )
	self.spellamp_pct_per_stack = self:GetAbility():GetSpecialValueFor( "spellamp_pct_per_stack" )
	self.zap_delay = self:GetAbility():GetSpecialValueFor( "zap_delay" )
	self.zap_range = self:GetAbility():GetSpecialValueFor( "zap_range" )
	self.zap_base_damage = self:GetAbility():GetSpecialValueFor( "zap_base_damage" )
	self.zap_damage_per_round = self:GetAbility():GetSpecialValueFor( "zap_damage_per_round" )
	self.zap_minimum_stacks = self:GetAbility():GetSpecialValueFor( "zap_minimum_stacks" )

	self:SetHasCustomTransmitterData( true )
	self:OnRefresh( kv )

	if IsServer() then	
		self.nNextZapTime = 0
		self:StartIntervalThink( 0.1 )

	
		
		--print( "Creating Crystal Ring FX" )
		self.nFXIndexB = ParticleManager:CreateParticle( "particles/gameplay/crystal_ring/crystal_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		--self.nFXIndexB = ParticleManager:CreateParticle( "particles/gameplay/moon_juice/moon_juice.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndexB, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndexB, 1, Vector( 0, 0.0, 0.0 ) )
		self:AddParticle( self.nFXIndexB, false, false, 10, true, false )
	end
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_buff:OnRefresh( kv )

	if IsServer() == false then
		return
	end

	self:OnStackCountChanged()
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_buff:OnStackCountChanged( nOldStackCount )
	if IsServer() == false then
		return
	end

	local nEnergy = self:GetStackCount()
	self.damage_buff_pct = math.ceil( nEnergy * self.damage_pct_per_stack )
	self.model_scale = math.min( nEnergy * 10, 100 )
	local nNewDamage = math.ceil( ( ( self:GetParent():GetBaseDamageMin() + self:GetParent():GetBaseDamageMax() / 2 ) * self.damage_buff_pct ) / 100 )
	local nNewAmp = math.ceil( nEnergy * self.spellamp_pct_per_stack )

	if nNewAmp ~= self.nSpellAmp then
		self.nBonusDamage = nNewDamage
		self.nSpellAmp = nNewAmp
		self:SendBuffRefreshToClients()

		self:GetParent():SetHealthBarOffsetOverride( self:GetParent():GetBaseHealthBarOffset() + self:GetParent():GetModelScale() * 50 )

		if self.nFXIndexB ~= nil then
			if nEnergy == 0 then
				ParticleManager:DestroyParticle( self.nFXIndexB, true )
				self.nFXIndexB = nil
			else
				ParticleManager:SetParticleControl( self.nFXIndexB, 1, Vector( nEnergy, 0.0, 0.0 ) )
			end
		end	

		if self.nParticleFX == nil then 
			self.nParticleFX = -1
		end

		if nEnergy == 0 then
			if self.nParticleFX ~= -1 then
				ParticleManager:DestroyParticle( self.nParticleFX, true )
				self.nParticleFX = -1
			end
		else
			local nStack = math.mod( nEnergy, 10 )
			local nTensStack = math.floor( nEnergy / 10 ) 
			if self.nParticleFX == -1 then
				self.nParticleFX = ParticleManager:CreateParticle( "particles/gameplay/moon_juice_overhead/moon_juice_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
				--printf( "candy count: %d; created overhead particle", nCandy )
				--self:AddParticle( self.nParticleFX, false, false, 10, true, true )
			end
			ParticleManager:SetParticleControl( self.nParticleFX, 2, Vector( nTensStack, nStack, 0 ) )
			ParticleManager:SetParticleControl( self.nParticleFX, 3, Vector( NEMESTICE_EMBERCHARGE_COUNTER_TEXT_COLOR_R, NEMESTICE_EMBERCHARGE_COUNTER_TEXT_COLOR_G, NEMESTICE_EMBERCHARGE_COUNTER_TEXT_COLOR_B ) )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_buff:OnIntervalThink()
	if IsServer() == false then
		return
	end

	if self:GetCaster():IsHero() == false and ( self:GetCaster():IsCreepHero() == false or self:GetCaster():IsOwnedByAnyPlayer() == false ) then
		return
	end

	local flDamage = self:GetParent():GetMaxHealth() * self.health_drain_pct_per_stack * self:GetStackCount() / 100
	if flDamage > 0 then
		local damageInfo = 
		{
			victim = self:GetParent(),
			attacker = self:GetParent(),
			damage = flDamage,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NON_LETHAL,
			ability = self:GetAbility(),
		}
	
		ApplyDamage( damageInfo )
	end

	if self:GetStackCount() >= self.zap_minimum_stacks and self.nNextZapTime < GameRules:GetDOTATime( false, true ) then
		local caster = self:GetParent()

		-- skip the zap if the caster is cc'd or invisible
		if caster ~= nil and caster:IsAlive() == true and caster:IsNull() == false and caster:IsStunned() == false and caster:IsHexed() == false and caster:IsInvisible() == false then

			local rgTargets = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.zap_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
			ShuffleListInPlace( rgTargets )
			
			for i=1,self:GetStackCount() do
				local hTarget = rgTargets[i]
				if hTarget then
					ApplyDamage( {
						victim = hTarget,
						attacker = self:GetParent(),
						damage = self.zap_base_damage + GameRules.Nemestice:GetRoundNumber() * self.zap_damage_per_round,
						damage_type = DAMAGE_TYPE_MAGICAL,
						damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
						ability = self:GetAbility(),
					} )
				end

				local nFXIndex = ParticleManager:CreateParticle( "particles/gameplay/meteor_zap/meteor_zap.vpcf", PATTACH_CUSTOMORIGIN, caster )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
				if hTarget then
					ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true )
				else
					local vTarget = RandomVector( RandomFloat( self.zap_range / 2, self.zap_range ) ) + caster:GetAbsOrigin() + Vector( 0, 0, 200 )
					ParticleManager:SetParticleControl( nFXIndex, 1, vTarget )
				end
				ParticleManager:SetParticleControl( nFXIndex, 62, Vector( math.random(), 0, 0 ) )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end

			if #rgTargets > 0 then
				EmitSoundOn( "Nemestice.Shard.Zap", caster )
			else
				EmitSoundOn( "Nemestice.Shard.ZapMiss", caster )
			end

		end

		self.nNextZapTime = GameRules:GetDOTATime( false, true ) + self.zap_delay
	end
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_buff:OnDestroy()
	if IsServer() == false then
		return
	end

	self:GetParent():SetHealthBarOffsetOverride( -1 )

	if self.nParticleFX ~= -1 then
		ParticleManager:DestroyParticle( self.nParticleFX, true )
		self.nParticleFX = -1
	end

	if self.nFXIndexB ~= nil then
	
		ParticleManager:DestroyParticle( self.nFXIndexB, true )
		self.nFXIndexB = nil
	end
	
	--[[if self:GetParent() ~= nil and self:GetParent():IsNull() == false and self:GetParent():IsAlive() then
		local hShardPouch = self:GetAbility()
		if hShardPouch and hShardPouch:GetShardCount() > 0 then
			if self:GetParent():IsRealHero() then
				GameRules.Nemestice:ChangeMeteorEnergy( self:GetParent():GetPlayerOwnerID(), -hShardPouch:GetShardCount(), "decay" )
			else
				hShardPouch:SetCurrentAbilityCharges( 0 )
			end
		end
	end--]]
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_buff:AddCustomTransmitterData( )
	return
	{
		damage = self.nBonusDamage,
		spellamp = self.damage_buff_pct,
	}
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_buff:HandleCustomTransmitterData( data )
	if data.damage ~= nil then
		self.nBonusDamage = tonumber( data.damage )
	end
	if data.spellamp ~= nil then
		self.nSpellAmp = tonumber( data.spellamp )
	end
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_buff:GetModifierSpellAmplify_Percentage( params )
	return self.nSpellAmp
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_buff:GetModifierModelScale( params )
	if self.model_scale == nil then return 0 end
	return self.model_scale
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_buff:GetModifierPreAttack_BonusDamage( params )
	return self.nBonusDamage
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_buff:OnAttackLanded( params )
	if IsServer() == false then
		return 0
	end

	if params.attacker == self:GetParent() and params.inflictor == nil and params.target ~= nil then
		-- --print( "try to dela splash" )
		-- --print ( self.splash_damage_radius )
		-- --print( self.splash_damage_damage_pct )
		-- local hEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), params.target:GetAbsOrigin(), nil, self.splash_damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
		-- for _, enemy in ipairs( hEnemies ) do
		-- 	local damageInfo = 
		-- 	{
		-- 		victim = enemy,
		-- 		attacker = self:GetParent(),
		-- 		damage = params.damage * self.splash_damage_damage_pct / 100,
		-- 		damage_type = DAMAGE_TYPE_PHYSICAL,
		-- 		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_USE_COMBAT_PROFICIENCY,
		-- 		ability = self:GetAbility(),
		-- 	}

		-- 	ApplyDamage( damageInfo )
		-- end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_buff:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetStackCount() * self.move_speed_pct_per_stack
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_buff:OnDamageCalculated( params )
	if IsServer() == false then
		return 0
	end
	local Attacker = params.attacker
	local Target = params.target
	local Ability = params.inflictor
	local flDamage = params.damage

	if Attacker ~= self:GetParent() then
		
		return 0
	end

	if Target == nil or Target:IsBuilding() or Target:IsOther() or Target:GetTeamNumber() == Attacker:GetTeamNumber() then
			
		return 0
	end

	if params.process_procs == false then
		return 0
	end
		
	local flLifesteal = flDamage * self.lifesteal_pct_per_stack * self:GetStackCount() / 100.0
	if flLifesteal == 0 then
		return 0
	end

	self:GetParent():Heal( flLifesteal, self:GetAbility() )
	ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) )
	return 0
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch_buff:OnTakeDamage( params )
	if IsServer() == false then
		return 0
	end
	local Attacker = params.attacker
	local Target = params.unit
	local Ability = params.inflictor
	local flDamage = params.damage

	if Attacker ~= self:GetParent() or Ability == nil or Target == nil then
		return 0
	end

	if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
		return 0
	end

	if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
		return 0
	end

	local flLifesteal = flDamage * self.lifesteal_pct_per_stack * self:GetStackCount() / 100
	if flLifesteal == 0 then
		return 0
	end
	if Target:IsHero() == false then
		flLifesteal = flLifesteal * 0.25
	end
	Attacker:Heal( flLifesteal, self:GetAbility() )

	local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	return 0
end

