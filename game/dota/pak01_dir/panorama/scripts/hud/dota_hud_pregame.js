/* Called from C++ Code */
function OnPreGameBecameHidden()
{
    var preGame = $.GetContextPanel();
    preGame.RemoveClass( 'StrategyVersusTransition' );
    preGame.RemoveClass( 'VersusOutro' );
    preGame.RemoveClass( 'VersusVisible' );
    $( '#VersusScreen' ).RemoveClass( 'StartVersusAnim' );
    preGame.RemoveClass( 'MapLoading' );
    preGame.RemoveClass( 'MapLoadingOutro' );
}

/* Called from C++ Code */
function OnStrategyBecameVisible()
{
	$.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'PregameBG', 'shot_cameraB', 1.0 );
}
		
/* Called from C++ Code */
function OnHeroGridBecameVisible()
{
	$.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'PregameBG', 'shot_cameraA', 1.0 );
}
		
/* Called from C++ Code */
function ShowVersusScreen( versusDuration )
{
    var preGame = $.GetContextPanel();

    preGame.AddClass( 'StrategyVersusTransition' );
	$.DispatchEventAsync( 0.0, 'PlaySoundEffect', 'versus_screen.top' );
    $.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'PregameBG', 'shot_cameraC', 5.0 );
    $.DispatchEvent( 'DOTAGlobalSceneFireEntityInput', 'GodRays', 'ui_burst_red', 'stop', 0 );
    $.DispatchEvent( 'DOTAGlobalSceneFireEntityInput', 'GodRays', 'godrays1', 'stop', 0 );
    $.DispatchEvent( 'DOTAGlobalSceneFireEntityInput', 'GodRays', 'godrays2', 'stop', 0 );
	$.DispatchEvent( 'DOTAGlobalSceneFireEntityInput', 'GodRays', 'godrays_spin', 'stop', 0 );
	$.DispatchEvent( 'DOTAGlobalSceneFireEntityInput', 'VersusFX', 'hbar', 'stop', 0 );
	$.DispatchEvent( 'DOTAGlobalSceneFireEntityInput', 'VersusFX', 'hbar2', 'stop', 0 );
	
	
    $.DispatchEventAsync( 1.5, 'AddStyle', preGame, 'VersusVisible' );
    $.DispatchEventAsync( 1.6, 'AddStyle', $( '#VersusScreen' ), 'StartVersusAnim' );
    $.DispatchEventAsync( 1.8, 'DOTAGlobalSceneFireEntityInput', 'VersusFX', 'hbar', 'start', 1 );
    $.DispatchEventAsync( 1.8, 'DOTAGlobalSceneFireEntityInput', 'VersusFX', 'hbar2', 'start', 1 );		
    $.DispatchEventAsync( 2.0, 'DOTAGlobalSceneSetCameraEntity', 'RadiantAmbient', 'camera_2', 5.0 );
    $.DispatchEventAsync( 2.0, 'DOTAGlobalSceneSetCameraEntity', 'DireAmbient', 'camera_1', 5.0 );
	
    //$.DispatchEventAsync( 3.0, 'PlaySoundEffect', 'ui.treasure.spin_music' );

    //$.DispatchEventAsync( 3.1, 'PlaySoundEffect', 'Loot_Drop_Stinger_Legendary' );
    //$.DispatchEventAsync( 3.3, 'PlaySoundEffect', 'ui.badge_levelup' );
    $.DispatchEventAsync( 3.58, 'DOTAGlobalSceneFireEntityInput', 'GodRays', 'ui_burst_red', 'start', 1 );
    $.DispatchEventAsync( 3.58, 'DOTAGlobalSceneFireEntityInput', 'GodRays', 'godrays1', 'start', 1 );
    $.DispatchEventAsync( 3.58, 'DOTAGlobalSceneFireEntityInput', 'GodRays', 'godrays2', 'start', 1 );

    // If we're passed a duration, then schedule the outro for X seconds before the phase is going to end.
    // If we're not passed a duration, then we're debugging and the code will call it manually.
    if ( versusDuration > 0.0 )
    {
        var versusOutroDuration = 1.5;
        $.DispatchEventAsync( versusDuration - versusOutroDuration, 'DOTAStartVersusScreenOutro' );
    }
}

/* Maybe called from C++ for debugging */
function ShowVersusScreenOutro()
{
    var preGame = $.GetContextPanel();
    preGame.AddClass( 'VersusOutro' );
	$.DispatchEventAsync( 0.0, 'PlaySoundEffect', 'versus_screen.end_swipe' );
    $.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'RadiantAmbient', 'camera_end_top', 2.0 );
    $.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'DireAmbient', 'camera_end_bottom', 2.0 );
    $.DispatchEvent( 'DOTAGlobalSceneFireEntityInput', 'GodRays', 'ui_burst_red', 'stop', 0 );
    $.DispatchEvent( 'DOTAGlobalSceneFireEntityInput', 'GodRays', 'godrays1', 'stop', 0 );
    $.DispatchEvent( 'DOTAGlobalSceneFireEntityInput', 'GodRays', 'godrays2', 'stop', 0 );
	$.DispatchEvent( 'DOTAGlobalSceneFireEntityInput', 'GodRays', 'godrays_spin', 'start', 1 );
	$.DispatchEvent( 'DOTAGlobalSceneFireEntityInput', 'VersusFX', 'hbar', 'stop', 0 );
	$.DispatchEvent( 'DOTAGlobalSceneFireEntityInput', 'VersusFX', 'hbar2', 'stop', 0 );	
}

/* Called from C++ Code */
function ShowMapLoadingScreen()
{
    var preGame = $.GetContextPanel();
    preGame.RemoveClass( 'StrategyVersusTransition' );
    preGame.AddClass( 'MapLoading' );
}

/* Called from C++ Code */
function TransitionFromMapLoadingScreen()
{
    var preGame = $.GetContextPanel();
    preGame.AddClass( 'MapLoadingOutro' );

    // Poke the C++ when the transition is finished
    var mapLoadingOutroDuration = 5.0;
    $.Schedule( mapLoadingOutroDuration, function () {
        $.GetContextPanel().MapLoadingOutroFinished();
    } );
}