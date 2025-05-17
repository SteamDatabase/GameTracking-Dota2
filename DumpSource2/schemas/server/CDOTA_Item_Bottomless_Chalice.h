// MNetworkVarNames = "int m_iStoredRuneType"
class CDOTA_Item_Bottomless_Chalice : public CDOTA_Item
{
	// MNetworkEnable
	// MNetworkChangeCallback = "OnChaliceStoredRuneChanged"
	int32 m_iStoredRuneType;
	GameTime_t m_fStoredRuneTime;
	float32 stored_rune_duration;
};
