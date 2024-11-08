class CDOTA_Modifier_Kez_FalconRush : public CDOTA_Buff
{
	int32 buff_evasion_pct;
	int32 rush_speed;
	int32 rush_range;
	bool m_bInRush;
	ParticleIndex_t m_nFXIndex;
	CHandle< CBaseEntity > m_hTarget;
};
