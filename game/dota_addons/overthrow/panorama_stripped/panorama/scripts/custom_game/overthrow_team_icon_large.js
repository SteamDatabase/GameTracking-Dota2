var teamId = $.GetContextPanel().GetAttributeInt( "team_id", -1 );
if ( GameUI.CustomUIConfig().team_colors )
{
	var teamColor = GameUI.CustomUIConfig().team_colors[ teamId ];
	if ( teamColor )
	{
		$("#ShieldColor").style.washColor = teamColor;
	}
}
if ( GameUI.CustomUIConfig().team_icons )
{
	var teamIcon = GameUI.CustomUIConfig().team_icons[ teamId ];
	if ( teamIcon )
	{
		$("#TeamIcon").SetImage( teamIcon );
	}
}