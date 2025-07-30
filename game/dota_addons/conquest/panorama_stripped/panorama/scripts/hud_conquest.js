"use strict";

var CONTROL_POINT_INFO =
[
    { "cp_num": 1, "node_id": "#CP1", "entity_name":"cp1", "cp_class_radiant":"cp1", "cp_class_dire":"cp5", "label_text":"#CP1" },
    { "cp_num": 2, "node_id": "#CP2", "entity_name":"cp2", "cp_class_radiant":"cp2", "cp_class_dire":"cp4", "label_text":"#CP2" },
    { "cp_num": 3, "node_id": "#CP3", "entity_name":"cp3", "cp_class_radiant":"cp3", "cp_class_dire":"cp3", "label_text":"#CP3" },
    { "cp_num": 4, "node_id": "#CP4", "entity_name":"cp4", "cp_class_radiant":"cp4", "cp_class_dire":"cp2", "label_text":"#CP4" },
    { "cp_num": 5, "node_id": "#CP5", "entity_name":"cp5", "cp_class_radiant":"cp5", "cp_class_dire":"cp1", "label_text":"#CP5" }
]

function CPInfo( cp_num )
{
	for ( var cp of CONTROL_POINT_INFO )
	{
		if ( cp.cp_num === cp_num )
		{
			return cp;
		}
	}

	return null;
}

function UpdateCPNew( data )
{
  	                               
	var info =
	{
		"cp_number" : data.cp_number,
		"last_team_capturing" : data.last_team_capturing_cp,
		"cp_owner" : data.cp_owner,
		"is_being_captured" : ( data.players_capturing > 0 ),
		"percentage_cp" : data.percentage_captured,
		"is_locked" : ( data.is_locked != 0 ),
		"players_capturing" : data.players_capturing,
		"radiant_near" : data.radiant_near,
		"radiant_capturing" : data.radiant_capturing,
		"dire_near" : data.dire_near,
		"dire_capturing" : data.dire_capturing,
		"is_fortified" : ( data.is_fortified != 0 ),
	}

  	                                   
	UpdateControlPointUI( info );
}

