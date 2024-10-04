class CDOTABehaviorAbilityChannel
{
	CountdownTimer m_timer;
	float32 m_flAbilityChannelDuration;
	CHandle< CBaseEntity > m_hAbility;
	CHandle< CBaseEntity > m_hTarget;
	bool m_bCompletedChanneling;
};
