class CDOTA_Modifier_Dazzle_NothlProjection_SoulDebuff : public CDOTA_Buff
{
	int32 ethereal_damage_bonus;
	int32 movement_slow;
	CHandle< C_BaseEntity > m_hPhysicalBody;
	ParticleIndex_t m_nTetherFXIndex;
};
