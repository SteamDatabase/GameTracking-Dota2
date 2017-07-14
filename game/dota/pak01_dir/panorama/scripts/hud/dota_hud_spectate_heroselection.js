/* Called from JS delay */
function OnHeroPickDelay()
{
	$.Msg( "OnHeroPickDelay" );
}


/* Called from C++ Code */
function OnHeroPicked( teamIndex, playerIndex )
{
	$.Msg( "OnHeroPicked" );
	$.Schedule( 2.0, function () {
		OnHeroPickDelay();
	} );
}


/* Called from C++ Code */
function OnDraftStateStarted( )
{
	$.Msg( "OnDraftStateStarted" );
}
