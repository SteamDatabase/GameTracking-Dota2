class CDOTA_Ability_Zuus_Thunder_Trail : public CDOTABaseAbility
{
	CUtlVector< CHandle< CBaseEntity > > hAlreadyHitList;
	int32 damage;
	int32 debuff_spell_amp_min;
	int32 debuff_spell_amp_max;
	Vector m_vStartPos;
	int32 m_nMaxRange;
};
