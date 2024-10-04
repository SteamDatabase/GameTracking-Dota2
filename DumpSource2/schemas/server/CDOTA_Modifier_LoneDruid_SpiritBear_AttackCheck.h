class CDOTA_Modifier_LoneDruid_SpiritBear_AttackCheck : public CDOTA_Buff
{
	bool m_bCanBeResummoned;
	bool m_bCanAttack;
	ParticleIndex_t m_nFxIndex;
	ParticleIndex_t m_nStatusFxIndex;
	int32 bear_attack_leash_range;
}