function UpdateControlPointUI( info )
{
	                          
    var localPlayerDetails = Game.GetLocalPlayerInfo();

	var localPlayerIsRadiant = localPlayerDetails ? localPlayerDetails.player_team_id == DOTATeam_t.DOTA_TEAM_GOODGUYS : false;

	var isAllyAttacking = false;
	var isEnemyAttacking = false;
	var isAllyControlled = false;
	var isEnemyControlled = false;

	var enemyTeam = DOTATeam_t.DOTA_TEAM_GOODGUYS;
	if ( localPlayerDetails != null )
	{
		if ( localPlayerDetails.player_team_id == DOTATeam_t.DOTA_TEAM_GOODGUYS )
		{
			enemyTeam = DOTATeam_t.DOTA_TEAM_BADGUYS;
		}

	    isAllyAttacking = ( info.last_team_capturing === localPlayerDetails.player_team_id );
	    isEnemyAttacking = ( info.last_team_capturing === enemyTeam );
	    isAllyControlled = ( info.cp_owner === localPlayerDetails.player_team_id );
	    isEnemyControlled = ( info.cp_owner === enemyTeam );
	}
	else                     
	{
		isAllyAttacking = ( info.last_team_capturing === DOTATeam_t.DOTA_TEAM_GOODGUYS );
	    isEnemyAttacking = ( info.last_team_capturing === DOTATeam_t.DOTA_TEAM_BADGUYS );
	    isAllyControlled = ( info.cp_owner === DOTATeam_t.DOTA_TEAM_GOODGUYS );
	    isEnemyControlled = ( info.cp_owner === DOTATeam_t.DOTA_TEAM_BADGUYS );
	}

	var isBeingCaptured = info.is_being_captured;
	var isBeingFortified = info.is_fortified;
	var isDireAttacking = ( info.last_team_capturing === DOTATeam_t.DOTA_TEAM_BADGUYS );
	var radiantCapturing = isBeingCaptured && info.radiant_capturing > 0 && ( info.cp_owner === DOTATeam_t.DOTA_TEAM_BADGUYS || ( info.cp_owner === DOTATeam_t.DOTA_TEAM_NOTEAM && info.dire_near === 0 ) );
	var direCapturing = isBeingCaptured && info.dire_capturing > 0 && ( info.cp_owner === DOTATeam_t.DOTA_TEAM_GOODGUYS || ( info.cp_owner === DOTATeam_t.DOTA_TEAM_NOTEAM && info.radiant_near === 0 ) );

	                                 
	var cpInfo = CPInfo( info.cp_number );
	var cpRoot = $( cpInfo.node_id );
	cpRoot.SetHasClass( "is_neutral", !isAllyControlled && !isEnemyControlled );
	cpRoot.SetHasClass( "controlled_by_ally", isAllyControlled );
	cpRoot.SetHasClass( "controlled_by_enemy", isEnemyControlled );
	cpRoot.SetHasClass( "being_captured_by_ally", isAllyAttacking );
	cpRoot.SetHasClass( "being_captured_by_enemy", isEnemyAttacking );
	cpRoot.SetHasClass( "being_captured_by_radiant", !isDireAttacking );
	cpRoot.SetHasClass( "being_captured_by_dire", isDireAttacking );
	cpRoot.SetHasClass( "cp_being_captured", isBeingCaptured );
	cpRoot.SetHasClass( "cp_locked", info.is_locked );
	cpRoot.SetHasClass( "radiant_on_point", info.radiant_near > 0 ); 
	cpRoot.SetHasClass( "dire_on_point", info.dire_near > 0 );
	cpRoot.SetHasClass( "radiant_capturing", radiantCapturing );
	cpRoot.SetHasClass( "dire_capturing", direCapturing );
	cpRoot.SetHasClass( "being_fortified", isBeingFortified );

	                          
	var cpCaptureProgress = cpRoot.FindChildInLayoutFile( "cp_capture_progress_bar" );
	var offset = info.percentage_cp * 1.45 - 150;
	if ( isDireAttacking )
	{
		offset = -info.percentage_cp * 1.45 + 50;
	}
	var percentStr = offset + "%;";
	cpCaptureProgress.style.x = percentStr;

	                             
	var cpNumberPro = cpRoot.FindChildInLayoutFile( "cp_pro_number" );
	var cpNumberAnti = cpRoot.FindChildInLayoutFile( "cp_anti_number" );
	if (radiantCapturing)
	{
		cpNumberPro.text = info.radiant_capturing;
		cpNumberAnti.text = info.dire_capturing;
	}
	else if (direCapturing)
	{
		cpNumberPro.text = info.dire_capturing;
		cpNumberAnti.text = info.radiant_capturing;
	}
	else
	{
		cpNumberPro.text = "";
		cpNumberAnti.text = "";
	}

	UpdateSharedCPStyles();
}

function UpdateSharedCPStyles()
{
	var good = 0;
	var bad = 0;
    for ( var cp_state of CustomNetTables.GetAllTableValues( "control_points" ) )
    {
		if ( cp_state.value.cp_owner === DOTATeam_t.DOTA_TEAM_GOODGUYS )
		{
			good += 1;
		}
		else if ( cp_state.value.cp_owner === DOTATeam_t.DOTA_TEAM_BADGUYS )
		{
			bad += 1;
		}
    }

	var all_points_captured = good + bad == 5;
	SetContestable( "#CP1", true);                       
	SetContestable( "#CP2", true);                       
	SetContestable( "#CP3", true);                                     
	SetContestable( "#CP4", true);                       
	SetContestable( "#CP5", true);                       

	if ( good == bad )
	{
		UpdateSharedCPStylesFromBias( 0 );
	}
	else if ( good > bad )
	{
		UpdateSharedCPStylesFromBias( good - 2 );
	}
	else
	{
		UpdateSharedCPStylesFromBias( -( bad - 2 ) );
	}
}

function SetContestable( panelName, val )
{
	var panel = $( panelName );
	if ( !panel )
		return;
	panel.SetHasClass( "contestable", val );
	panel.SetHasClass( "not_contestable", !val );
}

function SetContrib( panelName, val )
{
	var panel = $( panelName );
	if ( !panel )
		return;
	panel.SetHasClass( "contributing_points", val );
}

