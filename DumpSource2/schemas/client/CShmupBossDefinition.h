// MGetKV3ClassDefaults = {
//	"m_vecBodyParts":
//	[
//	],
//	"m_flIntroDuration": 0.000000,
//	"m_flMouthLaserChargeTime": 0.000000,
//	"m_flMouthLaserDuration": 0.000000,
//	"m_flWingBarrageChargeTime": 0.000000,
//	"m_flWingBarrageDuration": 0.000000,
//	"m_nSplinterBlastCount": 1,
//	"m_fSplinterBlastChargeTime": 1.000000,
//	"m_flSplinterBlastDuration": 1.000000,
//	"m_flColdEmbraceDuration": 1.000000,
//	"m_vIdlePosition":
//	[
//		0.000000,
//		0.000000
//	]
//}
// MVDataRoot
class CShmupBossDefinition
{
	CUtlVector< CShmupBossBodyPart > m_vecBodyParts;
	float32 m_flIntroDuration;
	float32 m_flMouthLaserChargeTime;
	float32 m_flMouthLaserDuration;
	float32 m_flWingBarrageChargeTime;
	float32 m_flWingBarrageDuration;
	int32 m_nSplinterBlastCount;
	float32 m_fSplinterBlastChargeTime;
	float32 m_flSplinterBlastDuration;
	float32 m_flColdEmbraceDuration;
	Vector2D m_vIdlePosition;
};
