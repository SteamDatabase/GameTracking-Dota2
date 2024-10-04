class CDOTA_Modifier_Mutation_Spellcast : public CDOTA_Buff
{
	CUtlVector< CDOTABaseAbility* > m_vecAbilities;
	float32 m_fNextCastTime;
	float32 m_fCastInterval;
	float32 m_fWarningTime;
	int32 m_iNextAbility;
};
