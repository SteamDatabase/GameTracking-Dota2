class CDOTA_Modifier_Pugna_NetherWard : public CDOTA_Buff
{
	float32 radius;
	float32 mana_multiplier;
	float32 mana_drained_per_attack;
	int32 attacks_to_destroy;
	int32 health_restore_pct;
	int32 mana_restore_pct;
	float32 self_restoration_range;
};
