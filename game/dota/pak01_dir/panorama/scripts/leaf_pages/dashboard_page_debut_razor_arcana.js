/**
 * DRAGON KNIGHT PERSONA DEBUT PAGE
 * file:    dashboard_page_debut_dragon_knight_persona.js
 *
 */
var seq;
var debug_animation = false;


/**
 * Main function linked to triggering the debut
 */
var RunPageAnimation = function () {
    seq = new RunSequentialActions();
 
    $.GetContextPanel().RemoveClass('ShowingAlternateStyle');
    $('#ModelContainer').RemoveAndDeleteChildren();
    $('#ModelContainer').BLoadLayoutSnippet('ModelSnippet');

    $( '#ModelBackground' ).RemoveClass( 'Initialize' );
    $( '#ModelBackgroundAlt' ).RemoveClass( 'Initialize' );

    seq.actions.push(new WaitAction(0.35));
    seq.actions.push(new RunFunctionAction(function () { $.DispatchEvent('DOTASetCurrentDashboardPageFullscreen', true); }))
    seq.actions.push(new WaitForClassAction($('#ModelBackground'), 'SceneLoaded'));
    //seq.actions.push(new WaitForClassAction($('#ModelForeground'), 'SceneLoaded'));

    seq.actions.push( new PlayAndTrackSoundAction( 'razor_arcana_debut_stinger' ));
    seq.actions.push( new PlayAndTrackSoundAction( 'razor_arcana_debut_sfx' ));

    seq.actions.push(new AddClassAction($('#MainContainer'), 'Initialize'));
    seq.actions.push(new AddClassAction($('#ModelBackground'), 'Initialize'));
    seq.actions.push( new AddClassAction( $('#ModelBackgroundAlt'), 'Initialize' ) );
    //seq.actions.push(new AddClassAction($('#ModelForeground'), 'Initialize'));

    
    seq.actions.push(new WaitAction(7.7));      //(7.7)

    seq.actions.push(new AddClassAction($('#DebutInformation'), 'Initialize'));
    seq.actions.push(new AddClassAction($('#InformationBody'), 'Initialize'));

    seq.actions.push( new WaitAction( 4.5 ) );
    seq.actions.push( new AddClassAction( $( '#SecondStyle' ), 'Initialize' ) );
    seq.actions.push( new AddClassAction( $( '#DefaultStyle' ), 'Initialize' ) );

    // enable mouse hover parallax (disable when blocking out camera animation)
    /**
    */
   
    seq.actions.push(new WaitAction(1.7));      //(0.4)

    seq.actions.push(new RunFunctionAction(function () { $.DispatchEvent('DOTAGlobalSceneSetCameraEntity', 'ModelBackground', 'hero_camera_post', 0.0); }))
    seq.actions.push(new RunFunctionAction(function () { $.DispatchEvent('DOTAGlobalSceneSetCameraEntity', 'ModelForeground', 'hero_camera_post', 0.0); }))
    seq.actions.push(new RunFunctionAction(function () { $.DispatchEvent('DOTAGlobalSceneSetRootEntity', 'ModelBackground', 'root_post'); }))
    seq.actions.push(new RunFunctionAction(function () { $.DispatchEvent('DOTAGlobalSceneSetRootEntity', 'ModelForeground', 'root_post'); }))

    //seq.actions.push(new WaitAction(1.0));


    //seq.actions.push(new LerpRotateAction($('#ModelBackground'), 0, 0, 0, 0, -.75, 0.75, -.5, .5, 0.5));
    //seq.actions.push(new LerpRotateAction($('#ModelForeground'), 0, 0, 0, 0, -1, 2, 1, 1, 0.0));
    seq.actions.push(new LerpRotateAction($('#ModelBackground'), 0, 0, 0, 0, -0.7, 0.7, -0.3, 0.3, 0.0));
    seq.actions.push(new LerpRotateAction($('#ModelBackgroundAlt'), 0, 0, 0, 0, -0.7, 0.7, -0.3, 0.3, 0.0));


    // play the sequences!
    RunSingleAction(seq);
}

function reloadRazorArcanaDebutPage() 
{
    $.DispatchEvent('DOTAReloadCurrentPage');
}

function alternateStyle()
{
    $.GetContextPanel().AddClass('ShowingAlternateStyle');
}

function originalStyle()
{
    $.GetContextPanel().RemoveClass('ShowingAlternateStyle');
}

/**
 * post-callback assigned when leaving the debut
 */
var EndPageAnimation = function () {
    if (seq != undefined) {
        seq.finish();
    }
    
    PlayAndTrackSoundAction.StopAllTrackedSounds();

    $('#MainContainer').RemoveClass('Initialize');
    $('#ModelBackground').RemoveClass('Initialize');
    //$('#ModelForeground').RemoveClass('Initialize');


    $('#DebutInformation').RemoveClass('Initialize');
    $('#InformationBody').RemoveClass('Initialize');

    //$.DispatchEvent('DOTAShowHomePage');
}

