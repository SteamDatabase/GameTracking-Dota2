"Resource/UI/DOTASettingsPanel.res"
{
	controls
	{
		"DOTASettingsPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTASettingsPanel"
			"xpos"				"0"
			"ypos"				"64"
			"zpos"				"60"
			"wide"	 			"f0"
			"tall"	 			"800"
			"style"				"BlackFilledBackground"
		}
		
//		BlackBackground { ControlName=ImagePanel fieldName=BlackBackground xpos=0 ypos=0 zpos=0 wide=f0 tall=800 zpos=-1 scaleImage=1 fillcolor="0 0 0 255" }
//		"Background" { ControlName=Label fieldName=Background xpos="c-480" ypos=0 zpos=0 wide=960 tall=800 style=GradientBackground visible=0 }
		
		"SettingsBackgroundImage"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"SettingsBackgroundImage"
			"zpos"				"1"
			"scaleImage"		"1"
			"image"				"materials/vgui/dashboard/background.vmat"
			"visible"			"0"
		}
						
		"SettingsTopBarLeft" { ControlName=Panel fieldName=SettingsTopBarLeft xpos=0 ypos=64 zpos=1 tall=32 style=GreyNoiseBackground }
		"SettingsTopBarRight" { ControlName=Panel fieldName=SettingsTopBarRight ypos=64 zpos=1 tall=32 style=GreyNoiseBackground }
				
		// TODO: Localize
		SettingsSectionButton0 { ControlName=CDOTASettingsSectionButton fieldName=SettingsSectionButton0 zpos=2 wide=128 tall=32 textAlignment=center command=ShowSettingsSection_0 labelText="KEYBOARD" style=SettingsSectionButton minimum-height=32 minimum-width=128 }
		SettingsSectionButton1 { ControlName=CDOTASettingsSectionButton fieldName=SettingsSectionButton1 zpos=2 wide=128 tall=32 textAlignment=center command=ShowSettingsSection_1 labelText="MOUSE" style=SettingsSectionButton minimum-height=32 minimum-width=128 }
		SettingsSectionButton2 { ControlName=CDOTASettingsSectionButton fieldName=SettingsSectionButton2 zpos=2 wide=128 tall=32 textAlignment=center command=ShowSettingsSection_2 labelText="VIDEO" style=SettingsSectionButton minimum-height=32 minimum-width=128 }
		SettingsSectionButton3 { ControlName=CDOTASettingsSectionButton fieldName=SettingsSectionButton3 zpos=2 wide=128 tall=32 textAlignment=center command=ShowSettingsSection_3 labelText="AUDIO" style=SettingsSectionButton minimum-height=32 minimum-width=128 }
		SettingsSectionButton4 { ControlName=CDOTASettingsSectionButton fieldName=SettingsSectionButton4 zpos=2 wide=128 tall=32 textAlignment=center command=ShowSettingsSection_4 labelText="VOICE" style=SettingsSectionButton minimum-height=32 minimum-width=128 }
		SettingsSectionButton5 { ControlName=CDOTASettingsSectionButton fieldName=SettingsSectionButton5 zpos=2 wide=128 tall=32 textAlignment=center command=ShowSettingsSection_5 labelText="GAME" style=SettingsSectionButton minimum-height=32 minimum-width=128 }
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
		
		
		SettingsSectionButton
		{
			textcolor=SectionButtonText
			font=Arial14Med
			
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_tab_normal.vmat )"
			}
		}
		SettingsSectionButton:hover
		{
			textcolor=SectionButtonText
			font=Arial14Med
			
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_tab_hover.vmat )"
			}
		}
		
		SettingsSectionButton:selected
		{
			textcolor=SectionButtonText
			font=Arial14Med
			
			render_bg
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_tab_selected.vmat )"
			}		
		}
		
		SettingsSectionButton:active
		{
			textcolor=SectionButtonText
			font=Arial14Med
			
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
