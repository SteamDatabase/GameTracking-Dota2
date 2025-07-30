                                                                  
gStats = {
	"m_LastHitCount" : 0, 
	"m_CurrentLastHitStreakCount": 0,
	"m_HighestLastHitStreakCount": 0,
	"m_CreepsOutOfZoneCount" : 0,
	"m_DenyCount": 0,
	"m_Score": 0
};

function SetText(name, value)
{
	var element = $(name);

	if(element == null)
		return;

	element.text = value;
}

function UpdateScores()
{
	                            

	SetText('#Score', "" + gStats["m_Score"]);
	SetText('#CurrentLastHitStreak', gStats["m_CurrentLastHitStreakCount"]);
	SetText('#CreepsLastHit', gStats["m_LastHitCount"]);
	SetText('#CreepsDenied', gStats["m_DenyCount"]);
	SetText('#TotalLastHitOrDenyPct', parseInt( gStats[ "m_TotalLastHitOrDenyPct" ] * 100 ) + "%" );
	SetText('#CreepsOutOfZone', gStats["m_CreepsOutOfZoneCount"]);
}

function OnLastHitTrainerStatsUpdated( tableName, key, data )
{
	                              
	gStats = data;

	                                                       

	UpdateScores();
}

(function()
{
	                                                
	CustomNetTables.SubscribeNetTableListener("last_hit_trainer_stats", OnLastHitTrainerStatsUpdated);

	                 
})();
