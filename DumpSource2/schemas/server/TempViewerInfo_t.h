// MNetworkVarNames = "int m_nGridX"
// MNetworkVarNames = "int m_nGridY"
// MNetworkVarNames = "int m_nRadius"
// MNetworkVarNames = "int8 m_nViewerType"
// MNetworkVarNames = "bool m_bObstructedVision"
// MNetworkVarNames = "bool m_bValid"
class TempViewerInfo_t
{
	// MNetworkEnable
	// MNetworkChangeCallback = "OnFieldChanged"
	int32 m_nGridX;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnFieldChanged"
	int32 m_nGridY;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnFieldChanged"
	int32 m_nRadius;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnFieldChanged"
	int8 m_nViewerType;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnFieldChanged"
	bool m_bObstructedVision;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnFieldChanged"
	bool m_bValid;
	bool m_bDirty;
	GameTime_t flEndTime;
	int32 nFoWID;
	CHandle< CBaseEntity > hOwner;
};
