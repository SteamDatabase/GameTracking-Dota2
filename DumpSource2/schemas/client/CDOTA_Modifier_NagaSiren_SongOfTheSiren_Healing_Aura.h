class CDOTA_Modifier_NagaSiren_SongOfTheSiren_Healing_Aura : public CDOTA_Buff
{
	float32 radius;
	int32 m_nAffectedAllies;
	CUtlVector< CHandle< C_BaseEntity > > m_vhAffectedHeroes;
}
