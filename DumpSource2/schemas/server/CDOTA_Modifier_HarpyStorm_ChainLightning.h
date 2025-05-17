class CDOTA_Modifier_HarpyStorm_ChainLightning : public CDOTA_Buff
{
	int32 jump_range;
	int32 max_targets;
	float32 damage_percent_loss;
	float32 m_flCurDamage;
	Vector m_vJumpPosition;
	CUtlVector< CHandle< CBaseEntity > > m_hHitEntities;
};
