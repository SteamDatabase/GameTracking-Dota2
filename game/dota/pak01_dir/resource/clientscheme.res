///////////////////////////////////////////////////////////
// Tracker scheme resource file
//
// sections:
//		Colors			- all the colors used by the scheme
//		BaseSettings	- contains settings for app to use to draw controls
//		Fonts			- list of all the fonts used by app
//		Borders			- description of all the borders
//
///////////////////////////////////////////////////////////
Scheme
{
	"proportional_base"		"768"
	"uses_appearances"		"1"
	
	//////////////////////// COLORS ///////////////////////////
	// color details
	// this is a list of all the colors used by the scheme
	Colors
	{
		"White"				"255 255 255 255"
		"OffWhite"			"216 216 216 255"
		"DullWhite"			"142 142 142 255"
		"Orange"			"255 155 0 255"
		"Transparent"		"0 0 0 0"
		"TransparentBlack"	"0 0 0 128"
		"Black"				"0 0 0 255"
		"Cyan"				"0 255 255 255"
		"PickGreen"			"0 205 0 255"
		
		"DarkGrey"			"40 40 40 255"
		
		"ScrollBarGrey"		"51 51 51 255"
		"ScrollBarHilight"	"110 110 110 255"
		"ScrollBarDark"		"38 38 38 255"	
		
		"HeroDetails.LightBG"	"82 82 82 355"
		"HeroDetails.MediumBG"	"46 43 39 355"
		"HeroDetails.DarkBG"	"38 34 33 355"
	}
	
	///////////////////// BASE SETTINGS ////////////////////////
	//
	// default settings for all panels
	// controls use these to determine their settings
	BaseSettings
	{
		"FgColor"			"255 220 0 100"
		"BgColor"			"0 0 0 76"

		"Panel.FgColor"			"255 220 0 100"
		"Panel.BgColor"			"0 0 0 76"
		
		"BrightFg"		"255 220 0 255"

		"DamagedBg"			"180 0 0 200"
		"DamagedFg"			"180 0 0 230"
		"BrightDamagedFg"		"255 0 0 255"

		// weapon selection colors
		"SelectionNumberFg"		"255 220 0 255"
		"SelectionTextFg"		"255 220 0 255"
		"SelectionEmptyBoxBg" 	"0 0 0 80"
		"SelectionBoxBg" 		"0 0 0 80"
		"SelectionSelectedBoxBg" "0 0 0 80"
		
		"ZoomReticleColor"	"255 220 0 255"

		// HL1-style HUD colors
		"Yellowish"			"255 160 0 255"
		"Normal"			"255 208 64 255"
		"Caution"			"255 48 0 255"

		// Top-left corner of the "Half-Life 2" on the main screen
		"Main.Title1.X"			"76"
		"Main.Title1.Y"			"200"
		"Main.Title1.Y_hidef"	"184"
		"Main.Title1.Color"	"255 255 255 255"

		// Top-left corner of secondary title e.g. "DEMO" on the main screen
		"Main.Title2.X"				"314"
		"Main.Title2.Y"				"257"
		"Main.Title2.Y_hidef"		"242"
		"Main.Title2.Color"	"255 255 255 200"

		// Top-left corner of the menu on the main screen
		"Main.Menu.X"			"53"
		"Main.Menu.X_hidef"		"76"
		"Main.Menu.Y"			"240"

		// Blank space to leave beneath the menu on the main screen
		"Main.BottomBorder"	"32"

		// kill streak colors
		"DOTA.Streak3Color"	"0 255 64 255"
		"DOTA.Streak4Color"	"64 0 128 255"
		"DOTA.Streak5Color"	"255 0 128 255"
		"DOTA.Streak6Color"	"255 128 0 255"
		"DOTA.Streak7Color"	"128 128 0 255"
		"DOTA.Streak8Color"	"255 128 255 255"
		"DOTA.Streak9Color"	"255 0 0 255"
		"DOTA.Streak10Color"	"255 128 0 255"

		"DOTA.EconItemCommonColor" "200 200 200 255"
		"DOTA.EconItemUncommonColor" "64 128 64 255"
		"DOTA.EconItemRareColor" "0 128 255 255"
		"DOTA.EconItemMythicalColor" "128 0 128 255"
		"DOTA.EconItemLegendaryColor" "255 0 128 255"
		"DOTA.EconItemAncientColor" "255 64 64 255"
		"DOTA.EconItemImmortalColor" "225 188 22 255"
 		"DOTA.EconItemArcanaColor" "173 229 92 255"
		"DOTA.EconItemSeasonalColor" "255 243 79 255"

		"DOTA.ItemColor"	"162 255 100 255"
		"DOTA.RecipeColor"	"87 64 255 255"
		"DOTA.GoldColor"	"225 188 22 255"
		
		"Tooltip.BgColor"	"0 0 0 0"
		"Tooltip.TextColor"	"178 178 178 0"

		"DOTA.PanelBlack"	"0 0 0 255"
		"DOTA.PanelDark"	"36 36 36 255"
		"DOTA.PanelLight"	"51 51 51 255"
		
		// HTML.	
		ScrollBar.Wide						12
		ScrollBar.BgColor	Transparent
	  	ScrollBarNobBorder.Outer 			"ScrollBarDark"
		ScrollBarNobBorder.Inner 			"ScrollBarGrey"
		ScrollBarNobBorderHover.Inner 		"ScrollBarGrey"
		ScrollBarNobBorderDragging.Inner 	"ScrollBarHilight"

		ScrollBarButton.FgColor				"ScrollBarHilight"
		ScrollBarButton.BgColor				"ScrollBarGrey"
		ScrollBarButton.ArmedFgColor		"ScrollBarHilight"
		ScrollBarButton.ArmedBgColor		"ScrollBarGrey"
		ScrollBarButton.DepressedFgColor	"ScrollBarHilight"
		ScrollBarButton.DepressedBgColor	"ScrollBarGrey"

		ScrollBarSlider.Inset				0						// Number of pixels to inset scroll bar nob
		ScrollBarSlider.FgColor				"ScrollBarGrey"			// nob color
		ScrollBarSlider.BgColor				"Transparent"			// slider background color
		ScrollBarSlider.NobFocusColor		"ScrollBarHilight"		// nob mouseover color
		ScrollBarSlider.NobDragColor		"ScrollBarHilight"		// nob active drag color

		// Keybinding.		
		SectionedListPanel.HeaderTextColor				"White"
		SectionedListPanel.HeaderBgColor				"Black"
		SectionedListPanel.DividerColor					"White"
		SectionedListPanel.TextColor					"DullWhite"
		SectionedListPanel.BrightTextColor				"White"
		SectionedListPanel.BgColor						"Black"
		SectionedListPanel.SelectedTextColor			"Black"
		SectionedListPanel.SelectedBgColor				"Cyan"
		SectionedListPanel.OutOfFocusSelectedTextColor	"Black"
		SectionedListPanel.OutOfFocusSelectedBgColor	"Cyan"		
		
		ComboBoxButton.ArrowColor			"DullWhite"
		ComboBoxButton.ArmedArrowColor		"DullWhite"
		ComboBoxButton.DisabledBgColor		"DullWhite"
		ComboBoxButton.BgColor				"DarkGrey"
		ComboBoxButton.DisabledBgColor		"DarkGrey"
		
		Menu.TextColor			"OffWhite"
		Menu.BgColor			"DarkGrey"
		Menu.ArmedTextColor		"Orange"
		Menu.ArmedBgColor		"DarkGrey"
		
		TextEntry.TextColor				"OffWhite"
		TextEntry.BgColor				"DarkGrey"
		TextEntry.CursorColor			"OffWhite"
		TextEntry.DisabledTextColor	"DullWhite"
		TextEntry.DisabledBgColor	"Blank"
		TextEntry.SelectedTextColor		"White"
		TextEntry.SelectedBgColor		"DarkGrey"
		TextEntry.OutOfFocusSelectedBgColor	"255 155 0 128"
		TextEntry.FocusEdgeColor	"0 0 0 196"
		
		CheckButton.BgColor				"DarkGrey"
		CheckButton.Check				"White"
		
		Slider.NobColor					"White"
		Slider.TextColor				"OffWhite"
		Slider.TrackColor				"OffWhite"
		
		ProgressBar.FgColor				"White"
		ProgressBar.BgColor				"DarkGrey"
		
		RichText.TextColor				"OffWhite"
		RichText.BgColor				"TransparentBlack"
		RichText.SelectedTextColor		"Black"
		RichText.SelectedBgColor		"Orange"

	}

	//////////////////////// BITMAP FONT FILES /////////////////////////////
	//
	// Bitmap Fonts are ****VERY*** expensive static memory resources so they are purposely sparse
	BitmapFontFiles
	{
	}

	
	//////////////////////// FONTS /////////////////////////////
	//
	// describes all the fonts
	Fonts
	{	
		"Arial10Fine"  // used by healthbars
		{
			"1"
			{
				"name"		"Arial"
				"tall"		"10"
				"weight"	"400"
				"antialias" "1"
			}
		}
		
		"Arial11Thick"	// used by healthbars
		{
			"1"
			{
				"name"		"Arial"
				"tall"		"11"
				"weight"	"900"
				"antialias" "1"
			}
		}
	
		"DebugFixed"
		{
			"1"
			{
				"name"		"Courier New"
				"tall"		"14"
				"weight"	"400"
				"antialias" "1"
			}
		}
		"DebugFixedSmall"
		{
			"1"
			{
				"name"		"Courier New"
				"tall"		"14"
				"weight"	"400"
				"antialias" "1"
			}
		}
		"DebugStats"
		{
			"1"
			{
				"name"		"Courier New"
				"tall"		"14"
				"weight"	"650"
				"antialias" "1"
				"outline"	"1"
			}
		}
		// fonts listed later in the order will only be used if they fulfill a range not already filled
		// if a font fails to load then the subsequent fonts will replace
		
		DefaultLarge
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"900"
				"antialias" "1"
			}
		}
		DefaultLargeTimer
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"30"
				"weight"	"800"
				"antialias" "1"
			}
		}
		
		Default
		{
			"1"	[$X360]
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"700"
				"antialias" "1"
			}
			"1"	[$WIN32]
			{
				"name"		"Verdana"
				"tall"		"9"
				"weight"	"700"
				"antialias" "1"
				"yres"	"1 599"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"700"
				"antialias" "1"
				"yres"	"600 767"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"14"
				"weight"	"900"
				"antialias" "1"
				"yres"	"768 1023"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"900"
				"antialias" "1"
				"yres"	"1024 1199"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"900"
				"antialias" "1"
				"yres"	"1200 10000"
				"additive"	"1"
			}
		}
		"DefaultSmall"
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"0"
				"range"		"0x0000 0x017F"
				"yres"	"480 599"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"13"
				"weight"	"0"
				"range"		"0x0000 0x017F"
				"yres"	"600 767"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"14"
				"weight"	"0"
				"range"		"0x0000 0x017F"
				"yres"	"768 1023"
				"antialias"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"0"
				"range"		"0x0000 0x017F"
				"yres"	"1024 1199"
				"antialias"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"0"
				"range"		"0x0000 0x017F"
				"yres"	"1200 6000"
				"antialias"	"1"
			}
			"6"
			{
				"name"		"Arial"
				"tall"		"12"
				"range" 		"0x0000 0x00FF"
				"weight"		"0"
			}
		}
		"DefaultVerySmall"
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"	"480 599"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"13"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"	"600 767"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"14"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"	"768 1023"
				"antialias"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"	"1024 1199"
				"antialias"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"		"1200 6000"
				"antialias"	"1"
			}
			"6"
			{
				"name"		"Verdana"
				"tall"		"12"
				"range" 		"0x0000 0x00FF"
				"weight"		"0"
			}
			"7"
			{
				"name"		"Arial"
				"tall"		"11"
				"range" 		"0x0000 0x00FF"
				"weight"		"0"
			}
		}
		
		"DefaultTiny"
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"	"768 1023"
				"antialias"	"1"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"18"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"		"1024 6000"
				"antialias"	"1"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"12"
				"range" 		"0x0000 0x00FF"
				"weight"		"0"
			}
			"4"
			{
				"name"		"Arial"
				"tall"		"11"
				"range" 		"0x0000 0x00FF"
				"weight"		"0"
			}
		}
		
		"DefaultVeryTiny"
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"10"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"	"768 1023"
				"antialias"	"1"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"15"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"		"1024 6000"
				"antialias"	"1"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"12"
				"range" 		"0x0000 0x00FF"
				"weight"		"0"
			}
			"4"
			{
				"name"		"Arial"
				"tall"		"11"
				"range" 		"0x0000 0x00FF"
				"weight"		"0"
			}
		}
		
		DefaultOverHeadInfo
		{
			"1"	[$WIN32]
			{
				"name"		"Verdana"
				"tall"		"9"
				"weight"	"700"
				"antialias" "1"
				"dropshadow"	"1"
				"yres"	"1 599"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"700"
				"antialias" "1"
				"dropshadow"	"1"
				"yres"	"600 767"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"14"
				"weight"	"900"
				"antialias" "1"
				"dropshadow"	"1"
				"yres"	"768 1023"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"900"
				"antialias" "1"
				"dropshadow"	"1"
				"yres"	"1024 1199"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"900"
				"antialias" "1"
				"yres"	"1200 10000"
				"dropshadow"	"1"
			}
		}
		BudgetLabel
		{
			"1"
			{
				"name"		"Courier New"
				"tall"		"22"
				"weight"	"400"
				"outline"	"1"
			}
		}
		DebugOverlay
		{
			"1"	[$WIN32]
			{
				"name"		"Tahoma"
				"tall"		"14"
				"weight"	"400"
				"outline"	"1"
			}
			"1"	[$X360]
			{
				"name"		"Tahoma"
				"tall"		"18"
				"weight"	"200"
				"outline"	"1"
			}
		}
		"CloseCaption_Normal"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"28"
				"weight"	"500"
			}
		}
		"CloseCaption_Italic"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"28"
				"weight"	"500"
				"italic"	"1"
			}
		}
		"CloseCaption_Bold"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"28"
				"weight"	"900"
			}
		}
		"CloseCaption_BoldItalic"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"28"
				"weight"	"900"
				"italic"	"1"
			}
		}
		"CloseCaption_Small"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"14"
				"tall_hidef"	"38"
				"weight"	"900"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
			}
		}
		"CommentaryDefault"
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"900"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"	"480 599"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"13"	[$WIN32]
				"tall"		"20"	[$X360]
				"weight"	"900"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"	"600 767"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"14"
				"weight"	"900"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"	"768 1023"
				"antialias"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"900"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"	"1024 1199"
				"antialias"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"900"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"	"1200 6000"
				"antialias"	"1"
			}
			"6"
			{
				"name"		"Verdana"
				"tall"		"12"
				"range" 		"0x0000 0x00FF"
				"weight"		"900"
			}
			"7"
			{
				"name"		"Arial"
				"tall"		"12"
				"range" 		"0x0000 0x00FF"
				"weight"		"800"
			}			
		}
		
		"UnitInfoHeroNameFont"
		{
			"1"
			{
				"name"		"Dota Hypatia Bold"
				"tall"		"16"
				"weight"	"400"
				"antialias" 	"1"
				"dropshadow"	"1"
			}
		}

		"UnitInfoPlayerLevelFont"
		{
			"1"
			{
				"name"		"Dota Hypatia Bold"
				"tall"		"18"
				"weight"	"400"
				"antialias" 	"1"
				"dropshadow"	"1"
				"isproportional" "0"
			}
		}

		"HypatiaBoldSmall"
		{
			"1"
			{
				"name"		"Dota Hypatia Bold"
				"tall"		"14"
				"weight"	"300"
				"antialias" 	"1"
			}
		}
		"CombatLogFont"
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"12"	[$WIN32]
				"tall"		"15"	[$X360]
				"weight"	"700"
				"yres"		"480 599"
				"dropshadow"	"1"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"14"	[$WIN32]
				"tall"		"17"	[$X360]
				"weight"	"700"
				"yres"		"600 767"
				"dropshadow"	"1"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"15"	[$WIN32]
				"tall"		"18"	[$X360]
				"weight"	"700"
				"yres"		"768 1023"
				"dropshadow"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"17"	[$WIN32]
				"tall"		"20"	[$X360]
				"weight"	"700"
				"yres"		"1024 1199"
				"dropshadow"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"22"	[$WIN32]
				"tall"		"25"	[$X360]
				"weight"	"700"
				"yres"		"1200 10000"
				"dropshadow"	"1"
			}
		}
	}