function UpdateSharedCPStylesFromBias( bias )
{
  	                                                
	$( "#CapturePoints" ).SetHasClass( "cp_bias_m3", bias <= -3 );
	$( "#CapturePoints" ).SetHasClass( "cp_bias_m2", bias == -2 );
	$( "#CapturePoints" ).SetHasClass( "cp_bias_m1", bias == -1 );
	$( "#CapturePoints" ).SetHasClass( "cp_bias_0", bias == 0 );
	$( "#CapturePoints" ).SetHasClass( "cp_bias_p1", bias == 1 );
	$( "#CapturePoints" ).SetHasClass( "cp_bias_p2", bias == 2 );
	$( "#CapturePoints" ).SetHasClass( "cp_bias_p3", bias >= 3 );

	  
	                                                       
	                                                       
	                                                                    
	                                                       
	                                                       
	    

	SetContrib( "#CP1", bias <= -3 );
	SetContrib( "#CP2", bias <= -2 );
	SetContrib( "#CP3", bias <= -1 || bias >=  1 );
	SetContrib( "#CP4", bias >=  2 );
	SetContrib( "#CP5", bias >=  3 );
}

                                                                
                                                                
function OnCountdownTimer( data )
{
   	                                    
	$.GetContextPanel().AddClass( "active_timer" );
    if ( ( data.timer_minute_01 < 1 ) && ( data.timer_minute_10 < 1 ) )
    {
    	$.GetContextPanel().AddClass( "alert_timer" );
    }
    if ( data.timer_minute_01 >= 1 )
    {
    	$.GetContextPanel().RemoveClass( "alert_timer" );
    }

	var timerText = "";
	timerText += data.timer_minute_10;
	timerText += data.timer_minute_01;
	timerText += ":";
	timerText += data.timer_second_10;
	timerText += data.timer_second_01;
                                             
	$( "#timer_digits" ).text = timerText;
}

                                                                
                                                                
function OnCPClicked( cp )
{
                                   
	var cpInfo = CPInfo( cp );
	Game.MoveLocalCameraToEntityByName( cpInfo.entity_name );
}

function MakeCPClickedCallback( cp )
{
	return function() { OnCPClicked( cp ); }
}

function OnNetTableChanged( table, key, data )
{
  	                                                             
	UpdateCPNew( data );
}

                                                                
                                                                
function OnGameStateChanged( table, key, data )
{
  	                                                              
	if ( key !== "game_state" )
		return;
	var countdown_timer = Math.floor( data.cp_game_timer );
	var minutes = Math.floor( countdown_timer / 60)
	var seconds = countdown_timer - (minutes * 60)
	var m10 = Math.floor(minutes / 10)
	var m01 = minutes - (m10 * 10)
	var s10 = Math.floor(seconds / 10)
	var s01 = seconds - (s10 * 10)
	var timer_data =
	{ 
		timer_minute_10: m10,
		timer_minute_01: m01,
		timer_second_10: s10,
		timer_second_01: s01
	}

	OnCountdownTimer( timer_data );
	if ( data.cp_game_timer <= 10 )
	{
		AlertTimer( timer_data )
	}
}

                                                                
                                                                
