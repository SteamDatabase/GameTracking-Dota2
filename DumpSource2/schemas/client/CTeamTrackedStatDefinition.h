// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class CTeamTrackedStatDefinition
{
	// MPropertyDescription = "unique integer ID of this stat"
	// MVDataUniqueMonotonicInt = "_editor/next_team_stat_id"
	// MPropertyAttributeEditor = "locked_int()"
	TrackedStatID_t m_unStatID;
	// MPropertyDescription = "how this stat is implemented"
	ETeamTrackedStatImpl m_eStatImpl;
	// MPropertyDescription = "For k_eTeamTrackedStatImpl_Expression, what is the expression information."
	// MPropertySuppressExpr = "m_eStatImpl != k_ePlayerTrackedStatImpl_Expression"
	TrackedStatExpressionData_t m_expressionData;
	// MPropertyDescription = "For k_eTeamTrackedStatImpl_PlayerAggregate, what is the aggregate information."
	// MPropertySuppressExpr = "m_eStatImpl != k_eTeamTrackedStatImpl_PlayerAggregate"
	TrackedStatAggregateData_t m_aggregateData;
};
