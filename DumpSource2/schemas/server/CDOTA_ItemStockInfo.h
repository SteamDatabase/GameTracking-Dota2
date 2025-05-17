// MNetworkVarNames = "int iTeamNumber"
// MNetworkVarNames = "AbilityID_t nItemAbilityID"
// MNetworkVarNames = "float fStockDuration"
// MNetworkVarNames = "GameTime_t fStockTime"
// MNetworkVarNames = "int iStockCount"
// MNetworkVarNames = "int iMaxCount"
// MNetworkVarNames = "float fInitialStockDuration"
// MNetworkVarNames = "PlayerID_t iPlayerID"
// MNetworkVarNames = "int iBonusDelayedStockCount"
class CDOTA_ItemStockInfo
{
	// MNetworkEnable
	int32 iTeamNumber;
	// MNetworkEnable
	AbilityID_t nItemAbilityID;
	// MNetworkEnable
	float32 fStockDuration;
	// MNetworkEnable
	GameTime_t fStockTime;
	// MNetworkEnable
	int32 iStockCount;
	// MNetworkEnable
	int32 iMaxCount;
	// MNetworkEnable
	float32 fInitialStockDuration;
	// MNetworkEnable
	PlayerID_t iPlayerID;
	// MNetworkEnable
	int32 iBonusDelayedStockCount;
};
