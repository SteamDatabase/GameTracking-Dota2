class CDOTA_Modifier_FacelessVoid_TimeDilation_Slow : public CDOTA_Buff
{
	ParticleIndex_t m_nFXIndex;
	int32 m_nAffectedAbilities;
	GameTime_t m_flLastDamageTime;
	int32 slow;
	int32 cooldown_percentage;
	int32 damage_per_stack;
	int32 base_damage;
}
