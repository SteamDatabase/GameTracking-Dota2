// MNetworkVarNames = "int m_nNumPoints"
// MNetworkVarNames = "GameTime_t m_flShowPopupTime"
class CDOTA_ArcanaDataEntity_FacelessVoid : public CDOTA_ArcanaDataEntity_Base
{
	// MNetworkEnable
	int32 m_nNumPoints;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnFacelessVoidArcanaChanged"
	GameTime_t m_flShowPopupTime;
};
