class CDOTA_Modifier_Item_ManaclesOfPower_Effect : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hPartner;
	ParticleIndex_t m_nFXIndex;
	float32 leash_distance;
	float32 leash_limit_multiplier;
	CHandle< CBaseEntity > m_hAnchor;
}
