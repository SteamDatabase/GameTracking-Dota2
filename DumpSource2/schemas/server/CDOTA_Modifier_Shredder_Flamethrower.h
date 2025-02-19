class CDOTA_Modifier_Shredder_Flamethrower
{
	int32 length;
	int32 width;
	int32 damage_per_second;
	ParticleIndex_t m_nBeamFXIndex;
	CHandle< CBaseEntity > m_hBeamEnd;
	GameTime_t m_flLastHit;
	CUtlVector< CBaseEntity* > m_vecBurningTrees;
	CHandle< CBaseEntity > m_hTreeFireThinker;
};
