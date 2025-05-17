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
// MNetworkVarNames = "bool m_bCanBeUsedOutOfInventory"
// MNetworkVarNames = "bool m_bItemEnabled"
// MNetworkVarNames = "GameTime_t m_flEnableTime"
// MNetworkVarNames = "GameTime_t m_flReclaimTime"
// MNetworkVarNames = "bool m_bCanBeConsumed"
// MNetworkVarNames = "bool m_bDisplayOwnership"
// MNetworkVarNames = "bool m_bShowOnMinimap"
// MNetworkVarNames = "float m_flMinimapIconSize"
// MNetworkVarNames = "bool m_bIsUpgradeable"
// MNetworkVarNames = "int m_nUpgradeProgress"
// MNetworkVarNames = "int m_nUpgradeGoal"
// MNetworkVarNames = "uint8 m_vecPreGameTransferPlayerIDs"
// MNetworkVarNames = "GameTime_t m_flPurchaseTime"
// MNetworkVarNames = "GameTime_t m_flAssembledTime"
// MNetworkVarNames = "int m_iCurrentCharges"
// MNetworkVarNames = "int m_iValuelessCharges"
// MNetworkVarNames = "int m_iSecondaryCharges"
// MNetworkVarNames = "bool m_bCombineLocked"
// MNetworkVarNames = "bool m_bMarkForSell"
// MNetworkVarNames = "PlayerID_t m_iPlayerOwnerID"
// MNetworkVarNames = "bool m_bPurchasedWhileDead"
class CDOTA_Item : public CDOTABaseAbility
{
	int32 m_iState;
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
	// MNetworkEnable
	bool m_bKillable;
	// MNetworkEnable
	bool m_bGloballyCombinable;
	// MNetworkEnable
	bool m_bDisassemblable;
	// MNetworkEnable
	bool m_bNeverDisassemble;
	bool m_bIsTempestDoubleClonable;
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
	bool m_bCanBeUsedOutOfInventory;
	// MNetworkEnable
	bool m_bItemEnabled;
	// MNetworkEnable
	// MNetworkPriority = 32
	GameTime_t m_flEnableTime;
	// MNetworkEnable
	GameTime_t m_flReclaimTime;
	// MNetworkEnable
	bool m_bCanBeConsumed;
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
	// MNetworkEnable
	CNetworkUtlVectorBase< uint8 > m_vecPreGameTransferPlayerIDs;
	bool m_bStackWithOtherOwners;
	bool m_bTemporarilyUncombinable;
	bool m_bHasCommentedOnEquip;
	int32 m_iDeclarationFlags;
	bool m_bCreatedByDisassemble;
	bool m_bHasMixedOwnership;
	bool m_bIsClonedItemProxy;
	bool m_bNeutralItemRequestDrop;
	// MNetworkEnable
	// MNetworkPriority = 32
	GameTime_t m_flPurchaseTime;
	// MNetworkEnable
	GameTime_t m_flAssembledTime;
	// MNetworkEnable
	// MNetworkPriority = 32
	int32 m_iCurrentCharges;
	// MNetworkEnable
	int32 m_iValuelessCharges;
	// MNetworkEnable
	int32 m_iSecondaryCharges;
	// MNetworkEnable
	bool m_bCombineLocked;
	// MNetworkEnable
	bool m_bMarkForSell;
	CHandle< CDOTA_Item_Physical > m_hContainer;
	// MNetworkEnable
	PlayerID_t m_iPlayerOwnerID;
	// MNetworkEnable
	bool m_bPurchasedWhileDead;
	int32 m_nCombineVersion;
};
