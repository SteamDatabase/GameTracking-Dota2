class CDOTABehaviorMoveToNPCToAttack
{
	CDOTABehaviorMoveTo m_MoveTo;
	bool m_bMovingToLastKnownTargetPosition;
	CountdownTimer m_AttackDelay;
	CountdownTimer m_ChaseLimit;
	bool m_bInAttackPosition;
	bool m_bTurningToTarget;
	float32 m_flTargetAngle;
	bool m_bAttackMove;
}
