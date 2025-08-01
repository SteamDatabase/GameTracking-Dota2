"GameInfo"
{
	//
	// Branch-varying info, such as the game/title and app IDs, is in gameinfo_branchspecific.gi.
	// gameinfo.gi is the non-branch-varying content and can be integrated between branches.
	//

	game 		"Dota 2"
	title 		"Dota 2"

	FileSystem
	{
		SteamAppId				570
		BreakpadAppId			373300	// Report crashes under beta DLC, not the S1 game.  Delete this when all clients are switched to S2
		BreakpadAppId_Tools		375360  // Use a separate bucket of buckets for "-tools" crashes so that they don't get drowned out by game crashes. Falls back to BreakpadAppId/SteamAppId if missing
	}
}
