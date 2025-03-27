class CDOTA_Ability_WitchDoctor_DeathWard
{
	CHandle< CBaseEntity > m_hWard;
	int32 bonus_accuracy;
	int32 m_iDamage;
	int32 m_iBounceRadius;
	int32 m_iProjectileSpeed;
	GameTime_t m_fWardExpireTime;
	ParticleIndex_t m_nFXIndex;
	CUtlVector< sBounceInfo > m_BounceInfo;
};
