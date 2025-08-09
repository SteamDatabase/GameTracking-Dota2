// MGetKV3ClassDefaults = {
//	"m_unStatID": 0,
//	"m_eStatImpl": "k_eMatchTrackedStatImpl_Invalid",
//	"m_expressionData":
//	{
//		"strExpression": ""
//	},
//	"m_aggregateData":
//	{
//		"m_strIndividualStat": "",
//		"m_eAggregate": "k_eTrackedStatAggregate_Invalid"
//	}
//}
// MVDataRoot
class CMatchTrackedStatDefinition
{
	// MPropertyDescription = "unique integer ID of this stat"
	// MVDataUniqueMonotonicInt = "_editor/next_match_stat_id"
	// MPropertyAttributeEditor = "locked_int()"
	TrackedStatID_t m_unStatID;
	// MPropertyDescription = "how this stat is implemented"
	EMatchTrackedStatImpl m_eStatImpl;
	// MPropertyDescription = "For k_eMatchTrackedStatImpl_Expression, what is the expression information."
	// MPropertySuppressExpr = "m_eStatImpl != k_eMatchTrackedStatImpl_Expression"
	TrackedStatExpressionData_t m_expressionData;
	// MPropertyDescription = "For k_eMatchTrackedStatImpl_PlayerAggregate or k_eMatchTrackedStatImpl_TeamAggregate, what is the aggregate information."
	// MPropertySuppressExpr = "m_eStatImpl != k_eMatchTrackedStatImpl_PlayerAggregate && m_eStatImpl != k_eMatchTrackedStatImpl_TeamAggregate"
	TrackedStatAggregateData_t m_aggregateData;
};
