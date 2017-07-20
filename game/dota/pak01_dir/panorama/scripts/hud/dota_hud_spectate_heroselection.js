/* Called from JS delay */
function OnHeroPickDelay()
{
	$.Msg( "OnHeroPickDelay" );
}


/* Called from C++ Code */
function OnHeroPicked( teamIndex, playerIndex )
{
	$.Msg( "OnHeroPicked " + teamIndex.toString() + " " + playerIndex.toString() );
	$.Schedule( 2.0, function () {
		OnHeroPickDelay();
	} );
}

/* Called from C++ Code */
function OnHeroPickStart( teamIndex, playerIndex )
{
	$.Msg( "OnHeroPickStart " + teamIndex.toString() + " " + playerIndex.toString() );
}

function OnHeroBanStart( teamIndex, playerIndex )
{
	$.Msg( "OnHeroBanStart " + teamIndex.toString() + " " + playerIndex.toString() );
}

function OnHeroBanned( teamIndex, playerIndex )
{
	$.Msg( "OnHeroBanned " + teamIndex.toString() + " " + playerIndex.toString() );
}



/* Called from C++ Code */
function OnDraftStateStarted( )
{
	$.Msg( "OnDraftStateStarted" );
}
