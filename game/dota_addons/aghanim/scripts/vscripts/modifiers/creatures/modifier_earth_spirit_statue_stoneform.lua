
modifier_earth_spirit_statue_stoneform = class({})

-----------------------------------------------------------------------------------------

function modifier_earth_spirit_statue_stoneform:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_earth_spirit_statue_stoneform:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_earth_spirit_statue_stoneform:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

-----------------------------------------------------------------------------------------

function modifier_earth_spirit_statue_stoneform:GetStatusEffectName()
	return "particles/status_fx/status_effect_earth_spirit_petrify.vpcf"
end

-------------------------------------------------------------------------------

function modifier_earth_spirit_statue_stoneform:StatusEffectPriority()
	return 60
end

-----------------------------------------------------------------------------------------

function modifier_earth_spirit_statue_stoneform:OnCreated( kv )
	if IsServer() then
		--printf( "modifier_earth_spirit_statue_stoneform - OnCreated" )

		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_earth_spirit/earthspirit_petrify_debuff_stoned.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )

		--[[
		self.nFXIndexB = ParticleManager:CreateParticle( "particles/units/heroes/hero_earth_spirit/espirit_stoneremnant_base.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndexB, 0, self:GetCaster(), PATTACH_ABSORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndexB, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		--ParticleManager:SetParticleControlEnt( self.nFXIndexB, 2, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		]]

		--[[ C++
		ParticleIndex_t nFXIndex = CreateBuffParticleEffect( "particles/units/heroes/hero_earth_spirit/earthspirit_petrify_debuff_stoned.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, GetParent() );
		GetParticleManager()->SetParticleControlEnt( nFXIndex, 0, GetParent(), PATTACH_ABSORIGIN_FOLLOW, NULL );
		GetParticleManager()->SetParticleControlEnt( nFXIndex, 1, GetParent(), PATTACH_ABSORIGIN_FOLLOW, NULL );
		AddParticle( nFXIndex, false );

		m_nFXIndex = CreateBuffParticleEffect( "particles/units/heroes/hero_earth_spirit/espirit_stoneremnant_base.vpcf", PATTACH_ABSORIGIN_FOLLOW, GetParent() );
		GetParticleManager()->SetParticleControlEnt( m_nFXIndex, 0, GetParent(), PATTACH_ABSORIGIN, NULL );
		GetParticleManager()->SetParticleControlEnt( m_nFXIndex, 1, GetParent(), PATTACH_ABSORIGIN_FOLLOW, NULL );
		GetParticleManager()->SetParticleControl( m_nFXIndex, 2, Vector( GetCaster()->GetSequence().GetRaw(), GetCaster()->GetModelScale(), 0 ) );
		]]
	end
end

-----------------------------------------------------------------------------------------

function modifier_earth_spirit_statue_stoneform:OnDestroy()
	if IsServer() then
		--printf( "modifier_earth_spirit_statue_stoneform - OnDestroy" )

		--local kv = { duration = -1 }
		--self:GetParent():AddNewModifier( self:GetParent(), self, "modifier_earth_spirit_statue_active", kv )

		EmitSoundOn( "Hero_EarthSpirit.StoneRemnant.Destroy", self:GetCaster() )
	end
end

-------------------------------------------------------------------------------

function modifier_earth_spirit_statue_stoneform:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_earth_spirit_statue_stoneform:GetOverrideAnimation( params )
	return ACT_DOTA_IDLE
	--return ACT_DOTA_IDLE_STATUE
end

-------------------------------------------------------------------------------

function modifier_earth_spirit_statue_stoneform:GetOverrideAnimationRate( params )
	return 0.0
end

-------------------------------------------------------------------------------

function modifier_earth_spirit_statue_stoneform:CheckState()
	local state =
	{
		[ MODIFIER_STATE_STUNNED ] = true,
		--[ MODIFIER_STATE_FROZEN ] = true,
		--[ MODIFIER_STATE_PROVIDES_VISION ] = true,

		[ MODIFIER_STATE_INVISIBLE ] = false,
	}

	return state
end

-------------------------------------------------------------------------------


--[[

//-----------------------------------------------------------------------------
// Modifier: Petrify 
//-----------------------------------------------------------------------------
class CDOTA_Modifier_AghsFort_EarthSpiritBoss_Petrify : public CDOTA_Buff
{
public:
	DECLARE_CLASS( CDOTA_Modifier_AghsFort_EarthSpiritBoss_Petrify, CDOTA_Buff );

	virtual bool IsDebuff( void ) { return true; }
	virtual bool IsStunDebuff( void ) { return true; }
	virtual bool IsPurgable( void ) { return false; }

	virtual void OnCreated( KeyValues *pKV );
	void OnDestroy( void );
	void DeclareFunctions( void );

	virtual void CheckState( CDOTABuffState &buffState ) OVERRIDE;

	bool HasBeenMagnetized( void ) { return m_bHasBeenMagnetized; }
	void SetMagnetized( bool bState ) { m_bHasBeenMagnetized = bState; }

	virtual const char *GetStatusEffectName( void ) { return "particles/status_fx/status_effect_earth_spirit_petrify.vpcf"; }
	virtual int StatusEffectPriority( void ) { return 420; }
	
	bool ProvidesTruesightForTeam( int nTeamNumber ) OVERRIDE { return nTeamNumber == GetTeam(); }
	ModifierVariant_t GetOverrideAnimationRate( const CModifierParams &params );
private:
	ParticleIndex_t m_nFXIndex;
	bool m_bHasBeenMagnetized;
};

LINK_MODIFIER_TO_CLASS( modifier_aghsfort_earth_spirit_boss_petrify, CDOTA_Modifier_AghsFort_EarthSpiritBoss_Petrify );

//--------------------------------------------------------------------------------

void CDOTA_Modifier_AghsFort_EarthSpiritBoss_Petrify::OnCreated( KeyValues *pKV )
{
#ifdef SERVER_DLL
	m_bHasBeenMagnetized = false;

	ParticleIndex_t nFXIndex = CreateBuffParticleEffect( "particles/units/heroes/hero_earth_spirit/earthspirit_petrify_debuff_stoned.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, GetParent() );
	GetParticleManager()->SetParticleControlEnt( nFXIndex, 0, GetParent(), PATTACH_ABSORIGIN_FOLLOW, NULL );
	GetParticleManager()->SetParticleControlEnt( nFXIndex, 1, GetParent(), PATTACH_ABSORIGIN_FOLLOW, NULL );
	AddParticle( nFXIndex, false );


	m_nFXIndex = CreateBuffParticleEffect( "particles/units/heroes/hero_earth_spirit/espirit_stoneremnant_base.vpcf", PATTACH_ABSORIGIN_FOLLOW, GetParent() );
	GetParticleManager()->SetParticleControlEnt( m_nFXIndex, 0, GetParent(), PATTACH_ABSORIGIN, NULL );
	GetParticleManager()->SetParticleControlEnt( m_nFXIndex, 1, GetParent(), PATTACH_ABSORIGIN_FOLLOW, NULL );
	GetParticleManager()->SetParticleControl( m_nFXIndex, 2, Vector( GetCaster()->GetSequence().GetRaw(), GetCaster()->GetModelScale(), 0 ) );

	if ( FStrEq( GetParent()->GetUnitName(), "npc_dota_hero_wisp" ) )
	{
		ParticleIndex_t nFXIndexWisp = CreateBuffParticleEffect( "particles/units/heroes/hero_earth_spirit/earthspirit_petrify_wisp.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, GetParent() );
		GetParticleManager()->SetParticleControlEnt( nFXIndexWisp, 0, GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc" );
		AddParticle( nFXIndexWisp, false );
	}
#endif
}

//--------------------------------------------------------------------------------

void CDOTA_Modifier_AghsFort_EarthSpiritBoss_Petrify::OnDestroy( void )
{
	float damage;
	float aoe;

	DOTA_RETRIEVE_VALUE( damage );
	DOTA_RETRIEVE_VALUE( aoe );

#ifdef SERVER_DLL
	CUtlVector<EHANDLE> hEntities;
	FindUnitsInRadius( GetCaster()->GetGridNav(), GetCaster()->GetTeamNumber(), GetParent()->GetAbsOrigin(), GetCaster(), aoe, &hEntities, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP | DOTA_UNIT_TARGET_HERO );
	GetParticleManager()->DestroyParticleEffect( m_nFXIndex, false );

	GetParent()->UnitEmitSound( "Hero_EarthSpirit.StoneRemnant.Destroy" );

	for ( int i = 0; i < hEntities.Count(); i++ )
	{
		CDOTA_BaseNPC *pNPC = ToDOTABaseNPC( hEntities[i] );
		if ( pNPC )
		{
			ApplyDamage( GetCaster(), pNPC, GetAbility(), damage, DAMAGE_TYPE_MAGICAL );
		}
	}

	if ( GetParent()->GetLocomotionInterface() && !GetParent()->GetLocomotionInterface()->IsCurrentlyMotionControlled() )
	{
		FindClearSpaceForUnit( GetParent(), GetParent()->GetAbsOrigin(), false );
	}
#endif

	ParticleIndex_t nFXIndexShockC = CreateBuffParticleEffect( "particles/units/heroes/hero_earth_spirit/earthspirit_petrify_shockwave.vpcf", PATTACH_ABSORIGIN_FOLLOW, GetParent() );
	GetParticleManager()->SetParticleControlEnt( nFXIndexShockC, 0, GetParent(), PATTACH_ABSORIGIN, NULL, GetParent()->GetAbsOrigin() );
	GetParticleManager()->SetParticleControl( nFXIndexShockC, 3, Vector( aoe, aoe, aoe ) );
	GetParticleManager()->ReleaseParticleIndex( nFXIndexShockC );

}

//-----------------------------------------------------------------------------------

void CDOTA_Modifier_AghsFort_EarthSpiritBoss_Petrify::DeclareFunctions( void )
{
	DOTA_LINK_FUNCTION( MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE, &CDOTA_Modifier_AghsFort_EarthSpiritBoss_Petrify::GetOverrideAnimationRate );
}
//-----------------------------------------------------------------------------

ModifierVariant_t CDOTA_Modifier_AghsFort_EarthSpiritBoss_Petrify::GetOverrideAnimationRate( const CModifierParams &params )
{
	return 0;
}

//-----------------------------------------------------------------------------

void CDOTA_Modifier_AghsFort_EarthSpiritBoss_Petrify::CheckState( CDOTABuffState &buffState )
{
	BaseClass::CheckState( buffState );

	buffState.Enable( MODIFIER_STATE_STUNNED );
	buffState.Enable( MODIFIER_STATE_FROZEN );
	buffState.Enable( MODIFIER_STATE_ATTACK_IMMUNE );
	buffState.Enable( MODIFIER_STATE_INVULNERABLE );
	buffState.Enable( MODIFIER_STATE_OUT_OF_GAME );
	buffState.Enable( MODIFIER_STATE_NO_HEALTH_BAR );
	buffState.Disable( MODIFIER_STATE_INVISIBLE );
}

//-----------------------------------------------------------------------------

]]
