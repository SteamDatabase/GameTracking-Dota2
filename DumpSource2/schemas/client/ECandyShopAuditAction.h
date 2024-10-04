enum ECandyShopAuditAction : uint32_t
{
	k_ECandyShopAuditAction_Invalid = 0,
	k_ECandyShopAuditAction_SupportModify = 1,
	k_ECandyShopAuditAction_PurchaseReward = 2,
	k_ECandyShopAuditAction_OpenBags = 3,
	k_ECandyShopAuditAction_RerollRewards = 4,
	k_ECandyShopAuditAction_DoVariableExchange = 5,
	k_ECandyShopAuditAction_DoExchange = 6,
	k_ECandyShopAuditAction_DEPRECATED_EventActionGrantInventorySizeIncrease = 7,
	k_ECandyShopAuditAction_EventActionGrantRerollChargesIncrease = 8,
	k_ECandyShopAuditAction_EventActionGrantUpgrade_InventorySize = 100,
	k_ECandyShopAuditAction_EventActionGrantUpgrade_RewardShelf = 101,
	k_ECandyShopAuditAction_EventActionGrantUpgrade_ExtraExchangeRecipe = 102,
};
