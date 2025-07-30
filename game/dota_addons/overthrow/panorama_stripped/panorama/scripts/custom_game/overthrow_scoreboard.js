"use strict";

function UpdateTimer( data )
{
	                                 
	                                                    

	                                          
	                                          

	                     
	                   
	                   

	                 
	   
	  	                 
	   
	                   

	var timerText = "";
	timerText += data.timer_minute_10;
	timerText += data.timer_minute_01;
	timerText += ":";
	timerText += data.timer_second_10;
	timerText += data.timer_second_01;

	$( "#Timer" ).text = timerText;

	                                 
}

function ShowTimer( data )
{
	$( "#Timer" ).AddClass( "timer_visible" );
}

function AlertTimer( data )
{
	$( "#Timer" ).AddClass( "timer_alert" );
}

function HideTimer( data )
{
	$( "#Timer" ).AddClass( "timer_hidden" );
}

function UpdateKillsToWin()
{
	var victory_condition = CustomNetTables.GetTableValue( "game_state", "victory_condition" );
	if ( victory_condition )
	{
		$("#VictoryPoints").text = victory_condition.kills_to_win;
	}
}

function OnGameStateChanged( table, key, data )
{
	$.Msg( "Table '", table, "' changed: '", key, "' = ", data );
	UpdateKillsToWin();
}

(function()
{
	                                                                                                          
	UpdateKillsToWin();
	CustomNetTables.SubscribeNetTableListener( "game_state", OnGameStateChanged );

    GameEvents.Subscribe( "countdown", UpdateTimer );
    GameEvents.Subscribe( "show_timer", ShowTimer );
    GameEvents.Subscribe( "timer_alert", AlertTimer );
    GameEvents.Subscribe( "overtime_alert", HideTimer );
	                
})();

