"use strict";

var g_vWorldHintLoc = null;

CustomNetTables.SubscribeNetTableListener( "base_scenario", OnScenarioInfoUpdated );
function OnScenarioInfoUpdated()
{
	var rgScenarioInfo = CustomNetTables.GetTableValue( "base_scenario", "scenario_info" );
	var strScenarioName = rgScenarioInfo[ "scenario_name" ];
	$( '#ScenarioDebugControls' ).SetDialogVariable( "scenario_name", strScenarioName );

	var hudPanel = $.GetContextPanel().FindAncestor( "Hud" );
	if ( hudPanel )
	{
		hudPanel.SwitchClass( "scenario_name", strScenarioName );
	}

	$( '#ObjectiveContainer' ).SetDialogVariable( "main_objective", $.Localize( "#" + strScenarioName + "_main_objective" ) );
}

function OnRestartButtonClicked()
{
	GameEvents.SendCustomGameEventToServer( "restart_scenario", {} );
}

GameEvents.Subscribe( "scenario_restarted", OnScenarioRestarted );
function OnScenarioRestarted( event )
{
	$( '#TaskList' ).RemoveAndDeleteChildren();
	$( '#ScenarioCompletePanel' ).RemoveClass( "ShowScenarioFinishedPanel" );
	$( '#ScenarioFailedPanel' ).RemoveClass( "ShowScenarioFinishedPanel" );
}

function OnExitButtonClicked()
{
	GameEvents.SendCustomGameEventToServer("exit_scenario", {});
	$.Schedule( 1.0, function ()
	{
		Game.FinishGame();
	} );
}

function OnQuitButtonClicked()
{
	$.Schedule( 0.0, function ()
	{
		Game.LeaveCurrentGame();
	} );
}


function OnWinButtonClicked()
{
	GameEvents.SendCustomGameEventToServer("win_scenario", {});
	$.Schedule( 1.0, function ()
	{
		Game.FinishGame();
	} );
}

GameEvents.Subscribe( "task_start", OnTaskStart );
function OnTaskStart( event )
{
	// var taskPanel = null;
	// if ( event[ "task_parent" ] !== undefined  )
	// {
	// 	for ( var j = 0; j < $( '#TaskList' ).GetChildCount(); j++ )
	// 	{
	// 		var panelChild = $( '#TaskList' ).GetChild( j );
	// 		if ( panelChild && panelChild.GetAttributeString( "task_parent", null ) == event[ "task_parent" ] && panelChild.BHasClass( "ObjectiveCompleted" ) )
	// 		{
	// 			taskPanel = panelChild;
	// 			break;
	// 		}
	// 	}
	// }

	var taskPanel = $.CreatePanel( "Panel", $( '#TaskList' ), event[ "task_name" ] );
	taskPanel.BLoadLayoutSnippet( "Task2" );
	taskPanel.SetAttributeString( "task_parent", event[ "task_parent"] );
	taskPanel.SetDialogVariable( "task_progress", 0 );
	taskPanel.SetHasClass( "Hidden", event["task_hidden"] );
	taskPanel.SetHasClass( "ObjectiveCompleted", false );
	taskPanel.SetHasClass( "BeginToHide", false );

	var rgTaskDialogVars = event[ "task_dialog_variables" ];
	if ( rgTaskDialogVars != null )
	{
		for ( var i = 0; i < Object.keys( rgTaskDialogVars ).length; i++ )
	    {
	    	UnserializeDialogVariables( taskPanel, Object.keys( rgTaskDialogVars )[ i ], rgTaskDialogVars[ Object.keys( rgTaskDialogVars )[ i ] ] );
	    }
	}

	var rgScenarioInfo = CustomNetTables.GetTableValue( "base_scenario", "scenario_info" );
	var szLocalizedName = $.Localize( "#" + rgScenarioInfo[ "scenario_name" ] + "_task_" + event[ "task_name" ], taskPanel );
	taskPanel.SetDialogVariable( "task_name", szLocalizedName );
	var szLocalizedDesc = $.Localize( "#" + rgScenarioInfo[ "scenario_name" ] + "_task_" + event[ "task_name" ] + "_Description", taskPanel );
	taskPanel.SetDialogVariable( "task_description", szLocalizedDesc );

	if ( event["task_hidden"] == false )
	{
		Game.EmitSound( "ui.npe_objective_given" );	
	}	
}

