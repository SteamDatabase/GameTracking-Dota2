function Init()
{
    var contextPanel = $.GetContextPanel();
    var parent = contextPanel.GetParent();
    var customRoot = parent.GetParent();
    var hudRoot = customRoot.GetParent().FindChild( 'HUDElements' );
    var menuButtons = hudRoot.FindChild( 'MenuButtons' );
	menuButtons.AddClass( "HeroDemo" );

	$.RegisterEventHandler( 'DOTAUIHeroPickerHeroSelected', $( '#SelectHeroContainer' ), SwitchToNewHero );
	$.RegisterEventHandler('DOTAHeroFacetDropdownFacetSelected', $('#HeroFacetDropdown'), SwitchToNewFacet);
	$.RegisterEventHandler('DOTAHeroFacetPickerFacetSelected', $('#SpawnHeroFacetPicker'), SwitchSpawnHeroFacet);

    var UiDefaults = CustomNetTables.GetTableValue( "game_global", "ui_defaults" );

    if( UiDefaults )
    {
		$( '#SpawnCreepsButton' ).SetSelected( UiDefaults["SpawnCreepsEnabled"] );
		$( '#TowersEnabledButton' ).SetSelected( UiDefaults["TowersEnabled"] );
    }

	$.DispatchEvent( 'FireCustomGameEvent_Str', 'RequestInitialSpawnHeroID', null );
}
Init();

function OnThink()
{
	var host_time_scale = Game.GetConvarFloat( "host_timescale" );
	                                                  

	var SpeedButton = $( '#SpeedResetButton' )    
	if ( SpeedButton )
	{
		SpeedButton.SetDialogVariable( "speed", host_time_scale );
	}	
	
	$.Schedule( 0.1, OnThink );
}
$.Schedule( 0.0, OnThink );

var bHeroPickerVisible = false;

function ToggleHeroPicker( bMainHero )
{
	Game.EmitSound( "UI.Button.Pressed" );

	$('#SelectHeroContainer').SetHasClass('PickMainHero', bMainHero);
	var HeroPicker = $('#HeroPicker');
	if (HeroPicker != null) {
		HeroPicker.selectfacet = bMainHero;
	}

	SetHeroPickerVisible( !bHeroPickerVisible );
}

function EscapeHeroPickerSearch()
{
	                                                                                              
	   
	  	                                       
	   
	      
	   
		SetHeroPickerVisible( false );
	   
}

function CloseHeroPicker()
{
	SetHeroPickerVisible( false );
}

function SetHeroPickerVisible( bVisible )
{
	$.Msg("SetHeroPickerVisible " + bVisible);
	if (!bVisible) {
		$('#SelectHeroContainer').RemoveClass('HeroPickerVisible');
		$("#SelectHeroContainer").FindChildTraverse("HeroSearchTextEntry").text = "";
	}
	if (bVisible) {
		$('#SelectHeroContainer').AddClass('HeroPickerVisible');
		$("#SelectHeroContainer").FindChildTraverse("HeroSearchTextEntry").SetFocus();
	}
	bHeroPickerVisible = bVisible;
}

function SwitchToNewHero( nHeroID, nHeroVariant )
{
	Game.EmitSound( "UI.Button.Pressed" );

	$.Msg( 'SwitchToNewHero - Hero = ' + nHeroID + ', Variant = ' + nHeroVariant );

	if ( $( '#SelectHeroContainer' ).BHasClass( 'PickMainHero' ) )
	{
		$.DispatchEvent( 'FireCustomGameEvent_Str', 'SelectMainHeroButtonPressed', String( nHeroID ) + ':' + String( nHeroVariant ) );
	}
	else
	{
		$.DispatchEvent('FireCustomGameEvent_Str', 'SelectSpawnHeroButtonPressed', String(nHeroID) + ':' + String(nHeroVariant));

		var SpawnHeroFacetPicker = $('#SpawnHeroFacetPicker');
		if (SpawnHeroFacetPicker != null) {
			SpawnHeroFacetPicker.heroid = nHeroID;
		}
	}

	$( '#SelectHeroContainer' ).RemoveClass( 'PickMainHero' );

	SetHeroPickerVisible( false );
}

function SwitchToNewFacet( nHeroID, nHeroFacet )
{
	$( '#SelectHeroContainer' ).SetHasClass( 'PickMainHero', true );

	var PlayerHeroImage = $( '#PlayerHeroImage' );
	if ( PlayerHeroImage != null )
	{
		$.DispatchEvent( 'FireCustomGameEvent_Str', 'SelectMainHeroButtonPressed', String( nHeroID ) + ':' + String( nHeroFacet ) );	
	}
}
function SwitchSpawnHeroFacet(nHeroID, nHeroFacet) {

	var SpawnHeroFacetPicker = $('#SpawnHeroFacetPicker');
	var nHeroFacetID = nHeroFacet & 0xFFFFFFFF;
	if (SpawnHeroFacetPicker != null) {
		$.Msg( 'SwitchSpawnHeroFacet ' + nHeroID + ' ' + nHeroFacetID );
		$.DispatchEvent( 'FireCustomGameEvent_Str', 'SelectSpawnHeroButtonPressed', String( nHeroID ) + ':' + String( nHeroFacetID ) );
	}
}


