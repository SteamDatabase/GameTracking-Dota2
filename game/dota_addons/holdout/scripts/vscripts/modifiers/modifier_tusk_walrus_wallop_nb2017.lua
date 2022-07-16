modifier_tusk_walrus_wallop_nb2017 = class({})

--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_nb2017:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_nb2017:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_nb2017:OnCreated( kv )
	self.bIsWalrusPunch = false
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor( "crit_multiplier" )
	self.knockback_height = self:GetAbility():GetSpecialValueFor( "knockback_height" )
	self.knockback_distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" ) 
	self.knockback_duration = self:GetAbility():GetSpecialValueFor( "knockback_duration" )
	self.max_targets = 100

	if IsServer() then
		self.hHitTargets = {}
		self.iProcAttackRecords = {}
	end
end

--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_nb2017:OnRefresh( kv )
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor( "crit_multiplier" )
	self.knockback_height = self:GetAbility():GetSpecialValueFor( "knockback_height" )
	self.knockback_distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" ) 
	self.knockback_duration = self:GetAbility():GetSpecialValueFor( "knockback_duration" )
end


--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_nb2017:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_RECORD,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_nb2017:OnAttackRecord( params )
	if IsServer() then
		local hAttacker = params.attacker
		local hTarget = params.target
		local hAbility = self:GetAbility()

		if hAttacker == nil or hAttacker ~= self:GetParent() or hTarget == nil or hAbility == nil then
			return 0
		end

		local bTalentProc = false
		local hTalent = self:GetCaster():FindAbilityByName( "special_bonus_unique_tusk_walrus_wallop_auto_trigger" )
		if hTalent and hTalent:GetLevel() > 0 then
			local fTalentChance = hTalent:GetSpecialValueFor( "value" )
			--print( 'CHECKING WALRUS WALLOP CHANCE @ ' .. fTalentChance )
			if RollPseudoRandomPercentage( math.floor( fTalentChance ), DOTA_PSEUDO_RANDOM_TUSK_CRIT, self:GetParent() ) then
				--print( 'WALLOP TIME!!!!' )
				bTalentProc = true
			end
		end		

		self.bIsWalrusPunch = false

		if not bTalentProc then
			if hAttacker:GetCurrentActiveAbility() ~= hAbility and hAbility:GetAutoCastState() == false then
				return 0
			end

			if hAbility:GetEffectiveManaCost( hAbility:GetLevel() ) > hAttacker:GetMana() then
				return 0
			end

			if hAbility:IsCooldownReady() == false then
				return 0
			end

			if hAttacker:IsSilenced() then
				return 0
			end
		end

		if hTarget:IsInvulnerable() or hTarget:IsBuilding() or hTarget:IsOther() or hTarget:GetTeamNumber() == hAttacker:GetTeamNumber() then
			return 0
		end

		self.bIsWalrusPunch = true
		if bTalentProc then
			table.insert( self.iProcAttackRecords, params.record )
		end
		self.hHitTargets = {}

		EmitSoundOn( "Hero_Tusk.WalrusPunch.Cast", hAttacker )
		hAttacker:StartGesture( ACT_DOTA_CAST_ABILITY_4 )
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_nb2017:OnAttackLanded( params )
	if IsServer() then
		local hAttacker = params.attacker
		local hTarget = params.target
		local hAbility = self:GetAbility()

		local bProcAttack = false
		for i = 1,#self.iProcAttackRecords do
			if self.iProcAttackRecords[i] == params.record then
				--print( 'FOUND PROC ATTACK!' )
				table.remove( self.iProcAttackRecords, i )
				bProcAttack = true
			end
		end

		if hAttacker == nil or hAttacker ~= self:GetParent() or hTarget == nil or hAbility == nil then
			return 0
		end

		if self.bIsWalrusPunch == false then
			return 0
		end

		if hTarget:IsInvulnerable() or hTarget:IsBuilding() or hTarget:IsOther() or hTarget:GetTeamNumber() == hAttacker:GetTeamNumber() then
			return 0
		end

		if bProcAttack == false then
			hAbility:CastAbility()
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_tusk/tusk_walruspunch_start.vpcf", PATTACH_CUSTOMORIGIN, hAttacker );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_attack2", hAttacker:GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, hAttacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hAttacker:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local nFXIndexB = ParticleManager:CreateParticle( "particles/units/heroes/hero_tusk/tusk_walruspunch_hand.vpcf", PATTACH_CUSTOMORIGIN, hAttacker );
		ParticleManager:SetParticleControlEnt( nFXIndexB, 1, hAttacker, PATTACH_POINT_FOLLOW, "attach_attack2", hAttacker:GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndexB, 2, hAttacker, PATTACH_POINT_FOLLOW, "attach_hitloc", hAttacker:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndexB )

		StopSoundOn( "Hero_Tusk.WalrusPunch.Cast", hAttacker )
		EmitSoundOn( "Hero_Tusk.WalrusPunch.Target", hTarget )
		self:GetAbility():SpeakAbilityConcept( 18 )

		local kv =
		{
			duration = self.knockback_duration,
			source_ent_index = self:GetCaster():entindex()
		}

		hTarget:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_tusk_walrus_punch_slow", kv )
		hTarget:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_tusk_walrus_wallop_enemy_nb2017", kv )

		table.insert( self.hHitTargets, hTarget )
		--print( "setting walrus punch = false" )
		self.bIsWalrusPunch = false
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_nb2017:GetCritDamage()
	return self.crit_multiplier
end

--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_nb2017:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() then
		if self.bIsWalrusPunch == false then
			return 0
		end

		local hAttacker = params.attacker
		local hTarget = params.target
		local hAbility = self:GetAbility()

		if hAttacker == nil or hAttacker ~= self:GetParent() or hTarget == nil or hAbility == nil then
			return 0
		end


		if hTarget:IsInvulnerable() or hTarget:IsBuilding() or hTarget:IsOther() or hTarget:GetTeamNumber() == hAttacker:GetTeamNumber() then
			return 0
		end

		local nCritPct = self.crit_multiplier
		local hTalent = self:GetCaster():FindAbilityByName( "special_bonus_unique_tusk_walrus_wallop_crit" )
		if hTalent and hTalent:GetLevel() > 0 then
			--print( 'ADDING CRIT TO WALRUS WALLOP = ' .. hTalent:GetSpecialValueFor( "value" ) )
			nCritPct = nCritPct + hTalent:GetSpecialValueFor( "value" )
		end

		return nCritPct
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_nb2017:CheckState()
	local state = {}

	if IsServer() then
		state =
		{
			[MODIFIER_STATE_CANNOT_MISS] = self.bIsWalrusPunch,
		}
	end

	return state
end

--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_nb2017:HasHitTarget( hTarget )
	for _, target in pairs( self.hHitTargets ) do
		if target == hTarget then
	    	return true
	    end
	end
	
	return false
end

--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_nb2017:AddHitTarget( hTarget )
	table.insert( self.hHitTargets, hTarget )
end

--------------------------------------------------------------------------------

function modifier_tusk_walrus_wallop_nb2017:HasHitMaxTargets()
	return #self.hHitTargets >= self.max_targets
end