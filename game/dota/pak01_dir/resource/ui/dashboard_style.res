"Resource/UI/dashboard_style.res"
{
	"colors"
	{
		White172="172 172 172 255"
		dullwhite="205 205 205 255"
		SectionTitleColor="200 200 200 255"
		StatLabelColor="255 255 255 255"
		MinorStatLabelColor="128 128 128 255"
		DashboardTitleColor="255 255 255 255"
		white="255 255 255 255"
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
		DashboardInnerBGColor="49 49 49 255"
		DashboardInnerBGBorder="20 20 20 255"
		ButtonBorder="112 109 105 255"
		ButtonBorderFocus="153 147 141 255"
		ButtonFace2="92 89 86 255" // for use in main client list panel column header, some button states
		Invisible="0 0 0 0"
	}
	"styles"
	{
		"SmallLabel"
		{
			textcolor=StatLabelColor
			font=Arial10Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		"StatLabel"
		{
			textcolor=StatLabelColor
			font=Arial12Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		"MinorStatLabel"
		{
			textcolor=MinorStatLabelColor
			font=Arial12Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		"DashboardTitle"
		{
			textcolor=DashboardTitleColor
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
		"StandardText"
		{
			textcolor=white
			font=Arial14Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		DashboardInnerBackground
		{
			render_bg
			{
				0="roundedfill( x0, y0, x1, y1, 6, DashboardInnerBGBorder )"
				1="roundedfill( x0+1, y0+1, x1-1, y1-1, 6, DashboardInnerBGColor )"
			}
		}
		DashboardPlayInnerBackground
		{
			render_bg
			{
				//1="roundedfill( x0, y0, x1, y1, 6, DashboardInnerBGBorder )"
				//2="roundedfill( x0+1, y0+1, x1-1, y1-1, 6, DashboardInnerBGColor )"
				0="image_scalable( x0, y0, x1, y1, materials/vgui/dashboard/dash_background_generic_inset_magic.vmat, 16, 16, 16, 16, 1, 1 )"
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
		
		PartySlotStyle
		{
			render_bg
			{
				0="image_scale( x0, y0, x1, y1, materials/vgui/dashboard/dash_drop_well.vmat )"
				//0="roundedfill( x0, y0, x1, y1, 6, White172 )"
			}
		}
		
		GreyButtonStyle				{ font=Arial18Thick textcolor=dullwhite bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_ancillary_bg.vmat)"	}	}
		GreyButtonStyle:hover		{ font=Arial18Thick textcolor=white bgcolor=none render_bg		{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_ancillary_bg.vmat)"	}	}
		GreyButtonStyle:active		{ font=Arial18Thick textcolor=dullwhite bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_ancillary_bg.vmat)"	}	}
		
		GreyButton14Style				{ font=Arial14Thick textcolor=dullwhite bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_ancillary_bg.vmat)"	}	}
		GreyButton14Style:hover		{ font=Arial14Thick textcolor=white bgcolor=none render_bg		{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_ancillary_bg.vmat)"	}	}
		GreyButton14Style:active		{ font=Arial14Thick textcolor=dullwhite bgcolor=none render_bg	{ 0="image_scale(x0,y0,x1,y1,materials/vgui/dashboard/dash_button_ancillary_bg.vmat)"	}	}
		
		CheckButtonStyle				{ font=Arial14Thick textcolor=dullwhite bgcolor=none render_bg=none	}
		CheckButtonStyle:hover		{ font=Arial14Thick textcolor=white bgcolor=none render_bg=none	}
		CheckButtonStyle:active		{ font=Arial14Thick textcolor=dullwhite bgcolor=none render_bg=none	}
		
		InvisibleButtonStyle			{ font=Arial14Thick textcolor=Invisible bgcolor=Invisible render_bg	{ 0="fill( x0, y0, x1, y1, Invisible )"	}	}
		InvisibleButtonStyle:hover		{ font=Arial14Thick textcolor=Invisible bgcolor=Invisible render_bg	{ 0="fill( x0, y0, x1, y1, Invisible )"	}	}
		InvisibleButtonStyle:active		{ font=Arial14Thick textcolor=Invisible bgcolor=Invisible render_bg	{ 0="fill( x0, y0, x1, y1, Invisible )"	}	}
		
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
			textcolor=none
			bgcolor=none
			render_bg
			{
				1="image_scale( x0, y0, x1, y1, materials/vgui/scroll_up.vmat )"
			}	
		}
	    
		ScrollBarButton.up:hover
		{
			bgcolor=none
			render_bg
			{
				1="image_scale( x0, y0, x1, y1, materials/vgui/scroll_up.vmat )"
			}
		}
	    
		ScrollBarButton.up:active
		{
			bgcolor=none
			render_bg
			{
				1="image_scale( x0, y0, x1, y1, materials/vgui/scroll_up.vmat )"
			}
		}
		
		ScrollBarButton.down
		{
			textcolor=none
			render_bg
			{
				1="image_scale( x0, y0, x1, y1, materials/vgui/scroll_down.vmat )"
			}
		}
	    
		ScrollBarButton.down:hover
		{
			render_bg
			{
				1="image_scale( x0, y0, x1, y1, materials/vgui/scroll_down.vmat )"
			}
		}
    
        ScrollBarButton.down:active
		{
			render_bg
			{
				1="image_scale( x0, y0, x1, y1, materials/vgui/scroll_down.vmat )"
			}
		}
		
		ScrollBarButton.left
		{
			textcolor=none
			bgcolor=none
			render_bg
			{
				1="image_scale( x0, y0, x1, y1, materials/vgui/scroll_up.vmat )"
			}
		}
	    
		ScrollBarButton.left:hover
		{
			textcolor=none
			bgcolor=none
			render_bg
			{
				1="image_scale( x0, y0, x1, y1, materials/vgui/scroll_up.vmat )"
			}
		}
	        
		ScrollBarButton.right
		{
			textcolor=none
			bgcolor=none
			render_bg
			{
				1="image_scale( x0, y0, x1, y1, materials/vgui/scroll_down.vmat )"
			}
		}
	        
		ScrollBarButton.right:hover
		{
			textcolor=none
			bgcolor=none
			render_bg
			{
				1="image_scale( x0, y0, x1, y1, materials/vgui/scroll_down.vmat )"
			}
		}
		
		ScrollBarHandle  //vertical scrollbar thumb
		{
			bgcolor="none"
			render_bg
			{
				1="image_scalable( x0, y0, x1, y1, materials/vgui/scroll_box.vmat, 0, 16, 0, 6, 1, 1 )"
			}
		}
	       
		"ScrollBarHandle:hover"
		{
			bgcolor="none"
			render_bg
			{
				1="image_scalable( x0, y0, x1, y1, materials/vgui/scroll_box.vmat, 0, 16, 0, 6, 1, 1 )"
			}
		}
	    
		"ScrollBarHandle:active"
		{
			bgcolor="none"
			render_bg
			{
				1="image_scalable( x0, y0, x1, y1, materials/vgui/scroll_box.vmat, 0, 16, 0, 6, 1, 1 )"
			}
		}
		
		ScrollBarSlider // gutter
		{
			bgcolor="none"
			render_bg
			{
				1="image_scale( x0, y0, x1, y1, materials/vgui/scroll_line.vmat )"
			}
		}
		
		ScrollBarSliderHoriz // gutter
		{
			bgcolor="none"
			render_bg
			{
				1="image_scale( x0, y0, x1, y1, materials/vgui/scroll_line.vmat )"
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
		
		ComboBox
		{
			inset="3 0 0 0"
			textcolor="Text"
			font=Arial14Thick
			selectedtextcolor="TextEntrySelected"
			selectedbgcolor="TextSelectedBG"
			render_bg
			{     
				0="image_scalable( x0, y0, x1, y1, materials/vgui/dashboard/dash_button_drop_bg.vmat, 8, 8, 8, 8, 1, 1 )"
			}
		}
	    
		ComboBox:hover
		{
			selectedbgcolor="none"
			selectedtextcolor="Text"
			render_bg
			{     
				0="image_scalable( x0, y0, x1, y1, materials/vgui/dashboard/dash_button_drop_bg.vmat, 8, 8, 8, 8, 1, 1 )"
			}
		}
	    
		ComboBox:focus
		{
			selectedbgcolor="none"
			selectedtextcolor="Text"
			render_bg
			{     
				0="image_scalable( x0, y0, x1, y1, materials/vgui/dashboard/dash_button_drop_bg.vmat, 8, 8, 8, 8, 1, 1 )"
			}
		}
		    
		ComboBox:focus:hover
		{
			selectedbgcolor="none"
			selectedtextcolor="Text"
			render_bg
			{     
				0="image_scalable( x0, y0, x1, y1, materials/vgui/dashboard/dash_button_drop_bg.vmat, 8, 8, 8, 8, 1, 1 )"
			}
		}
		
		ComboBoxButton
		{
			bgcolor=none
			textcolor=none
			padding-left=0
			padding-right=8
			image="dashboard/dash_button_drop_glyph_arrow"
			
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}

		ComboBoxButton:hover
		{
			bgcolor=none
			textcolor=none
			image="dashboard/dash_button_drop_glyph_arrow"
		}
		
		ComboBoxButton:active
		{
			bgcolor=none
			textcolor=none
			image="dashboard/dash_button_drop_glyph_arrow"
		}

		ComboBoxButton:focus
		{
			bgcolor=none
			textcolor=none
			image="dashboard/dash_button_drop_glyph_arrow"
		}

		ComboBoxButton:focus:hover
		{
			bgcolor=none
			textcolor=none
			image="dashboard/dash_button_drop_glyph_arrow"
		}
		
		MenuItem
		{
			textcolor=white172
			font=Arial14Thick
			bgcolor=none
		}

		MenuItem:hover
		{
			textcolor=white
			font=Arial14Thick
			bgcolor=LighterGrey
		}

		MenuItem:disabled
		{
			textcolor=LighterGrey
			font=Arial14Thick
		}

		MenuItem:disabled:hover
		{
			textcolor=white
			font=Arial14Thick
		}
	}
}