function OnSetPlayerHeroID( event_data )
{
	$.Msg( "OnSetPlayerHeroID: ", event_data );
	var PlayerHeroImage = $( '#PlayerHeroImage' );
	if ( PlayerHeroImage != null )
	{
		PlayerHeroImage.heroid = event_data.hero_id;
	}	

	var HeroFacetPicker = $( '#HeroFacetDropdown' );
	if( HeroFacetPicker != null )
	{
		HeroFacetPicker.Init( event_data.hero_id, event_data.hero_variant );
	}

	var HeroDemoButton = $( '#HeroDemoHeroName' );
	if ( HeroDemoButton != null )
	{
		var heroName = Players.GetPlayerSelectedHero( 0 );
		$.Msg( 'HERO NAME = ' + heroName );
		HeroDemoButton.SetDialogVariable( "hero_name", GameUI.GetUnitNameLocalized( heroName ) );
	}
}
GameEvents.Subscribe( "set_player_hero_id", OnSetPlayerHeroID );

function OnSetMainHeroID( event_data )
{
	$.Msg( "OnSetMainHeroID: ", event_data );

	$.DispatchEvent( "DOTADemoHeroEquippedItems", event_data.hero_name, event_data.hero_variant );
}
GameEvents.Subscribe( "set_main_hero_id", OnSetMainHeroID );

function OnSetSpawnHeroID( event_data )
{
	$.Msg( "OnSetSpawnHeroID: ", event_data );
	var HeroPickerImage = $( '#HeroPickerImage' );
	if ( HeroPickerImage != null )
	{
		HeroPickerImage.heroid = event_data.hero_id;
	}

	var SpawnHeroButton = $( '#SpawnHeroButton' );
	if ( SpawnHeroButton != null )
	{
		$.Msg( 'HERO NAME = ' + event_data.hero_name );
		SpawnHeroButton.SetDialogVariable( "hero_name", GameUI.GetUnitNameLocalized( event_data.hero_name ) );
		SpawnHeroButton.SetDialogVariable( "hero_variant", event_data.hero_variant );
	}
	if (event_data.initial_spawn) {
		var SpawnHeroFacetPicker = $('#SpawnHeroFacetPicker');
		if (SpawnHeroFacetPicker != null) {
			SpawnHeroFacetPicker.heroid = event_data.hero_id;
		}
	}
}
GameEvents.Subscribe( "set_spawn_hero_id", OnSetSpawnHeroID );

function ToggleCategoryVisibility( str )
{
                                                       
    $( str ).ToggleClass( 'CollapseCategory' )
}


function OnAddNewHeroEntry( event_data )
{
	$.Msg( "OnAddNewHeroEntry: ", event_data );

	                                                                     
	                                                 
}
GameEvents.Subscribe( "add_new_hero_entry", OnAddNewHeroEntry );

function RemoveSelectedHeroes()
{
	var entities = Players.GetSelectedEntities( 0 );
	var numEntities = Object.keys( entities ).length;

	var bDeletionAttempted = false;
    for ( var i = 0; i < numEntities; i++ )
    {
        var entindex = entities[ i ];
        if ( entindex == -1 )
            continue;

		var PlayerOwnerID = Entities.GetPlayerOwnerID( entindex );
		var bIsRealHero = Entities.IsRealHero( entindex );
		if ( PlayerOwnerID == 0 && bIsRealHero )
		{
			$.Msg( 'Skipping ent! ' + entindex );
			continue;	                           
		}

		bDeletionAttempted = true;
		$.DispatchEvent( 'FireCustomGameEvent_Str', 'RemoveHeroButtonPressed', String( entindex ) );
	}

	if ( bDeletionAttempted )
	{
		Game.EmitSound( "UI.Button.Pressed" );
	}
	else
	{
		Game.EmitSound( "General.Cancel" );
	}
}

function ToggleInvulnerability()
{
	var entities = Players.GetSelectedEntities( 0 );
	$.Msg( "Entities = " + entities );

	var numEntities = Object.keys( entities ).length;
	$.Msg( "Num entities = " + numEntities );

    for ( var i = 0; i < numEntities; i++ )
    {
        var entindex = entities[ i ];
        if ( entindex == -1 )
            continue;

		$.DispatchEvent( 'FireCustomGameEvent_Str', 'ToggleInvulnerabilityHero', String( entindex ) );
	}
}

function InvulnerableOn()
{
	var entities = Players.GetSelectedEntities( 0 );
	$.Msg( "Entities = " + entities );

	var numEntities = Object.keys( entities ).length;
	$.Msg( "Num entities = " + numEntities );

	for ( var i = 0; i < numEntities; i++ )
	{
		var entindex = entities[i];
		if ( entindex == -1 )
			continue;

		$.DispatchEvent( 'FireCustomGameEvent_Str', 'InvulnOnHero', String( entindex ) );
	}

	if ( numEntities > 0 )
	{
		Game.EmitSound( "UI.Button.Pressed" );
	}
}

