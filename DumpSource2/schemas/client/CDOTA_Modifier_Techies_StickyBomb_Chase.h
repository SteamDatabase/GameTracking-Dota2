class CDOTA_Modifier_Techies_StickyBomb_Chase : public CDOTA_Buff
{
	int32 acceleration;
	int32 m_nTeamNumber;
	float32 speed;
	float32 pre_chase_time;
	CHandle< C_BaseEntity > m_hAttachTarget;
	Vector m_vStartPosition;
	CountdownTimer m_MoveTime;
}
