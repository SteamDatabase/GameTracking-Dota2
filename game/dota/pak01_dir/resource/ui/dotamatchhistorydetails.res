"Resource/UI/DOTAMatchHistoryDetails.res"
{
	controls
	{
		"DOTAMatchHistoryDetails"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAMatchHistoryDetails"
			"visible" 		"1"
			"enabled" 		"1"
			"xpos"			"c-288"
			//"ypos"			"56"
			"wide"	 		"576"
			"tall"	 		"416"
			"zpos"			"21"
			"PaintBackground"	"1"
			"PaintBackgroundType"	"0"
			"bgcolor_override" "58 58 58 255"
		}
		
		"Background"
		{
			"ControlName"			"Panel"
			"fieldName"			"Background"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"0"
			"wide"				"568"
			"tall"				"416"
			style=GreyNoiseBackground
			MouseInputEnabled=0
		}
		
		"BackgroundInner"
		{
			"ControlName"		"Panel"
			"fieldName"			"BackgroundInner"
			"xpos"				"8"
			"ypos"				"8"
			"zpos"				"0"
			"wide"				"552"
			"tall"				"400"
			"style"				"DashboardInnerBackground"
			"visible"			"1"
			MouseInputEnabled=0
		}
		
		"TitleBar"
		{
			"ControlName"			"ImagePanel"
			"fieldName"			"TitleBar"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"2"
			"wide"				"576"
			"tall"				"24"
			"enabled"			"1"
			"visible"			"1"
			"scaleImage"			"1"
			//"image"			
			"fillcolor"			"21 21 21 255"
			"visible"			"0"
		}
		
		"Title"
		{
			"ControlName"			"Label"
			"fieldName"			"Title"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"3"
			"wide"				"576"
			"tall"				"24"
			"enabled"			"1"
			"visible"			"1"
			"textAlignment"		"center"
			"style"				"DashboardTitle"
			"labelText"			"#dota_match_history_details"
			"visible"			"0"
		}
		"MatchLabel"
		{
			"ControlName"		"Label"
			"fieldName"			"MatchLabel"
			"xpos"				"17"
			"ypos"				"48"
			"wide"				"150"
			"style"				"MinorStatLabel"
			"zpos"				"5"
		}
		"DateLabel"
		{
			"ControlName"		"Label"
			"fieldName"			"DateLabel"
			"xpos"				"17"
			"ypos"				"28"
			"wide"				"150"
			"style"				"StatLabel"
			"zpos"				"5"
		}
		"WinLabel"
		{
			"ControlName"		"Label"
			"fieldName"			"WinLabel"
			"xpos"				"0"
			"ypos"				"28"
			"wide"				"576"
			"style"				"StatLabel"
			"textAlignment"		"center"
			"zpos"				"5"
		}
		"DurationLabel"
		{
			"ControlName"		"Label"
			"fieldName"			"DurationLabel"
			"xpos"				"0"
			"ypos"				"28"
			"wide"				"556"
			"style"				"StatLabel"
			"textAlignment"		"east"
			"zpos"				"5"
		}
		
		// good guys
		"GoodGuysLabel"
		{
			"ControlName"		"Label"
			"fieldName"			"GoodGuysLabel"
			"xpos"				"17"
			"ypos"				"80"
			"wide"				"150"
			"labelText"			"#DOTA_Scoreboard_GoodGuys"
			"style"				"StatLabel"
			"zpos"				"5"
		}
		"PlayerRowGood_0"
		{
			"ControlName"		"Panel"
			"fieldName"			"PlayerRowGood_0"
			"xpos"				"17"
			"ypos"				"100"
			"wide"				"567"
			"tall"				"24"
			"zpos"				"5"
			"bgcolor_override"	"0 0 0 0"
		}
		"PlayerRowGood_1"
		{
			"ControlName"		"Panel"
			"fieldName"			"PlayerRowGood_1"
			"wide"				"567"
			"tall"				"24"
			"zpos"				"5"
			"bgcolor_override"	"0 0 0 0"
			
			"pin_to_sibling"			"PlayerRowGood_0"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"2"	
		}
		"PlayerRowGood_2"
		{
			"ControlName"		"Panel"
			"fieldName"			"PlayerRowGood_2"
			"wide"				"567"
			"tall"				"24"
			"zpos"				"5"
			"bgcolor_override"	"0 0 0 0"
			
			"pin_to_sibling"			"PlayerRowGood_1"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"2"	
		}
		"PlayerRowGood_3"
		{
			"ControlName"		"Panel"
			"fieldName"			"PlayerRowGood_3"
			"wide"				"567"
			"tall"				"24"
			"zpos"				"5"
			"bgcolor_override"	"0 0 0 0"
			
			"pin_to_sibling"			"PlayerRowGood_2"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"2"	
		}
		"PlayerRowGood_4"
		{
			"ControlName"		"Panel"
			"fieldName"			"PlayerRowGood_4"
			"wide"				"567"
			"tall"				"24"
			"zpos"				"5"
			"bgcolor_override"	"0 0 0 0"
			
			"pin_to_sibling"			"PlayerRowGood_3"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"2"	
		}
		"BadGuysLabel"
		{
			"ControlName"		"Label"
			"fieldName"			"BadGuysLabel"
			"xpos"				"17"
			"ypos"				"230"
			"wide"				"150"
			"labelText"			"#DOTA_Scoreboard_BadGuys"
			"style"				"StatLabel"
			"zpos"				"5"
		}
		// bad guys
		"PlayerRowBad_0"
		{
			"ControlName"		"Panel"
			"fieldName"			"PlayerRowBad_0"
			"xpos"				"17"
			"ypos"				"250"
			"wide"				"567"
			"tall"				"24"
			"zpos"				"5"
			"bgcolor_override"	"0 0 0 0"
		}
		"PlayerRowBad_1"
		{
			"ControlName"		"Panel"
			"fieldName"			"PlayerRowBad_1"
			"wide"				"567"
			"tall"				"24"
			"zpos"				"5"
			"bgcolor_override"	"0 0 0 0"
			
			"pin_to_sibling"			"PlayerRowBad_0"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"2"	
		}
		"PlayerRowBad_2"
		{
			"ControlName"		"Panel"
			"fieldName"			"PlayerRowBad_2"
			"wide"				"567"
			"tall"				"24"
			"zpos"				"5"
			"bgcolor_override"	"0 0 0 0"
			
			"pin_to_sibling"			"PlayerRowBad_1"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"2"	
		}
		"PlayerRowBad_3"
		{
			"ControlName"		"Panel"
			"fieldName"			"PlayerRowBad_3"
			"wide"				"567"
			"tall"				"24"
			"zpos"				"5"
			"bgcolor_override"	"0 0 0 0"
			
			"pin_to_sibling"			"PlayerRowBad_2"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"2"	
		}
		"PlayerRowBad_4"
		{
			"ControlName"		"Panel"
			"fieldName"			"PlayerRowBad_4"
			"wide"				"567"
			"tall"				"24"
			"zpos"				"5"
			"bgcolor_override"	"0 0 0 0"
			
			"pin_to_sibling"			"PlayerRowBad_3"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"2"	
		}
		"DOTAReplayDownloadPanel"
		{
			"ControlName"			"Panel"
			"fieldName"			"DOTAReplayDownloadPanel"
			"xpos"				"200"
			"ypos"				"380"
			"zpos"				"2"
		}
		"CloseButton"
		{
			"ControlName"			"Button"
			"fieldName"			"CloseButton"
			"xpos"				"493"
			"ypos"				"380"
			"zpos"				"2"
			"wide"				"50"
			"tall"				"15"
			"command"			"ClosePage"
			"textAlignment"		"north-east"
			"labelText"			"#dota_match_history_back"
		}
	}
	include="resource/UI/dashboard_style.res"
}
