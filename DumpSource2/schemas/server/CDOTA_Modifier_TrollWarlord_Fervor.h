class CDOTA_Modifier_TrollWarlord_Fervor : public CDOTA_Buff
{
	int32 max_stacks;
	int32 extra_attack_chance_per_stack;
	int32 base_chance;
	CHandle< CBaseEntity > m_hUnit;
};
