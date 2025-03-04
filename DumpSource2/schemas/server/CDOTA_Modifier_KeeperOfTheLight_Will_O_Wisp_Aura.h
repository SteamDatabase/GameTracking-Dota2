class CDOTA_Modifier_KeeperOfTheLight_Will_O_Wisp_Aura
{
	float32 radius;
	float32 wisp_damage;
	float32 off_duration;
	float32 off_duration_initial;
	float32 on_duration;
	int32 hit_count;
	int32 m_iAttackCount;
	GameTime_t m_flNextTimeOn;
	bool m_bActive;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndexB;
	GameTime_t m_flNextTime;
	CUtlVector< CHandle< CBaseEntity > > m_vecDamagedEntities;
	float32 m_flCorrectionTime;
};