function UnserializeDialogVariables( panel, key, value )
{
	if ( value == null || typeof value === 'undefined' )
		return;

	if ( typeof value === 'object' )
	{
		for ( var i = 0; i < Object.keys( value ).length; i++ )
	    {
	    	UnserializeDialogVariables( Object.keys( value )[ i ], value[ Object.keys( value )[ i ] ] );
	    }
	    return;
	}

	var szDialogVariableValue = value.toString();
	if ( key.toString() == "ItemName" || key.toString() == "ItemNames" || key.toString() == "AbilityName" || key.toString() == "AbilityNames" )
	{
		if ( GameUI.IsAbilityDOTATalent( value.toString() ) )
		{
			szDialogVariableValue = GameUI.SetupDOTATalentNameLabel( $( '#HiddenLabel' ), value.toString() );
		}
		else
		{
			szDialogVariableValue = $.Localize( "#DOTA_Tooltip_ability_" + value.toString(), panel );
		}
	}
	panel.SetDialogVariable( key.toString(), szDialogVariableValue );
}

GameEvents.Subscribe( "task_complete", OnTaskComplete );
function OnTaskComplete( event )
{
	var taskPanel = $( '#TaskList' ).FindChildTraverse( event[ "task_name" ] );
	if ( taskPanel === null )
		return;

	taskPanel.SetHasClass( "ObjectiveCompleted", true );

	if ( taskPanel.BHasClass( "Hidden" ) == false )
	{
		Game.EmitSound( "Tutorial.TaskProgress" );
	}	

	$.Schedule( 3.0, function()
	{
		if ( taskPanel.IsValid() )
		{
			taskPanel.SetHasClass( "BeginToHide", true);
		}
	} );
	
	$.Schedule( 4.0, function()
	{
		if ( taskPanel.IsValid() )
		{
			taskPanel.SetHasClass( "BeginToHide", false );
			taskPanel.SetHasClass( "Hidden", true );
		}
	} );
}


GameEvents.Subscribe( "task_progress_changed", OnTaskProgressChanged );
function OnTaskProgressChanged( event )
{
	var taskPanel = $( '#TaskList' ).FindChildTraverse( event[ "task_name" ] );

	if ( taskPanel )
	{
		var nTaskProgress = event[ "task_progress" ];
		var nTaskGoal = event[ "task_goal" ];
		taskPanel.SetHasClass( "HasProgress", nTaskGoal > 1 )
		taskPanel.SetDialogVariable( "task_progress", Math.min( nTaskProgress, nTaskGoal ) );
		taskPanel.SetDialogVariable( "task_goal", nTaskGoal );
	}
}

GameEvents.Subscribe( "display_hint", OnDisplayHint );
function OnDisplayHint( event )
{
	var hintPanel = $( '#HintPanel' );
	hintPanel.SetHasClass( "HintVisible", true );
	
	var rgScenarioInfo = CustomNetTables.GetTableValue( "base_scenario", "scenario_info" );
	var szLocalizedName = $.Localize( "#" + rgScenarioInfo[ "scenario_name" ] + "_hint_" + event[ "hint_text" ], hintPanel );
	hintPanel.SetDialogVariable( "hint_text", szLocalizedName );

	var flDuration = 10
	if ( 'duration' in event )
		flDuration = event['duration'];

	if ( flDuration > 0 )
	{
		hintPanel._closeEvent = $.Schedule( flDuration, function() { 
			if ( hintPanel._closeEvent !== undefined )
			{
				hintPanel._closeEvent = undefined;
			}
			DismissHint();
		});
	}
}

function DismissHint()
{
	var hintPanel = $( '#HintPanel' );
	hintPanel.SetHasClass( "HintVisible", false );
	if ( hintPanel._closeEvent !== undefined )
	{
		$.CancelScheduled( hintPanel._closeEvent );
		hintPanel._closeEvent = g_bInUnitIntroductionefined;
	}
}
GameEvents.Subscribe( "hide_hint", DismissHint );

//new

