class CDOTA_Modifier_Frogmen_WaterBubble : public CDOTA_Buff
{
	float32 radius;
	float32 damage_absorb;
	int32 m_nDamageAbsorbed;
	float32 heal_pct;
	GameTime_t m_flLastTickTime;
};
