modifier_treant_leech_seed_nb2017 = class({})

--------------------------------------------------------------------------------

function modifier_treant_leech_seed_nb2017:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_treant_leech_seed_nb2017:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_treant_leech_seed_nb2017:OnCreated( kv )
end

--------------------------------------------------------------------------------

function modifier_treant_leech_seed_nb2017:OnRefresh( kv )
end


--------------------------------------------------------------------------------

function modifier_treant_leech_seed_nb2017:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


--------------------------------------------------------------------------------

function modifier_treant_leech_seed_nb2017:OnAttackLanded( params )
	if IsServer() then
		local hAttacker = params.attacker
		local hTarget = params.target
		local hAbility = self:GetAbility()

		if hAttacker == nil or hAttacker ~= self:GetParent() or hTarget == nil or hAbility == nil then
			return 0
		end

		if hTarget:IsInvulnerable() or hTarget:IsMagicImmune() then
			return 0
		end

		if not hAbility:IsCooldownReady() then
			return 0
		end

		hAbility:StartCooldown( hAbility:GetCooldown( hAbility:GetLevel() ) )
		hTarget:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_treant_leech_seed", { duration = self:GetAbility():GetSpecialValueFor( "duration" ) } )

		EmitSoundOn( "Hero_Treant.LeechSeed.Cast", self:GetCaster() )
		EmitSoundOn( "Hero_Treant.LeechSeed.Target", hTarget )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_treant/treant_leech_seed.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", hTarget:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_ABSORIGIN, nil, hTarget:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end

	return 0
end


--------------------------------------------------------------------------------

function modifier_treant_leech_seed_nb2017:CheckState()
	local state = {}

	if IsServer() then
		state =
		{
			[MODIFIER_STATE_CANNOT_MISS] = self.bIsWalrusPunch,
		}
	end

	return state
end
