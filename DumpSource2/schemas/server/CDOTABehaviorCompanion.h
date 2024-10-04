class CDOTABehaviorCompanion
{
	CDOTABehaviorMoveTo m_MoveTo;
	CHandle< CBaseEntity > m_goalEntity;
	Vector m_vOffset;
	int32 m_iRightOffset;
	int32 m_iForwardOffset;
	CountdownTimer m_PositionFuzziness;
}
