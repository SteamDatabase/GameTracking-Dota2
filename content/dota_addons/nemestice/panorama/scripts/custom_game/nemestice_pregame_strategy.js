"use strict";

//-----------------------------------------------------------------------------------------
var g_sNemesticeTips = [
	"DOTA_nemestice_gameplay_tip_00",
	"DOTA_nemestice_gameplay_tip_01",
	"DOTA_nemestice_gameplay_tip_02",
	"DOTA_nemestice_gameplay_tip_03",
	"DOTA_nemestice_gameplay_tip_04",
	"DOTA_nemestice_gameplay_tip_05",
	"DOTA_nemestice_gameplay_tip_06",
	"DOTA_nemestice_gameplay_tip_07",
	"DOTA_nemestice_gameplay_tip_08",
	"DOTA_nemestice_gameplay_tip_09",
	"DOTA_nemestice_gameplay_tip_10",
	"DOTA_nemestice_gameplay_tip_11",
	"DOTA_nemestice_gameplay_tip_12",
	"DOTA_nemestice_gameplay_tip_13",
	"DOTA_nemestice_gameplay_tip_14",
	"DOTA_nemestice_gameplay_tip_15",
	"DOTA_nemestice_gameplay_tip_16",
	"DOTA_nemestice_gameplay_tip_17",
	"DOTA_nemestice_gameplay_tip_18",
	"DOTA_nemestice_gameplay_tip_19",
	"DOTA_nemestice_gameplay_tip_20",
	"DOTA_nemestice_gameplay_tip_21",
	"DOTA_nemestice_gameplay_tip_22",
	"DOTA_nemestice_gameplay_tip_23",
	"DOTA_nemestice_gameplay_tip_24",
	"DOTA_nemestice_gameplay_tip_25",
	"DOTA_nemestice_gameplay_tip_26",
	"DOTA_nemestice_gameplay_tip_27",
	"DOTA_nemestice_gameplay_tip_28",
	"DOTA_nemestice_gameplay_tip_29",
	"DOTA_nemestice_gameplay_tip_30",
];

var g_nNumNemesticeTips = g_sNemesticeTips.length
var g_nCurrentNemesticeTip = 0

//-----------------------------------------------------------------------------------------
$.Schedule( 0.0, function() 
{
	$.Msg( "nemestice_pregame_strategy.js - START!" )

	g_nCurrentNemesticeTip = Game.NemesticeGetGameplayTipNumber();
	OnShowPregameStrategy();
} );

//-----------------------------------------------------------------------------------------
function OnShowPregameStrategy()
{
	$.Msg( "nemestice_pregame_strategy.js - OnShowPregameStrategy()!" )
	$.GetContextPanel().SetDialogVariableInt( "num_tips", g_nNumNemesticeTips );
	SetNemesticeTipDialogVars();
}

function IncrementTip( nIncrement )
{
	g_nCurrentNemesticeTip = g_nCurrentNemesticeTip + nIncrement;
	if ( g_nCurrentNemesticeTip < 0 )
	{
		g_nCurrentNemesticeTip += g_nNumNemesticeTips;
	}
	g_nCurrentNemesticeTip = g_nCurrentNemesticeTip % g_nNumNemesticeTips;

	Game.NemesticeSetGameplayTipNumber( g_nCurrentNemesticeTip );
	SetNemesticeTipDialogVars(); 

	Game.EmitSound( "ui_select_arrow" );
}

//-----------------------------------------------------------------------------------------
function SetNemesticeTipDialogVars()
{
	$.GetContextPanel().SetDialogVariable( "tip_text", $.Localize( g_sNemesticeTips[ g_nCurrentNemesticeTip ] ) );
	$.GetContextPanel().SetDialogVariableInt( "current_tip_num", g_nCurrentNemesticeTip + 1 );

	$( '#TipBodyText' ).TriggerClass( 'AnimateNextTip' );
}

$.Schedule( 0.0, function onThink() {	
	if ( CustomNetTables.GetTableValue( 'globals', 'values' ) !== undefined )
	{
		Game.ForceCustomUILoad();
	}
	else
	{
		$.Schedule( 0.1, onThink );
	}
} );

