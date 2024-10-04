class CDOTABehaviorCommandVampireThrall
{
	CDOTABehaviorMoveTo m_MoveTo;
	CHandle< CBaseEntity > m_hTarget;
	float32 m_flTargetRange;
	bool m_bDeny;
	bool m_bInvisBreak;
	bool m_bNightmareAttack;
	bool m_bTurningToTarget;
	bool m_bHasPositionOrder;
	bool m_bIsAggressive;
	float32 m_flTargetAngle;
	Vector m_vFollowOffset;
	Vector m_vMoveToPosition;
	CHandle< CBaseEntity > m_hMaster;
}
