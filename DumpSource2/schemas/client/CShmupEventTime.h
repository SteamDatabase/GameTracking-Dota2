class CShmupEventTime
{
	float32 m_flDelay;
	CUtlString m_strEventName;
	bool m_bPathFlipped;
	bool m_bInvertColors;
	int32 m_nCount;
	float32 m_flRepeatInterval;
	Vector m_vOffset;
	Vector m_vRepeatOffset;
	CUtlVector< CShmupEventTime > m_children;
};
