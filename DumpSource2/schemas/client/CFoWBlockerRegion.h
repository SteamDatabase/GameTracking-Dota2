class CFoWBlockerRegion : public C_BaseEntity
{
	C_UtlVectorEmbeddedNetworkVar< FowBlocker_t > m_vecFowBlockers;
	float32 m_flMinX;
	float32 m_flMaxX;
	float32 m_flMinY;
	float32 m_flMaxY;
	float32 m_flGridSize;
};
