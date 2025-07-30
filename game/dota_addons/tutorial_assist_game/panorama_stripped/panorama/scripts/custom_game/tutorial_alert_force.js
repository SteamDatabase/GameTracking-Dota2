function OnFadeIn( event_data )
{
	$("#BasePanel").SetHasClass( "Visible", true )
	$("#InvulnerableNotification").SetHasClass( "Visible", false )
}
GameEvents.Subscribe( "fade_in_dialog", OnFadeIn );