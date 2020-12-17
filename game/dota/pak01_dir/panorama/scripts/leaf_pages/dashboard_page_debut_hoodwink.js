// ----------------------------------------------------------------------------
//   PlayAndTrackSoundAction
//
//   Helper action that keeps track of any sounds that are playing, and when
//   the page is closing it automatically stops them.
// ----------------------------------------------------------------------------
var seq;
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

//
//
//
var OnPageSetupSuccess = function ()
{
	// Disabling Fullscreen allows Menu UI to display
	$.DispatchEvent('DOTASetCurrentDashboardPageFullscreen', true);
}


/**
 * Samples a camera dof value between two ranges at time t following an ease-in, 
 * ease-out parametric: 
 * 
 * https://math.stackexchange.com/questions/121720/ease-in-out-function
 * 
 * If a is set to 1 the ramp function is linear.
 */
var get_dof_value = function( start_dof, end_dof, i_val, num_samples, a=2, dof_property='SetDOFFarBlurry', msg_prefix='TEST' )
{
    var delta = end_dof - start_dof;
    var x = i_val / num_samples;
    var x_a = Math.pow(x, a);
    var diff_a = Math.pow(1 - x, a);
    var y = x_a / (x_a + diff_a);

    var sampled = start_dof + y * delta;

    return function()
    {
        $('#Model').FireEntityInput('intro_camera', dof_property, sampled);
        //$.Msg( msg_prefix + ": i = " + i_val.toString() + "/" + num_samples.toString() + ";" + dof_property + " = " + sampled.toString() );
    }
}


/**
 * Main function linked to triggering the debut
 */
