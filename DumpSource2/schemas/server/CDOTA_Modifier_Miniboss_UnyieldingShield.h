class CDOTA_Modifier_Miniboss_UnyieldingShield
{
	int32 damage_absorb;
	float32 regen_per_second;
	float32 regen_bonus_per_interval;
	bool smaller_shield;
	int32 m_nDamageAbsorbed;
	GameTime_t m_timeLastTick;
	ParticleIndex_t nFXIndex;
	int32 m_nVisualTeam;
};