function FakeScore()
{
	var BASE = 1200;
	var score = { "radiant": BASE, "dire": BASE };
	var capt = { "team": 2, "capture_points": 0 };

	var time = Game.Time();
	
	var MAX = 800;
	var MAX_CAPT = 3;
	var SCALE = 3;
	var P = 10*SCALE;
	var P_R = 1*SCALE;
	var P_D = 5.5*SCALE;
	var TCHUNK = 4.5*SCALE;
	var t = time % P;
  	                          

	var CPS =
	[
		{ "cp_number": 1, "last_team_capturing": 0, "cp_owner":DOTATeam_t.DOTA_TEAM_GOODGUYS, "is_being_captured":0, "percentage_cp":0, "is_locked":0, "players_capturing":0, "pro_capturing":0, "anti_capturing":0, "is_fortified":0 },
		{ "cp_number": 2, "last_team_capturing": 0, "cp_owner":DOTATeam_t.DOTA_TEAM_GOODGUYS, "is_being_captured":0, "percentage_cp":0, "is_locked":0, "players_capturing":0, "pro_capturing":0, "anti_capturing":0, "is_fortified":0 },
		{ "cp_number": 3, "last_team_capturing": 0, "cp_owner":0, "is_being_captured":0, "percentage_cp":0, "is_locked":0, "players_capturing":0, "pro_capturing":0, "anti_capturing":0, "is_fortified":0 },
		{ "cp_number": 4, "last_team_capturing": 0, "cp_owner":DOTATeam_t.DOTA_TEAM_BADGUYS, "is_being_captured":0, "percentage_cp":0, "is_locked":0, "players_capturing":0, "pro_capturing":0, "anti_capturing":0, "is_fortified":0 },
		{ "cp_number": 5, "last_team_capturing": 0, "cp_owner":DOTATeam_t.DOTA_TEAM_BADGUYS, "is_being_captured":0, "percentage_cp":0, "is_locked":0, "players_capturing":0, "pro_capturing":0, "anti_capturing":0, "is_fortified":0 }
	];

	if ( t < P_R )
	{
		          
		UpdateSharedCPStylesFromBias( 0 );
	}
	else if ( t < P_D )
	{
		          
		var tt = ( t - P_R ) / TCHUNK;
		var ttc = (tt % 0.3333 / 0.333);
		score.radiant = BASE + Math.floor( tt * MAX );
		capt.team = 2;
		capt.capture_points = 3 + Math.floor( tt * MAX_CAPT );
		for ( var i = 0; i < capt.capture_points; ++i )
		{
			CPS[i].cp_owner = DOTATeam_t.DOTA_TEAM_GOODGUYS;
		}
		if ( capt.capture_points < 5 )
		{
			CPS[ capt.capture_points ].last_team_capturing = DOTATeam_t.DOTA_TEAM_GOODGUYS;
			CPS[ capt.capture_points ].is_being_captured = 1;
			CPS[ capt.capture_points ].percentage_cp = Math.floor( ttc * 100 );
			CPS[ capt.capture_points ].players_capturing = 3;
		}
		UpdateSharedCPStylesFromBias( capt.capture_points - 2 );
	}
	else
	{
		       
		var tt = ( t - P_D ) / TCHUNK;
		var ttc = (tt % 0.3333 / 0.333);
		score.dire = BASE + Math.floor( tt * MAX );
		capt.team = 3;
		capt.capture_points = 3 + Math.floor( tt * MAX_CAPT );
		for ( var i = 0; i < capt.capture_points; ++i )
		{
			CPS[ 4 - i ].cp_owner = DOTATeam_t.DOTA_TEAM_BADGUYS;
		}
		if ( capt.capture_points < 5 )
		{
			CPS[ 4 - capt.capture_points ].last_team_capturing = DOTATeam_t.DOTA_TEAM_BADGUYS;
			CPS[ 4 - capt.capture_points ].is_being_captured = 1;
			CPS[ 4 - capt.capture_points ].percentage_cp = Math.floor( ttc * 100 );
			CPS[ 4 - capt.capture_points ].players_capturing = 3;
		}
		UpdateSharedCPStylesFromBias( 2 - capt.capture_points );
	}
	
  	                                    
	OnScoreChanged( score );
	OnTeamGainingPoints( capt );
	for ( var c of CPS )
	{
		UpdateControlPointUI( c );
	}
	$.Schedule( .05, FakeScore );
}

function OnScoreChanged( data )
{
  	                                     
	var radiant_points = data.radiant;
	var dire_points = data.dire;
  	                                      
  	                                

    var localPlayerDetails = Game.GetLocalPlayerInfo();

    var localPlayerIsRadiant = localPlayerDetails ? localPlayerDetails.player_team_id == DOTATeam_t.DOTA_TEAM_GOODGUYS : false;

	var enemyTeam = DOTATeam_t.DOTA_TEAM_GOODGUYS;
	if ( localPlayerDetails != null )
	{
		if ( localPlayerDetails.player_team_id == DOTATeam_t.DOTA_TEAM_GOODGUYS )
		{
			enemyTeam = DOTATeam_t.DOTA_TEAM_BADGUYS;
		}
	}
	                    
	if ( localPlayerDetails == null )
	{
		enemyTeam = DOTATeam_t.DOTA_TEAM_BADGUYS;
	}

	if ( enemyTeam == DOTATeam_t.DOTA_TEAM_BADGUYS )
	{
    	$.GetContextPanel().SetHasClass( "points_radiant", true );
	}
	if ( enemyTeam == DOTATeam_t.DOTA_TEAM_GOODGUYS )
	{
   		$.GetContextPanel().SetHasClass( "points_dire", true );
	}
	                          
	var radiant_point_percentage = Math.floor(1000*data.radiant / 4000)*0.1
	var dire_point_percentage = Math.floor(1000*data.dire / 4000)*0.1 
	var radiant_percentStr = radiant_point_percentage + "%;";
	var dire_percentStr = dire_point_percentage + "%";
	$( "#radiant_progress_bar" ).style.width = radiant_percentStr;
	$( "#dire_progress_bar" ).style.width = dire_percentStr;
}

                                                                
                                                                
