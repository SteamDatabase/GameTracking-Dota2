"use strict";

function OnUpdateHeroSelection()
{
	for ( var teamId of Game.GetAllTeamIDs() )
	{
		UpdateTeam( teamId );
	}
}

function UpdateTeam( teamId )
{
	var teamPanelName = "team_" + teamId;
	var teamPanel = $( "#"+teamPanelName );
	var teamPlayers = Game.GetPlayerIDsOnTeam( teamId );
	teamPanel.SetHasClass( "no_players", ( teamPlayers.length == 0 ) );
	for ( var playerId of teamPlayers )
	{
		UpdatePlayer( teamPanel, playerId );
	}
}

function UpdatePlayer( teamPanel, playerId )
{
	var playerContainer = teamPanel.FindChildInLayoutFile( "PlayersContainer" );
	var playerPanelName = "player_" + playerId;
	var playerPanel = playerContainer.FindChild( playerPanelName );
	if ( playerPanel === null )
	{
		playerPanel = $.CreatePanel( "Image", playerContainer, playerPanelName );
		playerPanel.BLoadLayout( "file://{resources}/layout/custom_game/multiteam_hero_select_overlay_player.xml", false, false );
		playerPanel.AddClass( "PlayerPanel" );
	}

	var playerInfo = Game.GetPlayerInfo( playerId );
	if ( !playerInfo )
		return;

	var localPlayerInfo = Game.GetLocalPlayerInfo();
	if ( !localPlayerInfo )
		return;

	var localPlayerTeamId = localPlayerInfo.player_team_id;
	var playerPortrait = playerPanel.FindChildInLayoutFile( "PlayerPortrait" );
	
	if ( playerId == localPlayerInfo.player_id )
	{
		playerPanel.AddClass( "is_local_player" );
	}

	if ( playerInfo.player_selected_hero !== "" )
	{
		playerPortrait.SetImage( "file://{images}/heroes/" + playerInfo.player_selected_hero + ".png" );
		playerPanel.SetHasClass( "hero_selected", true );
		playerPanel.SetHasClass( "hero_highlighted", false );
	}
	else if ( playerInfo.possible_hero_selection !== "" && ( playerInfo.player_team_id == localPlayerTeamId ) )
	{
		playerPortrait.SetImage( "file://{images}/heroes/npc_dota_hero_" + playerInfo.possible_hero_selection + ".png" );
		playerPanel.SetHasClass( "hero_selected", false );
		playerPanel.SetHasClass( "hero_highlighted", true );
	}
	else
	{
		playerPortrait.SetImage( "file://{images}/custom_game/unassigned.png" );
	}

	var playerName = playerPanel.FindChildInLayoutFile( "PlayerName" );
	playerName.text = playerInfo.player_name;

	playerPanel.SetHasClass( "is_local_player", ( playerId == Game.GetLocalPlayerID() ) );
}

function UpdateTimer()
{
	var gameTime = Game.GetGameTime();
	var transitionTime = Game.GetStateTransitionTime();

	var timerValue = Math.max( 0, Math.floor( transitionTime - gameTime ) );
	
	if ( Game.GameStateIsAfter( DOTA_GameState.DOTA_GAMERULES_STATE_HERO_SELECTION ) )
	{
		timerValue = 0;
	}
	$("#TimerPanel").SetDialogVariableInt( "timer_seconds", timerValue );

	var banPhaseInstructions = $("#BanPhaseInstructions");
	var pickPhaseInstructions = $("#PickPhaseInstructions");

	var bIsInBanPhase = Game.IsInBanPhase();

	banPhaseInstructions.SetHasClass(  "Visible", bIsInBanPhase == true );
	pickPhaseInstructions.SetHasClass( "Visible", bIsInBanPhase == false );

	$.Schedule( 0.1, UpdateTimer );
}

(function()
{
	var bLargeGame = Game.GetAllPlayerIDs().length >= 12;

	var localPlayerTeamId = Game.GetLocalPlayerInfo().player_team_id;
	var first = true;
	var teamsContainer = $("#HeroSelectTeamsContainer");
	var teamsContainer2 = $("#HeroSelectTeamsContainer2");
	$.CreatePanel( "Panel", teamsContainer, "EndSpacer" );
	$.CreatePanel( "Panel", teamsContainer2, "EndSpacer" );
	
	var timerPanel = $.CreatePanel( "Panel", $.GetContextPanel(), "TimerPanel" );
	timerPanel.BLoadLayout( "file://{resources}/layout/custom_game/multiteam_hero_select_overlay_timer.xml", false, false );

	var nTeamsCreated = 0;
	var nTeams = Game.GetAllTeamIDs().length
	$.Msg( nTeams );
	for ( var teamId of Game.GetAllTeamIDs() )
	{
		var teamPanelToUse = null;
		if ( bLargeGame && nTeamsCreated >= ( nTeams / 2 ) )
		{
			teamPanelToUse = teamsContainer2;
		}
		else
		{
			teamPanelToUse = teamsContainer;
			
		}

		$.CreatePanel( "Panel", teamPanelToUse, "Spacer" );

		var teamPanelName = "team_" + teamId;
		var teamPanel = $.CreatePanel( "Panel", teamPanelToUse, teamPanelName );
		teamPanel.BLoadLayout( "file://{resources}/layout/custom_game/multiteam_hero_select_overlay_team.xml", false, false );
		var teamName = teamPanel.FindChildInLayoutFile( "TeamName" );
		if ( teamName )
		{
			teamName.text = $.Localize( Game.GetTeamDetails( teamId ).team_name );
		}

		var logo_xml = GameUI.CustomUIConfig().team_logo_xml;
		if ( logo_xml )
		{
			var teamLogoPanel = teamPanel.FindChildInLayoutFile( "TeamLogo" );
			teamLogoPanel.SetAttributeInt( "team_id", teamId );
			teamLogoPanel.BLoadLayout( logo_xml, false, false );
		}
		
		var teamGradient = teamPanel.FindChildInLayoutFile( "TeamGradient" );
		if ( teamGradient && GameUI.CustomUIConfig().team_colors )
		{
			var teamColor = GameUI.CustomUIConfig().team_colors[ teamId ];
			teamColor = teamColor.replace( ";", "" );
			var gradientText = 'gradient( linear, 0% 0%, 0% 100%, from( ' + teamColor + '40  ), to( #00000000 ) );';
//			$.Msg( gradientText );
			teamGradient.style.backgroundColor = gradientText;
		}

		if ( teamName )
		{
			teamName.text = $.Localize( Game.GetTeamDetails( teamId ).team_name );
		}
		teamPanel.AddClass( "TeamPanel" );

		if ( teamId === localPlayerTeamId )
		{
			teamPanel.AddClass( "local_player_team" );
		}
		else
		{
			teamPanel.AddClass( "not_local_player_team" );
		}
		nTeamsCreated = nTeamsCreated + 1;
	}

	$.CreatePanel( "Panel", teamsContainer, "EndSpacer" );
	$.CreatePanel( "Panel", teamsContainer2, "EndSpacer" );

	OnUpdateHeroSelection();
	GameEvents.Subscribe( "dota_player_hero_selection_dirty", OnUpdateHeroSelection );
	GameEvents.Subscribe( "dota_player_update_hero_selection", OnUpdateHeroSelection );

	UpdateTimer();
})();

