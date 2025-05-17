// MNetworkVarNames = "int m_iStoredRuneType"
class C_DOTA_Item_Bottomless_Chalice : public C_DOTA_Item
{
	// MNetworkEnable
	// MNetworkChangeCallback = "OnChaliceStoredRuneChanged"
	int32 m_iStoredRuneType;
	GameTime_t m_fStoredRuneTime;
	float32 stored_rune_duration;
};
