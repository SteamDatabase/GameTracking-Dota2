(function()
{
	var cfg = GameUI.CustomUIConfig().multiteam_top_scoreboard;
	if ( cfg )
	{
		if ( cfg.TeamOverlayXMLFile )
		{
			var teamId = $.GetContextPanel().GetAttributeInt( "team_id", -1 );
			$( "#TeamOverlayXMLFile" ).SetAttributeInt( "team_id", teamId );

			$( "#TeamOverlayXMLFile" ).BLoadLayout( cfg.TeamOverlayXMLFile, false, false );
		}
	}
})();