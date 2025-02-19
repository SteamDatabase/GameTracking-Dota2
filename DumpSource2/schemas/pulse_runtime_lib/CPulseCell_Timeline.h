class CPulseCell_Timeline
{
	CUtlVector< CPulseCell_Timeline::TimelineEvent_t > m_TimelineEvents;
	bool m_bWaitForChildOutflows;
	CPulse_ResumePoint m_OnFinished;
	CPulse_ResumePoint m_OnCanceled;
};
