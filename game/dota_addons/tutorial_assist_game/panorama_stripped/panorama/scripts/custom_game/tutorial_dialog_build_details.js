function OnFadeIn( event_data )
{
	$("#BasePanel").SetHasClass( "Visible", true )
	$("#InvulnerableNotification").SetHasClass( "Visible", false )
}
GameEvents.Subscribe( "fade_in_dialog", OnFadeIn );

function OnSetBuildImage( event_data )
{
	$("#BodyImage").SetHasClass( event_data.image_class, true );
}
GameEvents.Subscribe( "set_build_image", OnSetBuildImage );