GameEvents.Subscribe( "start_world_text_hint", StartWorldTextHint );
function StartWorldTextHint( event )
{
	var vAbsOrigin = [ event[ "location_x" ], event[ "location_y" ], event[ "location_z" ] ];
	var nX = Game.WorldToScreenX( vAbsOrigin[0], vAbsOrigin[1], vAbsOrigin[2] );
	var nY = Game.WorldToScreenY( vAbsOrigin[0], vAbsOrigin[1], vAbsOrigin[2] );

	g_vWorldHintLoc = vAbsOrigin;

	var rgScenarioInfo = CustomNetTables.GetTableValue( "base_scenario", "scenario_info" );

	if ( event[ "command" ] >= 0 )
	{
		$( '#WorldHintPanel' ).SetDialogVariable( "keybind", "<panel class='" + GetClassForKeybind( Game.GetKeybindForCommand( event["command"] ) ) + "'/>" );
		$( '#WorldHintPanel' ).SetDialogVariable( "secondary_keybind", "<panel class='" + GetClassForKeybind( GetSecondaryKeybindForCommand( event["command"] ) ) + "'/>" );
		$( '#WorldHintPanel' ).SetDialogVariable( "alternate_keybind", "<panel class='" + GetClassForKeybind( GetAlternateKeybindForCommand( event["command"] ) ) + "'/>" );
		$( '#WorldHintPanel' ).SetDialogVariable( "keybind_raw", Game.GetKeybindForCommand( event["command"] ) );
		$( '#WorldHintPanel' ).SetDialogVariable( "secondary_keybind_raw", GetSecondaryKeybindForCommand( event["command"] ) );
		$( '#WorldHintPanel' ).SetDialogVariable( "alternate_keybind_raw", GetAlternateKeybindForCommand( event["command"] ) );
	}

	var szLocalizedName = $.Localize( "#" + rgScenarioInfo[ "scenario_name" ] + "_hint_" + event[ "hint_text" ], $( '#WorldHintPanel' ) );
	$( '#WorldHintPanel' ).SetDialogVariable( "world_hint_text", szLocalizedName );
	$( '#WorldHintPanel' ).style.x = ( nX / $( "#WorldHintPanel" ).actualuiscale_x ) - (  $( '#WorldHintPanel' ).actuallayoutwidth / 2 ) + "px"; 
	$( '#WorldHintPanel' ).style.y = ( nY / $( "#WorldHintPanel" ).actualuiscale_y  ) + 75 + "px";
	$( '#WorldHintPanel' ).SetHasClass( "HintVisible", true );
}

function GetSecondaryKeybindForCommand( nCommand )
{
	switch ( nCommand )
	{
		case DOTAKeybindCommand_t.DOTA_KEYBIND_HERO_ATTACK:
		case DOTAKeybindCommand_t.DOTA_KEYBIND_HERO_MOVE:
		case DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORYTP:
		case DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY1:
		case DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY2:
		case DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY3:
		case DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_SECONDARY1:
		case DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_SECONDARY2:
		case DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_ULTIMATE:
		case DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY1:
		case DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY2:
		case DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY3:
		case DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY4:
		case DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY5:
		case DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY6:
			return "MOUSE1";
	}

	return Game.GetKeybindForCommand( nCommand );
}

function GetAlternateKeybindForCommand( nCommand )
{
		if ( nCommand === DOTAKeybindCommand_t.DOTA_KEYBIND_HERO_MOVE )
		return "MOUSE2";

	return Game.GetKeybindForCommand( nCommand );
}

function IsKeybindMouse( szKeybind )
{
	if ( szKeybind == "MOUSE1" || szKeybind == "MOUSE2" || szKeybind == "MOUSE3" || szKeybind == "MOUSE4" || szKeybind == "MOUSE5" )
		return true;

	return false;
}

function GetClassForKeybind( szKeybind )
{
	if ( IsKeybindMouse( szKeybind ) ) 
		return szKeybind;

	return "Keyboard";
}

GameEvents.Subscribe( "stop_world_text_hint", StopWorldTextHint );
function StopWorldTextHint( event )
{
	g_vWorldHintLoc = null;
	$( '#WorldHintPanel' ).SetHasClass( "HintVisible", false );
}

