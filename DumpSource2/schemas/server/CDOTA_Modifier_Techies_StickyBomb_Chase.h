class CDOTA_Modifier_Techies_StickyBomb_Chase
{
	int32 acceleration;
	int32 m_nTeamNumber;
	float32 speed;
	float32 pre_chase_time;
	CHandle< CBaseEntity > m_hAttachTarget;
	Vector m_vStartPosition;
	CountdownTimer m_MoveTime;
};
