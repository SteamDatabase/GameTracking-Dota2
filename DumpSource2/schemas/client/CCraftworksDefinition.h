// MGetKV3ClassDefaults = {
//	"m_sName": "",
//	"m_unCraftworksID": 0,
//	"m_eAssociatedEvent": "EVENT_ID_NONE",
//	"m_vecComponents":
//	[
//	],
//	"m_vecRecipeTiers":
//	[
//	],
//	"m_vecRecipes":
//	[
//	],
//	"m_vecQuests":
//	[
//	]
//}
// MVDataRoot
class CCraftworksDefinition
{
	CUtlString m_sName;
	CraftworksID_t m_unCraftworksID;
	EEvent m_eAssociatedEvent;
	CUtlVector< CCraftworksComponentDefinition > m_vecComponents;
	CUtlVector< CCraftworksRecipeTierDefinition > m_vecRecipeTiers;
	CUtlVector< CCraftworksRecipeDefinition > m_vecRecipes;
	CUtlVector< CCraftworksQuestDefinition > m_vecQuests;
};
