class C_CSequenceTransitioner2
{
	CNetworkedSequenceOperation m_currentOp;
	float32 m_flCurrentPlaybackRate;
	GameTime_t m_flCurrentAnimTime;
	TransitioningLayer_t[4] m_transitioningLayers;
	C_BaseAnimatingController* m_pOwner;
};
