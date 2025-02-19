class CDOTA_Modifier_Centaur_Cart
{
	CHandle< C_BaseEntity > m_hUnit;
	bool m_bWasMoving;
	bool m_bSpawnDone;
	Vector m_vecOldForward;
	int32 break_distance;
	Vector m_vecPreviousLocation;
};
