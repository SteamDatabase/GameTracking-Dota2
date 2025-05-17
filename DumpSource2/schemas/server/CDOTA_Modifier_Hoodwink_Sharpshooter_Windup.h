class CDOTA_Modifier_Hoodwink_Sharpshooter_Windup : public CDOTA_Buff
{
	bool m_bReachedMax;
	float32 m_flLastOverheadTime;
	float32 m_flFacingTarget;
	Vector m_vAimTarget;
	ParticleIndex_t m_nCrosshairFX;
	CUtlVector< CHandle< CBaseEntity > > m_vecVisionThinkers;
	float32 arrow_vision;
	float32 max_charge_time;
	float32 turn_rate;
	float32 base_power;
};
