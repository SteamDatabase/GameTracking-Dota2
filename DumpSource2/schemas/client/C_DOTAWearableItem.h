class C_DOTAWearableItem : public C_EconWearable
{
	bool m_bOwnerModelChanged;
	bool m_bIsGeneratingEconItem;
	bool m_bIsItemVisibleOnGeneratedEntity;
	bool m_bHideWearableButDrawAdditionalWearables;
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
