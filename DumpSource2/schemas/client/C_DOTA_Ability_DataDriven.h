class C_DOTA_Ability_DataDriven : public C_DOTABaseAbility
{
	bool m_bProcsMagicStick;
	bool m_bIsSharedWithTeammates;
	bool m_bCastFilterRejectCaster;
	float32 m_fAOERadius;
	int32 m_CastAnimation;
	CUtlVector< KeyValues* > m_ModifierKVDescriptions;
	KeyValues* m_pOnChannelFinishKV;
	KeyValues* m_pOnChannelSucceededKV;
	KeyValues* m_pOnChannelInterruptedKV;
	KeyValues* m_pOnOwnerSpawnedKV;
	KeyValues* m_pOnOwnerDiedKV;
	KeyValues* m_pOnUpgradeKV;
	KeyValues* m_pOnProjectileHitUnitKV;
	KeyValues* m_pOnProjectileFinishKV;
	KeyValues* m_pOnSpellStartKV;
	KeyValues* m_pOnAbilityPhaseStartKV;
	KeyValues* m_pOnAbilityPhaseInterruptedKV;
	KeyValues* m_pOnToggleOnKV;
	KeyValues* m_pOnToggleOffKV;
	KeyValues* m_pOnCreatedKV;
}
