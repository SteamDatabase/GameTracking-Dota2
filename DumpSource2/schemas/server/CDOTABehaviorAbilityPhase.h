class CDOTABehaviorAbilityPhase
{
	CountdownTimer m_abilityTimer;
	CountdownTimer m_backSwingTimer;
	bool m_bBackswinging;
	CHandle< CBaseEntity > m_hAbility;
	bool m_bActionLocked;
	bool m_bTargetTeleported;
	bool m_bOriginalTargetTeleported;
};
