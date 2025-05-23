class CDOTA_Modifier_Item_Helm_Of_The_Undying_Active : public CDOTA_Buff
{
	CHandle< C_BaseEntity > m_hTarget;
	bool m_bPassive;
	float32 bonus_kill_duration;
	float32 kill_radius;
};
