// Called from C++ when the scene starts
var PlayScene = function ()
{
	var mainPanel = $.GetContextPanel();
	var scenePanel = $( '#VersusScene' );
	var bRadiantTeam = $( '#TeamInfo' ).BHasClass( 'RadiantTeam' );

	// Initial Setup
	mainPanel.RemoveClass( 'RevealTeamDetails' );
	mainPanel.RemoveClass( 'RevealFeaturedHeroDetails' );

	scenePanel.FireEntityInput( mainPanel.GetHeroEntityNameByHeroSlot( 0 ), 'StartGestureOverride', 'ACT_DOTA_LOADOUT' );
    scenePanel.FireEntityInput( mainPanel.GetHeroEntityNameByHeroSlot( 0 ), 'SetPlaybackRateOnAllLayers', 0.5 );
	for ( var i = 1; i < 5; ++i )
	{
	    scenePanel.FireEntityInput( mainPanel.GetHeroEntityNameByHeroSlot( i ), 'StartGestureOverride', 'ACT_DOTA_LOADOUT' );
	    scenePanel.FireEntityInput( mainPanel.GetHeroEntityNameByHeroSlot( i ), 'SetPlaybackRateOnAllLayers', 0.3 );
	}

	// Wait for the fade-in, then reveal the scene
	var mainSeq = new RunSequentialActions();
	if ( bRadiantTeam )
	{
		mainSeq.actions.push( new PlaySoundEffectAction( 'versus_screen.whoosh' ) );
	}
	mainSeq.actions.push( new WaitForClassAction( scenePanel, 'SceneLoaded' ) );
	mainSeq.actions.push( new WaitAction( 0.5 ) );
	mainSeq.actions.push( new AddClassAction( mainPanel, 'RevealScene' ) );
	mainSeq.actions.push( new PlaySoundEffectAction( bRadiantTeam ? 'versus_screen.radiant' : 'versus_screen.dire' ) );

	// The UI will appear in pieces
	var uiSeq = new RunSequentialActions();
	uiSeq.actions.push( new AddClassAction( mainPanel, 'RevealTeamDetails' ) );
	uiSeq.actions.push( new WaitAction( 2.0 ) );
	uiSeq.actions.push( new AddClassAction( mainPanel, 'RevealFeaturedHeroDetails' ) );

	// Script the entities
	var entitySeq = new RunSequentialActions();
	entitySeq.actions.push( new FireEntityInputAction( scenePanel, 'debut_camera', 'SetAnimation', 'versus_camera_radiant_anim' ) );
	entitySeq.actions.push( new WaitAction( 7.0 ) );

	// Run both the UI and Entity sequence in parallel
	var par = new RunParallelActions();
	par.actions.push( uiSeq );
	par.actions.push( entitySeq );
	mainSeq.actions.push( par );

	// All done, fade to black
	mainSeq.actions.push( new RunFunctionAction( function ()
	{
		if ( IsFadeOutEnabled() )
		{
			PlaySoundEffect( 'versus_screen.whoosh' );
			mainPanel.RemoveClass( 'RevealScene' );
		}
	}));

	// Now that the sequence is created, actually run the thing
	RunSingleAction( mainSeq );
}
