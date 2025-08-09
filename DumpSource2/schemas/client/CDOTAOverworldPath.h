// MGetKV3ClassDefaults = {
//	"m_unID": 0,
//	"m_unNodeStart": 0,
//	"m_unNodeEnd": 0,
//	"m_strPathHiddenUntilEventAction": "",
//	"m_unCost": 0,
//	"m_flCircleInvRadius": 0.000000,
//	"m_vecRequiredTokenNames":
//	[
//	]
//}
// MVDataRoot
class CDOTAOverworldPath
{
	// MVDataUniqueMonotonicInt = "_editor/next_id_path"
	// MPropertyAttributeEditor = "locked_int()"
	OverworldPathID_t m_unID;
	// MPropertyDescription = ""
	OverworldNodeID_t m_unNodeStart;
	// MPropertyDescription = ""
	OverworldNodeID_t m_unNodeEnd;
	// MPropertyDescription = "An event action used to determine."
	CUtlString m_strPathHiddenUntilEventAction;
	// MPropertyDescription = ""
	uint8 m_unCost;
	// MPropertyAttributeRange = "-1 1"
	// MPropertyDescription = "0: line, +: curve to the 'right' from node 1 to node 2, -: curve left"
	float32 m_flCircleInvRadius;
	// MPropertyDescription = ""
	CUtlVector< CUtlString > m_vecRequiredTokenNames;
};
