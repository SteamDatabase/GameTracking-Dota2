"use strict";

//-----------------------------------------------------------------------------------------
function intToARGB(i) 
{ 
                return ('00' + ( i & 0xFF).toString( 16 ) ).substr( -2 ) +
                                               ('00' + ( ( i >> 8 ) & 0xFF ).toString( 16 ) ).substr( -2 ) +
                                               ('00' + ( ( i >> 16 ) & 0xFF ).toString( 16 ) ).substr( -2 ) + 
                                                ('00' + ( ( i >> 24 ) & 0xFF ).toString( 16 ) ).substr( -2 );
}

var g_bAnimatingTowersFinished = false;
var g_bAnimatingGoldBagsFinished = false;
var g_bAnimatingGoldBagsExpiredFinished = false;
var g_bAnimatingDeathsFinished = false;
var g_bAnimatingEventPointsFinished = false;
var g_bAnimatingStarScoreFinished = false;
var g_bRoundEndInit = false;
var g_flNextAnimTime = 0.0;
var g_nLoopHandle = 0;

function ToggleMute( nPlayerID )
{
	if ( nPlayerID !== -1 )
	{
		var newIsMuted = !Game.IsPlayerMuted( nPlayerID );
		Game.SetPlayerMuted( nPlayerID, newIsMuted );
		
	//	var playerRowPanelPrefix = "Player" + nPlayerID;
	//	var playerRow = $( "#HoldoutScoreboard" ).FindChildInLayoutFile( playerRowPanelPrefix );
	//	playerRow.SetHasClass( "player_muted", newIsMuted );
	}
}

function OnRoundStart()
{
	$.Msg( "OnRoundStart" )
	g_bAnimatingTowersFinished = false;
	g_bAnimatingGoldBagsFinished = false;
	g_bAnimatingGoldBagsExpiredFinished = false;
	g_bAnimatingDeathsFinished = false;
	g_bAnimatingEventPointsFinished = false;
	g_bAnimatingStarScoreFinished = false;
	g_bRoundEndInit = false;
	Game.StopSound( g_nLoopHandle );
	$.GetContextPanel().SetHasClass( "round_over", false );
}

GameEvents.Subscribe( "round_started", OnRoundStart );

function AnimateTowers( scoreData )
{
	if ( g_flNextAnimTime > Game.Time() )
		return;

	var nTargetValue = scoreData["TowersRemaining"]	
	var nCurrentValue = $( "#TowerAndBagContainer" ).FindChildInLayoutFile( "TowersRemaining" ).GetAttributeInt( "value", 0 ); 
	if ( nCurrentValue != nTargetValue )
	{
		var nNewValue = Math.min( nCurrentValue + 1, nTargetValue );
		$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "TowersRemaining" ).text = nNewValue;
		$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "TowersRemaining" ).SetAttributeInt( "value", nNewValue );
		Game.EmitSound( "TowerCountUp" );
	}
	else
	{
		$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "TowerGoldReward" ).text = scoreData["TowersReward"];
		g_bAnimatingTowersFinished = true;
	}
	g_flNextAnimTime = Game.Time() + 0.15;
}

function AnimateGoldBags( scoreData )
{
	if ( g_flNextAnimTime > Game.Time() )
		return;

	var nTargetValue = scoreData["GoldBagsCollected"]	
	var nCurrentValue = $( "#TowerAndBagContainer" ).FindChildInLayoutFile( "GoldBagsCollectedAmount" ).GetAttributeInt( "value", 0 ); 
	if ( nCurrentValue != nTargetValue )
	{
		var nNewValue = Math.min( nCurrentValue + 3, nTargetValue );
		$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "GoldBagsCollectedAmount" ).text = nNewValue;
		$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "GoldBagsCollectedAmount" ).SetAttributeInt( "value", nNewValue );
		if ( g_nLoopHandle === 0 )
		{
			g_nLoopHandle = Game.EmitSound( "GoldRising" );
		} 
	}
	else
	{
		Game.StopSound( g_nLoopHandle );
		g_nLoopHandle = 0;
		Game.EmitSound( "GoldRisingEnd" );
		g_bAnimatingGoldBagsFinished = true;
	}
	g_flNextAnimTime = Game.Time() + 0.15;
}

