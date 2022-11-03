/**
 * DEBUT PAGE
 */
var seq;
var debug_animation = false;


/**
 * Main function linked to triggering the debut
 */
var RunPageAnimation = function()
{
    seq = new RunSequentialActions();

    $( '#ModelContainer' ).RemoveAndDeleteChildren();
    $( '#ModelContainer' ).BLoadLayoutSnippet( 'ModelSnippet' );

    seq.actions.push( new WaitAction( 0.35 ) );
    seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'DOTASetCurrentDashboardPageFullscreen', true ); } ) );
    seq.actions.push( new WaitForClassAction( $( '#ModelBackground' ), 'SceneLoaded' ) );
    // seq.actions.push(new WaitForClassAction($('#ModelForeground'), 'SceneLoaded'));

    seq.actions.push( new AddClassAction( $( '#MainContainer' ), 'Initialize' ) );
    seq.actions.push( new AddClassAction( $( '#ModelBackground' ), 'Initialize' ) );
    // seq.actions.push(new AddClassAction($('#ModelForeground'), 'Initialize'));

    seq.actions.push( new PlayAndTrackSoundAction( 'crystal_maiden_persona_stinger' ) );
    seq.actions.push(new PlayAndTrackSoundAction( 'crystal_maiden_persona_sfx' ) );

    seq.actions.push( new WaitAction( 9.00 ) );

    seq.actions.push(new AddClassAction($('#DebutInformation'), 'Initialize'));
    seq.actions.push(new AddClassAction($('#InformationBody'), 'Initialize'));


    seq.actions.push( new WaitAction( 3.65 ) );

    // Switch cameras to enable parallax
    seq.actions.push(new RunFunctionAction(function () { $.DispatchEvent('DOTAGlobalSceneSetCameraEntity', 'ModelBackground', 'hero_camera_post', 0.0); }))
    seq.actions.push(new RunFunctionAction(function () { $.DispatchEvent('DOTAGlobalSceneSetRootEntity', 'ModelBackground', 'root_post'); }))


    // enable mouse hover parallax (disable when blocking out camera animation)
    //seq.actions.push(new LerpRotateAction($('#ModelForeground'), 0, 0, 0, 0, -1, 2, 1, 1, 0.0));
    seq.actions.push(new LerpRotateAction($('#ModelBackground'), 0, 0, 0, 0, -0.5, 0.5, -0.3, 0.3, 0.0));

    // play the sequences!
    RunSingleAction( seq );
};


/**
 * post-callback assigned when leaving the debut
 */
var EndPageAnimation = function()
{
    if ( seq != undefined )
    {
        seq.finish();
    }

    PlayAndTrackSoundAction.StopAllTrackedSounds();

    $( '#MainContainer' ).RemoveClass( 'Initialize' );
    $( '#ModelBackground' ).RemoveClass( 'Initialize' );
    // $('#ModelForeground').RemoveClass('Initialize');

    $( '#DebutInformation' ).RemoveClass( 'Initialize' );
    $( '#InformationBody' ).RemoveClass( 'Initialize' );

    //$.DispatchEvent('DOTAShowHomePage');
};

