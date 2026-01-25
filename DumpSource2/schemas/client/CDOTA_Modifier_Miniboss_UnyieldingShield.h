class CDOTA_Modifier_Miniboss_UnyieldingShield : public CDOTA_Buff
{
	float32 damage_absorb;
	float32 regen_per_second;
	float32 regen_bonus_per_interval;
	bool smaller_shield;
	float32 m_flDamageAbsorbed;
	GameTime_t m_timeLastTick;
	ParticleIndex_t nFXIndex;
	int32 m_nVisualTeam;
};
