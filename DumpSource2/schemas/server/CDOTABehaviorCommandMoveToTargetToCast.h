class CDOTABehaviorCommandMoveToTargetToCast
{
	CDOTABehaviorMoveTo m_MoveTo;
	CHandle< CBaseEntity > m_hTarget;
	CHandle< CBaseEntity > m_hAbility;
	int32 m_nMovementState;
	bool m_bFailedCast;
	float32 m_flTargetRange;
	bool m_bTurningToTarget;
	float32 m_flTargetAngle;
};
