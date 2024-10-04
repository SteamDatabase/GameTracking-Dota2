class CDOTABehaviorCommandMoveToTargetToAttack
{
	CDOTABehaviorMoveTo m_MoveTo;
	CHandle< CBaseEntity > m_hTarget;
	int32 m_nMovementState;
	bool m_bFailedCast;
	float32 m_flTargetRange;
	bool m_bDeny;
	bool m_bInvisBreak;
	bool m_bNightmareAttack;
	bool m_bTurningToTarget;
	float32 m_flTargetAngle;
	Vector m_vMoveToOrderPosition;
};