//
	//////////////////// BORDERS //////////////////////////////
	//
	// describes all the border types
	Borders
	{
		NoBorder
		{
			"inset" "0 0 0 0"
			Left
			{
				"1"
				{
					"color" "Blank"
					"offset" "0 0"
				}
			}

			Right
			{
				"1"
				{
					"color" "Blank"
					"offset" "0 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "Blank"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "Blank"
					"offset" "0 0"
				}
			}
		}
			
		
		ScrollBarButtonBorder
		{
			"inset" "0 0 0 0"
			"backgroundtype" "2"
		}

		ToolTipBorder
		{
			"inset" "0 0 1 1"
			"backgroundtype" "2"
			Left
			{
				"1"
				{
					"color" "Tooltip.TextColor"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "Tooltip.TextColor"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "Tooltip.TextColor"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "Tooltip.TextColor"
					"offset" "0 0"
				}
			}
		}

		ScrollBarButtonDepressedBorder
		{
			"inset" "0 0 0 0"
			"backgroundtype" "2"
		}

		ButtonBorder
		{
			"inset" "0 0 0 0"
			"backgroundtype" "0"
		}

		ButtonHUDBorder
		{
			"inset" "0 0 0 0"
			"backgroundtype" "2"
		}

		// this is the border used for default buttons (the button that gets pressed when you hit enter)
		ButtonKeyFocusBorder
		{
			"inset" "0 0 0 0"
			"backgroundtype" "0"
		}

		ButtonDepressedBorder
		{
			"inset" "0 0 0 0"
			"backgroundtype" "0"
		}

		ComboBoxBorder
		{
			"inset" "0 0 1 1"
			Left
			{
				"1"
				{
					"color" "TanLight"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "TanLight"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "TanLight"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "TanLight"
					"offset" "0 0"
				}
			}
		}
		
//		CrosshatchedBackground
//		{
//			"bordertype"			"image"
//			"backgroundtype"		"2"
//			"image"					"loadout_header"
//			"tiled"					"1"
//		}
		
//		OutlinedGreyBox
//		{
//			"bordertype"			"scalable_image"
//			"backgroundtype"		"2"
//			
//			"image"					"loadout_round_rect_selected"
//			"src_corner_height"		"24"				// pixels inside the image
//			"src_corner_width"		"24"
//			"draw_corner_width"		"11"				// screen size of the corners ( and sides ), proportional
//			"draw_corner_height" 	"11"	
//		}
//		OutlinedDullGreyBox
//		{
//			"bordertype"			"scalable_image"
//			"backgroundtype"		"2"
//			
//			"image"					"loadout_round_rect"
//			"src_corner_height"		"24"				// pixels inside the image
//			"src_corner_width"		"24"
//			"draw_corner_width"		"11"				// screen size of the corners ( and sides ), proportional
//			"draw_corner_height" 	"11"	
//		}
		
	}

	
	//////////////////////// CUSTOM FONT FILES /////////////////////////////
	//
	// specifies all the custom (non-system) font files that need to be loaded to service the above described fonts
	CustomFontFiles
	{
		// NOTE: Each entry must give both a font file and a font name
		// to be compatible with materialsystem2 custom fonts.
		"1"
		{
			"font"		"resource/dotahypatiasansprobold.vfont"
			"name"		"Dota Hypatia Bold"
		}
		"2"
        {
        	"font"		"vgui/fonts/verdana.ttf" [$LINUX]
        	"name"		"Verdana" [$LINUX]
        }
		"3"
        {
        	"font"		"vgui/fonts/arial.ttf" [$OSX||$LINUX]
        	"name"		"Arial" [$OSX||$LINUX]
        }
		"4"
        {
        	"font"		"vgui/fonts/cour.ttf" [$OSX||$LINUX]
        	"name"		"Courier New" [$OSX||$LINUX]
        }
	}
}
