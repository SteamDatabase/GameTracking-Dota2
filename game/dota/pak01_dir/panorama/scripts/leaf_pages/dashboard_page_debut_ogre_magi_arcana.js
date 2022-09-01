
var InfoDebugAction = function (InfoDebug) {
    $.Msg("Info Debug = " + InfoDebug);
    if (InfoDebug === 1) {
        $('#DebutInformation').AddClass('Initialize');
    }
    if (InfoDebug === 0) {
        $('#DebutInformation').RemoveClass('Initialize');
    }
}

var g_Toggle = false;
var CameraToggle = function () {
    //var flIntensity = g_Toggle ? 5.0 : 0.5;
    //g_Toggle = !g_Toggle;
    //$( '#Model' ).FireEntityInput( 'light_hero', 'Intensity', flIntensity );

    var strFunction = g_Toggle ? "om_arc_debut_camera_style_1" : "om_arc_debut_camera_style_2";
    g_Toggle = !g_Toggle;
//    $('#Model').FireEntityInput('light_hero', strFunction, '');
    $('#ModelBackground').FireEntityInput('debut_camera', 'SetAnimation', strFunction);
}

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
	$( '#ItemName' ).RemoveClass( 'Initialize' );
	$( '#InformationBodyBackground' ).RemoveClass( 'Initialize' );
	$( '#ItemLore' ).RemoveClass( 'Initialize' );

	// Disabling Fullscreen allows Menu UI to display
	$.DispatchEvent( 'DOTASetCurrentDashboardPageFullscreen', true );

	seq.actions.push( new WaitForClassAction( $( '#ModelBackground' ), 'SceneLoaded' ) );
	seq.actions.push( new RunFunctionAction( function () { $.DispatchEvent( 'PlaySoundEffect', 'om_arcana_takeover_stinger' ); } ) );
	seq.actions.push( new WaitAction( 0.1 ) );
	seq.actions.push( new AddClassAction( $( '#MainContainer' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 0.1 ) );
	seq.actions.push( new AddClassAction( $( '#ModelBackground' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 0.7 ) );
	seq.actions.push( new AddClassAction( $( '#DebutInformation' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#InformationBody' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 1.3 ) );
	seq.actions.push( new AddClassAction( $( '#ItemName' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 0.5 ) );
	seq.actions.push( new AddClassAction( $( '#InformationBodyBackground' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#ItemLore' ), 'Initialize' ) );

    // enabling camera movement
    seq.actions.push(new LerpRotateAction($('#ModelBackground'), 0, 0, 0, 0, -2, 2, -2, 2, 5.0));
    
	seq.actions.push( new WaitAction( 0 ) );
	seq.actions.push( new AddClassAction( $( '#SecondStyle' ), 'Initialize' ) );

	RunSingleAction(seq);
}
