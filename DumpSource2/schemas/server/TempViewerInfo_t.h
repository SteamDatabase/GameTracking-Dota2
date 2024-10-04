class TempViewerInfo_t
{
	int32 m_nGridX;
	int32 m_nGridY;
	int32 m_nRadius;
	int8 m_nViewerType;
	bool m_bObstructedVision;
	bool m_bValid;
	bool m_bDirty;
	GameTime_t flEndTime;
	int32 nFoWID;
	CHandle< CBaseEntity > hOwner;
};
