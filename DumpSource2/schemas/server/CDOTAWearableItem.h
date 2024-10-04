class CDOTAWearableItem : public CEconWearable
{
	bool m_bOwnerModelChanged;
	bool m_bIsGeneratingEconItem;
	bool m_bIsItemVisibleOnGeneratedEntity;
	bool m_bHideWearableButDrawAdditionalWearables;
	CHandle< CBaseAnimatingActivity > m_hAdditionalWearable;
}
