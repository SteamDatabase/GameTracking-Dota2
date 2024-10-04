class CDOTA_Modifier_Hoodwink_Bushwhack_Trap : public CDOTA_Buff
{
	int32 visual_height;
	float32 animation_rate;
	ParticleIndex_t m_nFXIndex;
	bool m_bPullComplete;
	uint32 m_TreeId;
	float32 m_flDamagePerTick;
	int32 m_nDamageTicks;
	GameTime_t m_flLastTick;
	CHandle< CDOTA_TempTree > m_hTree;
	CDOTA_Tree* m_pTree;
	Vector m_vPullPosition;
	Vector m_vDir;
}
