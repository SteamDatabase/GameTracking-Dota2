class CDOTA_Modifier_Tidehunter_DeadInTheWater : public CDOTA_Buff
{
	int32 max_movement_speed;
	int32 chain_length;
	CHandle< CBaseEntity > m_hAnchor;
	bool m_bDragging;
};
