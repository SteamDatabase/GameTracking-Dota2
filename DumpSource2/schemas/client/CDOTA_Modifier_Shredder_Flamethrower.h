class CDOTA_Modifier_Shredder_Flamethrower : public CDOTA_Buff
{
	float32 length;
	float32 width;
	float32 damage_per_second;
	ParticleIndex_t m_nBeamFXIndex;
	CHandle< C_BaseEntity > m_hBeamEnd;
	GameTime_t m_flLastHit;
	CUtlVector< C_BaseEntity* > m_vecBurningTrees;
};
