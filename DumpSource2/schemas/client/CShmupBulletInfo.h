class CShmupBulletInfo
{
	EShmupBulletPattern m_pattern;
	int32 m_nCount;
	float32 m_flSpeed;
	float32 m_flRadius;
	float32 m_flRandomTargetingOffsetMin;
	float32 m_flRandomTargetingOffsetMax;
	int32 m_nBulletsPerWave;
	float32 m_flAngleWidth;
	float32 m_flAngleOffset;
	float32 m_flSpeedPerBullet;
	float32 m_flRadiusPerBullet;
	float32 m_flAngleOffsetPerBullet;
	float32 m_flAngleOffsetPerWave;
	float32 m_flAngleStaggerPerWave;
	float32 m_flAngleSinWaveOffset;
	bool m_bSwapColorPerBullet;
	float32 m_flInterval;
	Vector2D m_vFixedDirection;
	bool m_bUseStoredPlayerLocation;
};
