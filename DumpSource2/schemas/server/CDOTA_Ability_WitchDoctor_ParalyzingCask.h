class CDOTA_Ability_WitchDoctor_ParalyzingCask : public CDOTABaseAbility
{
	int32 m_iBounces;
	int32 bounces;
	int32 bounce_bonus_damage;
	CUtlVector< CHandle< CBaseEntity > > m_vecHitHeroes;
};
