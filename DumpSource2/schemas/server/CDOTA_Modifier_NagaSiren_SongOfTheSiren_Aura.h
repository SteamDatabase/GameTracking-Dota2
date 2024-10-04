class CDOTA_Modifier_NagaSiren_SongOfTheSiren_Aura : public CDOTA_Buff
{
	float32 radius;
	int32 m_nAffectedEnemies;
	CUtlVector< CHandle< CBaseEntity > > m_vhAffectedHeroes;
}
