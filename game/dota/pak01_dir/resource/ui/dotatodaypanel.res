"Resource/UI/DOTATodayPanel.res"
{
	controls
	{
		"DOTATodayPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTATodayPanel"
			"visible" 		"1"
			"enabled" 		"1"
			//"xpos"			"c-512"
			//"ypos"			"56"
			//"wide"	 		"1024"
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
			"wide"				"1024"
			"tall"				"414"
			visible=0
			"PaintBackground"	"1"
			"PaintBackgroundType"	"0"
			"bgcolor_override" "0 0 0 255"
			mouseInputEnabled=0
		}
		
		"BackgroundInner"
		{
			"ControlName"		"Panel"
			"fieldName"			"BackgroundInner"
			"xpos"				"8"
			"ypos"				"8"
			"zpos"				"0"
			"wide"				"1008"
			"tall"				"397"
			"style"				"DashboardInnerBackground"
			"visible"			"0"
			"mouseInputEnabled"	"0"
		}
	}
	
	include="resource/UI/dashboard_style.res"
}
