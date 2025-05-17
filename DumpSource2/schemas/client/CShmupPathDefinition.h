// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
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
