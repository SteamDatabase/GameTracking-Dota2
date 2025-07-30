function OnSetCustomObjectiveString( event_data )
{
	$.Msg( "OnSetCustomObjectiveString: ", event_data );
	var bodyTextLabel = $("#BodyText");
	bodyTextLabel.SetDialogVariable( "keyname", event_data.keyname )
	bodyTextLabel.text = $.Localize( event_data.customBody, bodyTextLabel );
}
GameEvents.Subscribe( "set_custom_objective_string", OnSetCustomObjectiveString );