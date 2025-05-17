// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
// MVDataSingleton
// MVDataPreviewWidget (UNKNOWN FOR PARSER)
// MCustomFGDMetadata = "{ promote_children=[ { key="_editor" mode="ARRAY_OF_MULTIPLE" class="blessing_editor_guide" promotion_mode="VDATA_PROMOTE_AS_CHILD_NODE" }, ] }"
class CDOTALabyrinthBlessingsMap
{
	CUtlString m_strBlessingEventAction;
	// MPropertyAttributeEditor = "locked_int()"
	BlessingTypeID_t m_nNextBlessingTypeID;
	// MPropertyAttributeEditor = "locked_int()"
	BlessingID_t m_nNextBlessingID;
	// MPropertyAttributeEditor = "VDataNodePicker(//m_mapBlessingTypes/*)"
	CUtlString m_UnlockHeroBlessingType;
	CUtlVector< CUtlString > m_vecHeroNames;
	int32 m_nNumStartingHeroesUnlocked;
	// MPropertyAttributeEditor = "VDataNodePicker(//m_mapBlessingTypes/*)"
	CUtlString m_UnlockLegacyHeroBlessingType;
	CUtlVector< CUtlString > m_vecLegacyHeroNames;
	int32 m_nNumStartingLegacyHeroesUnlocked;
	// MVDataPromoteField (UNKNOWN FOR PARSER)
	CUtlDict< BlessingType_t > m_mapBlessingTypes;
	// MVDataPromoteField (UNKNOWN FOR PARSER)
	CUtlDict< Blessing_t > m_mapBlessings;
	// MVDataPromoteField (UNKNOWN FOR PARSER)
	CUtlVector< BlessingPath_t > m_vecPaths;
};
