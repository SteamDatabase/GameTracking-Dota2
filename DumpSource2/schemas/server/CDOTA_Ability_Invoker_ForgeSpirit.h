class CDOTA_Ability_Invoker_ForgeSpirit : public CDOTA_Ability_Invoker_InvokedBase
{
	float32 spirit_damage;
	int32 spirit_mana;
	int32 spirit_armor;
	float32 spirit_attack_range;
	int32 spirit_hp;
	int32 spirit_level;
	float32 spirit_duration;
	float32 armor_per_attack;
	CUtlVector< CHandle< CBaseEntity > > m_vecSpirits;
};
