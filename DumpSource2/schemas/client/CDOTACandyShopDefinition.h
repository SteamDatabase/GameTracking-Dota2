// MGetKV3ClassDefaults = {
//	"m_unCandyShopID": 0,
//	"m_sLocName": "",
//	"m_unDefaultInventorySize": <HIDDEN FOR DIFF>,
//	"m_unMaximumInventorySize": <HIDDEN FOR DIFF>,
//	"m_unDefaultRerollCharges": <HIDDEN FOR DIFF>,
//	"m_unDefaultMaxRerollCharges": <HIDDEN FOR DIFF>,
//	"m_unCandyBagItemDef": 0,
//	"m_unFixedExchangeRecipeMaxCandies": 0,
//	"m_unFixedExchangeRecipeStartDate": <HIDDEN FOR DIFF>,
//	"m_unFixedExchangeRecipeUpdateRateInSeconds": <HIDDEN FOR DIFF>,
//	"m_unFixedExchangeRecipeDefaultCount": <HIDDEN FOR DIFF>,
//	"m_unFixedExchangeRecipeMaximumCount": <HIDDEN FOR DIFF>,
//	"m_unVariableExchangeInputCandyCount": <HIDDEN FOR DIFF>,
//	"m_unVariableExchangeOutputCandyCount": <HIDDEN FOR DIFF>,
//	"m_eExpireEvent": <HIDDEN FOR DIFF>,
//	"m_unRewardSlotsDefaultCount": 26,
//	"m_sAttrLootList": "",
//	"m_sViewPageEvent": "",
//	"m_vecCandyTypes":
//	[
//	],
//	"m_vecRewardSlots":
//	[
//	],
//	"m_vecDefaultRewardOptions":
//	[
//	]
//}
// MVDataRoot
class CDOTACandyShopDefinition
{
	// MPropertyDescription = "unique integer ID of this candy shop"
	CandyShopID_t m_unCandyShopID;
	// MPropertyDescription = "localization name of the candy shop"
	CUtlString m_sLocName;
	// MPropertyDescription = "default inventory size"
	uint32 m_unDefaultInventorySize;
	// MPropertyDescription = "maximum inventory size after all expansions are unlocked"
	uint32 m_unMaximumInventorySize;
	// MPropertyDescription = "default reroll charges"
	uint32 m_unDefaultRerollCharges;
	// MPropertyDescription = "default maximum reroll charges allowed to save up (0 = unlimited)"
	uint32 m_unDefaultMaxRerollCharges;
	// MPropertyDescription = "candy bag item def"
	item_definition_index_t m_unCandyBagItemDef;
	// MPropertyDescription = "Maximum number of input or output candies for fixed exchange recipes."
	uint8 m_unFixedExchangeRecipeMaxCandies;
	// MPropertyDescription = "Start date for the fixed exchange recipes."
	uint32 m_unFixedExchangeRecipeStartDate;
	// MPropertyDescription = "Frequency of updating fixed exchange recipes in seconds."
	uint32 m_unFixedExchangeRecipeUpdateRateInSeconds;
	// MPropertyDescription = "Default number of fixed exchange recipes."
	uint8 m_unFixedExchangeRecipeDefaultCount;
	// MPropertyDescription = "Maximum number of fixed exchange recipes."
	uint8 m_unFixedExchangeRecipeMaximumCount;
	// MPropertyDescription = "Input candy count for variable exchange recipe"
	uint8 m_unVariableExchangeInputCandyCount;
	// MPropertyDescription = "Output candy count for variable exchange recipe"
	uint8 m_unVariableExchangeOutputCandyCount;
	// MPropertyDescription = "After this event expires, you can no longer interact with this candy shop."
	EEvent m_eExpireEvent;
	// MPropertyDescription = "Number of reward slots that are available by default"
	uint8 m_unRewardSlotsDefaultCount;
	// MPropertyDescription = "Loot list which contains attributes to add to all items received from this shop."
	CUtlString m_sAttrLootList;
	// MPropertyDescription = "Event to fire to view the page for this candy shop."
	CUtlString m_sViewPageEvent;
	CUtlVector< CandyShopCandyType_t > m_vecCandyTypes;
	CUtlVector< CandyShopRewardSlot_t > m_vecRewardSlots;
	CUtlVector< CandyShopRewardOption_t > m_vecDefaultRewardOptions;
};
