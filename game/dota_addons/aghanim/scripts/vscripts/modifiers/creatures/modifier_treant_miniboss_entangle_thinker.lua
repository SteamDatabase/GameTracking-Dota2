
modifier_treant_miniboss_entangle_thinker = class({})

-----------------------------------------------------------------------------

function modifier_treant_miniboss_entangle_thinker:OnCreated( kv )
	if not IsServer() then
		return
	end

	local vPos = self:GetParent():GetAbsOrigin()

	local nCastFX = ParticleManager:CreateParticle( "particles/creatures/treant_miniboss/entangle_vines.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	--local nCastFX = ParticleManager:CreateParticle( "particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	--local nCastFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_treant/treant_overgrowth_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( nCastFX, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", vPos, true )
	ParticleManager:ReleaseParticleIndex( nCastFX )

	local radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	local root_duration = self:GetAbility():GetSpecialValueFor( "root_duration" )

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vPos, self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
	for _, enemy in pairs( enemies ) do
		if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
			local DamageInfo =
			{
				victim = enemy,
				attacker = self:GetCaster(),
				ability = self,
				damage = damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
			}
			ApplyDamage( DamageInfo )

			enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_treant_miniboss_entangle", { duration = root_duration } )

			EmitSoundOn( "TreantMiniboss.Overgrowth.Target", enemy )

			--[[
			local nTrailFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_treant/treant_overgrowth_trails.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
			ParticleManager:SetParticleControl( nTrailFX, 0, self:GetCaster():GetAbsOrigin() )
			--ParticleManager:SetParticleControl( nTrailFX, 0, enemy:GetAbsOrigin() )
			ParticleManager:SetParticleControl( nTrailFX, 1, enemy:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex( nTrailFX )
			]]
		end
	end
end

-----------------------------------------------------------------------------
