// MNetworkVarNames = "int m_nInitiatingPlayerID"
// MNetworkVarNames = "int m_PingWheelMessageID"
// MNetworkVarNames = "float m_flActiveUntilTime"
// MNetworkVarNames = "Vector2D m_vLocation"
// MNetworkVarNames = "int m_nPingedEntityEntIndex"
// MNetworkVarNames = "int m_nID"
// MNetworkVarNames = "PingConfirmationIconType m_IconType"
// MNetworkVarNames = "int m_nAgreeState"
class PingConfirmationState_t
{
	// MNetworkEnable
	int32 m_nInitiatingPlayerID;
	// MNetworkEnable
	int32 m_PingWheelMessageID;
	// MNetworkEnable
	float32 m_flActiveUntilTime;
	// MNetworkEnable
	Vector2D m_vLocation;
	// MNetworkEnable
	int32 m_nPingedEntityEntIndex;
	// MNetworkEnable
	int32 m_nID;
	// MNetworkEnable
	PingConfirmationIconType m_IconType;
	// MNetworkEnable
	int32[24] m_nAgreeState;
};