var g_bDialogActive = false;
var g_nDialogChar = 0; 
var g_nDialogEnt = -1;
var g_bDialogBubble = false;
var g_szPendingDialog = null;

GameEvents.Subscribe( "start_dialog", StartDialog );
function StartDialog( event )
{
	$.Msg( "StartDialog" );

	var rgScenarioInfo = CustomNetTables.GetTableValue( "base_scenario", "scenario_info" );
	var szLocalizedText = $.Localize( "#" + rgScenarioInfo[ "scenario_name" ] + "_dialog_" + event[ "dialog_text" ], $( '#DialogPanel' ) );
	
	g_szPendingDialog = szLocalizedText;
	g_bDialogActive = true;
	g_nDialogEnt = event[ "dialog_ent_index" ];
	g_nDialogChar = 0;
	g_bDialogBubble = event["dialog_bubble"];

	var DialogPanel = !g_bDialogBubble ? $( '#DialogPanel' ) : $( '#FloatingDialogPanel' );
	DialogPanel.SetHasClass( "Visible", true );
	DialogPanel.SetDialogVariable( "dialog_text_sizer", szLocalizedText );

	if ( !g_bDialogBubble )
	{
		$( '#DialogPortrait' ).SetUnit( Entities.GetUnitName( g_nDialogEnt ), "", false );
	}

	if ( g_nDialogEnt !== -1 )
	{
		var szSpeakingEntityName = $.Localize( "#" + Entities.GetUnitName( g_nDialogEnt ) );
		DialogPanel.SetDialogVariable( "dialog_npc_name", szSpeakingEntityName );
	}
}

GameEvents.Subscribe( "server_ended_dialog", ServedEndedDialog );
function ServedEndedDialog( event )
{
	$.Msg( "ServedEndedDialog" );
	EndDialog();
}

function AdvanceDialog()
{
	var DialogPanel = !g_bDialogBubble ? $( '#DialogPanel' ) : $( '#FloatingDialogPanel' );
	
	if ( Game.GetGameTime() % 5 )
	{
		g_nDialogChar = Math.min( g_nDialogChar + 1, g_szPendingDialog.length )
		if ( g_nDialogChar >= g_szPendingDialog.length )
		{
			g_nDialogChar = g_szPendingDialog.length;
			DialogPanel.SetHasClass( "DialogFinished", true );
			DialogPanel.SetDialogVariable( "dialog_text", g_szPendingDialog );
		}
		else
		{
			DialogPanel.SetDialogVariable( "dialog_text", g_szPendingDialog.substring( 0, g_nDialogChar ) );
		}	
	}

	if ( g_bDialogBubble )
	{
		var vAbsOrigin = Entities.GetAbsOrigin( g_nDialogEnt );
		var nX = Game.WorldToScreenX( vAbsOrigin[0], vAbsOrigin[1], vAbsOrigin[2] );
		var nY = Game.WorldToScreenY( vAbsOrigin[0], vAbsOrigin[1], vAbsOrigin[2] );
		DialogPanel.style.x = ( nX / DialogPanel.actualuiscale_x ) + 25 + "px"; 
		DialogPanel.style.y = ( nY / DialogPanel.actualuiscale_y ) - 100 + "px";
	}
}

function EndDialog()
{
	$( '#DialogPanel' ).SetHasClass( "Visible", false );
	$( '#FloatingDialogPanel' ).SetHasClass( "Visible", false );

	g_bDialogActive = false;
	g_nDialogEnt = -1;
	g_nDialogChar = 0;
	g_szPendingDialog = null;
}

var g_bInUnitIntroduction = false;
var g_flCameraYawSpeed = 0.2;

GameEvents.Subscribe( "introduce_unit", IntroduceUnit );
function IntroduceUnit( event )
{
	//GameUI.SetCameraPitchMin( event["camera_pitch"] );
	//GameUI.SetCameraPitchMax( event["camera_pitch"] );
	//GameUI.SetCameraDistance( event["camera_distance"] );
	//GameUI.SetCameraLookAtPositionHeightOffset( event["camera_height"] );
	GameUI.SetCameraTarget( event["ent_index"] );
	//GameUI.SetCameraYaw( event["camera_initial_yaw"] );

	//g_flCameraYawSpeed = event["camera_yaw_rotate_speed"];

	g_bInUnitIntroduction = true;
}

