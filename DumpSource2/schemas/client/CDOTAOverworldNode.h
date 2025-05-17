// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class CDOTAOverworldNode
{
	// MVDataUniqueMonotonicInt = "_editor/next_id_node"
	// MPropertyAttributeEditor = "locked_int()"
	OverworldNodeID_t m_unID;
	Vector2D m_vPos;
	// MPropertyDescription = "A css class to be applied to the node."
	CUtlString m_sCustomClass;
	// MPropertyDescription = "Name/Key used to look up which Visual Novel dialogue to use."
	CUtlString m_sDialogueName;
	CUtlString m_sRewardEventAction;
	// MPropertyDescription = "If defined, this node and the path to it are invisible and unreachable to players unless they own a specific event action."
	CUtlString m_sHiddenWithoutEventAction;
	CUtlString m_sJSEvent;
	float32 m_flUnlockDelay;
	bool m_bSkipGrantingRewardOnUnlock;
	EOverworldNodeFlags m_eNodeFlags;
	CUtlString m_sEncounterName;
	// MPropertyDescription = "CSS Classes that will be applied to the map when this node is unlocked."
	CUtlVector< CUtlString > m_vecUnlockMapClasses;
	// MPropertyDescription = "CSS Classes that will be applied to the map when this node is being visited, and removed when leaving it."
	CUtlVector< CUtlString > m_vecVisitMapClasses;
};