function AnimateGoldBagsExpired( scoreData )
{
	if ( g_flNextAnimTime > Game.Time() )
		return;

	var nTargetValue = scoreData["GoldBagsExpired"]	
	var nCurrentValue = $( "#TowerAndBagContainer" ).FindChildInLayoutFile( "GoldBagsExpiredAmount" ).GetAttributeInt( "value", 0 );
	if ( nCurrentValue != nTargetValue )
	{
		var nNewValue = Math.min( nCurrentValue + 1, nTargetValue );
		$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "GoldBagsExpiredAmount" ).text = nNewValue;
		$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "GoldBagsExpiredAmount" ).SetAttributeInt( "value", nNewValue );
		Game.EmitSound( "Item.DropWorld" );
	}
	else
	{
		g_bAnimatingGoldBagsExpiredFinished = true;
	}
	g_flNextAnimTime = Game.Time() + 0.15;
}

function AnimateDeaths( scoreData )
{
	if ( g_flNextAnimTime > Game.Time() )
		return;

	var nTargetValue = scoreData["TotalDeaths"]	
	var nCurrentValue = $( "#TowerAndBagContainer" ).FindChildInLayoutFile( "DeathAmount" ).GetAttributeInt( "value", 0 );
	if ( nCurrentValue != nTargetValue )
	{
		var nNewValue = Math.min( nCurrentValue + 1, nTargetValue );
		$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "DeathAmount" ).text = nNewValue;
		$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "DeathAmount" ).SetAttributeInt( "value", nNewValue );
		Game.EmitSound( "TowerCountUp" );
	}
	else
	{
		g_bAnimatingDeathsFinished = true;
	}
	g_flNextAnimTime = Game.Time() + 0.15;
}

function AnimateEventPoints( scoreData )
{
	if ( g_flNextAnimTime > Game.Time() )
		return;

	var nTargetValue = scoreData["PointTotal"]	
	var nCurrentValue = $( "#TowerAndBagContainer" ).FindChildInLayoutFile( "PointsTotalValue" ).GetAttributeInt( "value", 0 ); 
	if ( nCurrentValue != nTargetValue )
	{
		var nNewValue = Math.min( nCurrentValue + 15, nTargetValue );
		$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "PointsTotalValue" ).text = nNewValue;
		$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "PointsTotalValue" ).SetAttributeInt( "value", nNewValue );
		if ( g_nLoopHandle === 0 )
		{
			g_nLoopHandle = Game.EmitSound( "FragmentsLoop" );
		}
	}
	else
	{
		Game.StopSound( g_nLoopHandle );
		g_nLoopHandle = 0;
		Game.EmitSound( "FragmentsLoopEnd" );
		g_bAnimatingEventPointsFinished = true;
	}
	g_flNextAnimTime = Game.Time() + 0.15;
}

function AnimateStarScore( scoreData )
{
	if ( g_flNextAnimTime > Game.Time() )
		return;

	var nTargetValue = scoreData["StarLevel"]
	var nCurrentValue = $( "#TowerAndBagContainer" ).FindChildInLayoutFile( "StarContainer" ).GetAttributeInt( "value", 0 ); 
	if ( nCurrentValue != nTargetValue )
	{
		var nNewValue = Math.min( nCurrentValue + 1, nTargetValue );
		$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "StarContainer" ).SetHasClass( "Rank" + nNewValue, true );
		$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "StarContainer" ).SetAttributeInt( "value", nNewValue );
		Game.EmitSound( "StarLevel" );
	}
	else
	{
		g_bAnimatingStarScoreFinished = true;
	}

	g_flNextAnimTime = Game.Time() + 0.33;
}



