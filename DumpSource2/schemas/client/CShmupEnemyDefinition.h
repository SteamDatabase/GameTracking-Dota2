class CShmupEnemyDefinition
{
	CUtlString m_strNameInMap;
	int32 m_nHealth;
	float32 m_flHitboxRadius;
	Vector m_vHitboxOffsetWS;
	int32 m_nKillScore;
	float32 m_flModelScale;
	bool m_bIsBoss;
	CUtlVector< CShmupBulletInfo > m_vecBulletPatterns;
	CUtlVector< CShmupBulletInfo > m_vecOnDeathBulletPatterns;
	CUtlVector< CShmupBulletInfo > m_vecSelfDestroyBulletPatterns;
};
