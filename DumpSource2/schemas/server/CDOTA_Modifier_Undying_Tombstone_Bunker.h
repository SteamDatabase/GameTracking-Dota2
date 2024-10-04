class CDOTA_Modifier_Undying_Tombstone_Bunker : public CDOTA_Buff
{
	float32 bunker_heal_pct;
	float32 tombstone_grab_radius;
	float32 tombstone_stun_penalty;
	CHandle< CBaseEntity > m_hLoadedUnit;
	ParticleIndex_t m_nBunkerEnterFXIndex;
};
