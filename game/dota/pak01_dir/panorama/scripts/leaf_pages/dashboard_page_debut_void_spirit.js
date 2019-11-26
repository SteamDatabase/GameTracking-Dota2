
var RunPageAnimation = function ()
{
	var seq = new RunSequentialActions();

	$( '#ModelContainer' ).RemoveAndDeleteChildren();
	$( '#ModelContainer' ).BLoadLayoutSnippet( 'ModelSnippet' );
	// disabling camera rotation for locked camera
	//$( '#ModelBackground' ).SetRotateParams( 2, 2, 2, 2 );

	$( '#MainContainer' ).RemoveClass( 'Initialize' );
	$( '#ModelBackground' ).RemoveClass( 'Initialize' );
	$( '#DebutInformation' ).RemoveClass( 'Initialize' );
	$( '#InformationBody' ).RemoveClass( 'Initialize' );
//	$( '#ItemName' ).RemoveClass( 'Initialize' );
	$( '#InformationBodyBackground' ).RemoveClass( 'Initialize' );
	$( '#ItemLore' ).RemoveClass( 'Initialize' );
	$( '#SnapfireLink' ).RemoveClass( 'Initialize' );

    $('#ModelBackground').SetRotateParams( -1, 1, 0, 0 );

	seq.actions.push( new WaitAction( 0.01 ) );
    seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'DOTASetCurrentDashboardPageFullscreen', true ); } ) )
	seq.actions.push( new WaitForClassAction( $( '#ModelBackground' ), 'SceneLoaded' ) );
	seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'PlaySoundEffect', 'void_spirit_debut_takeover_stinger' ); } ) )
	seq.actions.push( new WaitAction( 0.4 ) );
	seq.actions.push( new AddClassAction( $( '#MainContainer' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 0.0 ) );
	seq.actions.push( new AddClassAction( $( '#ModelBackground' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 8.9 ) );
	seq.actions.push( new AddClassAction( $( '#DebutInformation' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#InformationBody' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 0.0 ) );
//	seq.actions.push( new AddClassAction( $( '#ItemName' ), 'Initialize' ) );
//	seq.actions.push( new WaitAction( 0.0 ) );
	seq.actions.push( new AddClassAction( $( '#InformationBodyBackground' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#ItemLore' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 14.0 ) );
	seq.actions.push( new AddClassAction( $( '#SnapfireLink' ), 'Initialize' ) );

	RunSingleAction( seq );
}
