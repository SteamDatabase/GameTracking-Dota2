"Resource/UI/DOTATournamentsPanel.res"
{
	controls
	{
		"DOTATournamentsPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTATournamentsPanel"

			"ypos"			"0"
			"wide"	 		"512"
			"tall"	 		"416"
			"zpos"			"1"
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
			"zpos"				"-2"
			"wide"				"512"
			"tall"				"416"
			style=GreyNoiseBackground
			mouseInputEnabled=0
		}
		
		"BackgroundInner"
		{
			"ControlName"		"Panel"
			"fieldName"			"BackgroundInner"
			"xpos"				"8"
			"ypos"				"8"
			"zpos"				"-1"
			"wide"				"496"
			"tall"				"400"
			"style"				"DashboardInnerBackground"
			"visible"			"1"
			"mouseInputEnabled"	"0"
		}
		
		"Title" { ControlName=Label fieldName=Title xpos=70 ypos=24 wide=380 tall=16 style=DashboardTitle labelText="TOURNAMENT SCHEDULE" textAlignment=center minimum-width=112 }	// TODO:Localize
	}
	include="resource/UI/dashboard_style.res"
	
	styles
	{
		include="resource/UI/dashboard_style.res"
	}	
}
