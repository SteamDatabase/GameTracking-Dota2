class C_INIT_RandomSequence
{
	int32 m_nSequenceMin;
	int32 m_nSequenceMax;
	bool m_bShuffle;
	bool m_bLinear;
	CUtlVector< SequenceWeightedList_t > m_WeightedList;
};
