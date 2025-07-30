function OnSetAlertImage( event_data )
{
	$("#BodyImageRight").SetHasClass( event_data.image_class, true );
}
GameEvents.Subscribe( "set_alert_image", OnSetAlertImage );