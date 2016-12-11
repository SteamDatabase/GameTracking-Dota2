"Resource/UI/DOTAMatchmakingStatusPanel.res"
{
	controls
	{
		"DOTAMatchmakingStatusPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAMatchmakingStatusPanel"
			"xpos"			"20"
			"ypos"			"0"
			"wide"	 		"256"
			"tall"	 		"33"
			"zpos"			"3"
			style=StatusBarBGStyle
			visible=1
		}
		
		"SpinningCircle" { ControlName=CircularProgressBar fieldName=SpinningCircle wide=20 tall=20 xpos=0 ypos=8 zpos=6 alpha=255 fgcolor_override="255 255 255 128" bgcolor_override="64 64 64 64" }
		"StatusLabel" { ControlName=Label fieldName=StatusLabel xpos=25 ypos=0 wide=256 tall=36 textAlignment="west" zpos=2 visible=1 style=StatusBarTextStyle }
	}
	
	include="resource/UI/dashboard_style.res"
	
	colors
	{
		StatusBarText="165 165 165 255"
	}
	
	styles
	{
		"StatusBarTextStyle"
		{
			textcolor=StatusBarText
			font=Arial14Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		"StatusBarBGStyle"
		{
			bgcolor=none
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
	}
}