function OnTeamGainingPoints( data )
{
  	                                  
	var team_number = data.team;
	var team_capture_points = data.capture_points;

	if ( team_number == 2 )
	{
		$.GetContextPanel().SetHasClass( "radiant_earning_points", false );
		$.GetContextPanel().SetHasClass( "radiant_earning_double_points", false );
		$.GetContextPanel().SetHasClass( "radiant_earning_triple_points", false );

		if ( team_capture_points >= 3 )
		{
			$.GetContextPanel().SetHasClass( "radiant_earning_points", true );
		}

		if ( team_capture_points >= 4 )
		{
			$.GetContextPanel().SetHasClass( "radiant_earning_double_points", true );
		}

		if ( team_capture_points >= 5 )
		{
			$.GetContextPanel().SetHasClass( "radiant_earning_triple_points", true );
		}
	}
	if ( team_number == 3 )
	{
		$.GetContextPanel().SetHasClass( "dire_earning_points", false );
		$.GetContextPanel().SetHasClass( "dire_earning_double_points", false );
		$.GetContextPanel().SetHasClass( "dire_earning_triple_points", false );
		
		if ( team_capture_points >= 3 )
		{
			$.GetContextPanel().SetHasClass( "dire_earning_points", true );
		}

		if ( team_capture_points >= 4 )
		{
			$.GetContextPanel().SetHasClass( "dire_earning_double_points", true );
		}

		if ( team_capture_points >= 5 )
		{
			$.GetContextPanel().SetHasClass( "dire_earning_triple_points", true );
		}
	}
}

                                                                
                                                                
function OnWaypointActive( data )
{
  	                                         

	$.GetContextPanel().SetHasClass( "waypoint_active", true );

	$( "#WaypointMessage" ).text = $.Localize( "#Waypoint_Active" );

	if ( data.team == 2 )
	{
  		                                                                 
		GameUI.PingMinimapAtLocation( data.location );
		GameUI.PingMinimapAtLocation( data.exit );
	}
	if ( data.team == 3 )
	{
  		                                                              
		GameUI.PingMinimapAtLocation( data.location );
		GameUI.PingMinimapAtLocation( data.exit );
	}

	$.Schedule( 5, ClearWaypointMessage );
}

function ClearWaypointMessage()
{
	$.GetContextPanel().SetHasClass( "waypoint_active", false );
}

                                                                
                                                                
function OnGoalAchieved( data )
{
  	                                    

	$.GetContextPanel().SetHasClass( "points_achievement", true );

	if ( data.achieving_team == 2 )
	{
		$( "#PointMessage_Team" ).text = $.Localize( "#Radiant_Team" );
	}

	if ( data.achieving_team == 3 )
	{
		$( "#PointMessage_Team" ).text = $.Localize( "#Dire_Team" );
	}

	if ( data.achieving_points == 1 )
	{
		$( "#PointMessage_Text" ).text = $.Localize( "#Achievement_First" );
		if ( data.achieving_team == 2 )	
		{
			$( "#PointMessage_Points" ).text = $.Localize( "#Reward_First_Radiant" );
		}
		else
		{
			$( "#PointMessage_Points" ).text = $.Localize( "#Reward_First_Dire" );
		}
		$.GetContextPanel().SetHasClass( "milestone_active", true );
	}

	if ( data.achieving_points == 2 )
	{
		$( "#PointMessage_Text" ).text = $.Localize( "#Achievement_Second" );
		if ( data.achieving_team == 2 )	
		{	
			$( "#PointMessage_Points" ).text = $.Localize( "#Reward_Second_Radiant" );
		}
		else
		{
			$( "#PointMessage_Points" ).text = $.Localize( "#Reward_Second_Dire" );
		}
		$.GetContextPanel().SetHasClass( "milestone_active", true );
	}

	if ( data.achieving_points == 3 )
	{
		$( "#PointMessage_Text" ).text = $.Localize( "#Achievement_Third" );
		if ( data.achieving_team == 2 )
		{
			$( "#PointMessage_Points" ).text = $.Localize( "#Reward_Third_Radiant" );
		}	
		else
		{
			$( "#PointMessage_Points" ).text = $.Localize( "#Reward_Third_Dire" );
		}
		$( "#PointMessage_Trap" ).text = $.Localize( "" );
		$.GetContextPanel().SetHasClass( "milestone_active", true );
	}
	
	  
	                                 
	 
		                                                                     	
		                               
		 
			                                                                          
		 	
		    
		 
			                                                                       
		 
		                                                            
	 
	    

	if ( data.achieving_points == 4 )
	{
		$( "#PointMessage_Text" ).text = $.Localize( "#Achievement_Fifth" );	
		if ( data.achieving_team == 2 )
		{
			$( "#PointMessage_Points" ).text = $.Localize( "#Reward_Fifth_Radiant" );
		}	
		else
		{
			$( "#PointMessage_Points" ).text = $.Localize( "#Reward_Fifth_Dire" );
		}
		$.GetContextPanel().SetHasClass( "milestone_active", true );
	}

	$.Schedule( 10, ClearPointMessage );
}

