class CDOTA_Modifier_Shredder_Flamethrower
{
	float32 length;
	float32 width;
	float32 damage_per_second;
	ParticleIndex_t m_nBeamFXIndex;
	CHandle< CBaseEntity > m_hBeamEnd;
	GameTime_t m_flLastHit;
	CUtlVector< CBaseEntity* > m_vecBurningTrees;
	CHandle< CBaseEntity > m_hTreeFireThinker;
};
