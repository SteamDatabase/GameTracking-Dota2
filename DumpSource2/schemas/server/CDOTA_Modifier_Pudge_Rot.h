class CDOTA_Modifier_Pudge_Rot : public CDOTA_Buff
{
	int32 rot_damage;
	int32 rot_slow;
	int32 scepter_rot_regen_reduction_pct;
	GameTime_t m_flLastRotTime;
	bool m_bQualifiesAsPotentionalDeny;
};
