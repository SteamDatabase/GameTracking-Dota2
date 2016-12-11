"Resource/EarlyQuitContainer.res"
{
	controls
	{
		"EarlyQuitContainer"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"EarlyQuitContainer"
			"visible" 		"1"
			"enabled" 		"1"
			"xpos"			"0"
			"ypos"			"0"
			"wide"	 		"f0"
			"tall"	 		"f0"
			"PaintBackground"	"1"
			"zpos" "255"
		}

		QuitButton { ControlName=Button fieldName=QuitButton zpos=4 textAlignment=center auto_wide_to_contents=1 command=QuitButton xpos=r29 ypos=2 wide=28 tall=28 labelText="" style=QuitButtonStyle }
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
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/early_quit_button.vmat )"
			}
		}
		QuitButtonStyle:hover
		{
			bgcolor=none
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/early_quit_button_over.vmat )"
			}	
		}
		
		QuitButtonStyle:active
		{
			bgcolor=none
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/early_quit_button.vmat )"
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
