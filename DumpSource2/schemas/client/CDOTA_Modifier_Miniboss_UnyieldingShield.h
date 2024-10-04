class CDOTA_Modifier_Miniboss_UnyieldingShield : public CDOTA_Buff
{
	int32 damage_absorb;
	float32 regen_per_second;
	float32 regen_bonus_per_death;
	int32 m_nDamageAbsorbed;
	GameTime_t m_timeLastTick;
	ParticleIndex_t nFXIndex;
};
