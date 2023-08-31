"use strict";

//-----------------------------------------------------------------------------------------
function intToARGB(i) 
{ 
                return ('00' + ( i & 0xFF).toString( 16 ) ).substr( -2 ) +
                                               ('00' + ( ( i >> 8 ) & 0xFF ).toString( 16 ) ).substr( -2 ) +
                                               ('00' + ( ( i >> 16 ) & 0xFF ).toString( 16 ) ).substr( -2 ) + 
                                                ('00' + ( ( i >> 24 ) & 0xFF ).toString( 16 ) ).substr( -2 );
}


function OnRoundDataUpdated( table_name, key, data )
{
	UpdateRoundUI();
}

CustomNetTables.SubscribeNetTableListener( "round_data", OnRoundDataUpdated )

function UpdateRoundUI()
{
	var key = 0;
	var roundData = CustomNetTables.GetTableValue( "round_data", key.toString() );
	if ( roundData !== null )
	{
		$( "#RoundNumber" ).text = roundData.round_number;
		$( "#EnemyNumber" ).text = roundData.enemies_total - roundData.enemies_killed;
		$( "#EnemyTotalNumber" ).text = roundData.enemies_total;
		$( "#EnemyProgressBar" ).value = ( roundData.enemies_total - roundData.enemies_killed ) / roundData.enemies_total;
		$( "#PrepTimer" ).text = parseInt( roundData.prep_time_left );

		var nInvokerHP = roundData.invoker_hp;
		var bShowInvokerHP = roundData.invoker_hp == 0 ? false : true;
		$( "#InvokerProgressBar" ).value = nInvokerHP / 100;
		$( "#InvokerHP").SetHasClass( "Visible", bShowInvokerHP );


		var nAncientHP = roundData.ancient_hp;
		var bShowAncientHP = roundData.ancient_hp == -1 ? false : true;
		$( "#AncientProgressBar" ).value = roundData.ancient_hp / 4250;
		$( "#AncientHP").SetHasClass( "Visible", bShowAncientHP && !bShowInvokerHP );
		
		var bRoundInProgress = roundData.prep_time_left === 0;
		$( "#HoldoutState" ).SetHasClass( "RoundInProgress", bRoundInProgress );
	}
}

function OnRoundStarted( roundStartData )
{
	if ( roundStartData !== null )
	{
		$( "#RoundStartPanel" ).FindChildInLayoutFile( "RoundNameLabel" ).text = $.Localize( roundStartData.round_name );
		$( "#RoundStartPanel" ).SetHasClass( "Round" + ( roundStartData.round_number - 1), false );  
		$( "#RoundStartPanel" ).SetHasClass( "Round" + roundStartData.round_number, true );
	}

	$( "#RoundStartPanel" ).SetHasClass( "Visible", true );
	Game.EmitSound( "RoundStart" );
	$.Schedule( 5.0, HideRoundStart );
	$.DispatchEvent( "DOTAHUDHideScoreboard" )
}

function HideRoundStart()
{
	$( "#RoundStartPanel" ).SetHasClass( "Visible", false );
}

GameEvents.Subscribe( "round_started", OnRoundStarted );

var bGameEndActive = false;
function OnGameEnd()
{
	// Don't do a Game End screen, they'll see it in Post-Game.
	// HandleGameEnd();
}

CustomNetTables.SubscribeNetTableListener( "game_end", OnGameEnd )

function HandleGameEnd()
{
	if ( bGameEndActive )
	{
		bGameEndActive = false;
		$( "#GameEndPanel" ).SetHasClass( "Visible", false );
		return;
	}
	
	bGameEndActive = true;
	$( "#GameEndPanel" ).SetHasClass( "Visible", true );
	Game.EmitSound( "RoundEnd" );

	var key = 0;
	var gameEndData = CustomNetTables.GetTableValue( "game_end", key.toString() );
	if ( gameEndData !== null )
	{
		var localPlayerInfo = Game.GetLocalPlayerInfo();
		var players = Game.GetPlayerIDsOnTeam( localPlayerInfo.player_team_id );
		var i = 0
		for ( i; i < 5; i++ )
		{
			var playerID = i;
			var playerRowPanelPrefix = "Player" + playerID;
			var playerHeroEntIndex = Players.GetPlayerHeroEntityIndex( playerID );
			var playerRow = $( "#GameEndPanel" ).FindChildInLayoutFile( playerRowPanelPrefix );

			if ( playerRow !== null )
			{
				if ( playerHeroEntIndex === -1 )
				{
					playerRow.SetHasClass( "Hide", true );
					continue;
				}

				playerRow.SetHasClass( "Hide", false );

				var colorInt = Players.GetPlayerColor( playerID );
				var colorString = "#" + intToARGB( colorInt );

				var playerColor = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "Color" );
				playerColor.style.backgroundColor = colorString;

				var playerHeroNameLabel = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "HeroName" );

				var szPlayerNameString = Players.GetPlayerSelectedHero( playerID );
				playerHeroNameLabel.text = GameUI.GetUnitNameLocalized( szPlayerNameString )

				var playerNameLabel = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "PlayerName" );
				playerNameLabel.text = Players.GetPlayerName( playerID );

				var playerHeroImage = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "HeroImage" );
				playerHeroImage.heroname = szPlayerNameString

				var playerKills = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "Kills" );
				playerKills.text = gameEndData[playerID.toString() + "Kills"];

				var playerDeaths = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "Deaths" );
				playerDeaths.text = gameEndData[playerID.toString() + "Deaths"];

				var playerBags = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "Bags" );
				playerBags.text = gameEndData[playerID.toString() + "Bags"];

				var playerSaves = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "Saves" );
				playerSaves.text = gameEndData[playerID.toString() + "Saves"];
			}
		}

		var header = $( "#GameEndPanel" ).FindChildInLayoutFile( "GameEndHeader" );
		if ( gameEndData["victory"] === true )
		{
			header.text = $.Localize( "#DOTA_HUD_Victory" );
		}
		else
		{
			header.text = $.Localize( "#DOTA_HUD_Defeat" );
		}
	}
}

