class CDOTA_Item_Tombstone : public CDOTA_Item
{
	float32 m_flTimer;
	CHandle< CDOTA_Item_Tombstone > m_hParent;
	CHandle< CDOTA_Item_Tombstone > m_hNextChild;
	Vector m_vContainerPosition;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndex2;
};
