class C_DOTA_Ability_KeeperOfTheLight_Illuminate : public C_DOTABaseAbility
{
	CHandle< C_BaseEntity > m_hThinker;
	GameTime_t m_fStartTime;
	int32 m_iProjectile;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndexB;
	Vector m_vPos;
	int32 total_damage;
	bool m_bStarted;
};
