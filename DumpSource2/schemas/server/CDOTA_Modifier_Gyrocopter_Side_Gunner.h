class CDOTA_Modifier_Gyrocopter_Side_Gunner : public CDOTA_Buff
{
	float32 sidegunner_radius;
	float32 sidegunner_fire_rate;
	float32 m_flRotation;
	CHandle< CBaseEntity > m_hIdealTarget;
	CHandle< CBaseEntity > m_hSecondaryTarget;
	float32 m_flLastFireTime;
	CHandle< CBaseEntity > m_hOwnerNPC;
	CHandle< CBaseEntity > m_hOwningAbility;
	int32 m_iAttackRecord;
};
