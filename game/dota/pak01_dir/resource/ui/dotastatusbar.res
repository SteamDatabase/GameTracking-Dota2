"Resource/UI/DOTAStatusBar.res"
{
	controls
	{
		"StatusBar"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"StatusBar"
			"xpos"			"0"
			"ypos"			"64"
			"wide"	 		"f0"
			"tall"	 		"33"
			"zpos"			"11"
			style=StatusBarBGStyle
			visible=1
		}
		
		"StatusLabel" { ControlName=Label fieldName=StatusLabel xpos=0 ypos=0 wide=f0 tall=36 textAlignment="center" zpos=2 visible=1 style=StatusBarTextStyle }
		
		//"WellBG" { ControlName=ImagePanel fieldName=WellBG xpos=c-250 ypos=4 wide=500 tall=25 scaleImage=1 image="dashboard/dash_status_well" }
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
