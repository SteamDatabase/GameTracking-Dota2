class CDOTA_Modifier_Rubick_SpellSteal : public CDOTA_Buff
{
	CUtlString m_strActivityModifier;
	CUtlVector< CHandle< CBaseEntity > > m_vecAbilities;
	bool m_bUsesTwoSlots;
	int32 stolen_debuff_amp;
	float32 stolen_mana_reduction;
};
