class CDOTA_Modifier_Item_ManaclesOfPower_Effect : public CDOTA_Buff
{
	CHandle< C_BaseEntity > m_hPartner;
	ParticleIndex_t m_nFXIndex;
	float32 leash_distance;
	float32 leash_limit_multiplier;
	CHandle< C_BaseEntity > m_hAnchor;
}
