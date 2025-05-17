class CDOTA_Modifier_Centaur_Stampede : public CDOTA_Buff
{
	float32 radius;
	int32 damage_reduction;
	int32 has_flying_movement;
	CUtlVector< CHandle< CBaseEntity > > m_hEntitiesAffected;
};
