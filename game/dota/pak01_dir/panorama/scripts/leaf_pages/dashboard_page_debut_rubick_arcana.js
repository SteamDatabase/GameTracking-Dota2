
var g_bIsShowingProgress = false;
var g_bIsTransitioningShowingProgress = false;

var g_bIsOnRight = false;
var g_bButtonPressed = false;

$.Schedule(0.0, function ()
{
    $.RegisterEventHandler('DOTAScenePanelSceneLoaded', $('#ModelBackground'), function () { $.DispatchEvent('PlaySoundEffect', 'rubick_arc_takeover_stinger'); });
});

var SetShowingProgress = function ( bShowProgress )
{
	if ( g_bIsTransitioningShowingProgress )
		return;

	if ( g_bIsShowingProgress == bShowProgress )
		return;

	g_bIsShowingProgress = bShowProgress;

	$.GetContextPanel().SetHasClass( 'ShowingProgress', bShowProgress );

	g_bIsTransitioningShowingProgress = true;
	if ( bShowProgress )
	{
		g_bButtonPressed = true;
		g_bIsOnRight = false;

		$( '#ModelBackground' ).FireEntityInput( 'debut_camera', 'SetAnimation', 'debut_camera_rubick_arcana_transition_left_tk3' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop', 'SetAnimation', 'rbck_arc_debut_prop_anim_transition_left_tk3' );
		$( '#ModelBackground' ).FireEntityInput( 'hero', 'SetActivityModifier', 'debut_left' );
		$( '#ModelBackground' ).FireEntityInput( 'hero', 'SetActivity', 'ACT_DOTA_TRANSITION' );

		$.Schedule( 3.0, function () //7.1
		{	
			g_bIsTransitioningShowingProgress = false;
		} );
		
		$.Schedule( 7.1, function () 
		{
			if ( !g_bIsOnRight && !g_bIsTransitioningShowingProgress )
			{
				$( '#ModelBackground' ).FireEntityInput( 'debut_camera', 'SetAnimation', 'debut_camera_rubick_arcana_idle_left_tk3');
				$( '#ModelBackground' ).FireEntityInput( 'arcana_prop', 'SetAnimation', 'rbck_arc_debut_prop_anim_idle_left_tk3' );
				$( '#ModelBackground' ).FireEntityInput( 'hero', 'SetActivityModifier', 'debut_left' );			
				$( '#ModelBackground' ).FireEntityInput( 'hero', 'SetActivity', 'ACT_DOTA_LOADOUT' );
			}
		} );
	}
	else
	{
		g_bButtonPressed = true;
		g_bIsOnRight = true;

		$( '#ModelBackground' ).FireEntityInput( 'debut_camera', 'SetAnimation', 'debut_camera_rubick_arcana_transition_right_tk3' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop', 'SetAnimation', 'rbck_arc_debut_prop_anim_transition_right_tk3' );
		$( '#ModelBackground' ).FireEntityInput( 'hero', 'SetActivityModifier', 'debut_right' );
		$( '#ModelBackground' ).FireEntityInput( 'hero', 'SetActivity', 'ACT_DOTA_TRANSITION' );

		$.Schedule( 3.0, function ()
		{
			g_bIsTransitioningShowingProgress = false;
		} );
		
		$.Schedule( 10.36, function ()
		{
			if ( g_bIsOnRight && !g_bIsTransitioningShowingProgress )
			{
				$( '#ModelBackground' ).FireEntityInput( 'debut_camera', 'SetAnimation', 'debut_camera_rubick_arcana_idle_right_tk3' );
				$( '#ModelBackground' ).FireEntityInput( 'arcana_prop', 'SetAnimation', 'rbck_arc_debut_prop_anim_idle_right_tk3' );
				$( '#ModelBackground' ).FireEntityInput( 'hero', 'SetActivityModifier', 'debut_right' );
				$( '#ModelBackground' ).FireEntityInput( 'hero', 'SetActivity', 'ACT_DOTA_LOADOUT' );
			}
		} );		
	}
}

var ToggleShowingProgress = function ()
{
	SetShowingProgress( !g_bIsShowingProgress );
}

$.GetContextPanel().SetDialogVariableInt( "arcana_item_def", 12451 );


var RunPageAnimation = function ()
{
	// Initial Setup
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
	$( '#ViewProgressButton' ).RemoveClass( 'Initialize' );
	$( '#ViewFeaturesButton' ).RemoveClass( 'Initialize' );
	$.DispatchEvent( 'DOTASetCurrentDashboardPageFullscreen', true );	

	SetShowingProgress( false );

	// Animations Track
	var seqAnim = new RunSequentialActions();
	seqAnim.actions.push( new WaitForClassAction( $( '#ModelBackground' ), 'SceneLoaded' ) );
	seqAnim.actions.push( new RunFunctionAction( function () 
	{
		//$( '#ModelBackground' ).FireEntityInput( 'hero_start', 'Disable', '' );
		$( '#ModelBackground' ).FireEntityInput( 'hero', 'Disable', '' );
	} ) );
	seqAnim.actions.push( new WaitAction( 1.6 ) );
	seqAnim.actions.push( new RunFunctionAction( function () 
	{
		$( '#ModelBackground' ).FireEntityInput( 'hero_start', 'Disable', '' );
	} ) );	
	seqAnim.actions.push( new WaitAction( 1.53 ) );//6.23 f187
	seqAnim.actions.push( new RunFunctionAction( function () 
	{
		$( '#ModelBackground' ).FireEntityInput( 'hero', 'Enable', '' );
	} ) );
	seqAnim.actions.push( new WaitAction( 0.97 ) );//7.1
	seqAnim.actions.push( new RunFunctionAction( function () 
	{
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_1', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_2', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_3', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_4', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_5', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_6', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_7', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_8', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_9', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_10', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_11', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_12', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_13', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_14', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_15', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_16', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_17', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_18', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_19', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_20', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_21', 'TurnOff', '' );
		$( '#ModelBackground' ).FireEntityInput( 'arcana_prop_cube_22', 'TurnOff', '' );
	} ) );	
	
	seqAnim.actions.push( new WaitAction( 10.73 ) ); //17.83
	seqAnim.actions.push( new RunFunctionAction( function () 
	{
		
		if (g_bButtonPressed == false)
		{
			$( '#ModelBackground' ).FireEntityInput( 'arcana_prop', 'SetAnimation', 'rbck_arc_debut_prop_anim_idle_right_tk3' );
		}
	
	} ) );	
	
	// UI Track
	var seqUI = new RunSequentialActions();
	seqUI.actions.push( new WaitForClassAction( $( '#ModelBackground' ), 'SceneLoaded' ) );
	seqUI.actions.push( new WaitAction( 0.1 ) );
	seqUI.actions.push( new AddClassAction( $( '#MainContainer' ), 'Initialize' ) );
	seqUI.actions.push( new WaitAction( 3.4 ) );
	seqUI.actions.push( new AddClassAction( $( '#ModelBackground' ), 'Initialize' ) );	
	seqUI.actions.push( new WaitAction( 1.0 ) );
	seqUI.actions.push( new AddClassAction( $( '#DebutInformation' ), 'Initialize' ) );
	seqUI.actions.push( new AddClassAction( $( '#InformationBody' ), 'Initialize' ) );
	seqUI.actions.push( new WaitAction( 0.5 ) );
	seqUI.actions.push( new AddClassAction( $( '#ItemName' ), 'Initialize' ) );
	seqUI.actions.push( new WaitAction( 0.5 ) );
	seqUI.actions.push( new AddClassAction( $( '#InformationBodyBackground' ), 'Initialize' ) );
	seqUI.actions.push( new AddClassAction( $( '#ItemLore' ), 'Initialize' ) );
	seqUI.actions.push( new AddClassAction( $( '#InnerPanel' ), 'Initialize' ) );
	seqUI.actions.push( new WaitAction( 1.5 ) );
	seqUI.actions.push( new AddClassAction( $( '#Buttons' ), 'Initialize' ) );
	seqUI.actions.push( new WaitAction( 1.5 ) );
	
	seqUI.actions.push( new AddClassAction( $( '#ViewProgressButton' ), 'Initialize' ) );
	seqUI.actions.push( new AddClassAction( $( '#ViewFeaturesButton' ), 'Initialize' ) );
	seqUI.actions.push( new WaitAction( 1.5 ) );
	seqUI.actions.push( new AddClassAction( $( '#QualityContainer' ), 'Initialize' ) );

	// Run the Animations and UI Track in Parallel
	var par = new RunParallelActions();
	
	par.actions.push( seqAnim );
	par.actions.push( seqUI );

	RunSingleAction( par );
}

