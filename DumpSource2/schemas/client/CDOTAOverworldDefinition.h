// MGetKV3ClassDefaults = {
//	"generic_data_type": "",
//	"m_unID": 0,
//	"m_sKey": "",
//	"m_eAssociatedEvent": 13762040,
//	"m_eProgressionType": "k_eOverworldProgressionType_NodesAndPaths",
//	"m_sNodeUnlockEventAction": "",
//	"m_vGridOffset":
//	[
//		0.000000,
//		0.000000
//	],
//	"m_unGridSize": 64,
//	"m_unMapWidth": 0,
//	"m_unMapHeight": 0,
//	"m_sMapVisualsXmlPath": "",
//	"m_vecStartNodeIds":
//	[
//	],
//	"m_unEndNodeID": 0,
//	"m_sVisualNovelName": "",
//	"m_sTokenLocStringPrefix": "",
//	"m_sActNumberLocString": "",
//	"m_sActTitleLocString": "",
//	"m_unPremiumItemDef": 0,
//	"m_unFullCompletionItemDef": 0,
//	"m_unScrapTokenID": 0,
//	"m_vecEventActionTriggers":
//	[
//	],
//	"m_vecEventActionGrantAndClaimPairTriggers":
//	[
//	],
//	"m_vecPathColorRules":
//	[
//	],
//	"m_vecTokenTypes":
//	[
//	],
//	"m_vecHeroRewards":
//	[
//	],
//	"m_vecNodes":
//	[
//	],
//	"m_vecPaths":
//	[
//	],
//	"m_vecRooms":
//	[
//	],
//	"m_vecEncounters":
//	[
//	],
//	"m_vecHeroes":
//	[
//	],
//	"m_vecCharacters":
//	[
//	],
//	"m_vecClickables":
//	[
//	]
//}
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
	EOverworldProgressionType m_eProgressionType;
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
	CUtlVector< CDOTAOverworldRoom* > m_vecRooms;
	CUtlVector< CDOTAOverworldEncounter* > m_vecEncounters;
	CUtlVector< CDOTAOverworldHero* > m_vecHeroes;
	CUtlVector< CDOTAOverworldCharacter* > m_vecCharacters;
	CUtlVector< CDOTAOverworldClickable* > m_vecClickables;
};
