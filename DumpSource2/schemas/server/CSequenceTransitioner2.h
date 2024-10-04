class CSequenceTransitioner2
{
	CNetworkedSequenceOperation m_currentOp;
	float32 m_flCurrentPlaybackRate;
	GameTime_t m_flCurrentAnimTime;
	TransitioningLayer_t[4] m_transitioningLayers;
	CBaseAnimatingController* m_pOwner;
};
