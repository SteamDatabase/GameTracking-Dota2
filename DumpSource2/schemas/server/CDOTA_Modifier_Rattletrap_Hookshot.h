class CDOTA_Modifier_Rattletrap_Hookshot : public CDOTA_Buff
{
	CUtlVector< CHandle< CBaseEntity > > m_hDamaged;
	CHandle< CBaseEntity > m_hTarget;
	Vector m_vStartPosition;
	int32 speed;
	float32 stun_radius;
	float32 stun_radius_ally;
	float32 cooldown_refund_ally;
	float32 damage;
	float32 duration;
	float32 ally_shield_duration;
}