function UpdateScoreboard( scoreData )
{
	if ( $.GetContextPanel().BHasClass( "round_over" ) || $.GetContextPanel().BHasClass( "flyout_scoreboard_visible" ) )
	{
		$.Schedule( 0.2, UpdateScoreboard );
	}

	var key = 0;
	var scoreData = CustomNetTables.GetTableValue( "holdout_scores", key.toString() );
	if ( typeof scoreData != 'undefined' )
	{
		var localPlayerInfo = Game.GetLocalPlayerInfo();
		var players = Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_GOODGUYS );
		var i = 0;

		for ( i; i < 5; i++ )
		{
			var playerID = i;
			var playerRowPanelPrefix = "Player" + playerID;
			var playerHeroEntIndex = Players.GetPlayerHeroEntityIndex( playerID );
			var playerRow = $( "#HoldoutScoreboard" ).FindChildInLayoutFile( playerRowPanelPrefix );

			if ( playerRow !== null )
			{
				if ( playerHeroEntIndex === -1 )
				{
					playerRow.SetHasClass( "Hide", true );
					continue;
				}
				playerRow.SetHasClass( "Hide", false );
				playerRow.SetHasClass( "player_muted", Game.IsPlayerMuted( playerID ) )
				playerRow.SetHasClass( "local_player", Game.GetLocalPlayerID() == playerID )

				var playerKills = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "Kills" );
				playerKills.text = scoreData[playerID.toString() + "Kills"];

				var playerDeaths = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "Deaths" );
				playerDeaths.text = scoreData[playerID.toString() + "Deaths"];

				var playerBags = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "Bags" );
				playerBags.text = scoreData[playerID.toString() + "Bags"];

				var playerSaves = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "Saves" );
				playerSaves.text = scoreData[playerID.toString() + "Saves"];
			}
		}

		$( "#TowerAndBagContainer" ).SetHasClass( "RoundOver", scoreData["RoundOver"] === 1 )
		if ( scoreData["RoundOver"] === 1 )
		{
			if ( g_bRoundEndInit === false )
			{
				$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "TowersRemaining" ).text = 0;
				$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "TowersRemaining" ).SetAttributeInt( "value", 0 );
				$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "TowerGoldReward" ).text = 0;
				$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "TowerGoldReward" ).SetAttributeInt( "value", 0 );
				$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "GoldBagsExpiredAmount" ).text = 0;
				$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "GoldBagsExpiredAmount" ).SetAttributeInt( "value", 0 ); 
				$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "GoldBagsCollectedAmount" ).text = 0;
				$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "GoldBagsCollectedAmount" ).SetAttributeInt( "value", 0 ); 
				$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "StarContainer" ).SetHasClass( "Rank1", false );
				$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "StarContainer" ).SetHasClass( "Rank2", false );
				$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "StarContainer" ).SetHasClass( "Rank3", false );
				$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "StarContainer" ).SetAttributeInt( "value", 0 ); 
				$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "DeathAmount" ).text = 0;
				$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "DeathAmount" ).SetAttributeInt( "value", 0 );
				
				$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "PointsThisRoundValue" ).text = scoreData["PointReward"];
				$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "PointsTotalValue" ).text = scoreData["PointTotal"] - scoreData["PointReward"];
				$( "#TowerAndBagContainer" ).FindChildInLayoutFile( "GoldBagsCollectedAmount" ).GetAttributeInt( "value", scoreData["PointTotal"] - scoreData["PointReward"] ); 
				g_bRoundEndInit = true;
				g_flNextAnimTime = Game.Time() + 3.0;
			}
			
			if ( g_bAnimatingTowersFinished === false )
			{
				//$.Msg( "Animating Towers" );
				AnimateTowers( scoreData );
				return;
			}

			if ( g_bAnimatingGoldBagsFinished === false )
			{
				//$.Msg( "Animating GoldBagsCollected" );
				AnimateGoldBags( scoreData );
				return;
			}

			if ( g_bAnimatingGoldBagsExpiredFinished === false )
			{
				//$.Msg( "Animating GoldBagsExpired" );
				AnimateGoldBagsExpired( scoreData );
				return;
			}

			if ( g_bAnimatingDeathsFinished === false )
			{
				//$.Msg( "Animating GoldBagsExpired" );
				AnimateDeaths( scoreData );
				return;
			}

			if ( g_bAnimatingEventPointsFinished === false )
			{
				//$.Msg( "Animating EventPointsExpired" );
				AnimateEventPoints( scoreData );
				return;
			}

			if ( g_bAnimatingStarScoreFinished === false )
			{
				//$.Msg( "Animating StarScore" );
				AnimateStarScore( scoreData );
				return;
			}	

			$.GetContextPanel().SetHasClass( "round_over", false );
		}
	}



}

