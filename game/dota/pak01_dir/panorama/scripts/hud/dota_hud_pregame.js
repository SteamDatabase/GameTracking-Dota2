/* Called from C++ Code */
function OnPreGameBecameHidden()
{
	var preGame = $.GetContextPanel();
	preGame.RemoveClass( 'StrategyVersusTransition' );
	preGame.RemoveClass( 'VersusOutro' );
	preGame.RemoveClass('VersusVisible');
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
