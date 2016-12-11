"Resource/UI/DOTAFriendsPanel.res"
{
	controls
	{
		"DOTAFriendsPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAFriendsPanel"
			"xpos"			"r256"
			"ypos"			"r256"
			"wide"	 		"256"
			"tall"	 		"256"
			"zpos"			"20"
			"bgcolor_override"	"0 0 0 0"
			"visible"		"1"
		}
		
		"Background"
		{
			"ControlName"		"Panel"
			"fieldName"			"Background"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"0"
			"wide"				"256"
			"tall"				"256"
			"style"				"GreyNoiseBackground"
			"visible"			"1"
			"mouseInputEnabled"	"0"
		}
		
		"BackgroundInner"
		{
			"ControlName"		"Panel"
			"fieldName"			"BackgroundInner"
			"xpos"				"4"
			"ypos"				"20"
			"zpos"				"0"
			"wide"				"248"
			"tall"				"232"
			"style"				"DashboardInnerBackground"
			"visible"			"1"
			"mouseInputEnabled"	"0"
		}
		
		"Title"
		{
			"ControlName"			"Label"
			"fieldName"			"Title"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"2"
			"wide"				"256"
			"tall"				"20"			
			"textAlignment"		"center"
			"labelText"			"FRIENDS"	// TODO: Localize
			"style"				"DashboardTitle"
			"mouseInputEnabled"	"0"
		}
		
		"ListPanel"
		{
			"ControlName"			"ImagePanel"
			"fieldName"			"ListPanel"
			"xpos"				"8"
			"ypos"				"24"
			"zpos"				"0"
			"wide"				"246"
			"tall"				"224"
			"bgcolor_override" "0 0 0 0"
			zpos=2
		}
		
		"PlayingDOTAHeader" { ControlName=Label fieldName=PlayingDOTAHeader wide=200 tall=15 style="SectionTitle" labelText="PLAYING DOTA" visible=0 }	// TODO: Localize
		"OnlineHeader" { ControlName=Label fieldName=OnlineHeader wide=200 tall=15 style="SectionTitle" labelText="ONLINE" visible=0 }	// TODO: Localize
		"OfflineHeader" { ControlName=Label fieldName=OfflineHeader wide=200 tall=15 style="SectionTitle" labelText="OFFLINE" visible=0 }	// TODO: Localize
	}
	
	include="resource/UI/dashboard_style.res"
	
	colors
	{
	}
	
	styles
	{
	}
}
