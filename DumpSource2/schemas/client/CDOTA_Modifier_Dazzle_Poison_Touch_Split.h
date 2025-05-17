class CDOTA_Modifier_Dazzle_Poison_Touch_Split : public CDOTA_Buff
{
	int32 m_nAttacksLanded;
	int32 attacks_to_split;
	int32 split_radius;
	ParticleIndex_t m_nFXStackIndex;
};
