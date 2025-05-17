// MNetworkExcludeByUserGroup = "m_flCycle"
// MNetworkExcludeByName = "m_flAnimTime"
// MNetworkExcludeByUserGroup = "m_flPoseParameter"
// MNetworkExcludeByUserGroup = "overlay_vars"
// MNetworkExcludeByName = "m_flexWeight"
// MNetworkExcludeByName = "m_blinktoggle"
// MNetworkExcludeByName = "m_vLookTargetPosition"
// MNetworkExcludeByName = "m_baseLayer.m_hSequence"
// MNetworkExcludeByName = "m_nForceBone"
// MNetworkExcludeByName = "m_vecForce"
// MNetworkExcludeByName = "m_nHitboxSet"
// MNetworkExcludeByName = "m_flEncodedController"
// MNetworkExcludeByName = "m_flSimulationTime"
// MNetworkExcludeByName = "m_angRotation"
// MNetworkExcludeByName = "m_vecOrigin"
// MNetworkExcludeByName = "m_cellX"
// MNetworkExcludeByName = "m_cellY"
// MNetworkExcludeByName = "m_cellZ"
// MNetworkExcludeByName = "m_vecSpecifiedSurroundingMaxs"
// MNetworkExcludeByName = "m_vecSpecifiedSurroundingMins"
// MNetworkExcludeByName = "m_vecMaxs"
// MNetworkExcludeByName = "m_vecMins"
// MNetworkExcludeByName = "m_hOwnerEntity"
// MNetworkExcludeByName = "m_hParent"
// MNetworkExcludeByName = "m_flCreateTime"
// MNetworkExcludeByName = "CAttributeManager::m_hOuter"
// MNetworkExcludeByName = "VPhysicsCollisionAttribute_t::m_nEntityId"
// MNetworkExcludeByName = "VPhysicsCollisionAttribute_t::m_nOwnerId"
// MNetworkExcludeByName = "VPhysicsCollisionAttribute_t::m_nHierarchyId"
// MNetworkExcludeByName = "CEconItemView::m_iInventoryPosition"
// MNetworkVarNames = "bool m_bOwnerModelChanged"
// MNetworkVarNames = "bool m_bIsGeneratingEconItem"
// MNetworkVarNames = "bool m_bIsItemVisibleOnGeneratedEntity"
// MNetworkVarNames = "bool m_bHideWearableButDrawAdditionalWearables"
// MNetworkVarNames = "CHandle< CBaseAnimating> m_hAdditionalWearable"
class C_DOTAWearableItem : public C_EconWearable
{
	// MNetworkEnable
	bool m_bOwnerModelChanged;
	// MNetworkEnable
	bool m_bIsGeneratingEconItem;
	// MNetworkEnable
	bool m_bIsItemVisibleOnGeneratedEntity;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnHideWearableButDrawAdditionalWearablesChanged"
	bool m_bHideWearableButDrawAdditionalWearables;
	// MNetworkEnable
	CHandle< CBaseAnimatingActivity > m_hAdditionalWearable;
	CHandle< C_DOTAWearableItem > m_hDrawWearable;
	bool m_bHiddenByCombiner;
	bool m_bHiddenByEquipmentSlot;
	bool m_bIsPortrait;
	float32 m_fZDelta;
	CUtlVector< CStrongHandleCopyable< InfoForResourceTypeIMaterial2 > > m_combinerMaterialOverrideList;
	bool m_bCombinerMaterialOverrideListChanged;
	bool m_bRubickFollower;
	bool m_bHasPlayerModel;
};
