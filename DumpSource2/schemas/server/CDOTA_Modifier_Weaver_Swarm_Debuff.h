class CDOTA_Modifier_Weaver_Swarm_Debuff : public CDOTA_Buff
{
	float32 armor_reduction;
	int32 damage;
	int32 experience_gain;
	float32 m_flCurrentArmorReduction;
	CHandle< CBaseEntity > m_hSwarmBug;
}
