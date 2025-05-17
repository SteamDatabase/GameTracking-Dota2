class CDOTA_Modifier_Abaddon_AphoticShield : public CDOTA_Buff
{
	float32 radius;
	float32 damage_absorb;
	int32 regen;
	int32 m_nDamageAbsorbed;
	float32 absorb_to_damage;
	float32 absorb_damage_aoe;
	GameTime_t m_flLastTickTime;
};
