class CDOTABehaviorPet : public CDOTABehaviorCompanion
{
	float32 m_flThreatLevel;
	CountdownTimer m_ThreatTimer;
	CountdownTimer m_StuckTimer;
	bool m_bHasVanished;
	CountdownTimer m_VanishOnThreatTimer;
	Vector m_vecFleeCurrentTarget;
	Vector m_vecFleeDirection;
	Vector m_vecOldFleeDirection;
	CountdownTimer m_FleePersistTimer;
	CountdownTimer m_CombatRepositionTimer;
	CHandle< CDOTA_BaseNPC > m_hNearestEnemyHero;
	GameTime_t m_flLastInWater;
	Vector m_vecHomeBasePosition;
	bool m_bReturnToBase;
	CountdownTimer m_ReturnToBaseTimer;
	PetCoopStates_t m_nCoopTeleportState;
	CountdownTimer m_CarryItemTimer;
	CountdownTimer m_PickupDelayTimer;
	CountdownTimer m_LevelupCheckTimer;
	bool m_bIsEmoting;
	CHandle< CDOTA_BaseNPC > m_hEmoteTarget;
	CountdownTimer m_EmoteTimer;
	int32 m_nEmoteActivity;
	CHandle< CBaseEntity > m_tempGoalEntity;
	bool m_bFollowingTempGoal;
	int32 m_event_dota_illusions_created;
}
