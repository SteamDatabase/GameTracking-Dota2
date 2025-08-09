// MGetKV3ClassDefaults = {
//	"m_unShapeID": 0,
//	"m_eShapeBehavior": "k_eFantasyShapeBehavior_Invalid",
//	"m_sLocName": "",
//	"m_sLocExplanation": ""
//}
// MPropertyAutoExpandSelf
class FantasyCraftingShapeData_t
{
	// MPropertyDescription = "Unique identifier for the Shape"
	FantasyGemShape_t m_unShapeID;
	// MPropertyDescription = "Maps the shape to it's code behavior."
	EFantasyShapeBehavior m_eShapeBehavior;
	// MPropertyDescription = "Localization token for the name of the shape"
	CUtlString m_sLocName;
	// MPropertyDescription = "Localization token for explaining what the shape does"
	CUtlString m_sLocExplanation;
};
