class CDOTA_DB_Page_StickerEntity : public C_BaseEntity
{
	bool m_bIsPlaced;
	item_definition_index_t m_ItemDefinitionIndex;
	float32 m_flStickerScale;
	uint16 m_unDepthBias;
	int32 m_nStickerNumber;
	int32 m_nDbPageNumber;
	bool m_bVisible;
	uint32 m_hDecalSpawnGroupHandle;
	uint32 m_hDynamicPropSpawnGroupHandle;
}