function InvulnerableOff()
{
	var entities = Players.GetSelectedEntities( 0 );
	$.Msg( "Entities = " + entities );

	var numEntities = Object.keys( entities ).length;
	$.Msg( "Num entities = " + numEntities );

	for ( var i = 0; i < numEntities; i++ )
	{
		var entindex = entities[i];
		if ( entindex == -1 )
			continue;

		$.DispatchEvent( 'FireCustomGameEvent_Str', 'InvulnOffHero', String( entindex ) );
	}

	if ( numEntities > 0 )
	{
		Game.EmitSound( "UI.Button.Pressed" );
	}
}

function LevelUpSelectedHeroes()
{
	var entities = Players.GetSelectedEntities( 0 );
	$.Msg( "Entities = " + entities );

	var numEntities = Object.keys( entities ).length;
	$.Msg( "Num entities = " + numEntities );

    for ( var i = 0; i < numEntities; i++ )
    {
        var entindex = entities[ i ];
        if ( entindex == -1 )
            continue;

		$.DispatchEvent( 'FireCustomGameEvent_Str', 'LevelUpHero', String( entindex ) );
	}

	if ( numEntities > 0 )
	{
		Game.EmitSound( "UI.Button.Pressed" );
	}
}

function MaxLevelUpSelectedHeroes()
{
	var entities = Players.GetSelectedEntities( 0 );
	$.Msg( "Entities = " + entities );

	var numEntities = Object.keys( entities ).length;
	$.Msg( "Num entities = " + numEntities );

    for ( var i = 0; i < numEntities; i++ )
    {
        var entindex = entities[ i ];
        if ( entindex == -1 )
            continue;

		$.DispatchEvent( 'FireCustomGameEvent_Str', 'MaxLevelUpHero', String( entindex ) );
	}

	if ( numEntities > 0 )
	{
		Game.EmitSound( "UI.Button.Pressed" );
	}
}

function ResetSelectedHeroes()
{
	var entities = Players.GetSelectedEntities( 0 );
	$.Msg( "Entities = " + entities );

	var numEntities = Object.keys( entities ).length;
	$.Msg( "Num entities = " + numEntities );

	for ( var i = 0; i < numEntities; i++ )
	{
		var entindex = entities[i];
		if ( entindex == -1 )
			continue;

		$.DispatchEvent( 'FireCustomGameEvent_Str', 'ResetHero', String( entindex ) );
	}

	if ( numEntities > 0 )
	{
		Game.EmitSound( "UI.Button.Pressed" );
	}
}

function ShardSelectedHeroes()
{
	var entities = Players.GetSelectedEntities( 0 );
	$.Msg( "Entities = " + entities );

	var numEntities = Object.keys( entities ).length;
	$.Msg( "Num entities = " + numEntities );

    for ( var i = 0; i < numEntities; i++ )
    {
        var entindex = entities[ i ];
        if ( entindex == -1 )
            continue;

		$.DispatchEvent( 'FireCustomGameEvent_Str', 'ShardHero', String( entindex ) );
	}

	if ( numEntities > 0 )
	{
		Game.EmitSound( "UI.Button.Pressed" );
	}
}

function ScepterSelectedHeroes()
{
	var entities = Players.GetSelectedEntities( 0 );
	$.Msg( "Entities = " + entities );

	var numEntities = Object.keys( entities ).length;
	$.Msg( "Num entities = " + numEntities );

    for ( var i = 0; i < numEntities; i++ )
    {
        var entindex = entities[ i ];
        if ( entindex == -1 )
            continue;

		$.DispatchEvent( 'FireCustomGameEvent_Str', 'ScepterHero', String( entindex ) );
	}

	if ( numEntities > 0 )
	{
		Game.EmitSound( "UI.Button.Pressed" );
	}
}

function ToggleHeroActive()
{
	$.Msg( 'ToggleHeroActive()' )
}

function MouseOverRune( strRuneID, strRuneTooltip )
{
	var runePanel = $( '#' + strRuneID );
	runePanel.StartAnimating();
	$.DispatchEvent( 'UIShowTextTooltip', runePanel, strRuneTooltip );
}

function MouseOutRune( strRuneID )
{
	var runePanel = $( '#' + strRuneID );
	runePanel.StopAnimating();
	$.DispatchEvent( 'UIHideTextTooltip', runePanel );
}

function SlideThumbActivate()
{
	var slideThumb = $.GetContextPanel();
	var bMinimized = slideThumb.BHasClass( 'Minimized' );

	if ( bMinimized )
	{
		Game.EmitSound( "ui_settings_slide_out" );
	}
	else
	{
		Game.EmitSound( "ui_settings_slide_in" );
	}

	slideThumb.ToggleClass( 'Minimized' );
}

function SaveState()
{
	$.DispatchEvent( 'FireCustomGameEvent_Str', 'SaveState', null );
}

function RestoreState()
{
	$.DispatchEvent( 'FireCustomGameEvent_Str', 'ClearGameState', null );
	$.DispatchEvent( 'FireCustomGameEvent_Str', 'RestoreState', null );
}