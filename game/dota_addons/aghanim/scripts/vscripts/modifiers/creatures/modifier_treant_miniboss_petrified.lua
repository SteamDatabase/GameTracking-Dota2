
modifier_treant_miniboss_petrified = class({})

--------------------------------------------------------------------------------

function modifier_treant_miniboss_petrified:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_treant_miniboss_petrified:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_treant_miniboss_petrified:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

--------------------------------------------------------------------------------

function modifier_treant_miniboss_petrified:GetStatusEffectName()
	return "particles/status_fx/status_effect_earth_spirit_petrify.vpcf"
end

-------------------------------------------------------------------------------

function modifier_treant_miniboss_petrified:StatusEffectPriority()
	return 60
end

--------------------------------------------------------------------------------

function modifier_treant_miniboss_petrified:OnCreated( kv )
	if IsServer() then
		printf( "modifier_treant_miniboss_petrified:OnCreated" )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_earth_spirit/earthspirit_petrify_debuff_stoned.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, false )
	end
end

--------------------------------------------------------------------------------

function modifier_treant_miniboss_petrified:OnDestroy()
	if IsServer() then
		--EmitSoundOn( "Hero_EarthSpirit.StoneRemnant.Destroy", self:GetCaster() )

		self:GetCaster():AddNewModifier( self:GetCaster(), nil, "modifier_absolute_no_cc", { duration = -1 } )
	end
end

--------------------------------------------------------------------------------

function modifier_treant_miniboss_petrified:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_treant_miniboss_petrified:GetOverrideAnimation( params )
	return ACT_DOTA_IDLE
end

-------------------------------------------------------------------------------

function modifier_treant_miniboss_petrified:GetOverrideAnimationRate( params )
	return 0.0
end

--------------------------------------------------------------------------------

function modifier_treant_miniboss_petrified:CheckState()
	local state =
	{
		[ MODIFIER_STATE_ATTACK_IMMUNE ] = true,
		[ MODIFIER_STATE_OUT_OF_GAME ] = true,
		[ MODIFIER_STATE_INVULNERABLE ] = true,
		[ MODIFIER_STATE_MAGIC_IMMUNE ] = true,
		[ MODIFIER_STATE_DISARMED ] = true,
		[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
		[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true,
		[ MODIFIER_STATE_STUNNED ] = true,
		[ MODIFIER_STATE_INVISIBLE ] = false,
	}

	return state
end

--------------------------------------------------------------------------------