function InitializeScoreboard()
{
	var localPlayerInfo = Game.GetLocalPlayerInfo();
	var players = Game.GetPlayerIDsOnTeam( localPlayerInfo.player_team_id );
	var i = 0
	for ( i; i < 5; i++ )
	{
		var playerID = i;
		var playerRowPanelPrefix = "Player" + playerID;
		var playerHeroEntIndex = Players.GetPlayerHeroEntityIndex( playerID );
		var playerRow = $( "#PlayerContainer" ).FindChildInLayoutFile( playerRowPanelPrefix );
		if ( playerRow !== null )
		{
			playerRow.SetHasClass( "player_muted", Game.IsPlayerMuted( playerID ) )
			playerRow.SetHasClass( "local_player", Game.GetLocalPlayerID() == playerID )
			playerRow.SetAttributeInt( "player_id", playerID );

			var colorInt = Players.GetPlayerColor( playerID );
			var colorString = "#" + intToARGB( colorInt );

			var playerColor = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "Color" );
			playerColor.style.backgroundColor = colorString;

			var playerHeroNameLabel = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "HeroName" );
			var szPlayerNameString = Players.GetPlayerSelectedHero( playerID );
			playerHeroNameLabel.text = $.Localize( "#" + szPlayerNameString );
			if ( playerHeroNameLabel.text === "invalid index" )
			{
				 playerHeroNameLabel.text = "";
			} 

			var playerNameLabel = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "PlayerName" );
			playerNameLabel.text = Players.GetPlayerName( playerID );

			var playerHeroImage = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "HeroImage" );
			playerHeroImage.heroname = szPlayerNameString;


			var playerKills = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "Kills" );
			playerKills.text = 0;

			var playerDeaths = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "Deaths" );
			playerDeaths.text = 0;

			var playerBags = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "Bags" );
			playerBags.text = 0;

			var playerSaves = playerRow.FindChildInLayoutFile( playerRowPanelPrefix + "Saves" );
			playerSaves.text = 0;
		}
	}
}

function OnRoundEnded()
{
	Game.EmitSound( "RoundSuccess" );
	if ( Players.IsSpectator( Game.GetLocalPlayerID() ) === false )
	{
		$.GetContextPanel().SetHasClass( "round_over", true );
		$.DispatchEvent( "DOTAHUDToggleScoreboard" )
	}
}    

function OnScoreboardDataUpdated( table_name, key, data  )
{
	//UpdateScoreboard();
}

GameEvents.Subscribe( "round_over", OnRoundEnded );
CustomNetTables.SubscribeNetTableListener( "holdout_scores", OnScoreboardDataUpdated )


function SetFlyoutScoreboardVisible( bVisible )
{
	$.GetContextPanel().SetHasClass( "flyout_scoreboard_visible", bVisible );
	if ( bVisible === true )
	{
		UpdateScoreboard();
	}
}

(function()
{	
	InitializeScoreboard();
	SetFlyoutScoreboardVisible( false );
	
	$.RegisterEventHandler( "DOTACustomUI_SetFlyoutScoreboardVisible", $.GetContextPanel(), SetFlyoutScoreboardVisible );
})();

