class CDOTA_Modifier_PrimalBeast_Pulverize_Self
{
	CHandle< C_DOTA_BaseNPC > m_hTarget;
	Vector m_vPulverizeCenter;
	Vector m_vCasterStartPos;
	float32 splash_radius;
	float32 interval;
	float32 ministun;
	int32 damage;
	int32 bonus_damage_per_hit;
	int32 m_nHitCount;
	float32 bonus_aoe_duration;
};
