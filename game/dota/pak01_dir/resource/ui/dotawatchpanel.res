"Resource/UI/DOTAWatchPanel.res"
{
	controls
	{
		"DOTAWatchPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAWatchPanel"
			"visible" 		"1"
			"enabled" 		"1"
			"xpos"			"c-388"
			//"ypos"			"56"
			"wide"	 		"776"
			"tall"	 		"416"
			"zpos"			"21"
			"PaintBackground"	"1"
			"PaintBackgroundType"	"0"
			"bgcolor_override" "0 0 0 255"
		}
		
		"Background"
		{
			"ControlName"			"Panel"
			"fieldName"			"Background"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"0"
			"wide"				"768"
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
			"wide"				"752"
			"tall"				"400"
			"style"				"DashboardInnerBackground"
			"visible"			"1"
			MouseInputEnabled=0
		}
		
		DOTARecentMatchesListBrief { Controlname=Panel fieldName=DOTARecentMatchesListBrief xpos=30 ypos=180 }
	}
	
	include="resource/UI/dashboard_style.res"
}