GameEvents.Subscribe( "end_introduce_unit", EndIntroduceUnit );
function EndIntroduceUnit( event )
{
	//GameUI.SetCameraPitchMin( 38 );
	//GameUI.SetCameraPitchMax( 60 );
	//GameUI.SetCameraDistance( 1134.0 );
	//GameUI.SetCameraLookAtPositionHeightOffset( 0 );
	GameUI.SetCameraTarget( -1 );
	//GameUI.SetCameraYaw( 0 );
	//g_flCameraYawSpeed = 0.2;

	g_bInUnitIntroduction = false;
}

GameEvents.Subscribe( "end_introduce_scenario", EndIntroduceScenario );
function EndIntroduceScenario( event )
{
	$( '#ObjectivesPanel' ).SetHasClass( "IntroductionComplete", true );
}

GameEvents.Subscribe( "scenario_complete", OnScenarioComplete );
function OnScenarioComplete( event )
{
	Game.EmitSound( "Loot_Drop_Stinger_Immortal" );
	$( '#ScenarioCompletePanel' ).AddClass( "ShowScenarioFinishedPanel" );
	$( '#ScenarioCompletePanel' ).AddClass( "ScenarioFinishedPanelVictory" );
}

GameEvents.Subscribe( "scenario_failed", OnScenarioFailed );
function OnScenarioFailed( event )
{
	var szFailureReason = event[ "failure_reason" ];
	if ( szFailureReason != null )
	{
		$.Msg( "FAILURE = " + szFailureReason )
		$( '#ScenarioFailedPanel' ).SetDialogVariable( "failure_reason", $.Localize( "#" + szFailureReason ) );
	}
	else
	{
		$( '#ScenarioFailedPanel' ).SetDialogVariable( "failure_reason", "" );	
	}

	$( '#ScenarioFailedPanel' ).AddClass( "ShowScenarioFinishedPanel" );
}

var g_bTimerActive = false;
var g_flTimerEndTime = -1.0;
var g_flTimerStartTime = -1.0;

GameEvents.Subscribe( "timer_set", OnTimerSet );
function OnTimerSet( event )
{
	$( '#TimerPanel' ).AddClass( "ShowTimerPanel" );
	$( '#TimerPanel' ).SetDialogVariable( "header", $.Localize( "#" + event["timer_header"] ) );
	g_bTimerActive = true;

	var nTimerValue = event.timer_value || 0;
	var flDotaTime = Game.GetDOTATime( false, true );
	if ( event.timer_countdown === 1 )
	{
		g_flTimerEndTime = flDotaTime + nTimerValue;
		g_flTimerStartTime = -1.0;
	}
	else
	{
		g_flTimerEndTime = -1.0;
		g_flTimerStartTime = flDotaTime - nTimerValue;
	}
}

GameEvents.Subscribe( "timer_hide", OnTimerHide );
function OnTimerHide( event )
{
	$( '#TimerPanel' ).RemoveClass( "ShowTimerPanel" );
	g_bTimerActive = false;
	g_flTimerEndTime = -1.0;
	g_flTimerStartTime = -1.0;
}

GameEvents.Subscribe( "show_wizard_tip", ShowWizardTip ); 
function ShowWizardTip( event )
{
	var szTipText = '#' + event[ "tip_name" ] + "_Text";
	var szTipAnnotation = '#' + event[ "tip_name" ] + "_Annotation";
	var flDuration = event[ "tip_duration" ];
	var referencedAbilities = null
	if ( event[ "tip_ability_names" ] != null ) 
	{
		referencedAbilities = Object.values( event[ "tip_ability_names" ] );
	}
	var referencedUnits = null;
	if ( event[ "tip_unit_names" ] != null )
	{
		referencedUnits = Object.values( event[ "tip_unit_names" ] );
	}
	var panoramaClasses = null;
	if ( event[ "tip_panorama_classes" ] != null )
	{
		panoramaClasses = Object.values( event[ "tip_panorama_classes" ] );
	}
	GameUI.DisplayCustomContextualTip( { TipText: szTipText, DisplayDuration: flDuration, ReferencedAbilities: referencedAbilities, ReferencedUnits: referencedUnits, PanoramaClasses: panoramaClasses } );
}


