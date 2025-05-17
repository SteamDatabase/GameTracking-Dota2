// MNetworkVarNames = "int8 m_vecDrowRangerArcanaTargetPlayerID"
// MNetworkVarNames = "GameTime_t m_vecDrowRangerArcanaDeathTime"
// MNetworkVarNames = "GameTime_t m_vecDrowRangerArcanaKillTime"
class CDOTA_ArcanaDataEntity_DrowRanger : public CDOTA_ArcanaDataEntity_Base
{
	// MNetworkEnable
	// MNetworkChangeCallback = "OnDrowArcanaChanged"
	int8[24] m_vecDrowRangerArcanaTargetPlayerID;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnDrowArcanaChanged"
	GameTime_t[24] m_vecDrowRangerArcanaDeathTime;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnDrowArcanaChanged"
	GameTime_t[24] m_vecDrowRangerArcanaKillTime;
};
