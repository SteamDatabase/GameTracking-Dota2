class C_DOTA_Item_TeleportScroll : public C_DOTA_Item
{
	CHandle< C_BaseEntity > m_hTeleportTarget;
	ParticleIndex_t m_nFXOrigin;
	ParticleIndex_t m_nFXDestination;
	VectorWS m_vDestination;
	int32 m_iMinDistance;
	float32 m_flBaseTeleportTime;
	float32 m_flExtraTeleportTime;
};
