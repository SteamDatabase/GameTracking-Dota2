// MGetKV3ClassDefaults = {
//	"m_strNameInMap": "",
//	"m_flSpeed": 0.000000,
//	"m_vPathOffset":
//	[
//		0.000000,
//		0.000000,
//		0.000000
//	],
//	"m_vecPathEvents":
//	[
//	]
//}
// MVDataRoot
class CShmupPathDefinition
{
	// MPropertyDescription = "Name of the path entity in the map."
	CUtlString m_strNameInMap;
	// MPropertyDescription = "Speed in units/second."
	float32 m_flSpeed;
	Vector m_vPathOffset;
	CUtlVector< CShmupPathEvent > m_vecPathEvents;
};
