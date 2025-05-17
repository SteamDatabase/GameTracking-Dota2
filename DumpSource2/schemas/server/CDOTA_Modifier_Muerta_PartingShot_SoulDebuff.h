class CDOTA_Modifier_Muerta_PartingShot_SoulDebuff : public CDOTA_Buff
{
	int32 ethereal_damage_bonus;
	int32 movement_slow;
	CHandle< CBaseEntity > m_hPhysicalBody;
	ParticleIndex_t m_nTetherFXIndex;
};
