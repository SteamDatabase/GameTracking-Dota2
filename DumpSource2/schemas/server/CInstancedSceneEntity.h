class CInstancedSceneEntity
{
	CHandle< CBaseEntity > m_hOwner;
	bool m_bHadOwner;
	float32 m_flPostSpeakDelay;
	float32 m_flPreDelay;
	bool m_bIsBackground;
	bool m_bRemoveOnCompletion;
	CHandle< CBaseEntity > m_hTarget;
};
