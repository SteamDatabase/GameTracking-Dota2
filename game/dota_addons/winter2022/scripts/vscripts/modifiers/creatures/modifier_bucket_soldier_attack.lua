
if modifier_bucket_soldier_attack == nil then
	modifier_bucket_soldier_attack = class( {} ) 
end

----------------------------------------------------------------------------------------

function modifier_bucket_soldier_attack:IsHidden()
	return false
end

----------------------------------------------------------------------------------------

function modifier_bucket_soldier_attack:IsPurgable()
	return false
end

----------------------------------------------------------------------------------------

function modifier_bucket_soldier_attack:OnCreated( kv )
	if not self:GetAbility() then
		return
	end

	if IsServer() then
		self.debuff_duration = self:GetAbility():GetSpecialValueFor( "debuff_duration" )
		self.cooldown_reduction_per_buff_level = self:GetAbility():GetSpecialValueFor( "cooldown_reduction_per_buff_level" )
		self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_bucket_soldier_attack_ready", { duration = -1 } )
		self:StartIntervalThink( 0.1 )
	end
end

-----------------------------------------------------------------------------

function modifier_bucket_soldier_attack:OnIntervalThink()
	if IsServer() == false then
		return
	end

	if self:GetAbility():IsCooldownReady() and self:GetCaster():HasModifier( "modifier_bucket_soldier_attack_ready" ) == false then
		self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_bucket_soldier_attack_ready", { duration = -1 } )
	end
end

-----------------------------------------------------------------------------

function modifier_bucket_soldier_attack:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
	}

	return funcs
end

-----------------------------------------------------------------------------

function modifier_bucket_soldier_attack:OnAttackLanded( params )
	if IsServer() then
		if self:GetAbility():IsCooldownReady() == false then
			return
		end

		local hAttacker = params.attacker
		if ( hAttacker == nil ) or hAttacker:IsNull() or ( hAttacker ~= self:GetParent() ) then
			return
		end

		local hVictim = params.target
		if hVictim == nil or hVictim:IsNull() then
			return
		end

		if hVictim:GetTeamNumber() == hAttacker:GetTeamNumber() then
			return
		end

		local bHit = false
		if hVictim:IsIllusion() and not hVictim:IsStrongIllusion() then
			hVictim:Kill( self:GetAbility(), self:GetCaster() )
			bHit = true
		end

		if hVictim:IsHero() and hVictim:IsMagicImmune() == false then
			hVictim:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_bucket_soldier_attack_fear", { run_from_bucket = true, duration = self.debuff_duration } )
			bHit = true
		end

		if bHit then
			self:GetAbility():StartCooldown( -1 )

			self:GetCaster():RemoveModifierByName( "modifier_bucket_soldier_attack_ready" )

			EmitSoundOn( "BucketSoldier.Fear", hVictim )
		end
	end
end

-----------------------------------------------------------------------------

function modifier_bucket_soldier_attack:GetModifierCooldownReduction_Constant( params )
	--print( '^^^modifier_bucket_soldier_attack:GetModifierCooldownReduction_Constant' )
	local fCooldownReduction = 0
	if IsServer() then
		local hBuff = self:GetParent():FindModifierByName( "modifier_creature_buff_dynamic" )
		if hBuff ~= nil then
			local nBuffLevel = hBuff:GetBaseBuffLevel()
			--print( '^^^modifier_bucket_soldier_attack:GetModifierCooldownReduction_Constant( params ) Buff Level = ' .. nBuffLevel )
			fCooldownReduction = nBuffLevel * self.cooldown_reduction_per_buff_level
		end
	end
	--print( '^^^CD Reduction = ' .. fCooldownReduction )
	return fCooldownReduction
end
