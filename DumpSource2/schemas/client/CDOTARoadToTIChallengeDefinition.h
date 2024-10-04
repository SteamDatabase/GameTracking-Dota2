class CDOTARoadToTIChallengeDefinition
{
	EEvent m_eEvent;
	uint32 m_unTotalQuestPeriods;
	uint32 m_unHeroesPerQuest;
	CUtlVector< uint32 > m_vecQuestPattern;
	item_definition_index_t m_unCullingBladeItemDef;
	item_definition_index_t m_unRerollItemDef;
	CUtlVector< RoadToTIQuestDefinition_t > m_vecQuests;
};
