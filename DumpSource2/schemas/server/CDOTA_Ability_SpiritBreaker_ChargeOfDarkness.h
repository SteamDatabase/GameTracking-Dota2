class CDOTA_Ability_SpiritBreaker_ChargeOfDarkness : public CDOTABaseAbility
{
	bool m_bFinished;
	bool m_bInterrupted;
	bool m_bPlayedChargeAnimation;
	Vector m_vProjectileLocation;
	Vector m_vTargetLocation;
	CHandle< CBaseEntity > m_hTarget;
	CUtlVector< CHandle< CBaseEntity > > m_hTrackingProjectileHits;
	CUtlVector< CDOTA_Tree* > m_hTrackingProjectileTrees;
	int32 nFXIndex;
	int32 m_iCurProjectileIndex;
	Vector m_vChargeStartPos;
};
