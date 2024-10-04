class CDOTA_Modifier_BottleRegeneration : public CDOTA_Buff
{
	int32 health_restore;
	int32 mana_restore;
	int32 health_restore_pct;
	int32 mana_restore_pct;
	int32 break_on_hero_damage;
	float32 m_fHealingDone;
};
