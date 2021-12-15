/**
 * DROW RANGER ARCANA DEBUT PAGE
 * file:    dashboard_page_debut_drow_ranger_arcana.js
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
    $.GetContextPanel().RemoveClass('ShowingAlternateStyle');
 
	$( '#ModelContainer' ).RemoveAndDeleteChildren();
	$( '#ModelContainer' ).BLoadLayoutSnippet( 'ModelSnippet' );

    $( '#MainContainer' ).RemoveClass( 'Initialize' );
    $( '#ModelForeground' ).RemoveClass( 'Initialize' );
    $( '#BottomGradient' ).RemoveClass( 'Initialize' );
    $( '#DebutInformation' ).RemoveClass( 'Initialize' );
    $( '#InformationBody' ).RemoveClass( 'Initialize' );

    $( '#DefaultStyle' ).RemoveClass( 'Initialize' );
    $( '#SecondStyle' ).RemoveClass( 'Initialize' );

	seq.actions.push( new WaitAction( 0.01 ) );
    seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'DOTASetCurrentDashboardPageFullscreen', true ); } ) )
    //seq.actions.push( new WaitForClassAction( $( '#ModelBackground' ), 'SceneLoaded' ) );
    seq.actions.push( new WaitForClassAction( $( '#ModelForeground' ), 'SceneLoaded' ) );

    seq.actions.push( new PlayAndTrackSoundAction( 'drow_arcana_stinger' ) );
    seq.actions.push( new PlayAndTrackSoundAction( 'drow_arcana_sfx' ) );

	seq.actions.push( new AddClassAction( $( '#MainContainer' ), 'Initialize' ) );
	//seq.actions.push( new AddClassAction( $( '#ModelBackground' ), 'Initialize' ) );
	seq.actions.push( new AddClassAction( $( '#ModelForeground' ), 'Initialize' ) );
    
    var info_delay = 8.0
    seq.actions.push(new WaitAction(info_delay));

    seq.actions.push( new AddClassAction( $( '#DebutInformation' ), 'Initialize' ) );
    seq.actions.push( new AddClassAction( $( '#InformationBody' ), 'Initialize' ) );

    // load up the second style
    var second_style_delay = 3.5;
    seq.actions.push(new WaitAction(second_style_delay));

    seq.actions.push( new AddClassAction( $( '#SecondStyle' ), 'Initialize' ) );
    seq.actions.push( new AddClassAction( $( '#DefaultStyle' ), 'Initialize' ) );

    // enable mouse hover parallax (disable when blocking out camera animation)
    /**
    seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'ModelBackground', 'hero_camera_post', 4.0 );  } ) )
    seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'DOTAGlobalSceneSetRootEntity', 'ModelBackground', 'root_post' ); } ) )
    seq.actions.push(new LerpRotateAction($('#ModelBackground'), 0, 0, 0, 0, -.25, 0.25, -.1, .1, 0.1));

    seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'ModelForeground', 'hero_camera_post', 4.0 );  } ) )
    seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'DOTAGlobalSceneSetRootEntity', 'ModelForeground', 'root_post' ); } ) )
    seq.actions.push(new LerpRotateAction($('#ModelForeground'), 0, 0, 0, 0, -.25, 0.25, -.1, .1, 0.1));
    */


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
    //$('#ModelBackground').RemoveClass('Initialize');
    $('#ModelForeground').RemoveClass('Initialize');

    $('#DebutInformation').RemoveClass('Initialize');
    $('#InformationBody').RemoveClass('Initialize');

    //$.DispatchEvent('DOTAShowHomePage');
}



function alternateStyle()
{
    $.GetContextPanel().AddClass('ShowingAlternateStyle');
}

function originalStyle()
{
    $.GetContextPanel().RemoveClass('ShowingAlternateStyle');
}
