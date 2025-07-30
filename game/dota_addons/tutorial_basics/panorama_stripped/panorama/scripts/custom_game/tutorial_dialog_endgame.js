function OnSetImage( event_data )
{
	$("#BodyImage").SetHasClass( event_data.image_class, true );
}
GameEvents.Subscribe( "set_image", OnSetImage);