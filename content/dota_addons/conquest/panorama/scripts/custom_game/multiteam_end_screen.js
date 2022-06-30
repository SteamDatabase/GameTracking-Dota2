"use strict";

//==============================================================
//==============================================================
function OnGameStateChanged( table, key, data )
{
//	$.Msg( "OnGameStateChanged: ", table, ", ", key, ", ", data );
	if ( key !== "score_table" || data === undefined )
		return;

	var radScore = $( "#RadiantPoints" );
	if ( radScore && data.radiant !== undefined )
	{
		radScore.text = Math.floor(data.radiant);
	}
	
	var direScore = $( "#DirePoints" );
	if ( direScore && data.dire !== undefined )
	{
		direScore.text = Math.floor(data.dire);
	}
}


//==============================================================
//==============================================================
(function()
{
	if ( ScoreboardUpdater_InitializeScoreboard === null ) { $.Msg( "WARNING: This file requires shared_scoreboard_updater.js to be included." ); }

	var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/multiteam_end_screen_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/multiteam_end_screen_player.xml",
	};

	var endScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, $( "#TeamsContainer" ) );
	
	var teamInfoList = ScoreboardUpdater_GetSortedTeamInfoList( endScoreboardHandle );
	var delay = 0.2;
	var delay_per_panel = 1 / teamInfoList.length;
	for ( var teamInfo of teamInfoList )
	{
//		$.Msg( teamInfo );
		ScoreboardUpdater_GetTeamPanel( endScoreboardHandle, teamInfo.team_id )
	}
	
	var winningTeamId = Game.GetGameWinner();
	var winningTeamDetails = Game.GetTeamDetails( winningTeamId );
	var endScreenVictory = $( "#EndScreenVictory" );
	if ( endScreenVictory )
	{
		endScreenVictory.SetDialogVariable( "winning_team_name", $.Localize( winningTeamDetails.team_name ) );
	}

	var radiant = ( Game.GetGameWinner() == 2 )
	$( "#RadiantAndVictory" ).SetHasClass( "victory_team", radiant );
	$( "#DireAndVictory" ).SetHasClass( "victory_team", !radiant );

	CustomNetTables.SubscribeNetTableListener( "game_state", OnGameStateChanged );

	OnGameStateChanged( "game_state", "score_table", CustomNetTables.GetTableValue( "game_state", "score_table" ) );
})();

