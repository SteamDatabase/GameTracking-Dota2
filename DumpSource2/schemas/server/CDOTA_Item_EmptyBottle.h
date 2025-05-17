// MNetworkVarNames = "int m_iStoredRuneType"
class CDOTA_Item_EmptyBottle : public CDOTA_Item
{
	// MNetworkEnable
	// MNetworkChangeCallback = "OnStoredRuneChanged"
	int32 m_iStoredRuneType;
	GameTime_t m_fStoredRuneTime;
	float32 rune_expire_time;
};
