// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class CPlayerTrackedStatDefinition
{
	// MPropertyDescription = "unique integer ID of this stat"
	// MVDataUniqueMonotonicInt = "_editor/next_player_stat_id"
	// MPropertyAttributeEditor = "locked_int()"
	TrackedStatID_t m_unStatID;
	// MPropertyDescription = "how this stat is implemented"
	EPlayerTrackedStatImpl m_eStatImpl;
	// MPropertyDescription = "For k_ePlayerTrackedStatImpl_KillEater, what is the kill eater information."
	// MPropertySuppressExpr = "m_eStatImpl != k_ePlayerTrackedStatImpl_KillEater"
	TrackedStatKillEaterData_t m_killEaterData;
	// MPropertyDescription = "For k_ePlayerTrackedStatImpl_CombatQuery, what is the combat query information."
	// MPropertySuppressExpr = "m_eStatImpl != k_ePlayerTrackedStatImpl_CombatQuery"
	TrackedStatCombatQueryData_t m_combatQueryData;
	// MPropertyDescription = "For k_ePlayerTrackedStatImpl_Expression, what is the expression information."
	// MPropertySuppressExpr = "m_eStatImpl != k_ePlayerTrackedStatImpl_Expression"
	TrackedStatExpressionData_t m_expressionData;
	// MPropertyDescription = "For k_ePlayerTrackedStatImpl_HeroAdjective, what is the adjective information."
	// MPropertySuppressExpr = "m_eStatImpl != k_ePlayerTrackedStatImpl_HeroAdjective"
	TrackedStatHeroAdjectiveData_t m_heroAdjectiveData;
};
