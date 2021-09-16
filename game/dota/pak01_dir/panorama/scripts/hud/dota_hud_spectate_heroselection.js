/* Called from C++ Code */
function OnHeroPicked( teamIndex, playerIndex )
{
	//$.Msg( "OnHeroPicked " + teamIndex.toString() + " " + playerIndex.toString() );

	if ( teamIndex == 0 )
	{	
		$( '#Row0' ).RemoveClass( 'ViewAll' );
		$.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'RadiantScene', teamIndex + '_camera_hero' + playerIndex, 1.5 );
		$( '#RadiantScene' ).FireEntityInput( 'fx_spot_0_'+ playerIndex, 'Stop', '' );
		$.DispatchEvent( 'AddStyle', $('#SpectateHeroSelection'), 'RadiantFocusActive');
		$( '#RadiantScene' ).FireEntityInput( 'fx_tease_' + teamIndex + '_' + playerIndex, 'Stop', '' );
		$( '#RadiantScene' ).FireEntityInput( 'fx_tease_'+ teamIndex +'_'+ playerIndex, 'Start', '' );	
	}
	else if ( teamIndex == 1 )
	{
		$( '#Row1' ).RemoveClass( 'ViewAll' );
		$.DispatchEvent( 'DOTAGlobalSceneSetCameraEntity', 'DireScene', teamIndex + '_camera_hero' + playerIndex, 1.5 );
		$( '#DireScene' ).FireEntityInput( 'fx_spot_1_'+ playerIndex, 'Stop', '' );
		$.DispatchEvent( 'AddStyle', $('#SpectateHeroSelection'), 'DireFocusActive');	
		$( '#DireScene' ).FireEntityInput( 'fx_tease_' + teamIndex + '_' + playerIndex, 'Stop', '' );
		$( '#DireScene' ).FireEntityInput( 'fx_tease_'+ teamIndex +'_'+ playerIndex, 'Start', '' );					
	}

	$.DispatchEvent( 'PlaySoundEffect', 'InspectorCam.Activate' );
}

/* Called from C++ Code */
function OnHeroPickStart( teamIndex, playerIndex )
{
	//$.Msg( "OnHeroPickStart " + teamIndex.toString() + " " + playerIndex.toString() );
		
	if ( teamIndex == 0 )
	{	
		var scenePanelRadiant = $( '#RadiantScene' );
		scenePanelRadiant.FireEntityInput( 'fx_spot_' + teamIndex + '_' + playerIndex, 'Stop', '' );
		scenePanelRadiant.FireEntityInput( 'fx_spot_'+ teamIndex +'_'+ playerIndex, 'Start', '' );		
	}
	else if ( teamIndex == 1 )
	{
		var scenePanelDire = $( '#DireScene' );
		scenePanelDire.FireEntityInput( 'fx_spot_' + teamIndex + '_' + playerIndex, 'Stop', '' );
		scenePanelDire.FireEntityInput( 'fx_spot_'+ teamIndex +'_'+ playerIndex, 'Start', '' );		
	}

	for (i = 0; i < 5; i++) 
	{ 
		$( '#BansBackground' ).RemoveClass( 'team1slot' + i );
	}						
	for (i = 0; i < 5; i++) 
	{ 
		$( '#BansBackground' ).RemoveClass( 'team0slot' + i );
	}					
	
	$.DispatchEvent( 'AddStyle', $( '#BansBackground' ), 'team' + teamIndex + 'slot' + playerIndex );
}

/* Called from C++ Code */
function OnHeroSpawned( teamIndex, playerIndex )
{
	//$.Msg( "OnHeroSpawned " + teamIndex.toString() + " " + playerIndex.toString() );

	if ( teamIndex == 0 )
	{
		var scenePanelRadiant = $( '#RadiantScene' );
		scenePanelRadiant.FireEntityInput( 'fx_' + teamIndex + '_' + playerIndex, 'Stop', '' );
		scenePanelRadiant.FireEntityInput( 'fx_' + teamIndex + '_' + playerIndex, 'Start', '' );
	}
	else if ( teamIndex == 1 )
	{
		var scenePanelDire = $( '#DireScene' );
		scenePanelDire.FireEntityInput( 'fx_' + teamIndex + '_' + playerIndex, 'Stop', '' );
		scenePanelDire.FireEntityInput( 'fx_' + teamIndex + '_' + playerIndex, 'Start', '' );
	}
}

/* Called from C++ Code */
function OnHeroSpawnedUI( teamIndex, playerIndex )
{
	//$.Msg( "OnHeroSpawnedUI " + teamIndex.toString() + " " + playerIndex.toString() );

	if ( teamIndex == 0 )
	{
		$( '#HeroPickedRadiant' ).AddClass( 'ShowPickedLabel' );
	}
	else if ( teamIndex == 1 )
	{
		$( '#HeroPickedDire' ).AddClass( 'ShowPickedLabel' );
	}
}

/* Called from C++ Code */
function OnHeroSpawnComplete(teamIndex, playerIndex)
{
	//$.Msg("OnHeroSpawnComplete " + teamIndex.toString() + " " + playerIndex.toString());

	if (teamIndex == 0)
	{
		$.DispatchEvent('DOTAGlobalSceneSetCameraEntity', 'RadiantScene', 'radiant_camera', 1.5);
		$('#Row0').AddClass('ViewAll');
		$('#SpectateHeroSelection').RemoveClass('RadiantFocusActive');
		$('#HeroPickedRadiant').RemoveClass('ShowPickedLabel');
	}
	else if (teamIndex == 1)
	{
		$.DispatchEvent('DOTAGlobalSceneSetCameraEntity', 'DireScene', 'dire_camera', 1.5);
		$('#Row1').AddClass('ViewAll');
		$('#SpectateHeroSelection').RemoveClass('DireFocusActive');
		$('#HeroPickedDire').RemoveClass('ShowPickedLabel');
	}
}

function OnHeroBanStart( teamIndex, playerIndex )
{
	//$.Msg( "OnHeroBanStart " + teamIndex.toString() + " " + playerIndex.toString() );
}

function OnHeroBanned( teamIndex, playerIndex )
{
	//$.Msg( "OnHeroBanned " + teamIndex.toString() + " " + playerIndex.toString() );
}



/* Called from C++ Code */
function OnDraftStateStarted( )
{
	//$.Msg( "OnDraftStateStarted" );
}
