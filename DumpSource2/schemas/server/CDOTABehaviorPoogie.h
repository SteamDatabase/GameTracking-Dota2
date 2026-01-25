class CDOTABehaviorPoogie : public CDOTABehaviorCompanion
{
	CHandle< CBaseEntity > m_hMyHero;
	CHandle< CBaseEntity > m_hEffigy;
	CHandle< CBaseEntity > m_hHighFiveAbility;
	bool m_bEnemiesNearBase;
	int32 m_iRightOffsetEffigy;
	int32 m_iForwardOffsetEffigy;
	int32 m_iRightOffsetHero;
	int32 m_iForwardOffsetHero;
	CountdownTimer m_PositionOffsetsTimer;
	CountdownTimer m_HighFiveTimer;
	CountdownTimer m_EmoteTimer;
	CountdownTimer m_VanishTimer;
	CountdownTimer m_GreetHeroTimer;
	CountdownTimer m_EnemiesNearBaseTimer;
	CountdownTimer m_FindEffigyTimer;
};
