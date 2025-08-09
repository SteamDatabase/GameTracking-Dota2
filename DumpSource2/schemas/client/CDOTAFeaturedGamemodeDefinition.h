// MGetKV3ClassDefaults = {
//	"m_nID": 0,
//	"m_eGameMode": "DOTA_GAMEMODE_NONE",
//	"m_sCustomGame": "",
//	"m_nShardsPerWin": 100,
//	"m_nShardsPerLoss": 50,
//	"m_sStartTime": "",
//	"m_sEndTime": ""
//}
// MVDataRoot
class CDOTAFeaturedGamemodeDefinition
{
	// MPropertyDescription = "unique integer ID of this weekly featured game mode"
	// MVDataUniqueMonotonicInt = "_editor/next_featured_gamemode_id"
	// MPropertyAttributeEditor = "locked_int()"
	uint16 m_nID;
	// MPropertyDescription = "Game Mode; use DOTA_GAMEMODE_EVENT for custom games and include custom game name"
	DOTA_GameMode m_eGameMode;
	// MPropertyDescription = "custom game addon name if any; references event_games.txt"
	CUtlString m_sCustomGame;
	// MPropertyDescription = "shards per win"
	int32 m_nShardsPerWin;
	// MPropertyDescription = "shards per loss"
	int32 m_nShardsPerLoss;
	// MPropertyDescription = "the date/time this mode starts (YYYY-MM-DD hh:mm:ss) UTC"
	CUtlString m_sStartTime;
	// MPropertyDescription = "the date/time this mode ends (YYYY-MM-DD hh:mm:ss) UTC"
	CUtlString m_sEndTime;
};
