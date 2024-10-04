class CDOTA_Item_TeleportScroll : public CDOTA_Item
{
	CHandle< CBaseEntity > m_hTeleportTarget;
	ParticleIndex_t m_nFXOrigin;
	ParticleIndex_t m_nFXDestination;
	Vector m_vDestination;
	int32 m_iMinDistance;
	float32 m_flBaseTeleportTime;
	float32 m_flExtraTeleportTime;
};
