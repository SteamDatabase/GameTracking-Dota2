// MGetKV3ClassDefaults = {
//	"m_pattern": "k_eShmupBulletPattern_Invalid",
//	"m_nCount": 1,
//	"m_flSpeed": 150.000000,
//	"m_flRadius": 8.000000,
//	"m_flRandomTargetingOffsetMin": 0.000000,
//	"m_flRandomTargetingOffsetMax": 0.000000,
//	"m_nBulletsPerWave": 6,
//	"m_flAngleWidth": 0.080000,
//	"m_flAngleOffset": 0.000000,
//	"m_flSpeedPerBullet": 0.000000,
//	"m_flRadiusPerBullet": 0.000000,
//	"m_flAngleOffsetPerBullet": 0.000000,
//	"m_flAngleOffsetPerWave": 0.000000,
//	"m_flAngleStaggerPerWave": 0.000000,
//	"m_flAngleSinWaveOffset": 0.000000,
//	"m_bSwapColorPerBullet": false,
//	"m_flInterval": 0.000000,
//	"m_vFixedDirection":
//	[
//		-1.000000,
//		0.000000
//	],
//	"m_bUseStoredPlayerLocation": false
//}
// MVDataRoot
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
