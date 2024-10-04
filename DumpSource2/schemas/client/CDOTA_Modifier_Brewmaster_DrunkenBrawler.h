class CDOTA_Modifier_Brewmaster_DrunkenBrawler : public CDOTA_Buff
{
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndexB;
	int32 min_movement;
	int32 max_movement;
	int32 m_iMovementBonus;
	GameTime_t m_flNextUpdateTime;
};
