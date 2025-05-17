// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
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
