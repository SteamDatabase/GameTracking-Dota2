
if modifier_bucket_soldier_attack == nil then
	modifier_bucket_soldier_attack = class( {} ) 
end

----------------------------------------------------------------------------------------

function modifier_bucket_soldier_attack:IsHidden()
	return true
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

		if hVictim:IsRealHero() and hVictim:IsMagicImmune() == false then
			hVictim:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_bucket_soldier_attack_fear", { duration = self.debuff_duration } )

			local fCooldown = self:GetAbility():GetCooldown( self:GetAbility():GetLevel() )
			self:GetAbility():StartCooldown( fCooldown )

			self:GetCaster():RemoveModifierByName( "modifier_bucket_soldier_attack_ready" )

			EmitSoundOn( "BucketSoldier.Fear", hVictim )
		end
	end
end

-----------------------------------------------------------------------------
