class CPulseCell_Step_CallExternalMethod
{
	PulseSymbol_t m_MethodName;
	PulseSymbol_t m_GameBlackboard;
	CUtlLeanVector< CPulseRuntimeMethodArg > m_ExpectedArgs;
	PulseMethodCallMode_t m_nAsyncCallMode;
	CPulse_ResumePoint m_OnFinished;
};
