/**
 * DAWNBREAKER DEBUT PAGE
 * file:    dashboard_page_debut_dawnbreaker.js
 *
 */
var seq;
var debug_animation = false;
var g_trackedSoundEvents = [];


function PlayAndTrackSoundAction( soundName )
{
	this.soundName = soundName;
}
PlayAndTrackSoundAction.prototype = new BaseAction();


PlayAndTrackSoundAction.prototype.update = function ()
{
	g_trackedSoundEvents.push( PlayUISoundScript( this.soundName ) );
	return false;
}
var StopAllTrackedSounds = function()
{
	for ( var i = 0; i < g_trackedSoundEvents.length; ++i )
	{
		StopUISoundScript( g_trackedSoundEvents[ i ] );
	}

	g_trackedSoundEvents = [];
}


/**
 * Samples a camera dof value between two ranges at time t following an ease-in, 
 * ease-out parametric: 
 * 
 * https://math.stackexchange.com/questions/121720/ease-in-out-function
 * 
 * If a is set to 1 the ramp function is linear.
 */
var get_dof_value = function(
        start_dof, end_dof, i_val, num_samples, a=2, dof_property='SetDOFFarBlurry', 
        msg_prefix='TEST', camera_name='intro_camera', model_id='#Model')
{
    var delta = end_dof - start_dof;
    var x = i_val / num_samples;
    var x_a = Math.pow(x, a);
    var diff_a = Math.pow(1 - x, a);
    var y = x_a / (x_a + diff_a);

    var sampled = start_dof + y * delta;

    return function()
    {
        $('#ModelBackground').FireEntityInput('hero_camera', dof_property, sampled);
        //$(model_id).FireEntityInput(camera_name, dof_property, sampled);
        //$.Msg( msg_prefix + ": i = " + i_val.toString() + "/" + num_samples.toString() + ";" + dof_property + " = " + sampled.toString() );
    }
}


/**
 * Main function linked to triggering the debut
 */
