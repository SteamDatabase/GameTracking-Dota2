/**
 * DRAGON KNIGHT PERSONA DEBUT PAGE
 * file:    dashboard_page_debut_dragon_knight_persona.js
 *
 */
var seq;
var debug_animation = false;


/**
 * Samples a camera dof value between two ranges at time t following an ease-in, 
 * ease-out parametric: 
 * 
 * https://math.stackexchange.com/questions/121720/ease-in-out-function
 * 
 * If a is set to 1 the ramp function is linear.
 */
var get_dof_value = function (
    start_dof, end_dof, i_val, num_samples, a = 2, dof_property = 'SetDOFFarBlurry',
    msg_prefix = 'TEST', camera_name = 'intro_camera', model_id = '#Model') {
    var delta = end_dof - start_dof;
    var x = i_val / num_samples;
    var x_a = Math.pow(x, a);
    var diff_a = Math.pow(1 - x, a);
    var y = x_a / (x_a + diff_a);

    var sampled = start_dof + y * delta;

    return function () {
        $('#ModelBackground').FireEntityInput('hero_camera', dof_property, sampled);
        //$(model_id).FireEntityInput(camera_name, dof_property, sampled);
        //$.Msg( msg_prefix + ": i = " + i_val.toString() + "/" + num_samples.toString() + ";" + dof_property + " = " + sampled.toString() );
    }
}


/**
 * Main function linked to triggering the debut
 */
var RunPageAnimation = function () {
    seq = new RunSequentialActions();

    $('#ModelContainer').RemoveAndDeleteChildren();
    $('#ModelContainer').BLoadLayoutSnippet('ModelSnippet');

    seq.actions.push(new WaitAction(0.35));
    seq.actions.push(new RunFunctionAction(function () { $.DispatchEvent('DOTASetCurrentDashboardPageFullscreen', true); }))
    seq.actions.push(new WaitForClassAction($('#ModelBackground'), 'SceneLoaded'));
    seq.actions.push(new WaitForClassAction($('#ModelForeground'), 'SceneLoaded'));

    seq.actions.push(new PlayAndTrackSoundAction('primal_beast_debut_stinger'));
    seq.actions.push( new PlayAndTrackSoundAction('primal_beast_debut_sfx' ));

    seq.actions.push(new AddClassAction($('#MainContainer'), 'Initialize'));
    seq.actions.push(new AddClassAction($('#ModelBackground'), 'Initialize'));
    seq.actions.push(new AddClassAction($('#ModelForeground'), 'Initialize'));


    seq.actions.push(new WaitAction(5.0));

    seq.actions.push(new AddClassAction($('#DebutInformation'), 'Initialize'));
    seq.actions.push(new AddClassAction($('#InformationBody'), 'Initialize'));

    // enable mouse hover parallax (disable when blocking out camera animation)
    /**
    */

    //seq.actions.push(new WaitAction(1.0));

    seq.actions.push(new RunFunctionAction(function () { $.DispatchEvent('DOTAGlobalSceneSetCameraEntity', 'ModelBackground', 'hero_camera_post', 0.0); }))
    seq.actions.push(new RunFunctionAction(function () { $.DispatchEvent('DOTAGlobalSceneSetCameraEntity', 'ModelForeground', 'hero_camera_post', 0.0); }))
    seq.actions.push(new RunFunctionAction(function () { $.DispatchEvent('DOTAGlobalSceneSetRootEntity', 'ModelBackground', 'root_post'); }))
    seq.actions.push(new RunFunctionAction(function () { $.DispatchEvent('DOTAGlobalSceneSetRootEntity', 'ModelForeground', 'root_post'); }))

    //seq.actions.push(new WaitAction(1.0));


    //seq.actions.push(new LerpRotateAction($('#ModelBackground'), 0, 0, 0, 0, -.75, 0.75, -.5, .5, 0.5));
    seq.actions.push(new LerpRotateAction($('#ModelForeground'), 0, 0, 0, 0, -1, 2, 1, 1, 0.0));
    seq.actions.push(new LerpRotateAction($('#ModelBackground'), 0, 0, 0, 0, -1, 2, 1, 1, 0.0));



    // play the sequences!
    RunSingleAction(seq);
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
    $('#ModelForeground').RemoveClass('Initialize');


    $('#DebutInformation').RemoveClass('Initialize');
    $('#InformationBody').RemoveClass('Initialize');

    //$.DispatchEvent('DOTAShowHomePage');
}

