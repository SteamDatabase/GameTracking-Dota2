class CDOTA_Ability_KeeperOfTheLight_Illuminate
{
	CHandle< CBaseEntity > m_hThinker;
	GameTime_t m_fStartTime;
	int32 m_iProjectile;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndexB;
	Vector m_vPos;
	int32 total_damage;
	bool m_bStarted;
};
