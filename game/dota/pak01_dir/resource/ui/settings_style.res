"Resource/UI/settings_style.res"
{
	"colors"
	{
		SectionTitleColor="200 200 200 255"
		StatLabelColor="255 255 255 255"
		SettingsTitleColor="255 255 255 255"
		"MenuButtonBlue"		"126 176 214 255"
		"MenuBackgroundGrey"	"46 43 39 255"
		CenterPanelGradientTop="0 0 0 255"
		CenterPanelGradientBottom="19 19 19 255"
		TabButtonTextSelected="172 172 172 255"
		TabButtonBgSelected="46 46 46 255"
		TabButtonText="103 103 103 255"
		TabButtonBg="33 33 33 255"
		RoundedButtonBG="46 43 39 255"
		"ProfileGradientTop"		"68 68 68 255"
		"ProfileGradientBottom"		"55 55 55 255"
		SettingsInnerBGColor="49 49 49 255"
		SettingsInnerBGBorder="20 20 20 255"
	}
	"styles"
	{
		"StatLabel"
		{
			textcolor=StatLabelColor
			font=Arial12Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		"SettingsTitle"
		{
			textcolor=SettingsTitleColor
			font=Arial18Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		"Header"
		{
			font=Arial14Thick
			textcolor=white
			bgcolor=none
			
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		"SectionTitle"
		{
			textcolor=SectionTitleColor
			font=Arial12Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		SettingsInnerBackground
		{
			render_bg
			{
				0="roundedfill( x0, y0, x1, y1, 6, SettingsInnerBGBorder )"
				1="roundedfill( x0+1, y0+1, x1-1, y1-1, 6, SettingsInnerBGColor )"
			}
		}
		Button
		{
			textcolor=MenuButtonBlue
			font=Arial14Thick
			
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		Button:hover
		{
			textcolor=MenuBackgroundGrey
			font=Arial14Thick
			
			bgcolor=MenuButtonBlue		
		}
		
		Button:active
		{
			textcolor=white
			font=Arial14Thick
			
			bgcolor=MenuButtonBlue			
		}
		// ==
		SmallButton
		{
			textcolor=MenuButtonBlue
			font=Arial12Thick
			
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		SmallButton:hover
		{
			textcolor=MenuBackgroundGrey
			font=Arial12Thick
			
			bgcolor=MenuButtonBlue		
		}
		
		SmallButton:active
		{
			textcolor=white
			font=Arial12Thick
			
			bgcolor=MenuButtonBlue			
		}
		
		RoundedButton
		{
			textcolor=MenuButtonBlue
			font=Arial14Thick
			
			render_bg
			{
				0="roundedfill( x0, y0, x1, y1, 6, RoundedButtonBG )"
			}
		}
		RoundedButton:hover
		{
			textcolor=MenuBackgroundGrey
			font=Arial14Thick
			bgcolor=none
			
			render_bg
			{
				0="roundedfill( x0, y0, x1, y1, 6, MenuButtonBlue )"
			}	
		}
		RoundedButton:active
		{
			textcolor=white
			font=Arial14Thick
			bgcolor=none
			
			render_bg
			{
				0="roundedfill( x0, y0, x1, y1, 6, MenuButtonBlue )"
			}			
		}
		
		CenterPanelGradient
		{
			render_bg
			{
				// background fill
				0="gradient( x0, y0, x1, y1, CenterPanelGradientTop, CenterPanelGradientBottom )"
			}
		}
		// ==
		TabButton
		{
			textcolor=TabButtonText
			font=Arial12Thick
			
			render_bg
			{
				0="fill(x0,y0,x1,y1,TabButtonBg)"
			}
		}
		TabButton:hover
		{
			textcolor=TabButtonTextSelected
			font=Arial12Thick
			
			bgcolor=TabButtonBgSelected		
		}
		
		TabButton:active
		{
			textcolor=TabButtonTextSelected
			font=Arial12Thick
			
			bgcolor=TabButtonBgSelected			
		}
		TabBarBackground
		{
			bgcolor=TabButtonBgSelected	
		}
		
		ScrollBarButton.up
		{
			font=Marlett
			textcolor=none
			bgcolor=none
			inset="-1 2 0 0"
			//image="graphics/icon_up_default"
			render_bg
			{
				// background fill
				0="fill( x0 + 2, y0 + 3, x1 - 4, y1 + 2, buttonface )"
						
				// lines around
				1="fill( x0 + 3, y0 + 2, x1 - 5, y0 + 3, ButtonFace )"  // top
				2="fill( x0 + 3, y1 + 2, x1 - 5, y1 + 3, ButtonFace )"  // bottom
			}			
		}
	    
		ScrollBarButton.up:hover
		{
			font=Marlett
			bgcolor=red
			inset="-1 2 0 0"
			//image="graphics/icon_up_hover"
			render_bg
			{
				// background fill
				0="fill( x0 + 2, y0 + 3, x1 - 4, y1 + 2, buttonfaceActive )"
						
				// lines around
				1="fill( x0 + 3, y0 + 2, x1 - 5, y0 + 3, ButtonFaceActive )"  // top
				2="fill( x0 + 3, y1 + 2, x1 - 5, y1 + 3, ButtonFaceActive )"  // bottom
			}
		}
	    
		ScrollBarButton.up:active
		{
			font=Marlett
			inset="-1 2 0 0"
			//image="graphics/icon_up_hover"
			render_bg
			{
				// background fill
				0="fill( x0 + 2, y0 + 3, x1 - 4, y1 + 2, buttonfaceActive )"
						
				// lines around
				1="fill( x0 + 3, y0 + 2, x1 - 5, y0 + 3, ButtonFaceActive )"  // top
				2="fill( x0 + 3, y1 + 2, x1 - 5, y1 + 3, ButtonFaceActive )"  // bottom
			}
		}
		
		ScrollBarButton.down
		{
			font=Marlett
			textcolor=none
			bgcolor=none
			inset="-2 0 0 0"
			//image="graphics/icon_down_default"
			render_bg
			{
				// background fill
				0="fill( x0 + 2, y0 - 1, x1 - 4, y1 - 3, buttonface )"
						
				// lines around
				1="fill( x0 + 3, y0 - 2, x1 - 5, y0 - 1, buttonface )"  // top
				2="fill( x0 + 3, y1 - 3, x1 - 5, y1 - 2, buttonface )"  // bottom
			}
		}
	    
		ScrollBarButton.down:hover
		{
			font=Marlett
			inset="-2 0 0 0"
			//image="graphics/icon_down_hover"
			render_bg
			{
				// background fill
				0="fill( x0 + 2, y0 - 1, x1 - 4, y1 - 3, buttonfaceActive )"
						
				// lines around
				1="fill( x0 + 3, y0 - 2, x1 - 5, y0 - 1, buttonfaceActive )"  // top
				2="fill( x0 + 3, y1 - 3, x1 - 5, y1 - 2, buttonfaceActive )"  // bottom
			}
		}
    
        ScrollBarButton.down:active
		{
			font=Marlett
			inset="-2 0 0 0"
			//image="graphics/icon_down_hover"
			render_bg
			{
				// background fill
				0="fill( x0 + 2, y0 - 1, x1 - 4, y1 - 3, buttonfaceActive )"
						
				// lines around
				1="fill( x0 + 3, y0 - 2, x1 - 5, y0 - 1, buttonfaceActive )"  // top
				2="fill( x0 + 3, y1 - 3, x1 - 5, y1 - 2, buttonfaceActive )"  // bottom
			}
		}
		
		ScrollBarButton.left
		{
			font=Marlett
			textcolor=none
			bgcolor=none
			inset="1 3 0 0"
			//image="graphics/icon_left_default"
			render_bg 
			{
				// center fill
				0="fill( x0 + 2, y0 + 5, x1, y1 - 3, ButtonFace )"
				
				// lines around
				1="fill( x0 + 3, y0 + 4, x1 - 1, y0 + 5, buttonface )"  // top
				2="fill( x0 + 3, y1 - 3, x1 - 1, y1 - 2, buttonface )"  // bottom
        		}
		}
	    
		ScrollBarButton.left:hover
		{
			font=Marlett
			//image="graphics/icon_left_hover"
			inset="1 3 0 0"
			render_bg 
			{
				// center fill
				0="fill( x0 + 2, y0 + 5, x1, y1 - 3, ButtonFaceActive )"
				
				// lines around
				1="fill( x0 + 3, y0 + 4, x1 - 1, y0 + 5, ButtonFaceActive )"  // top
				2="fill( x0 + 3, y1 - 3, x1 - 1, y1 - 2, ButtonFaceActive )"  // bottom
        		}
		}
	        
		ScrollBarButton.right
		{
			font=Marlett
			textcolor=none
			bgcolor=none
			//image="graphics/icon_right_default"
			inset="0 2 0 0"
			render_bg 
			{
				// center fill
				0="fill( x0, y0 + 5, x1, y1 - 3, ButtonFace )"
				
				// lines around
				1="fill( x0 + 1, y0 + 4, x1 - 2, y0 + 5, ButtonFace )"  // top
				2="fill( x0 + 1, y1 - 3, x1 - 2, y1 - 2, ButtonFace )"  // bottom
			}
		}
	        
		ScrollBarButton.right:hover
		{
			font=Marlett
			//image="graphics/icon_right_hover"
			inset="0 2 0 0"
			render_bg 
			{
				// center fill
				0="fill( x0, y0 + 5, x1, y1 - 3, ButtonFaceActive )"
				
				// lines around
				1="fill( x0 + 1, y0 + 4, x1 - 2, y0 + 5, ButtonFaceActive )"  // top
				2="fill( x0 + 1, y1 - 3, x1 - 2, y1 - 2, ButtonFaceActive )"  // bottom
			}
		}
		
		ProfileGradientBackground
		{
			render_bg
			{
				// background fill
				0="gradient( x0, y0, x1, y1, ProfileGradientTop, ProfileGradientBottom )"
			}
		}
		
		GreyNoiseBackground
		{
			render_bg
			{
				0="image_tiled( x0, y0, x1, y1, materials/vgui/dashboard/dash_background_generic_tiler.vmat )"
			}
		}
		
		RedBackground
		{
			bgcolor="255 0 0 255"
		}		
	}
}
