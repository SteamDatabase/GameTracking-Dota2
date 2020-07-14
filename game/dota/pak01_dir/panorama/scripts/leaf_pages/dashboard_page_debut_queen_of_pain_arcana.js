
var g_Toggle = false;
var CameraToggle = function () {
    var strFunction = g_Toggle ? "qop_arc_debut_camera_style_1" : "qop_arc_debut_camera_style_2";
    g_Toggle = !g_Toggle;
    $('#ModelBackground').FireEntityInput( 'camera_driver', 'SetAnimation', strFunction );
}

var RunPageAnimation = function ()
{
	var seq = new RunSequentialActions();

	$( '#ModelContainer' ).RemoveAndDeleteChildren();
	$( '#ModelContainer' ).BLoadLayoutSnippet( 'ModelSnippet' );

	$( '#MainContainer' ).RemoveClass( 'Initialize' );
	$( '#ModelBackground' ).RemoveClass( 'Initialize' );
	$( '#DebutInformation' ).RemoveClass( 'Initialize' );
	$( '#InformationBody' ).RemoveClass( 'Initialize' );
	$( '#InformationBodyBackground' ).RemoveClass( 'Initialize' );
	$( '#ItemLore' ).RemoveClass( 'Initialize' );
    $('#AlternateStyleButton').RemoveClass('Initialize');
    $('#DefaultStyleButton').RemoveClass('Initialize');

	seq.actions.push( new WaitAction( 0.01 ) );
    seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'DOTASetCurrentDashboardPageFullscreen', true ); } ) )
	seq.actions.push( new WaitForClassAction( $( '#ModelBackground' ), 'SceneLoaded' ) );
    seq.actions.push( new RunFunctionAction( function () { $('#ModelBackground').FireEntityInput('qop_arcana_alt', "Disable", '0'); } ) )
	seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'PlaySoundEffect', 'qop_arcana_takeover_stinger' ); } ) )
	seq.actions.push( new WaitAction( 0.25 ) );
	seq.actions.push( new AddClassAction( $( '#MainContainer' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 0.0 ) );
	seq.actions.push( new AddClassAction( $( '#ModelBackground' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 2.0 ) );
	seq.actions.push( new AddClassAction( $( '#DebutInformation' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#InformationBody' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#InformationBodyBackground' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#ItemLore' ), 'Initialize' ) );
    seq.actions.push( new AddClassAction( $( '#AlternateStyleButton'), 'Initialize' ) );
    seq.actions.push( new AddClassAction( $( '#DefaultStyleButton'), 'Initialize' ) );

	seq.actions.push( new RunFunctionAction( function() 
	{
	    $('#ModelBackground').SetRotateParams( -1, 1, -1, 1 );
	}));

	RunSingleAction( seq );
}

function alternateStyle() {
    $.GetContextPanel().AddClass('ShowingAlternateStyle');
    CameraToggle();
    $( '#ModelBackground' ).FireEntityInput( 'qop_arcana_alt', 'SetActivityModifier', 'debut_alt_style' );
    $.Schedule(0.4, function () {
        $('#ModelBackground').FireEntityInput( 'qop_arcana_alt', "Enable", '0' );
        $('#ModelBackground').FireEntityInput( 'qop_arcana_alt', 'SetActivity', 'ACT_DOTA_SPAWN' );
    } );
    $.Schedule(1.0, function () { $( '#ModelBackground' ).FireEntityInput( 'qop_arcana_alt', 'SetActivity', 'ACT_DOTA_LOADOUT' ); } );
}

function originalStyle() {
    $.GetContextPanel().RemoveClass( 'ShowingAlternateStyle' );
    // play blue blink fx
    CameraToggle();
    $( '#ModelBackground' ).FireEntityInput( 'qop_arcana_alt', 'SetActivityModifier', 'debut_alt_style' );
    $( '#ModelBackground' ).FireEntityInput( 'qop_arcana_alt', 'SetActivity', 'ACT_BARNACLE_CHEW' );
    $.Schedule(0.5, function () { $('#ModelBackground').FireEntityInput('qop_arcana_alt', "Disable", '0'); } );
}

function closeQueenOfPainDebutPage()
{
    $.GetContextPanel().RemoveClass('ShowingAlternateStyle');
    if ( g_Toggle )
    {
        CameraToggle();
    }
    $.DispatchEvent( 'DOTAShowHomePage' );
}