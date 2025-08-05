// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MCellForDomain = "BaseDomain"
// MPulseCellMethodBindings (UNKNOWN FOR PARSER)
// MPulseCellOutflowHookInfo (UNKNOWN FOR PARSER)
// MPulseEditorHeaderIcon = "tools/images/pulse_editor/observable_variable_listener.png"
// MPropertyFriendlyName = "Wait For Observable Condition"
class CPulseCell_WaitForObservable : public CPulseCell_BaseYieldingInflow
{
	// MPropertyDescription = "Condition to evaluate when any of its dependent values change."
	PulseObservableBoolExpression_t m_Condition;
	CPulse_ResumePoint m_OnTrue;
};
