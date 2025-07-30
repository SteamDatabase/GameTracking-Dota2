function OnSetImage( event_data )
{
	$("#BodyImage").SetHasClass( event_data.image_class, true );
}
GameEvents.Subscribe( "set_image", OnSetImage);

function OnSetCustomInfoString( event_data )
{
	$.Msg( "OnSetCustomInfoString: ", event_data );
	var bodyTextLabel = $("#BodyText");
	bodyTextLabel.SetDialogVariable( "keyname", event_data.keyname )
	bodyTextLabel.text = $.Localize( event_data.customBody, bodyTextLabel );
}
GameEvents.Subscribe( "set_custom_info_string", OnSetCustomInfoString );