function OnVoteYesClicked()
{
	var localPlayerInfo = Game.GetLocalPlayerInfo();
	GameEvents.SendCustomGameEventToServer( "vote_button_clicked", { "player_id" : Game.GetLocalPlayerID(), "play_again" : true } );
}

function OnVoteNoClicked()
{
	var localPlayerInfo = Game.GetLocalPlayerInfo();
	GameEvents.SendCustomGameEventToServer( "vote_button_clicked", { "player_id" : Game.GetLocalPlayerID(), "play_again" : false } );
}

function OnVotesUpdated()
{
	var key = 0;
	var voteData = CustomNetTables.GetTableValue( "restart_votes", key.toString() );
	if ( voteData !== null )
	{
		var nYesVotes = voteData["yes"];
		var nNoVotes = voteData["no"];

		var i = 0
		for ( i; i < 5; i++ )
		{
			var voteNode = $( "#VotePanel" ).FindChildInLayoutFile( "VoteNode" + i.toString() );
			if ( nYesVotes > 0 )
			{
				voteNode.SetHasClass( "Yes", true );
				voteNode.SetHasClass( "No", false );
				nYesVotes = nYesVotes - 1
				continue;
			}

			if ( nNoVotes > 0 )
			{
				voteNode.SetHasClass( "Yes", false );
				voteNode.SetHasClass( "No", true );
				nNoVotes = nNoVotes - 1
				continue;
			}

			voteNode.SetHasClass( "Yes", false );
			voteNode.SetHasClass( "No", false );
			continue;
		}

		$( "#VotePanel" ).FindChildInLayoutFile( "VoteTimer" ).text = parseInt( voteData["time_left"] );
	}

}

CustomNetTables.SubscribeNetTableListener( "restart_votes", OnVotesUpdated )

function TestAward()
{
	var awardDesc = $( "#AwardPanel" ).FindChildInLayoutFile( "AwardDesc" );
	$.Msg( awardDesc );

	var txt = $.Localize( "#DOTA_Holdout_Award_MostBags_Title" );
	$.Msg( 'txt = ' + txt );

	awardDesc.text = $.Localize( "#DOTA_Holdout_Award_MostBags_Desc" );

	return '5';
}

var testAwardFunc = function()
{
	var awardDesc = $( "#AwardPanel" ).FindChildInLayoutFile( "AwardDesc" );
	awardDesc.text = $.Localize( "#DOTA_Holdout_Award_MostBags_Desc" );
}


function DisplayAward( netTable )
{
	if ( netTable !== null )
	{
		$.Msg( "Updating Award" );
		
		$( "#AwardPanel" ).SetHasClass( "Visible", true );
		var playerAvatar = $( "#AwardPanel" ).FindChildInLayoutFile( "PlayerAvatar" );
		if ( playerAvatar !== null )
		{
			playerAvatar.steamid = netTable["SteamID"];
		}

		var awardHeroImage = $( "#AwardPanel" ).FindChildInLayoutFile( "AwardHeroImage" );
		if ( awardHeroImage !== null )
		{
			awardHeroImage.heroname = Players.GetPlayerSelectedHero( netTable["PlayerID"] );
		}
		
		var awardIcon = $( "#AwardPanel" ).FindChildInLayoutFile( "AwardIcon" );
		if ( awardIcon !== null )
		{
			awardIcon.SetImage( netTable["Icon"] );
		}

		var awardName = $( "#AwardPanel" ).FindChildInLayoutFile( "AwardName" );
		if ( awardName !== null )
		{
			awardName.text = $.Localize( netTable["Title"] );
			awardName.html = true
		}
		
		var awardDesc = $( "#AwardPanel" ).FindChildInLayoutFile( "AwardDesc" );
		if ( awardDesc !== null )
		{

			awardDesc.text = $.Localize( netTable["Desc"] );
			awardDesc.html = true
		}


		$( "#AwardPanel" ).SetDialogVariable( "player_name", Players.GetPlayerName( netTable["PlayerID"] ) ); 
		$( "#AwardPanel" ).SetDialogVariableInt( "value", netTable["ResultValue"] ); 
	}

	$.Schedule( 15.0, HideAward );
}

function HideAward()
{
	$( "#AwardPanel" ).SetHasClass( "Visible", false );
}

GameEvents.Subscribe( "display_award", DisplayAward );