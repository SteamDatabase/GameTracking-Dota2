class CDOTA_Modifier_Pangolier_ShieldCrash_Buff : public CDOTA_Buff
{
	ParticleIndex_t m_nFXIndex;
	int32 m_nAbsorbRemaining;
	int32 hero_shield;
	int32 base_shield;
	int32 accumulated_value;
	float32 effectiveness_pct;
	GameTime_t m_flLastParryTime;
};
