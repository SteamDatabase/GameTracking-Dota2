// MGetKV3ClassDefaults = {
//	"m_eEvent": 964631232,
//	"m_unTotalQuestPeriods": 21920,
//	"m_unHeroesPerQuest": 2800943360,
//	"m_vecQuestPattern":
//	[
//	],
//	"m_unCullingBladeItemDef": 0,
//	"m_unRerollItemDef": 0,
//	"m_vecQuests":
//	[
//	]
//}
// MVDataRoot
class CDOTARoadToTIChallengeDefinition
{
	// MPropertyDescription = "Event ID that the challenge is for"
	EEvent m_eEvent;
	// MPropertyDescription = "Total Quest Periods within the challenge"
	uint32 m_unTotalQuestPeriods;
	// MPropertyDescription = "Number of hero options expected in each quest."
	uint32 m_unHeroesPerQuest;
	// MPropertyDescription = "A list of quest difficulties. This defines the pattern for each period and total quests per period. Eg [1, 1, 2] would mean every period has 3 quests (two easy, then one medium)."
	CUtlVector< uint32 > m_vecQuestPattern;
	// MPropertyDescription = "Item def for Culling Blade item"
	item_definition_index_t m_unCullingBladeItemDef;
	// MPropertyDescription = "Item def for Reroll Token item"
	item_definition_index_t m_unRerollItemDef;
	// MPropertyDescription = "The quests in the challenge"
	CUtlVector< RoadToTIQuestDefinition_t > m_vecQuests;
};
