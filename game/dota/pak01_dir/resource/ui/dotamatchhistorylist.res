"Resource/UI/DOTAMatchHistoryList.res"
{
	controls
	{
		"DOTAMatchHistoryList"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAMatchHistoryList"
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
			"visible"			"0"
			"scaleImage"			"1"
			//"image"			
			"fillcolor"			"21 21 21 255"
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
			"visible"			"0"
			"textAlignment"		"center"
			"style"				"DashboardTitle"
			"labelText"			"#dota_match_history"
		}
		
		"CloseButton"
		{
			"ControlName"			"Button"
			"fieldName"			"CloseButton"
			"xpos"				"460"
			"ypos"				"380"
			"zpos"				"2"
			"wide"				"70"
			"tall"				"14"
			"textAlignment"		"north-west"
			"labelText"			"#dota_match_history_back"
			"command"			"ClosePage"
			"visible"			"1"
		}
	}
	include="resource/UI/dashboard_style.res"
	
	styles
	{
		include="resource/UI/dashboard_style.res"
	}	
}
