class CDOTABehaviorChase
{
	CDOTABehaviorMoveTo m_MoveTo;
	CHandle< CBaseEntity > m_hChaseEntity;
	bool m_bTargetMoves;
	float32[2] m_flFollowDistance;
	float32 m_flForwardDistance;
	float32 m_flRightDistance;
	CountdownTimer m_PositionFuzziness;
};
