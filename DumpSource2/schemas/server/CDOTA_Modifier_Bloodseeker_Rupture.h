class CDOTA_Modifier_Bloodseeker_Rupture : public CDOTA_Buff
{
	int32 movement_damage_pct;
	float32 hp_pct;
	Vector vLastPos;
	bool bResetPosition;
	float32 knockback;
	float32 knockback_duration;
	float32 m_fAccumulatedDamage;
}
