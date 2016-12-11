"Resource/UI/DOTANewsArticlePanel.res"
{
	controls
	{
		"DOTANewsArticlePanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTANewsArticlePanel"
			"visible" 		"1"
			"enabled" 		"1"
			"xpos"			"c-512"
			//"ypos"			"56"
			"wide"	 		"1024"
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
			"wide"				"1024"
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
			"zpos"				"0"
			"wide"				"1008"
			"tall"				"400"
			"style"				"DashboardInnerBackground"
			"visible"			"1"
			"mouseInputEnabled"	"0"
		}
		
		"HTML"
		{
			"ControlName"			"Panel"
			"fieldName"			"HTML"
			"xpos"				"8"
			"ypos"				"8"
			"zpos"				"0"
			"wide"				"1016"
			"tall"				"397"
			"mouseinputenabled"	"1"
			"zpos"				"3"
			bgcolor_override="0 0 0 0"
		}
		
		"CloseButton"
		{
			"ControlName"			"Button"
			"fieldName"			"CloseButton"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"5"
			"wide"				"70"
			"tall"				"14"
			"textAlignment"		"north-west"
			"labelText"			"#dota_match_history_back"
			"command"			"ClosePage"
		}
	}
	
	include="resource/UI/dashboard_style.res"
}
