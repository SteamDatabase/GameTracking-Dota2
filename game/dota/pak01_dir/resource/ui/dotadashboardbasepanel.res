"Resource/UI/DOTADashboardBasePanel.res"
{
	controls
	{
		"DOTADashboardBasePanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTADashboardBasePanel"
			"visible" 		"1"
			"enabled" 		"1"
			"xpos"			"0"
			"ypos"			"0"
			"wide"	 		"f0"
			"tall"	 		"f0"
			"PaintBackground"	"0"
		}
		
		BlackBackground { ControlName=ImagePanel fieldName=BlackBackground xpos=0 ypos=0 zpos=0 wide=f0 tall=f0 zpos=-1 scaleImage=1 fillcolor="0 0 0 255" }
		
		"Background" { ControlName=Label fieldName=Background xpos="c-480" ypos=0 zpos=0 wide=960 tall="f0" style=GradientBackground visible=0 }
		
		"Illustration"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"Illustration"
			"zpos"				"1"
			"scaleImage"		"1"
			"image"				"materials/vgui/dashboard/background.vmat"
			"visible"			"1"
		}
				
		TopBlackGradient { ControlName=Panel fieldName=TopBlackGradient xpos=0 ypos=96 zpos=2 wide="f0" tall="50" style=BlackToTransGradient }
		LowerBlackGradient { ControlName=Panel fieldName=LowerBlackGradient xpos=0 ypos=463 zpos=2 wide="f0" tall="50" style=TransToBlackGradient visible=1 }
		LowerBlackShortGradient { ControlName=Panel fieldName=LowerBlackGradient xpos=0 ypos=r261 zpos=2 wide="f0" tall="5" style=TransToBlackGradient zpos=50 }
		LowerBlackBackground { ControlName=Panel fieldName=LowerBlackBackground xpos=0 ypos=r256 zpos=2 wide="f0" tall="256" style=BlackFilledBackground visible=1 }
		
		"TopBar" { ControlName=Panel fieldName=TopBar xpos=0 ypos=0 zpos=2 wide="f0" tall="64" style=BlackSquareBackground }
		"TopBarLeft" { ControlName=CDOTAWindowDraggingPanel fieldName=TopBarLeft xpos=0 ypos=0 zpos=3 tall="64" style=GreyNoiseBackground }
		"TopBarRight" { ControlName=CDOTAWindowDraggingPanel fieldName=TopBarRight ypos=0 zpos=3 tall="64" style=GreyNoiseBackground }

		QuitButton { ControlName=Button fieldName=QuitButton zpos=4 textAlignment=center auto_wide_to_contents=1 command=QuitButton xpos=r64 ypos=10 wide=64 tall=32 labelText="" style=QuitButtonStyle }
		MaximizeButton { ControlName=Button fieldName=MaximizeButton zpos=4 textAlignment=center auto_wide_to_contents=1 command=MaximizeButton xpos=r64 ypos=26 wide=64 tall=32 labelText="" style=MaximizeButtonStyle }
		SettingsButton { ControlName=Button fieldName=SettingsButton zpos=4 textAlignment=center auto_wide_to_contents=1 command=SettingsButton xpos=r120 ypos=2 wide=64 tall=64 labelText="" style=SettingsButtonStyle }
				
		// TODO: Localize
		SectionButton0 { ControlName=CDOTADashboardSectionButton fieldName=SectionButton0 zpos=4 wide=128 tall=64 textAlignment=center command=ShowSection_0 labelText="TODAY" style=DashboardSectionButton minimum-height=64 minimum-width=128 }
		SectionButton1 { ControlName=CDOTADashboardSectionButton fieldName=SectionButton1 zpos=4 wide=128 tall=64 textAlignment=center command=ShowSection_1 labelText="PLAY" style=DashboardSectionButton minimum-height=64 minimum-width=128 }
		SectionButton2 { ControlName=CDOTADashboardSectionButton fieldName=SectionButton2 zpos=4 wide=128 tall=64 textAlignment=center command=ShowSection_2 labelText="SOCIALIZE" style=DashboardSectionButton minimum-height=64 minimum-width=128 }
		SectionButton3 { ControlName=CDOTADashboardSectionButton fieldName=SectionButton3 zpos=4 wide=128 tall=64 textAlignment=center command=ShowSection_3 labelText="WATCH" style=DashboardSectionButton minimum-height=64 minimum-width=128 }
		SectionButton4 { ControlName=CDOTADashboardSectionButton fieldName=SectionButton4 zpos=4 wide=128 tall=64 textAlignment=center command=ShowSection_4 labelText="LEARN" style=DashboardSectionButton minimum-height=64 minimum-width=128 }
		
		//"DOTADashboardTabRow" { ControlName=Panel fieldName=DOTADashboardTabRow xpos="c-288" ypos=32 wide=568 tall=40 zpos=10 bgcolor_override="0 0 0 0" }
	}
	
	include="resource/UI/dashboard_style.res"
	
	colors
	{
		"DashboardGradientTop"		"50 50 50 255"
		"DashboardGradientBottom"	"0 0 0 255"
		"TopBarButtonLight"			"140 140 140 255"
		"TopBarBG"					"50 50 50 255"
		"SectionButtonText"			"207 207 207 255"
		"SectionButtonBG"			"68 68 68 255"
		"SectionButtonBGOver"		"49 49 49 255"
		"black" "0 0 0 255"
		"transblack" "0 0 0 200"
		"invis" "0 0 0 0"
	}
	
	styles
	{
		BlackFilledBackground
		{
			render_bg
			{
				0="fill(x0,y0,x1,y1,black)"
			}
		}
		GradientBackground
		{
			render_bg
			{
				// background fill
				0="gradient( x0, y0, x1, y1, DashboardGradientTop, DashboardGradientBottom )"
			}
		}
		TransToBlackGradient
		{
			render_bg
			{
				// background fill
				0="gradient( x0, y0, x1, y1, invis, transblack )"
			}
		}
		BlackToTransGradient
		{
			render_bg
			{
				// background fill
				0="gradient( x0, y0, x1, y1, transblack, invis )"
			}
		}
		TopBarButton
		{
			textcolor=TopBarButtonLight
			font=DefaultLarge
			
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		TopBarButton:hover
		{
			textcolor=TopBarBG
			font=DefaultLarge
			
			bgcolor=TopBarButtonLight		
		}
		
		TopBarButton:active
		{
			textcolor=white
			font=DefaultLarge
			
			bgcolor=TopBarButtonLight			
		}
		
		QuitButtonStyle
		{
			bgcolor=none
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_button_quit_normal.vmat )"
			}
		}
		QuitButtonStyle:hover
		{
			bgcolor=none
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_button_quit_over.vmat )"
			}	
		}
		
		QuitButtonStyle:active
		{
			bgcolor=none
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_button_quit_down.vmat )"
			}		
		}
		
		SettingsButtonStyle
		{
			bgcolor=none
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_button_settings_normal.vmat )"
			}
		}
		SettingsButtonStyle:hover
		{
			bgcolor=none
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_button_settings_over.vmat )"
			}	
		}
		SettingsButtonStyle:active
		{
			bgcolor=none
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_button_settings_down.vmat )"
			}		
		}
		
		MaximizeButtonStyle
		{
			bgcolor=none
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_button_window_normal.vmat )"
			}
		}
		MaximizeButtonStyle:hover
		{
			bgcolor=none
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_button_window_over.vmat )"
			}	
		}
		MaximizeButtonStyle:active
		{
			bgcolor=none
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_button_window_down.vmat )"
			}		
		}
		
		
		DashboardSectionButton
		{
			textcolor=SectionButtonText
			font=DefaultLarge
			
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_tab_normal.vmat )"
			}
		}
		DashboardSectionButton:hover
		{
			textcolor=SectionButtonText
			font=DefaultLarge
			
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_tab_hover.vmat )"
			}
		}
		
		DashboardSectionButton:selected
		{
			textcolor=SectionButtonText
			font=DefaultLarge
			
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_tab_selected.vmat )"
			}		
		}
		
		DashboardSectionButton:active
		{
			textcolor=SectionButtonText
			font=DefaultLarge
			
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_tab_flash.vmat )"
			}			
		}
		
		TopBarTitleStyle
		{
			textcolor=TopBarButtonLight			
			font=Arial14Thick
		}
	}		
	
	layout
	{
	}
}
