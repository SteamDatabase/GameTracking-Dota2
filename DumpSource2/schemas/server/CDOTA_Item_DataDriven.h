class CDOTA_Item_DataDriven : public CDOTA_Item, public CDOTA_ActionRunner
{
	bool m_bProcsMagicStick;
	bool m_bIsSharedWithTeammates;
	bool m_bCastFilterRejectCaster;
	float32 m_fAnimationPlaybackRate;
	float32 m_fAOERadius;
	CUtlVector< KeyValues* > m_ModifierKVDescriptions;
	KeyValues* m_pOnChannelFinishKV;
	KeyValues* m_pOnChannelSucceededKV;
	KeyValues* m_pOnChannelInterruptedKV;
	KeyValues* m_pOnOwnerSpawnedKV;
	KeyValues* m_pOnOwnerDiedKV;
	KeyValues* m_pOnProjectileHitUnitKV;
	KeyValues* m_pOnProjectileFinishKV;
	KeyValues* m_pOnSpellStartKV;
	KeyValues* m_pOnAbilityPhaseStartKV;
	KeyValues* m_pOnToggleOnKV;
	KeyValues* m_pOnToggleOffKV;
	KeyValues* m_pOnEquipKV;
	KeyValues* m_pOnUnequipKV;
	KeyValues* m_pOnCreatedKV;
};
