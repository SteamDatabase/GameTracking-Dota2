var OnPageSetupSuccess = function ()
{
	// Disabling Fullscreen allows Menu UI to display
	$.DispatchEvent('DOTASetCurrentDashboardPageFullscreen', true);
}

var RunPageAnimation = function ()
{
	var seq = new RunSequentialActions();

	$('#ModelContainer').RemoveAndDeleteChildren();
	$('#ModelContainer').BLoadLayoutSnippet('ModelSnippet');
	$('#DebutInformation').RemoveClass('Initialize');
	$('#CloseButton').RemoveClass('Initialize');
	$('#VoidSpiritLink').RemoveClass('Initialize');

	seq.actions.push( new WaitAction( 0.01 ) );
    seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'DOTASetCurrentDashboardPageFullscreen', true ); } ) )
	seq.actions.push( new WaitForClassAction( $( '#Model' ), 'SceneLoaded' ) );
	seq.actions.push( new RunFunctionAction( function () { $.DispatchEvent('PlaySoundEffect', 'snapfire_takeover_stinger'); }));

    seq.actions.push( new WaitAction( 4.0 ) );
	seq.actions.push( new AddClassAction( $( '#DebutInformation' ), 'Initialize' ) );
// enabling camera movement
	seq.actions.push( new RunFunctionAction( function() 
	{
	    $('#Model').SetRotateParams( -1, 0, -1, 0 );
	}));
	seq.actions.push( new WaitAction( 8.0 ) );
	seq.actions.push( new AddClassAction( $( '#VoidSpiritLink' ), 'Initialize' ) );

	RunSingleAction(seq);
}