GameEvents.Subscribe( "fade_to_black", OnGameEventFadeToBlack );
function OnGameEventFadeToBlack( e )
{
    if ( e.fade_down == 1 )
    {
        $.GetContextPanel().AddClass( "FadeToBlack" );
    }
    else
    {
        $.GetContextPanel().RemoveClass( "FadeToBlack" );
    }
}

var g_nUITipWindowEdgeBuffer = 20;
var g_szUITipDismissEvent = null;
var g_nCurrentUIHintID = 0;
var g_nNudge = null;

GameEvents.Subscribe( "show_ui_hint", ShowUIHint );
function ShowUIHint( event )
{
	if ( $( '#TutorialUIHint' ).BHasClass( "Visible" ) )
	{
		HideUIHint();
	}

	var szPanelName = event[ "panel_name" ];
	var tipPanelTarget = $.GetContextPanel().FindAncestor( "Hud" );
	szPanelName.split( " " ).forEach( function ( szPanelId ) {
    if ( tipPanelTarget == null )
    {
      return;
    }
		tipPanelTarget = tipPanelTarget.FindChildTraverse( szPanelId );
	} );
	if ( tipPanelTarget )
	{
		var nX = ( tipPanelTarget.GetPositionWithinWindow().x / tipPanelTarget.actualuiscale_x );
		var nY = ( tipPanelTarget.GetPositionWithinWindow().y / tipPanelTarget.actualuiscale_y ); 

		$( '#TutorialUIHint' ).AddClass( "Visible" );
		$( '#TutorialUIHint' ).RemoveClass( "Nudge" );
		$( '#TutorialUIHint' ).SwitchClass( "panel_name", szPanelName );

		var nContentsX = Math.min( Math.max( nX - ( 255 / 2 ), g_nUITipWindowEdgeBuffer ), $( '#TutorialUIHint' ).actuallayoutwidth - ( 201 + g_nUITipWindowEdgeBuffer ) );
		var nContentsY = Math.min( Math.max( nY - ( 94 * 1.5 ), g_nUITipWindowEdgeBuffer ), $( '#TutorialUIHint' ).actuallayoutheight - ( 94 + g_nUITipWindowEdgeBuffer ) );
		$( '#TutorialUIHintContentsContainer' ).style.x = nContentsX + "px";
		$( '#TutorialUIHintContentsContainer' ).style.y = nContentsY + "px";

		var nLongestDimension = Math.max( tipPanelTarget.actuallayoutwidth / tipPanelTarget.actualuiscale_x, tipPanelTarget.actuallayoutheight / tipPanelTarget.actualuiscale_y );
		var nShortestDimension = Math.min( tipPanelTarget.actuallayoutwidth / tipPanelTarget.actualuiscale_x, tipPanelTarget.actuallayoutheight / tipPanelTarget.actualuiscale_y );
		var nOffset = ( nLongestDimension - nShortestDimension ) / 2;

		if ( nShortestDimension == ( tipPanelTarget.actuallayoutheight / tipPanelTarget.actualuiscale_y ) )
		{
			nY = nY - nOffset;
		}
		else
		{
			nX = nX - nOffset;
		}

		$( '#TutorialUIHintHighlight1' ).style.x = nX + "px";
		$( '#TutorialUIHintHighlight1' ).style.y = nY + "px";
		$( '#TutorialUIHintHighlight1' ).style.width = nLongestDimension + 2 + "px";
		$( '#TutorialUIHintHighlight1' ).style.height = nLongestDimension + 2 + "px";
		$( '#TutorialUIHintHighlight2' ).style.x = nX + "px";
		$( '#TutorialUIHintHighlight2' ).style.y = nY + "px";
		$( '#TutorialUIHintHighlight2' ).style.width = nLongestDimension + 2 + "px";
		$( '#TutorialUIHintHighlight2' ).style.height = nLongestDimension + 2 + "px";
		$( '#TutorialUIHintHighlight3' ).style.x = nX + "px";
		$( '#TutorialUIHintHighlight3' ).style.y = nY + "px";
		$( '#TutorialUIHintHighlight3' ).style.width = nLongestDimension + 2 + "px";
		$( '#TutorialUIHintHighlight3' ).style.height = nLongestDimension + 2 + "px";

		if ( event[ "ui_tip_text" ] )
		{
			$( '#TutorialUIHintText' ).SetDialogVariable( "ui_hint_text", $.Localize( "#" + event[ "ui_tip_text" ] ) );

			if ( event[ "nudge_time" ] )
			{
				g_nNudge = $.Schedule( event[ "nudge_time" ], NudgeUIHint );
			}
			else
			{
				NudgeUIHint();
			}
		}

		if ( event[ "dismiss_event" ] )
		{
			g_szUITipDismissEvent = event[ "dismiss_event" ];
			$.Msg( "registering event: " + g_szUITipDismissEvent );
			$.RegisterForUnhandledEvent( g_szUITipDismissEvent, ClientDismissUIHint );
		}

	 	g_nCurrentUIHintID = event[ "ui_hint_id" ];
	}
	else
	{
		$.Msg( "Couldn't find UI hint panel " + event[ "panel_name" ] );
	}
	
}

