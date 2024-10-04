class CDOTA_Modifier_SkeletonKing_Reincarnation_Scepter_Active : public CDOTA_Buff
{
	int32 scepter_move_speed_pct;
	int32 scepter_attack_speed;
	CHandle< C_BaseEntity > m_hTarget;
	bool m_bPassive;
	bool m_bKillAtEnd;
}
