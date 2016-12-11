"Resource/UI/DOTAPracticeLobbyPlayerEntry.res"
{
	controls
	{
		"DOTAPracticeLobbyPlayerEntry"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAPracticeLobbyPlayerEntry"
			"wide"	 		"180"
			"tall"	 		"24"
			"zpos"			"2"
			"bgcolor_override" "0 0 0 0"
		}
		
		"background" { ControlName=EditablePanel wide=180 tall=22 bgcolor_override="0 0 0 0" }
		
		"PlayerName"
		{
			"ControlName"	"label"
			"fieldName"		"PlayerName"
			"labeltext"		"name"
			"xpos"			"5"
			"ypos"			"3"
			"wide"			"170"
			"tall"			"14"
			"textAlignment"		"west"
			"style"			"WhiteLabel"
			"labelText"		"%PlayerName%"
			fgcolor_override="255 255 255 255"
		}
		
		"PlayerRank"
		{
			"ControlName"	"label"
			"fieldName"		"PlayerRank"
			"xpos"			"0"
			"ypos"			"3"
			"wide"			"170"
			"tall"			"14"
			"textAlignment"		"east"
			"style"			"RankLabel"
			"labelText"		"%rank%"
		}
	}
	
	include="resource/UI/dashboard_style.res"
	
	"colors"
	{
		White="255 255 255 255"
		RankLabelColor="128 128 128 255"
	}
	
	styles
	{
		WhiteLabel
		{
			textcolor=White
			font=Arial12Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		RankLabel
		{
			textcolor=RankLabelColor
			font=Arial12Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
	}
}