// MGetKV3ClassDefaults = {
//	"m_type": "k_eShmupPathEventType_Invalid",
//	"m_nBulletPatternIndex": 0,
//	"m_flTime": -1.000000,
//	"m_flSpeed": 0.000000
//}
// MVDataRoot
class CShmupPathEvent
{
	EShmupPathEventType m_type;
	int32 m_nBulletPatternIndex;
	float32 m_flTime;
	// MPropertySuppressExpr = "m_type != k_eShmupPathEventType_Speed"
	float32 m_flSpeed;
};
