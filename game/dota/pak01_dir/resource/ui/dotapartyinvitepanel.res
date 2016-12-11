"Resource/UI/DOTAPartyInvitePanel.res"
{
	controls
	{
		"DOTAPartyInvitePanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAPartyInvitePanel"
			"wide"	 		"456"
			"tall"	 		"360"
			"zpos"			"100"
		}
		
		"Background"
		{
			"ControlName"			"Panel"
			"fieldName"			"Background"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"1"
			"wide"				"456"
			"tall"				"360"
			"style"				"GradientBackground"
		}
		
		"SenderName"
		{
			"ControlName"			"Label"
			"fieldName"			"SenderName"
			"xpos"				"20"
			"ypos"				"100"
			"zpos"				"3"
			"wide"				"350"
			"tall"				"19"
			"fgcolor_override"	"255 255 255 255"
			"bgcolor_override"	"0 0 0 255"
			"font"				"Arial12Med"
			"labelText"			"%SenderName%"
		}
		"InviteLabel"
		{
			"ControlName"			"Label"
			"fieldName"			"InviteLabel"
			"xpos"				"5"
			"ypos"				"0"
			"zpos"				"3"
			"wide"				"350"
			"tall"				"19"
			"fgcolor_override"	"255 255 255 255"
			"bgcolor_override"	"0 0 0 255"
			"font"				"Arial12Med"
			"labelText"			"has invited you to a party"		// TODO: Localize/put name in, etc.
			"pin_to_sibling"			"SenderName"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"1"	
			"visible"			"0"
		}
		"AcceptButton"
		{
			"ControlName"		"Button"
			"fieldName"			"AcceptButton"
			"xpos"				"20"
			"ypos"				"290"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"19"
			"labelText"			"ACCEPT"		// TODO: Localize
			"textAlignment"		"center"
			"Command"			"Accept"
		}
		"DeclineButton"
		{
			"ControlName"		"Button"
			"fieldName"			"DeclineButton"
			"xpos"				"300"
			"ypos"				"290"
			"zpos"				"3"
			"wide"				"100"
			"tall"				"19"
			"labelText"			"DECLINE"		// TODO: Localize
			"textAlignment"		"center"
			"Command"			"Decline"
		}
	}
	
	colors
	{
		"DashboardGradientTop"		"50 50 50 255"
		"DashboardGradientBottom"	"0 0 0 255"
		"TopBarButtonLight"			"97 97 97 255"
		"TopBarBG"					"58 58 58 255"
	}
		
	styles
	{
		GradientBackground
		{
			render_bg
			{
				// background fill
				0="gradient( x0, y0, x1, y1, DashboardGradientTop, DashboardGradientBottom )"
			}
		}
	}
}
