class CDOTA_Modifier_Animation_TailSpin : public CDOTA_Buff
{
	int32 damage;
	int32 damage_radius;
	float32 m_flPlaybackRate;
	CUtlVector< CHandle< CBaseEntity > > m_vHitEntities;
};
