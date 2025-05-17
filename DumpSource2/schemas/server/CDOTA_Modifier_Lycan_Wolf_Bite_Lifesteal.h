class CDOTA_Modifier_Lycan_Wolf_Bite_Lifesteal : public CDOTA_Buff
{
	float32 creep_penalty;
	int32 lifesteal_percent;
	int32 lifesteal_range;
	CUtlVector< CHandle< CBaseEntity > > m_vecTargets;
};
