class CDOTA_Modifier_Spectre_Spectral : public CDOTA_Buff
{
	int32 speed_bonus;
	int32 radius;
	float32 linger_time;
	bool m_bSpeedBonus;
	CHandle< CBaseEntity > m_hAttackTarget;
	GameTime_t m_flLingerUntil;
	ParticleIndex_t m_nFXIndex;
};
