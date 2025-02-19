class CDOTA_Modifier_Gyrocopter_Side_Gunner
{
	float32 sidegunner_radius;
	float32 sidegunner_fire_rate;
	float32 m_flRotation;
	CHandle< C_BaseEntity > m_hIdealTarget;
	CHandle< C_BaseEntity > m_hSecondaryTarget;
	float32 m_flLastFireTime;
	CHandle< C_BaseEntity > m_hOwnerNPC;
	CHandle< C_BaseEntity > m_hOwningAbility;
};
