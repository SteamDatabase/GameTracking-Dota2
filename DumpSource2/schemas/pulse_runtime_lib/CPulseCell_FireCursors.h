class CPulseCell_FireCursors
{
	CUtlVector< CPulse_OutflowConnection > m_Outflows;
	bool m_bWaitForChildOutflows;
	CPulse_ResumePoint m_OnFinished;
	CPulse_ResumePoint m_OnCanceled;
};
