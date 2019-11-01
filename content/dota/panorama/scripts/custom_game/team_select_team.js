"use strict";


//--------------------------------------------------------------------------------------------------
// Handle the team panel button press and assign the player to the team
//--------------------------------------------------------------------------------------------------
function OnJoinTeamPressed()
{
	// Get the team id asscociated with the team button that was pressed
	var teamId = $.GetContextPanel().GetAttributeInt( "team_id", -1 );

	// Request to join the team of the button that was pressed
	Game.PlayerJoinTeam( teamId );
}


//--------------------------------------------------------------------------------------------------
// Entry point function for a team panel, there is one team panel per-team, so this will be called 
// once for each each of the teams.
//--------------------------------------------------------------------------------------------------
(function ()
{	
	var teamId = $.GetContextPanel().GetAttributeInt( "team_id", -1 );
	var teamDetails = Game.GetTeamDetails( teamId );

	// Add the team logo to the panel
	var logo_xml = GameUI.CustomUIConfig().team_logo_xml;
	if ( logo_xml )
	{
		var teamLogoPanel = $( "#TeamLogo" );
		teamLogoPanel.SetAttributeInt( "team_id", teamId );
		teamLogoPanel.BLoadLayout( logo_xml, false, false );
	}

	// Set the team name
	var teamDetails = Game.GetTeamDetails( teamId );
	$( "#TeamNameLabel" ).text = $.Localize( teamDetails.team_name );
	
	// Get the player list and add player slots so that there are upto team_max_player slots
	var playerListNode = $.GetContextPanel().FindChildInLayoutFile( "PlayerList" );

	var numPlayerSlots = teamDetails.team_max_players;
	for ( var i = 0; i < numPlayerSlots; ++i )
	{
		// Add the slot itself
		var slot = $.CreatePanel( "Panel", playerListNode, "" );
		slot.AddClass( "player_slot" );
		slot.SetAttributeInt( "player_slot", i );
	}

	if ( GameUI.CustomUIConfig().team_colors )
	{
		var teamColor = GameUI.CustomUIConfig().team_colors[ teamId ];
		teamColor = teamColor.replace( ";", "" );
		
		var teamBackgroundGradient = $( "#TeamBackgroundGradient" );
		if ( teamBackgroundGradient )
		{
			var gradientText = 'gradient( linear, -800% -1600%, 50% 100%, from( ' + teamColor + ' ), to( #00000088 ) );';
			teamBackgroundGradient.style.backgroundColor = gradientText;	
		}

		var teamBackgroundGradientHighlight = $( "#TeamBackgroundGradientHighlight" );
		if ( teamBackgroundGradientHighlight )
		{
			var gradientText = 'gradient( linear, -800% -1600%, 90% 100%, from( ' + teamColor + ' ), to( #00000088 ) );';
			teamBackgroundGradientHighlight.style.backgroundColor = gradientText;
		}

		var teamNameLabel = $( "#TeamNameLabel" );
		if ( teamNameLabel )
		{
			var colorText = teamColor + ';';
			teamNameLabel.style.color = colorText;
		}		
	}
	

})();
