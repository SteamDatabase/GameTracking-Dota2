class CDOTA_Modifier_AghsFort_ShadowWaveEffectPotion : public CDOTA_Buff_Item
{
	int32 m_iCurJumpCount;
	Vector m_vCurTargetLoc;
	CUtlVector< CHandle< C_BaseEntity > > m_hHitEntities;
	float32 m_fProcChance;
	int32 m_nCastRange;
	int32 m_nBounceRadius;
	int32 m_nDamageRadius;
	int32 m_nDamage;
	int32 m_nMaxTargets;
}
