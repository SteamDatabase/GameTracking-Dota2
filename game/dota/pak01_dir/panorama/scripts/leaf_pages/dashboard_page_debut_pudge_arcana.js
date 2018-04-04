
$.Schedule( 0.0, function()
{
    $.RegisterEventHandler('DOTAScenePanelSceneLoaded', $('#ModelBackground'), function () { $.DispatchEvent('PlaySoundEffect', 'pudge_arcana_takeover_stinger'); });
});

var RunPageAnimation = function ()
{
	var seq = new RunSequentialActions();

	$( '#ModelContainer' ).RemoveAndDeleteChildren();
	$( '#ModelContainer' ).BLoadLayoutSnippet( 'ModelSnippet' );

	$( '#MainContainer' ).RemoveClass( 'Initialize' );
	$( '#ModelBackground' ).RemoveClass( 'Initialize' );
	$( '#DebutInformation' ).RemoveClass( 'Initialize' );
	$( '#InformationBody' ).RemoveClass( 'Initialize' );
	$( '#ItemName' ).RemoveClass( 'Initialize' );
	$( '#InformationBodyBackground' ).RemoveClass( 'Initialize' );
	$( '#ItemLore' ).RemoveClass( 'Initialize' );
	$( '#InnerPanel' ).RemoveClass( 'Initialize' );
	$( '#StyleContainer' ).RemoveClass( 'Initialize' );
	$( '#MainContainer' ).RemoveClass( 'Style1Visible' );
	$( '#MainContainer' ).RemoveClass( 'Style2Visible' );

	$.DispatchEvent( 'DOTASetCurrentDashboardPageFullscreen', true );

	seq.actions.push(new WaitForClassAction($('#ModelBackground'), 'SceneLoaded'));
	seq.actions.push(new WaitAction(1.0));
	seq.actions.push(new AddClassAction($('#MainContainer'), 'Initialize'));
	seq.actions.push(new WaitAction(6.0));
	seq.actions.push(new AddClassAction($('#ModelBackground'), 'Initialize'));
	seq.actions.push(new WaitAction(1.0));
	seq.actions.push( new AddClassAction( $( '#DebutInformation' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#InformationBody' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 0.5 ) );
	seq.actions.push( new AddClassAction( $( '#ItemName' ), 'Initialize' ) );
	seq.actions.push( new WaitAction( 0.5 ) );
	seq.actions.push( new AddClassAction( $( '#InformationBodyBackground' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#ItemLore' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#InnerPanel' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#StyleContainer' ), 'Initialize' ) );
	seq.actions.push(new AddClassAction($('#MainContainer'), 'Style1Visible'));
	seq.actions.push(new WaitAction(1.5));
	seq.actions.push(new AddClassAction($('#Buttons'), 'Initialize'));
	seq.actions.push(new WaitAction(1.5));
	seq.actions.push(new AddClassAction($('#NextButton'), 'Initialize'));
	seq.actions.push(new AddClassAction($('#QualityContainer'), 'Initialize'));

	RunSingleAction( seq );
}

var g_nCurrentStyle = 0;
const k_nStyleCount = 2;
var onNextStyle = function ()
{
	g_nCurrentStyle = ( g_nCurrentStyle + 1 ) % k_nStyleCount;

	$( '#MainContainer' ).SetHasClass( 'Style1Visible', g_nCurrentStyle == 0 );
	$( '#MainContainer' ).SetHasClass( 'Style2Visible', g_nCurrentStyle == 1 );

	if ( g_nCurrentStyle == 0 )
	{
		$.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'ModelBackground', 'hero_camera_3', 0.6 );
		$.DispatchEvent( 'DOTAGlobalSceneSetRootEntity', 'ModelBackground', 'root_3' );
		$( '#ModelBackground' ).SetRotateParams( -3, 3, -8, -2 );
	}
	else
	{
		$.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'ModelBackground', 'camera_style2', 0.6 );
		$.DispatchEvent( 'DOTAGlobalSceneSetRootEntity', 'ModelBackground', 'root_style2' );
		$( '#ModelBackground' ).SetRotateParams( -9, 0, -3, 3 );
	}
};