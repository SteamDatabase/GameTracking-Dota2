class CDOTAOverworldDefinition
{
	CUtlString generic_data_type;
	OverworldID_t m_unID;
	CUtlString m_sKey;
	EEvent m_eAssociatedEvent;
	CUtlString m_sNodeUnlockEventAction;
	Vector2D m_vGridOffset;
	uint32 m_unGridSize;
	uint32 m_unMapWidth;
	uint32 m_unMapHeight;
	CUtlString m_sMapVisualsXmlPath;
	OverworldNodeID_t m_unStartNodeID;
	OverworldNodeID_t m_unEndNodeID;
	CUtlString m_sVisualNovelName;
	CUtlString m_sTokenLocStringPrefix;
	CUtlString m_sActNumberLocString;
	CUtlString m_sActTitleLocString;
	item_definition_index_t m_unPremiumItemDef;
	item_definition_index_t m_unFullCompletionItemDef;
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
}