var RunPageAnimation = function ()
{
	seq = new RunSequentialActions();

	$('#ModelContainer').RemoveAndDeleteChildren();
	$('#ModelContainer').BLoadLayoutSnippet('ModelSnippet');
	$('#DebutInformation').RemoveClass('Initialize');

	seq.actions.push( new WaitAction( 0.01 ) );
    seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'DOTASetCurrentDashboardPageFullscreen', true ); } ) )
	seq.actions.push( new WaitForClassAction( $( '#Model' ), 'SceneLoaded' ) );
	seq.actions.push( new PlayAndTrackSoundAction( 'hoodwink_debut_stinger' ) );
	seq.actions.push( new PlayAndTrackSoundAction( 'hoodwink_debut_sfx' ) );

    seq.actions.push(new RunFunctionAction(function () { $('#Model').FireEntityInput('hoodwink', 'SetAnimation', 'hoodwink_debut_spawn'); }))
    seq.actions.push(new RunFunctionAction(function () { $('#Model').FireEntityInput('creep1', 'SetAnimation', 'hoodwink_debut_crp1'); }))
    seq.actions.push(new RunFunctionAction(function () { $('#Model').FireEntityInput('creep2', 'SetAnimation', 'hoodwink_debut_crp2'); }))

    //
    // put the animated rack focus, plus contingency plan for the beginning 
    // part of the sequence in case the creep + bolt timing is off
    //
    var s_near_blurry, s_near_crisp, s_far_crisp, s_far_blurry;
    var e_near_blurry, e_near_crisp, e_far_crisp, e_far_blurry;
    var dt;
    var num_samples = 25;

    var ANIMATE_STARTING_RACK_FOCUS = true;
    if( ANIMATE_STARTING_RACK_FOCUS )
    {
        seq.actions.push(new WaitAction(0.45));

        //
        // animate rack focus transitioning from beginning to mid sequence
        //
        num_samples = 8;
        s_near_crisp = 300;
        s_far_crisp = 400;
        s_far_blurry = 500;
        e_near_crisp = 150;
        e_far_crisp = 700;
        e_far_blurry = 1000;

        var duration;
        var accum = 0.0;

        duration = 1.50;
        dt = duration / num_samples;

        for( var i = 0; i < num_samples; i++ )
        {
            seq.actions.push(new WaitAction(dt));

            fn = get_dof_value( s_near_crisp, e_near_crisp, i, num_samples, a=1, dof_property="SetDOFNearCrisp" );
            seq.actions.push( new RunFunctionAction( fn ) );

            fn = get_dof_value( s_far_crisp, e_far_crisp, i, num_samples, a=1, dof_property="SetDOFFarCrisp" );
            seq.actions.push( new RunFunctionAction( fn ) );

            fn = get_dof_value( s_far_blurry, e_far_blurry, i, num_samples, a=1, dof_property="SetDOFFarBlurry" );
            seq.actions.push( new RunFunctionAction( fn ) );
        }


    }
    else
    {
        // contingency plan if creep3 hit is not connecting: set a predefined dof value and don't peform the rack
        seq.actions.push( new RunFunctionAction( function() { $('#Model').FireEntityInput('intro_camera', "SetDOFNearCrisp", 140); }));
        seq.actions.push( new RunFunctionAction( function() { $('#Model').FireEntityInput('intro_camera', "SetDOFFarCrisp", 500); }));
        seq.actions.push( new RunFunctionAction( function() { $('#Model').FireEntityInput('intro_camera', "SetDOFFarBlurry", 1000); }));
        $('#Model').FireEntityInput('intro_camera', "SetDOFFarBlurry", 1000);

        seq.actions.push(new WaitAction(0.45));
        seq.actions.push(new WaitAction(1.50));
    }

    //
    // unfortunately have to manually eyeball the start trigger for the 3rd creep bcse dumb reasons
    //
    seq.actions.push(new RunFunctionAction(function () { $('#Model').FireEntityInput('creep3', 'SetAnimation', 'hoodwink_debut_crp3'); }))

    //
    // animate rack focus transitioning to the middle sequence (hero shot)
    //
    num_samples = 25;
    s_near_crisp = 150;
    s_far_crisp = 700;
    s_far_blurry = 1000;
    e_near_crisp = 400;
    e_far_crisp = 1500;
    e_far_blurry = 6000;

    dt = 2.0 / num_samples;
    for( var i = 0; i <= num_samples; i++ )
    {
        seq.actions.push(new WaitAction(dt));

        fn = get_dof_value( s_near_crisp, e_near_crisp, i, num_samples, a=1, dof_property="SetDOFNearCrisp" );
        seq.actions.push( new RunFunctionAction( fn ) );

        fn = get_dof_value( s_far_crisp, e_far_crisp, i, num_samples, a=1, dof_property="SetDOFFarCrisp" );
        seq.actions.push( new RunFunctionAction( fn ) );

        fn = get_dof_value( s_far_blurry, e_far_blurry, i, num_samples, a=1, dof_property="SetDOFFarBlurry" );
        seq.actions.push( new RunFunctionAction( fn ) );
    }


    seq.actions.push(new WaitAction(0.05));

    //
    // animate rack focus transitioning to the end (hold, keepalive)
    //
    s_near_crisp = 400;
    s_far_crisp = 2000;
    s_far_blurry = 6000;
    e_near_crisp = 200;
    e_far_crisp = 430;
    e_far_blurry = 2000;

    dt = 2.0 / num_samples;
    for( var i = 0; i <= num_samples; i++ )
    {
        seq.actions.push(new WaitAction(dt));

        fn = get_dof_value( s_near_crisp, e_near_crisp, i, num_samples, a=2, dof_property="SetDOFNearCrisp" );
        seq.actions.push( new RunFunctionAction( fn ) );

        fn = get_dof_value( s_far_crisp, e_far_crisp, i, num_samples, a=2, dof_property="SetDOFFarCrisp" );
        seq.actions.push( new RunFunctionAction( fn ) );

        fn = get_dof_value( s_far_blurry, e_far_blurry, i, num_samples, a=2, dof_property="SetDOFFarBlurry" );
        seq.actions.push( new RunFunctionAction( fn ) );
    }

    //
    // enable the camera 
    //
    seq.actions.push( new WaitAction( 0.8 ) );
	seq.actions.push( new AddClassAction( $( '#DebutInformation' ), 'Initialize' ) );
	seq.actions.push( new RunFunctionAction( function() 
	{
	    $('#Model').SetRotateParams( -1, 0, -1, 0 );
	}));

    seq.actions.push(new WaitAction(7.93));
    seq.actions.push(new RunFunctionAction(function () { $('#Model').FireEntityInput('hoodwink', 'SetAnimation', 'hoodwink_debut_idle'); }))

	RunSingleAction(seq);
}


/**
 * post-callback assigned when leaving the debut
 */
var EndPageAnimation = function()
{
    seq.finish();
	StopAllTrackedSounds();

    //$( '#ItemName' ).RemoveClass( 'Initialize' );
	//$( '#InformationBodyBackground' ).RemoveClass( 'Initialize' );
	//$( '#ItemLore' ).RemoveClass( 'Initialize' );

	$( '#Model' ).RemoveClass( 'Initialize' );
	$( '#DebutInformation' ).RemoveClass( 'Initialize' );
}