function ClearPointMessage()
{
	$.GetContextPanel().SetHasClass( "points_achievement", false );
	$.GetContextPanel().SetHasClass( "milestone_active", false );
	$.GetContextPanel().SetHasClass( "radiant_achievement", false );
	$.GetContextPanel().SetHasClass( "dire_achievement", false );
}

                                                                
                                                                
function OnCountdownEnabled( data )
{
  	                             
	var winningTeam = data.team;
	var remainingText = data.score;
	$.GetContextPanel().SetHasClass( "countdown_active", true );

	if ( winningTeam == 2 )
	{
		$( "#CountdownMessage" ).text = $.Localize( "#Radiant_Winning" );
		$( "#CountdownNumbers" ).text = remainingText;
	}
	if ( winningTeam == 3 )
	{
		$( "#CountdownMessage" ).text = $.Localize( "#Dire_Winning" );
		$( "#CountdownNumbers" ).text = remainingText;
	}
}

                                                                
                                                                
(function () {
	var localPlayerInfo  = Game.GetLocalPlayerInfo();
	var localPlayerIsRadiant = localPlayerInfo ? localPlayerInfo.player_team_id == DOTATeam_t.DOTA_TEAM_GOODGUYS : true;
	$.GetContextPanel().SetHasClass( "local_player_is_radiant", localPlayerIsRadiant );
	$( "#RadiantPoints" ).SetHasClass( "local_player_team", localPlayerIsRadiant );
	$( "#DirePoints" ).SetHasClass( "local_player_team", !localPlayerIsRadiant );

	                                       
    for ( var cp of CONTROL_POINT_INFO )
    {
		var cpRootNode = $( cp.node_id );
		if ( cp.cp_class_radiant !== cp.cp_class_dire )
		{
			cpRootNode.SetHasClass( cp.cp_class_radiant, localPlayerIsRadiant );
			cpRootNode.SetHasClass( cp.cp_class_dire, !localPlayerIsRadiant );
		}
		else
		{
			cpRootNode.SetHasClass( cp.cp_class_radiant, true );
		}

		cpRootNode.BLoadLayout( "file://{resources}/layout/custom_game/conquest_cp.xml", false, false );
  		                                                                               
  		                       
    }

    for ( var cp_initial_state of CustomNetTables.GetAllTableValues( "control_points" ) )
    {
  		                                                      
		UpdateCPNew( cp_initial_state.value );
  		                       
    }

	GameEvents.Subscribe( "team_points", OnScoreChanged );
	GameEvents.Subscribe( "point_notification", OnGoalAchieved );
	GameEvents.Subscribe( "countdown_notification", OnCountdownEnabled );
	GameEvents.Subscribe( "broadcast_team", OnTeamGainingPoints );
	GameEvents.Subscribe( "waypoint_notification", OnWaypointActive );
	CustomNetTables.SubscribeNetTableListener( "control_points", OnNetTableChanged );
	CustomNetTables.SubscribeNetTableListener( "game_state", OnGameStateChanged );
  	            
})();


