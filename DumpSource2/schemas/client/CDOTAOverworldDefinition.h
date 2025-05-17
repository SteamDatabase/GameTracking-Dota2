// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
// MVDataSingleton
class CDOTAOverworldDefinition
{
	CUtlString generic_data_type;
	// MPropertyDescription = ""
	OverworldID_t m_unID;
	// MPropertyDescription = ""
	CUtlString m_sKey;
	// MPropertyDescription = "The event related to this overworld. Used for rewards and expiration."
	EEvent m_eAssociatedEvent;
	// MPropertyDescription = "An event action to grant whenever a node is unlocked."
	CUtlString m_sNodeUnlockEventAction;
	Vector2D m_vGridOffset;
	uint32 m_unGridSize;
	uint32 m_unMapWidth;
	uint32 m_unMapHeight;
	CUtlString m_sMapVisualsXmlPath;
	// MPropertyDescription = ""
	CUtlVector< OverworldNodeID_t > m_vecStartNodeIds;
	// MPropertyDescription = ""
	OverworldNodeID_t m_unEndNodeID;
	// MPropertyDescription = "Name/key of the Visual Novel associated with this map."
	CUtlString m_sVisualNovelName;
	// MPropertyDescription = "Prefix to combine with tokent names to give their loc strings."
	CUtlString m_sTokenLocStringPrefix;
	// MPropertyDescription = "Act number loc string, e.g. Act I."
	CUtlString m_sActNumberLocString;
	// MPropertyDescription = "Act title loc string, e.g. The Eyrie."
	CUtlString m_sActTitleLocString;
	// MPropertyDescription = ""
	item_definition_index_t m_unPremiumItemDef;
	// MPropertyDescription = ""
	item_definition_index_t m_unFullCompletionItemDef;
	// MPropertyDescription = "ID of the scrap token rewarded for playing matches."
	OverworldTokenID_t m_unScrapTokenID;
	CUtlVector< CDOTAEventActionTrigger > m_vecEventActionTriggers;
	CUtlVector< CDOTAEventActionGrantAndClaimPairTrigger > m_vecEventActionGrantAndClaimPairTriggers;
	CUtlVector< CDOTAOverworldPathColorRule > m_vecPathColorRules;
	CUtlVector< CDOTAOverworldToken* > m_vecTokenTypes;
	CUtlVector< CDOTAOverworldHeroReward* > m_vecHeroRewards;
	CUtlVector< CDOTAOverworldNode* > m_vecNodes;
	CUtlVector< CDOTAOverworldPath* > m_vecPaths;
	CUtlVector< CDOTAOverworldEncounter* > m_vecEncounters;
	CUtlVector< CDOTAOverworldHero* > m_vecHeroes;
	CUtlVector< CDOTAOverworldCharacter* > m_vecCharacters;
	CUtlVector< CDOTAOverworldClickable* > m_vecClickables;
};
