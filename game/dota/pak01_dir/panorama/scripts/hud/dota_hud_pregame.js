/* Called from C++ Code */
function OnPreGameBecameHidden()
{
	var preGame = $.GetContextPanel();
	preGame.RemoveClass( 'StrategyVersusTransition' );
	preGame.RemoveClass( 'VersusOutro' );
	preGame.RemoveClass('VersusVisible');
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
function ShowVersusScreen()
{
	var preGame = $.GetContextPanel();

	preGame.AddClass( 'StrategyVersusTransition' );
	$.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'PregameBG', 'shot_cameraC', 5.0 );

	$.DispatchEventAsync( 1.5, 'AddStyle', preGame, 'VersusVisible' );
	$.DispatchEventAsync( 0.0, 'PlaySoundEffect', 'versus_screen.top' );

	$.DispatchEvent( 'DOTAGlobalSceneFireEntityInput', 'GodRays', 'ui_burst_red', 'stop', 0 );
	$.DispatchEvent( 'DOTAGlobalSceneFireEntityInput', 'GodRays', 'godrays1', 'stop', 0 );
	$.DispatchEvent( 'DOTAGlobalSceneFireEntityInput', 'GodRays', 'godrays2', 'stop', 0 );
	$.DispatchEvent( 'DOTAGlobalSceneFireEntityInput', 'GodRays', 'godrays_spin', 'stop', 0 );
	$.DispatchEvent( 'DOTAGlobalSceneFireEntityInput', 'VersusFX', 'hbar', 'stop', 0 );
	$.DispatchEvent( 'DOTAGlobalSceneFireEntityInput', 'VersusFX', 'hbar2', 'stop', 0 );

	$.DispatchEventAsync( 1.6, 'AddStyle', $( '#VersusScreen' ), 'StartVersusAnim');
	$.DispatchEventAsync( 1.8, 'DOTAGlobalSceneFireEntityInput', 'VersusFX', 'hbar', 'start', 1 );
	$.DispatchEventAsync( 1.8, 'DOTAGlobalSceneFireEntityInput', 'VersusFX', 'hbar2', 'start', 1 );
	$.DispatchEventAsync( 2.0, 'DOTAGlobalSceneSetCameraEntity', 'RadiantAmbient', 'camera_2', 5.0 );
	$.DispatchEventAsync( 2.0, 'DOTAGlobalSceneSetCameraEntity', 'DireAmbient', 'camera_1', 5.0 );

	$.DispatchEventAsync( 3.58, 'DOTAGlobalSceneFireEntityInput', 'GodRays', 'ui_burst_red', 'start', 1 );
	$.DispatchEventAsync( 3.58, 'DOTAGlobalSceneFireEntityInput', 'GodRays', 'godrays1', 'start', 1 );
	$.DispatchEventAsync( 3.58, 'DOTAGlobalSceneFireEntityInput', 'GodRays', 'godrays2', 'start', 1 );
}

/* Called from C++ Code */  
function ShowVersusScreenOutro()
{
	var preGame = $.GetContextPanel();

	$.DispatchEventAsync( 3.5, 'AddStyle', preGame, 'VersusOutro' );
	$.DispatchEventAsync( 3.5, 'PlaySoundEffect', 'versus_screen.end_swipe' );
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
function ShowVersusScreenV2()
{
	var preGame = $.GetContextPanel();

	preGame.AddClass( 'StrategyVersusTransition' );
	$.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'PregameBG', 'shot_cameraC', 5.0 );
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
