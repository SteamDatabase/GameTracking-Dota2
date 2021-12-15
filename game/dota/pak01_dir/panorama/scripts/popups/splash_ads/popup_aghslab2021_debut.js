function RunPopupAnimation()
{
	var popup = $.GetContextPanel();

	var moviePanel = $( '#DebutMovie' );
	moviePanel.SetMovie( 'file://{resources}/videos/continuum_conundrum/continuum_conundrum_%language%.webm' );
	moviePanel.SetCaptions( 'file://{resources}/videos/continuum_conundrum/continuum_conundrum_%language%.vtt' );

	var seq = new RunSequentialActions();
	seq.actions.push( new StartDuckingUIMusicAction( popup ) );
	seq.actions.push( new PlayMovieAction( moviePanel ) );
	seq.actions.push( new AddClassAction( popup, 'MovieFinished' ) );

	RunSingleAction( seq );
}

function HandleCancel()
{
	$.GetContextPanel().AddClass( "ShowCloseButton" );
}