class CDOTA_Modifier_Animation_LeftClawSwipe : public CDOTA_Buff
{
	int32 damage;
	int32 damage_radius;
	float32 m_flScalar;
	CUtlVector< CHandle< CBaseEntity > > m_vHitEntities;
};
