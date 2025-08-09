// MGetKV3ClassDefaults = {
//	"m_flDelay": 0.000000,
//	"m_strEventName": "",
//	"m_bPathFlipped": false,
//	"m_bInvertColors": false,
//	"m_nCount": 1,
//	"m_flRepeatInterval": 0.000000,
//	"m_vOffset":
//	[
//		0.000000,
//		0.000000,
//		0.000000
//	],
//	"m_vRepeatOffset":
//	[
//		0.000000,
//		0.000000,
//		0.000000
//	],
//	"m_children":
//	[
//	]
//}
// MVDataRoot
class CShmupEventTime
{
	float32 m_flDelay;
	CUtlString m_strEventName;
	bool m_bPathFlipped;
	bool m_bInvertColors;
	int32 m_nCount;
	float32 m_flRepeatInterval;
	Vector m_vOffset;
	Vector m_vRepeatOffset;
	CUtlVector< CShmupEventTime > m_children;
};