var RunPageAnimation = function ()
{
    seq = new RunSequentialActions();

	$( '#ModelContainer' ).RemoveAndDeleteChildren();
	$( '#ModelContainer' ).BLoadLayoutSnippet( 'ModelSnippet' );

	seq.actions.push( new WaitAction( 0.01 ) );
    seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'DOTASetCurrentDashboardPageFullscreen', true ); } ) )
    seq.actions.push( new WaitForClassAction( $( '#ModelBackground' ), 'SceneLoaded' ) );

	seq.actions.push( new PlayAndTrackSoundAction( 'dawnbreaker_debut_vo' ) );
    seq.actions.push( new PlayAndTrackSoundAction( 'dawnbreaker_debut_stinger' ) );
	seq.actions.push( new PlayAndTrackSoundAction( 'dawnbreaker_debut_sfx' ) );

	seq.actions.push( new AddClassAction( $( '#MainContainer' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#ModelBackground' ), 'Initialize' ) );

    seq.actions.push( new RunFunctionAction( function() { $('#ModelBackground').FireEntityInput( 'dawnbreaker_hammer_ambient_fx', "stop", '0' ); }));

    // play valora debut sequence
    seq.actions.push( new RunFunctionAction( function() { $('#ModelBackground').FireEntityInput( 'dawnbreaker_debut_fx_model', "SetAnimation", 'dawnbreaker_debut_layout' ); }));
    if( debug_animation ){
        seq.actions.push( new RunFunctionAction( function() { $('#ModelBackground').FireEntityInput( 'valora', "SetAnimation", 'battlemaiden_debut_layout' ); }));
        seq.actions.push( new WaitAction(4.00));

    } else {
        seq.actions.push( new RunFunctionAction( function() { $('#ModelBackground').FireEntityInput( 'valora', "Disable", '0' ); }));
        seq.actions.push( new WaitAction(4.00));
        seq.actions.push( new RunFunctionAction( function() { $('#ModelBackground').FireEntityInput( 'valora', "Enable", '0' ); }));
        seq.actions.push( new RunFunctionAction( function() { $('#ModelBackground').FireEntityInput( 'valora', "SetAnimation", 'battlemaiden_debut_truncated' ); }));

    }

    seq.actions.push( new RunFunctionAction( function() { $('#ModelBackground').FireEntityInput( 'melee_creep_a', "SetAnimation", 'battlemaiden_debut_creep_a' ); }));
    seq.actions.push( new RunFunctionAction( function() { $('#ModelBackground').FireEntityInput( 'melee_creep_b', "SetAnimation", 'battlemaiden_debut_creep_b' ); }));
    seq.actions.push( new RunFunctionAction( function() { $('#ModelBackground').FireEntityInput( 'melee_creep_c', "SetAnimation", 'battlemaiden_debut_creep_c' ); }));
    seq.actions.push( new RunFunctionAction( function() { $('#ModelBackground').FireEntityInput( 'melee_creep_d', "SetAnimation", 'battlemaiden_debut_creep_d' ); }));
    

    seq.actions.push(new WaitAction(1.00));
    seq.actions.push( new RunFunctionAction( function() { $('#ModelBackground').FireEntityInput( 'dawnbreaker_hammer_ambient_fx', "start", '0' ); }));
    seq.actions.push(new WaitAction(3.00));
    seq.actions.push(new WaitAction(4.0));

    seq.actions.push( new AddClassAction( $( '#DebutInformation' ), 'Initialize' ) );
    //seq.actions.push( new AddClassAction( $( '#InformationBody' ), 'Initialize' ) );

    //
    // animate rack focus transitioning from beginning to mid sequence
    //
    num_samples = 8;
    s_near_blurry = 150;
    s_near_crisp = 500;
    s_far_crisp = 30000;
    s_far_blurry = 50000;

    e_near_blurry = 150;
    e_near_crisp = 350;
    e_far_crisp = s_far_crisp * 0.625;
    e_far_blurry = s_far_blurry * 0.9;

    var duration;
    var accum = 0.0;

    duration = 4.0;
    dt = duration / num_samples;

    for( var i = 0; i < num_samples; i++ )
    {
        seq.actions.push(new WaitAction(dt));

        fn = get_dof_value(s_near_blurry, e_near_blurry, i, num_samples, a=1, 
                           dof_property="SetDOFNearBlurry", camera_name='hero_camera',
                           model_id='#ModelBackground');
        seq.actions.push( new RunFunctionAction( fn ) );

        fn = get_dof_value(s_near_crisp, e_near_crisp, i, num_samples, a=1, 
                           dof_property="SetDOFNearCrisp", camera_name='hero_camera',
                           model_id='#ModelBackground');
        seq.actions.push( new RunFunctionAction( fn ) );

        fn = get_dof_value(s_far_crisp, e_far_crisp, i, num_samples, a=1, 
                          dof_property="SetDOFFarCrisp" , camera_name='hero_camera',
                          model_id='#ModelBackground');
        seq.actions.push( new RunFunctionAction( fn ) );

        fn = get_dof_value(s_far_blurry, e_far_blurry, i, num_samples, a=1, 
                           dof_property="SetDOFFarBlurry", camera_name='hero_camera',
                           model_id='#ModelBackground');
        seq.actions.push( new RunFunctionAction( fn ) );
    }

    // enable mouse hover parallax
    seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'ModelBackground', 'hero_camera_post', 3.0 );  } ) )
    seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'DOTAGlobalSceneSetRootEntity', 'ModelBackground', 'root_post' ); } ) )
    seq.actions.push(new LerpRotateAction($('#ModelBackground'), 0, 0, 0, 0, -3, 6, 0, 0, 3.0));
    
    // queue the loopable idle 
    seq.actions.push(new WaitAction(5.5));
    seq.actions.push( new RunFunctionAction( function() { $('#ModelBackground').FireEntityInput( 'valora', "SetAnimation", 'battlemaiden_debut_idle' ); }));

       
    // play the sequences!
    RunSingleAction( seq );
}


/**
 * post-callback assigned when leaving the debut
 */
var EndPageAnimation = function()
{
    if( seq != undefined ){
        seq.finish();
    }
    StopAllTrackedSounds();

    $('#MainContainer').RemoveClass('Initialize');
    $('#ModelBackground').RemoveClass('Initialize');

    $('#DebutInformation').RemoveClass('Initialize');
    //$('#InformationBody').RemoveClass('Initialize');

    //$.DispatchEvent('DOTAShowHomePage');
}

