
$.Schedule( 0.0, function()
{
    $.RegisterEventHandler('DOTAScenePanelSceneLoaded', $('#ModelBackground'), function () { $.DispatchEvent('PlaySoundEffect', 'grimstroke_takeover_stinger'); });
});

var RunPageAnimation = function ()
{
	var seq = new RunSequentialActions();

	$( '#ModelContainer' ).RemoveAndDeleteChildren();
	$( '#ModelContainer' ).BLoadLayoutSnippet( 'ModelSnippet' );
	// disabling camera rotation for locked camera
	$( '#ModelBackground' ).SetRotateParams( 5, 5, 2, 2 );

	$( '#MainContainer' ).RemoveClass( 'Initialize' );
	$( '#ModelBackground' ).RemoveClass( 'Initialize' );
	$( '#DebutInformation' ).RemoveClass( 'Initialize' );
	$( '#InformationBody' ).RemoveClass( 'Initialize' );
	$( '#ItemName' ).RemoveClass( 'Initialize' );
	$( '#InformationBodyBackground' ).RemoveClass( 'Initialize' );
	$( '#ItemLore' ).RemoveClass( 'Initialize' );

	// Disabling Fullscreen allows Menu UI to display
	$.DispatchEvent( 'DOTASetCurrentDashboardPageFullscreen', true );

	seq.actions.push( new WaitForClassAction( $( '#ModelBackground' ), 'SceneLoaded' ) );
	seq.actions.push( new WaitAction( 0.4 ) );
	seq.actions.push( new AddClassAction( $( '#MainContainer' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 0.0 ) );
	seq.actions.push( new AddClassAction( $( '#ModelBackground' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 0.5 ) );
	seq.actions.push( new AddClassAction( $( '#DebutInformation' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#InformationBody' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 0.0 ) );
	seq.actions.push( new AddClassAction( $( '#ItemName' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 0.0 ) );
	seq.actions.push( new AddClassAction( $( '#InformationBodyBackground' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#ItemLore' ), 'Initialize' ) );
	// enabling camera movement
	seq.actions.push( new RunFunctionAction( function() 
	{
	    $('#ModelBackground').SetRotateParams( 5, 9, -2, 2 );
	} ) );
	seq.actions.push( new WaitAction( 3.0 ) );

	RunSingleAction( seq );
}
