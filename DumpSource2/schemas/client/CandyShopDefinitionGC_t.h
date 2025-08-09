// MGetKV3ClassDefaults = {
//	"m_unCandyShopID": 0,
//	"m_vecRewards":
//	[
//	]
//}
// MPropertyAutoExpandSelf
class CandyShopDefinitionGC_t
{
	// MPropertyDescription = "unique integer ID of this candy shop"
	CandyShopID_t m_unCandyShopID;
	CUtlVector< CandyShopRewardOptionGC_t > m_vecRewards;
};
