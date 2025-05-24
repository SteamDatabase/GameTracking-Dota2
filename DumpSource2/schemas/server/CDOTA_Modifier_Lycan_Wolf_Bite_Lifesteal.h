class CDOTA_Modifier_Lycan_Wolf_Bite_Lifesteal : public CDOTA_Buff
{
	float32 creep_penalty;
	float32 lifesteal_percent;
	float32 lifesteal_range;
	CUtlVector< CHandle< CBaseEntity > > m_vecTargets;
};
