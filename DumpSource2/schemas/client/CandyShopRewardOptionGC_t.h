// MGetKV3ClassDefaults = {
//	"m_unRewardOptionID": 0,
//	"m_unRewardOptionMaxCount": 0,
//	"m_unCandyPrice": 0,
//	"m_unWeight": 0,
//	"m_eOptionType": "k_eCandyShopRewardOptionType_SingleItem",
//	"m_unSingleItemDef": 0,
//	"m_sLootList": "",
//	"m_eEvent": "EVENT_ID_NONE",
//	"m_unEventActionID": 0,
//	"m_unEventPoints": 0
//}
// MPropertyAutoExpandSelf
class CandyShopRewardOptionGC_t
{
	// MPropertyDescription = "A unique ID for this reward option.  Must match the ID in CandyShopRewardOption_t"
	CandyShopRewardOptionID_t m_unRewardOptionID;
	// MPropertyDescription = "The maximum number of this reward option to grant. 0 means infinite"
	uint32 m_unRewardOptionMaxCount;
	// MPropertyDescription = "How many candy does it cost for one of these rewards"
	uint32 m_unCandyPrice;
	// MPropertyDescription = "what are the odds that this option will be picked compared to other options"
	uint32 m_unWeight;
	// MPropertyDescription = "how should rewards for this option be generated?"
	ECandyShopRewardOptionType m_eOptionType;
	// MPropertyDescription = "For k_eCandyShopRewardOptionType_SingleItem, what is the item def."
	// MPropertySuppressExpr = "m_eOptionType != k_eCandyShopRewardOptionType_SingleItem"
	item_definition_index_t m_unSingleItemDef;
	// MPropertyDescription = "For k_eCandyShopRewardOptionType_LootList, what is the loot list to get the reward from."
	// MPropertySuppressExpr = "m_eOptionType != k_eCandyShopRewardOptionType_LootList"
	CUtlString m_sLootList;
	// MPropertyDescription = "For k_eCandyShopRewardOptionType_SingleEventAction, what is the event id for the action."
	// MPropertySuppressExpr = "m_eOptionType != k_eCandyShopRewardOptionType_SingleEventAction && m_eOptionType != k_eCandyShopRewardOptionType_EventPoints"
	EEvent m_eEvent;
	// MPropertyDescription = "For k_eCandyShopRewardOptionType_SingleEventAction, what is the action id for the action."
	// MPropertySuppressExpr = "m_eOptionType != k_eCandyShopRewardOptionType_SingleEventAction"
	uint32 m_unEventActionID;
	// MPropertyDescription = "For k_eCandyShopRewardOptionType_EventPoints, what is the amount of event points."
	// MPropertySuppressExpr = "m_eOptionType != k_eCandyShopRewardOptionType_EventPoints"
	uint32 m_unEventPoints;
};
