/**
 * samples a value following an ease-in, ease-out parametric:
 * https://math.stackexchange.com/questions/121720/ease-in-out-function
 * 
 * If a is set to 1 the ramp function is linear.
 */
var get_dof_value = function(start_val, end_val, sample_ratio, a=2)
{
    var delta = end_val - start_val;
    //var x = i / num_samples;
    var x = sample_ratio;
    var x_a = Math.pow(x, a);
    var diff_a = Math.pow(1 - x, a);
    var y = x_a / (x_a + diff_a);

    return start_val + y * delta;
}

/**
 * Globally available so that it can be finished in EndPageAnimation()
 */
var seq;

/**
 * Main function linked to triggering the debut
 */
var RunPageAnimation = function () {
    seq = new RunSequentialActions();

    $('#ModelContainer').RemoveAndDeleteChildren();
    $('#ModelContainer').BLoadLayoutSnippet('ModelSnippet');

    seq.actions.push(new WaitAction(0.0));
    seq.actions.push(new RunFunctionAction(function () { $.DispatchEvent('DOTASetCurrentDashboardPageFullscreen', false); }))
    seq.actions.push(new WaitForClassAction($('#ModelBackground'), 'SceneLoaded'));
    // seq.actions.push(new WaitForClassAction($('#ModelForeground'), 'SceneLoaded'));

    //
    // handle rackfocus
    //
    seq.actions.push( new RunFunctionAction( function() { 
        let debug = false;

        if( debug )
        {
            // static dof setup for figuring out settings
            let focus_dist = 500;
            let near_oof_band = 480;
            let in_focus_band = 15;
            let far_oof_band = 2000;

            let dof_near_blurry = focus_dist - near_oof_band;
            let dof_near_crisp = focus_dist;
            let dof_far_crisp = dof_near_crisp + in_focus_band;
            let dof_far_blurry = dof_far_crisp + far_oof_band;

            $('#ModelBackground').FireEntityInput('hero_camera', 'SetDOFNearBlurry', dof_near_blurry);
            $('#ModelBackground').FireEntityInput('hero_camera', 'SetDOFNearCrisp', dof_near_crisp);
            $('#ModelBackground').FireEntityInput('hero_camera', 'SetDOFFarCrisp', dof_far_crisp);
            $('#ModelBackground').FireEntityInput('hero_camera', 'SetDOFFarBlurry', dof_far_blurry);

            $('#ModelBackground').FireEntityInput('hero_camera_post', 'SetDOFNearBlurry', dof_near_blurry);
            $('#ModelBackground').FireEntityInput('hero_camera_post', 'SetDOFNearCrisp', dof_near_crisp);
            $('#ModelBackground').FireEntityInput('hero_camera_post', 'SetDOFFarCrisp', dof_far_crisp);
            $('#ModelBackground').FireEntityInput('hero_camera_post', 'SetDOFFarBlurry', dof_far_blurry);

        } else {
            // the real deal -- animate the rack focus given 2 dof settings
            let start_time = 0.00;
            let duration = 1.5;
            let num_samples = 16;
            let dt = duration / num_samples;

            let start_near_blurry = 0;
            let start_near_crisp = 20;
            let start_far_crisp = 2500;
            let start_far_blurry = 3000;

            let end_near_blurry = 20;
            let end_near_crisp = 500;
            let end_far_crisp = 515;
            let end_far_blurry = 2515;

            for( var i=0; i < num_samples; i++ )
            {
                let sample_ratio = i / num_samples;

                //seq.actions.push(new PrintAction("asdf"));
                $.Schedule(start_time + (i * dt), function() {
                    let i_nb = get_dof_value(start_near_blurry, end_near_blurry, sample_ratio);
                    let i_nc = get_dof_value(start_near_crisp, end_near_crisp, sample_ratio);
                    let i_fc = get_dof_value(start_far_crisp, end_far_crisp, sample_ratio);
                    let i_fb = get_dof_value(start_far_blurry, end_far_blurry, sample_ratio);

                    $('#ModelBackground').FireEntityInput('hero_camera', 'SetDOFNearBlurry', i_nb);
                    $('#ModelBackground').FireEntityInput('hero_camera', 'SetDOFNearCrisp', i_nc);
                    $('#ModelBackground').FireEntityInput('hero_camera', 'SetDOFFarCrisp', i_fc);
                    $('#ModelBackground').FireEntityInput('hero_camera', 'SetDOFFarBlurry', i_fb);

                    $('#ModelBackground').FireEntityInput('hero_camera_post', 'SetDOFNearBlurry', i_nb);
                    $('#ModelBackground').FireEntityInput('hero_camera_post', 'SetDOFNearCrisp', i_nc);
                    $('#ModelBackground').FireEntityInput('hero_camera_post', 'SetDOFFarCrisp', i_fc);
                    $('#ModelBackground').FireEntityInput('hero_camera_post', 'SetDOFFarBlurry', i_fb);
                });
            }

        } // if debug
    }));

    //
    // queue camera playback
    //
    seq.actions.push( new RunFunctionAction( function() { 
        $('#ModelBackground').FireEntityInput('hero_camera_driver', 'SetAnimGraphParameter', 'sequence=truck');

    } ) );

    seq.actions.push(new AddClassAction($('#MainContainer'), 'Initialize'));
    seq.actions.push(new AddClassAction($('#ModelBackground'), 'Initialize'));
    // seq.actions.push(new AddClassAction($('#ModelForeground'), 'Initialize'));

    seq.actions.push(new WaitAction(4.0));

    //
    // Switch cameras to enable mouse hover parallax
    //
    seq.actions.push(new RunFunctionAction(function () { $.DispatchEvent('DOTAGlobalSceneSetCameraEntity', 'ModelBackground', 'hero_camera_post', 0.2); }))
    seq.actions.push(new RunFunctionAction(function () { $.DispatchEvent('DOTAGlobalSceneSetRootEntity', 'ModelBackground', 'root_post'); }))
    seq.actions.push(new LerpRotateAction($('#ModelBackground'), 0, 0, 0, 0, -0.13, 0.13, -0.03, 0.03, 0.0));

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

    $('#MainContainer').RemoveClass('Initialize');
    $('#ModelBackground').RemoveClass('Initialize');
    // $('#ModelForeground').RemoveClass('Initialize');

    //$.DispatchEvent('DOTAShowHomePage');
}

