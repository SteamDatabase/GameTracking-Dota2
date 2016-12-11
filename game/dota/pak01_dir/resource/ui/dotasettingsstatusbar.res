"Resource/UI/DOTASettingsStatusBar.res"
{
	controls
	{
		"SettingsStatusBar"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"SettingsStatusBar"
			"xpos"				"0"
			"ypos"				"64"
			"wide"	 			"f0"
			"tall"	 			"33"
			"zpos"				"22"
			"style"				"StatusBarBGStyle"
		}
		
		"StatusLabel" { ControlName=Label fieldName=StatusLabel xpos=0 ypos=0 wide=f0 tall=33 textAlignment="center" zpos=2 visible=1 style=StatusBarTextStyle }
	}
	
	include="resource/UI/settings_style.res"
	
	colors
	{
		StatusBarText="165 165 165 255"
	}
	
	styles
	{
		"StatusBarTextStyle"
		{
			textcolor=StatusBarText
			font=Arial18Thick
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
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_status_bar.vmat )"
			}
		}
	}
}
