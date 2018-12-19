
invoker_cold_snap_winter = class({})

--------------------------------------------------------------------------------

function invoker_cold_snap_winter:GetAOERadius()
	return self:GetSpecialValueFor( "cast_radius" )
end

--------------------------------------------------------------------------------

function invoker_cold_snap_winter:GetCooldown( iLevel )
	local fCooldown = self.BaseClass.GetCooldown( self, self:GetLevel() )

	local hSpecialBonus = self:GetCaster():FindAbilityByName( "special_bonus_unique_invoker_9" )
	if hSpecialBonus and hSpecialBonus:GetLevel() > 0 then
		fCooldown = fCooldown - self:GetLevelSpecialValueFor( "value", 1 )
	end

	return flCooldown
end

--------------------------------------------------------------------------------

function invoker_cold_snap_winter:OnSpellStart()
	if IsServer() then
		local vCastPos = GetCursorTarget():GetAbsOrigin()

		local fDuration = self:GetLevelSpecialValueFor( "duration", self:GetQuasLevel() ) -- GetQuasLevel is probably not script-accessible

		local hSpecialBonus = self:GetCaster():FindAbilityByName( "special_bonus_unique_invoker_7" )
		if hSpecialBonus and hSpecialBonus:GetLevel() > 0 then
			fDuration = fDuration + hSpecialBonus:GetLevelSpecialValueFor( "value", 1 )
		end

		local kv =
		{
			duration = fDuration,
			quas_level = self:GetQuasLevel(),
		}

		local hEnemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vCastPos, nil, cast_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

		for _, hUnit in pairs( hEnemies ) do
			if hUnit and hUnit:IsMagicImmune() == false and hUnit:IsInvulnerable() == false and hUnit:TriggerSpellAbsorb( self ) == false then
				hUnit:AddNewModifier( self:GetCaster(), self, "modifier_invoker_cold_snap", kv )
				EmitSoundOn( "Hero_Invoker.ColdSnap", hUnit )
			end
		end

		self:GetCaster():StartGesture( ACT_DOTA_CAST_COLD_SNAP )
		EmitSoundOn( "Hero_Invoker.Coldsnap.Cast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

--[[
schema class CDOTA_Ability_Invoker_ColdSnap : public CDOTA_Ability_Invoker_InvokedBase
{
	DECLARE_ENTITY_CLASS_WITH_LIMITED_INHERITED_DATADESC( CDOTA_Ability_Invoker_ColdSnap, CDOTA_Ability_Invoker_InvokedBase, "invoker_cold_snap" );
public:
	DECLARE_NETWORKCLASS();

	void OnSpellStart( void );

	virtual float GetCooldown( int iLevel = -1 );

	virtual const char *GetAssociatedSecondaryAbilities( void ) OVERRIDE { return "invoker_wex;invoker_quas;invoker_exort"; }
};

IMPLEMENT_NETWORKCLASS_ALIASED( DOTA_Ability_Invoker_ColdSnap, DT_DOTA_Unit_Ability_Invoker_ColdSnap )

BEGIN_NETWORK_TABLE( CDOTA_Ability_Invoker_ColdSnap, DT_DOTA_Unit_Ability_Invoker_ColdSnap )
END_NETWORK_TABLE()

LINK_ENTITY_TO_CLASS( invoker_cold_snap, CDOTA_Ability_Invoker_ColdSnap );


//-----------------------------------------------------------------------------

float CDOTA_Ability_Invoker_ColdSnap::GetCooldown( int iLevel )
{
	float flCooldown = BaseClass::GetCooldown( iLevel );

	CDOTABaseAbility *pAbility = GetCaster() ? GetCaster()->FindAbilityByName( "special_bonus_unique_invoker_9" ) : nullptr;
	if ( pAbility && pAbility->GetLevel() > 0 )
	{
		flCooldown -= pAbility->GetLevelSpecialValueFor<int>( "value", 1, true );
	}

	return flCooldown;
}

//-----------------------------------------------------------------------------

void CDOTA_Ability_Invoker_ColdSnap::OnSpellStart( void )
{
#ifdef SERVER_DLL
	CDOTA_BaseNPC *pTarget = ToDOTABaseNPC( GetCursorTarget() );
	if ( pTarget && !pTarget->IsInvulnerable() && !pTarget->IsMagicImmune() && !pTarget->TriggerSpellAbsorb( this ) )
	{
		float flDuration = GetLevelSpecialValueFor< float >( "duration", GetQuasLevel() );
		
		CDOTABaseAbility *pSpecialAbility = GetCaster() ? GetCaster()->FindAbilityByName( "special_bonus_unique_invoker_7" ) : nullptr;
		if ( pSpecialAbility && pSpecialAbility->GetLevel() > 0 )
		{
			flDuration += pSpecialAbility->GetLevelSpecialValueFor<float>( "value", 1, true );
		}

		KeyValues kv( "modifier_invoker_cold_snap" );
		kv.SetFloat( "duration", flDuration );
		kv.SetInt( "quas_level", GetQuasLevel() );
		pTarget->AddNewModifier( GetCaster(), this, "modifier_invoker_cold_snap", &kv, NULL, true );
		pTarget->UnitEmitSound( "Hero_Invoker.ColdSnap" );
	}

	GetCaster()->StartGesture( ACT_DOTA_CAST_COLD_SNAP );
	GetCaster()->UnitEmitSound( "Hero_Invoker.ColdSnap.Cast" );
#endif
}
]]

