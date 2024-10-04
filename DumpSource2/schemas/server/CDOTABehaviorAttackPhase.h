class CDOTABehaviorAttackPhase
{
	CHandle< CBaseEntity > m_hTarget;
	CountdownTimer m_attackTimer;
	bool m_bAttackComplete;
	bool m_bDeny;
	bool m_bCastAttack;
	bool m_bTargetTeleported;
	float32 m_flBackswingDuration;
	float32 m_flAnimSpeed;
	float32 m_flAttackPortionPriorToTimer;
	HSequence m_iSequence;
};
