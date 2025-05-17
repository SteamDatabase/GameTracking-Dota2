// MNetworkVarNames = "bool m_bCombinable"
// MNetworkVarNames = "bool m_bPermanent"
// MNetworkVarNames = "bool m_bStackable"
// MNetworkVarNames = "int m_iStackableMax"
// MNetworkVarNames = "bool m_bRecipe"
// MNetworkVarNames = "bool m_bRecipeConsumesCharges"
// MNetworkVarNames = "int m_iSharability"
// MNetworkVarNames = "bool m_bDroppable"
// MNetworkVarNames = "bool m_bPurchasable"
// MNetworkVarNames = "bool m_bSellable"
// MNetworkVarNames = "bool m_bInitiallySellable"
// MNetworkVarNames = "bool m_bForceUnsellable"
// MNetworkVarNames = "bool m_bRequiresCharges"
// MNetworkVarNames = "bool m_bKillable"
// MNetworkVarNames = "bool m_bGloballyCombinable"
// MNetworkVarNames = "bool m_bDisassemblable"
// MNetworkVarNames = "bool m_bNeverDisassemble"
// MNetworkVarNames = "bool m_bIsNeutralActiveDrop"
// MNetworkVarNames = "bool m_bIsNeutralPassiveDrop"
// MNetworkVarNames = "int m_nNeutralDropTeam"
// MNetworkVarNames = "bool m_bAlertable"
// MNetworkVarNames = "int m_iInitialCharges"
// MNetworkVarNames = "bool m_bCastOnPickup"
// MNetworkVarNames = "bool m_bOnlyPlayerHeroPickup"
// MNetworkVarNames = "bool m_bCreepHeroPickup"
// MNetworkVarNames = "bool m_bCanBeConsumed"
// MNetworkVarNames = "int m_iValuelessCharges"
// MNetworkVarNames = "int m_iCurrentCharges"
// MNetworkVarNames = "int m_iSecondaryCharges"
// MNetworkVarNames = "int m_iMaxCharges"
// MNetworkVarNames = "bool m_bCombineLocked"
// MNetworkVarNames = "bool m_bMarkForSell"
// MNetworkVarNames = "GameTime_t m_flPurchaseTime"
// MNetworkVarNames = "GameTime_t m_flAssembledTime"
// MNetworkVarNames = "bool m_bPurchasedWhileDead"
// MNetworkVarNames = "bool m_bCanBeUsedOutOfInventory"
// MNetworkVarNames = "bool m_bItemEnabled"
// MNetworkVarNames = "GameTime_t m_flEnableTime"
// MNetworkVarNames = "GameTime_t m_flReclaimTime"
// MNetworkVarNames = "bool m_bDisplayOwnership"
// MNetworkVarNames = "bool m_bShowOnMinimap"
// MNetworkVarNames = "float m_flMinimapIconSize"
// MNetworkVarNames = "bool m_bIsUpgradeable"
// MNetworkVarNames = "int m_nUpgradeProgress"
// MNetworkVarNames = "int m_nUpgradeGoal"
// MNetworkVarNames = "PlayerID_t m_iPlayerOwnerID"
// MNetworkVarNames = "uint8 m_vecPreGameTransferPlayerIDs"
class C_DOTA_Item : public C_DOTABaseAbility
{
	int32 m_CastAnimation;
	// MNetworkEnable
	bool m_bCombinable;
	// MNetworkEnable
	// MNetworkPriority = 32
	bool m_bPermanent;
	// MNetworkEnable
	// MNetworkPriority = 32
	bool m_bStackable;
	// MNetworkEnable
	// MNetworkPriority = 32
	int32 m_iStackableMax;
	// MNetworkEnable
	bool m_bRecipe;
	// MNetworkEnable
	bool m_bRecipeConsumesCharges;
	// MNetworkEnable
	// MNetworkPriority = 32
	int32 m_iSharability;
	// MNetworkEnable
	bool m_bDroppable;
	// MNetworkEnable
	bool m_bPurchasable;
	// MNetworkEnable
	bool m_bSellable;
	// MNetworkEnable
	bool m_bInitiallySellable;
	// MNetworkEnable
	bool m_bForceUnsellable;
	// MNetworkEnable
	bool m_bRequiresCharges;
	bool m_bDisplayCharges;
	bool m_bHideCharges;
	// MNetworkEnable
	bool m_bKillable;
	// MNetworkEnable
	bool m_bGloballyCombinable;
	// MNetworkEnable
	bool m_bDisassemblable;
	// MNetworkEnable
	bool m_bNeverDisassemble;
	// MNetworkEnable
	bool m_bIsNeutralActiveDrop;
	// MNetworkEnable
	bool m_bIsNeutralPassiveDrop;
	// MNetworkEnable
	int32 m_nNeutralDropTeam;
	// MNetworkEnable
	bool m_bAlertable;
	// MNetworkEnable
	// MNetworkPriority = 32
	int32 m_iInitialCharges;
	// MNetworkEnable
	bool m_bCastOnPickup;
	// MNetworkEnable
	bool m_bOnlyPlayerHeroPickup;
	// MNetworkEnable
	bool m_bCreepHeroPickup;
	// MNetworkEnable
	bool m_bCanBeConsumed;
	// MNetworkEnable
	int32 m_iValuelessCharges;
	// MNetworkEnable
	// MNetworkPriority = 32
	int32 m_iCurrentCharges;
	// MNetworkEnable
	int32 m_iSecondaryCharges;
	// MNetworkEnable
	int32 m_iMaxCharges;
	// MNetworkEnable
	bool m_bCombineLocked;
	// MNetworkEnable
	bool m_bMarkForSell;
	// MNetworkEnable
	// MNetworkPriority = 32
	GameTime_t m_flPurchaseTime;
	// MNetworkEnable
	// MNetworkPriority = 32
	GameTime_t m_flAssembledTime;
	// MNetworkEnable
	bool m_bPurchasedWhileDead;
	// MNetworkEnable
	bool m_bCanBeUsedOutOfInventory;
	// MNetworkEnable
	bool m_bItemEnabled;
	// MNetworkEnable
	// MNetworkPriority = 32
	GameTime_t m_flEnableTime;
	// MNetworkEnable
	GameTime_t m_flReclaimTime;
	// MNetworkEnable
	bool m_bDisplayOwnership;
	// MNetworkEnable
	bool m_bShowOnMinimap;
	// MNetworkEnable
	float32 m_flMinimapIconSize;
	// MNetworkEnable
	bool m_bIsUpgradeable;
	// MNetworkEnable
	int32 m_nUpgradeProgress;
	// MNetworkEnable
	int32 m_nUpgradeGoal;
	CHandle< C_BaseEntity > m_hOldOwnerEntity;
	int32 m_iOldCharges;
	// MNetworkEnable
	PlayerID_t m_iPlayerOwnerID;
	// MNetworkEnable
	C_NetworkUtlVectorBase< uint8 > m_vecPreGameTransferPlayerIDs;
};
