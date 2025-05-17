class CDOTA_Modifier_MonkeyKing_BouncePerch : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hTree;
	bool m_bGroundToTree;
	bool m_bTreeToGround;
	bool m_bTreeToTree;
	float32 perched_day_vision;
	float32 perched_night_vision;
	bool m_bAbilityIsStolen;
};
