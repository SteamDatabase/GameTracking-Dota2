function OnFadeIn( event_data )
{
	$("#BasePanel").SetHasClass( "Visible", true )
	$("#InvulnerableNotification").SetHasClass( "Visible", false )
}
GameEvents.Subscribe( "fade_in_dialog", OnFadeIn );

function OnSetCustomAlertString( event_data )
{
	$.Msg( "OnSetCustomAlertString: ", event_data );
	var bodyTextLabel = $("#BodyText");
	bodyTextLabel.SetDialogVariable( "keyname", event_data.keyname )
	bodyTextLabel.SetDialogVariable( "keyname2", event_data.keyname2 )
	bodyTextLabel.text = $.Localize( event_data.customBody, bodyTextLabel );
}
GameEvents.Subscribe( "set_custom_alert_string", OnSetCustomAlertString );