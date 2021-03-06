
// For debugging, allow turning off the fade out
var g_bFadeOutEnabled = true;
function IsFadeOutEnabled()
{
	return g_bFadeOutEnabled;
}
function SetFadeOutEnabled( bEnabled )
{
	g_bFadeOutEnabled = bEnabled;

	var toggleButton = $( '#ToggleFadeOut' );
	if ( toggleButton )
	{
		toggleButton.SetSelected( bEnabled );
	}
}
function ToggleFadeOutEnabled()
{
	SetFadeOutEnabled( !IsFadeOutEnabled() );
}

// Wait for any hero models to finish async loading
function WaitForHeroModelsAction()
{
}
WaitForHeroModelsAction.prototype = new BaseAction();
WaitForHeroModelsAction.prototype.update = function ()
{
	return !$.GetContextPanel().AreHeroModelsLoaded();
}

// Action to wait until a set of scene panels has loaded
function WaitForScenesToLoadAction( /*list out the scene panels*/ )
{
	this.scenePanels = [];
	for ( var i = 0; i < arguments.length; ++i )
	{
		this.scenePanels.push( arguments[ i ] );
	}
}

WaitForScenesToLoadAction.prototype = new BaseAction();
WaitForScenesToLoadAction.prototype.start = function ()
{
	// Setup a sequence to track the things that are loading
	this.loadingSeq = new RunSequentialActions();

	var par = new RunParallelActions();
	for ( var i = 0; i < this.scenePanels.length; ++i )
	{
		par.actions.push( new WaitForClassAction( this.scenePanels[ i ], 'SceneLoaded' ) ); 
	}
	this.loadingSeq.actions.push( par );

	// Wait at least one frame before checking that hero models are loaded. This is to make
	// sure that the update that starts the spawning has a chance to run.
	this.loadingSeq.actions.push( new WaitOneFrameAction() ); 
	this.loadingSeq.actions.push( new WaitForHeroModelsAction() );

	// Setup a sequence to show loading state after a delay
	this.uiSeq = new RunSequentialActions();
	this.uiSeq.actions.push( new WaitAction( 2.0 ) );
	this.uiSeq.actions.push( new AddClassAction( $.GetContextPanel(), 'LoadingVersusScreen' ) );

	// Start up both sequences
	this.loadingSeq.start();
	this.uiSeq.start();
}
WaitForScenesToLoadAction.prototype.update = function ()
{
	// Tick both sequences, but move on the minute the loading sequence is done
	this.uiSeq.update();
	return this.loadingSeq.update();
}
WaitForScenesToLoadAction.prototype.finish = function ()
{
	this.uiSeq.finish();
	this.loadingSeq.finish();
	$.GetContextPanel().RemoveClass( 'LoadingVersusScreen' );
}

