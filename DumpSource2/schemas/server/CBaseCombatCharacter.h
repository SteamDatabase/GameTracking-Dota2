class CBaseCombatCharacter
{
	bool m_bForceServerRagdoll;
	CNetworkUtlVectorBase< CHandle< CEconWearable > > m_hMyWearables;
	float32 m_impactEnergyScale;
	bool m_bApplyStressDamage;
	bool m_bDeathEventsDispatched;
	int32 m_iDamageCount;
	CUtlVector< RelationshipOverride_t >* m_pVecRelationships;
	CUtlSymbolLarge m_strRelationships;
	Hull_t m_eHull;
	uint32 m_nNavHullIdx;
	CMovementStatsProperty m_movementStats;
};
