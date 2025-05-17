class CDOTA_Modifier_AntiMage_Counterspell : public CDOTA_Buff
{
	CModifierParams m_LastParams;
	int32 magic_resistance;
	int32 reflected_spell_amp;
	int32 mana_drain_percent;
	int32 damage_from_mana_drain_percent;
	int32 max_damage_from_mana_drain;
};
