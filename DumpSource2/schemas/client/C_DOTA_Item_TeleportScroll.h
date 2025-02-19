class C_DOTA_Item_TeleportScroll
{
	CHandle< C_BaseEntity > m_hTeleportTarget;
	ParticleIndex_t m_nFXOrigin;
	ParticleIndex_t m_nFXDestination;
	Vector m_vDestination;
	int32 m_iMinDistance;
	float32 m_flBaseTeleportTime;
	float32 m_flExtraTeleportTime;
};