function NudgeUIHint()
{
	g_nNudge = null;
	$( '#TutorialUIHint' ).AddClass( "Nudge" );
}

function ClientDismissUIHint()
{
	if ( g_szUITipDismissEvent == null )
		return true;

	HideUIHint();
	return true;
}

GameEvents.Subscribe( "hide_ui_hint", HideUIHint );
function HideUIHint( event )
{
	$( '#TutorialUIHint' ).RemoveClass( "Visible" );
	$( '#TutorialUIHint' ).RemoveClass( "Nudge" );
	//$.CancelScheduled( NudgeUIHint );

	if ( g_szUITipDismissEvent != null )
	{
		//$.Msg( "unregistering event: " + g_szUITipDismissEvent );
		//$.UnregisterForUnhandledEvent( g_szUITipDismissEvent, HideUIHint );
		g_szUITipDismissEvent = null;
	}

	if ( g_nNudge != null )
	{
		$.CancelScheduled( g_nNudge );
		g_nNudge = null;
	}

	var data = {};
	data[ "ui_hint_id" ] = g_nCurrentUIHintID;
	GameEvents.SendCustomGameEventToServer( "ui_hint_advanced", data )
}

GameEvents.Subscribe( "dota_set_quick_buy", OnPlayerSetQuickBuy )
function OnPlayerSetQuickBuy( event )
{
	GameEvents.SendCustomGameEventToServer( "dota_set_quick_buy", event );
}


(function HUDThink()
{
	if ( g_vWorldHintLoc !== null )
	{
		var nX = Game.WorldToScreenX( g_vWorldHintLoc[0], g_vWorldHintLoc[1], g_vWorldHintLoc[2] );
		var nY = Game.WorldToScreenY( g_vWorldHintLoc[0], g_vWorldHintLoc[1], g_vWorldHintLoc[2] );
		$( '#WorldHintPanel' ).style.x = ( nX / $( "#WorldHintPanel" ).actualuiscale_x ) - (  $( '#WorldHintPanel' ).actuallayoutwidth / 2 ) + "px"; 
		$( '#WorldHintPanel' ).style.y = ( nY / $( "#WorldHintPanel" ).actualuiscale_y  ) + 75 + "px";
	}

	if ( g_bDialogActive )
	{
		AdvanceDialog();
	}

	if ( g_bTimerActive )
	{
		var flTimerValue = 0;
		var flDotaTime = Game.GetDOTATime( false, true);
		if ( g_flTimerEndTime !== -1 )
		{
			flTimerValue = g_flTimerEndTime - flDotaTime;
		}
		else if ( g_flTimerStartTime !== -1 )
		{
			flTimerValue = flDotaTime - g_flTimerStartTime;
		}
		$( '#TimerPanel' ).SetDialogVariable( "time", Math.ceil( flTimerValue ) );
	}

	$.Schedule( 0.003, HUDThink );
})();

(function Init()
{
	var hudPanel = $.GetContextPanel().FindAncestor( "Hud" );
	if ( hudPanel )
	{
		hudPanel.SetHasClass( "NPXScenario", true )
	}
})();

