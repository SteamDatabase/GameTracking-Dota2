"Resource/UI/HUD_Shop.res"
{
	"shop"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"shop"
 		"xpos"				"c-450"
 		"ypos"				"40"
		"wide"				"900"
		"tall"				"513"
		"zpos"				"12"
		"visible"			"0"
		"style"				"Background"
		"mouseinputenabled"	"1"
	}
	
	"TopBarBackground"
	{
		"ControlName"		"Panel"
		"wide"				"900"
		"tall"				"76"
		"visible"			"1"
		"style"				"TopBarBackground"
	}
		
	"SideShopButton"
	{
		"ControlName"		"RadioButton"
		"zpos"				"2"
		"wide"				"96"
		"tall"				"36"
		"style"				"ShopSelectorButton"
		"minimum-width"		"96"
		"minimum-height"	"36"
		"textalignment"		"center"
		"labeltext"			"#DOTA_SHOP_NAME_SIDE"
		"tabPosition"		"3"
		"subtabposition"	"1"
	}
		
	"MainShopButton"
	{
		"ControlName"		"RadioButton"
		"zpos"				"2"
		"wide"				"128"
		"tall"				"48"
		"style"				"ShopSelectorButton"
		"minimum-width"		"128"
		"minimum-height"	"48"
		"textalignment"		"center"
		"labeltext"			"#DOTA_SHOP_NAME_BASIC"
		"tabPosition"		"3"
		"subtabposition"	"0"
	}
	
	"SecretShopButton"
	{
		"ControlName"		"RadioButton"
		"zpos"				"2"
		"wide"				"96"
		"tall"				"36"
		"style"				"ShopSelectorButton"
		"minimum-width"		"96"
		"minimum-height"	"36"
		"textalignment"		"center"
		"labeltext"			"#DOTA_SHOP_NAME_SECRET"
		"tabPosition"		"3"
		"subtabposition"	"2"
	}
	
	"SearchTextEntry"
	{
		"ControlName"		"TextEntry"
		"fieldName"			"SearchTextEntry"
		"tall"				"25"
		"wide"				"200"
		"minimum-width"		"200"
		"zpos"				"1"
		"visible"			"1"
		"tabPosition"		"0"
		"textHidden"		"0"
		"editable"			"1"
		"maxchars"			"100"
		"NumericInputOnly"	"0"
		"enabled"			"1"
		"visible"			"1"		
		
		"style"				"SearchText"
			
		"fgcolor_override"	"255 255 255 255"
		"bgcolor_override"	"0 0 0 255"	
	}
	
	SearchOverlayLabel
	{ 
		ControlName=Label
		fieldName=SearchOverlayLabel
		zpos=2
		wide=200
		tall=25
		minimum-width=200
		minimum-height=25
		style=SearchOverlay
		mouseInputEnabled=0
		labelText="#DOTA_Shop_Search_Field_Default"
	}
	
	"ClearSearchButton"
	{
		"ControlName"		"Button"
		"fieldName"			"ClearSearchButton"
		"zpos"				"2"
		"wide"				"14"
		"tall"				"14"
		"tabPosition"		"0"
		"style"				"ClearSearchButton"
		"minimum-height"	"14"
		"minimum-width"		"14"
		"textalignment"		"center"
		"labeltext"			"X"	
		"command"			"clearsearch"
	}
	
	"TagSectionBG"
	{
		"ControlName"			"Panel"
		"zpos"					"1"
		"wide"					"157"
		"tall"					"382"
		"minimum-width"			"157"
		"minimum-height"		"382"
		"visible"				"1"
		"style"					"TagSectionBG"
	}

	"TagSectionHeader"
	{
		"ControlName"			"Label"
		"zpos"					"2"
		"wide"					"122"
		"tall"					"26"
		"minimum-width"			"122"
		"minimum-height"		"26"
		"visible"				"0"
		"textAlignment"			"center"
		"labelText"				"#DOTA_SHOP_FILTERS"
		"style"					"TagsSectionHeader"
	}
	
	"TagsSectionBlocker"
	{
		"ControlName"			"Panel"
		"zpos"					"3"
		"wide"					"157"
		"tall"					"382"
		"minimum-width"			"157"
		"minimum-height"		"382"
		"visible"				"1"
		"style"					"TagSectionBG"
		"mouseinputenabled"		"1"
		"group"					"coverfilters"
	}
	
	"AllTagsButton"
	{
		"ControlName"		"RadioButton"
		"fieldName"			"AllTagsButton"
		"zpos"				"2"
		"wide"				"150"
		"minimum-width"		"150"
		"tall"				"18"
		"minimum-height"	"18"
		"style"				"TagButton"
		"labelText"			"#DOTA_SHOP_TAG_ALL"
		"textalignment"		"west"
		"command"			"alltags"
		"tabposition"		"2"
		"subtabposition"	"0"
	}
	
	"FilterByLabel"
	{
		"ControlName"		"Label"
		"fieldName"			"FilterByLabel"
		"zpos"				"2"
		"wide"				"104"
		"minimum-width"		"104"
		"tall"				"20"
		"minimum-height"	"20"
		"visible"			"1"
		"textAlignment"		"west"
		"labelText"			"#DOTA_SHOP_FILTER_BY"
		"style"				"TagLabel"
	}	
	
	"TagButton1"
	{
		"ControlName"		"RadioButton"
		"fieldName"			"TagButton1"
		"zpos"				"2"
		"wide"				"150"
		"minimum-width"		"150"
		"tall"				"18"
		"minimum-height"	"18"
		"style"				"TagButton"
		"textalignment"		"west"
		"tabposition"		"2"
		"subtabposition"	"1"
		"group"				"filters"
	}
	
	"TagButton2"
	{
		"ControlName"		"RadioButton"
		"fieldName"			"TagButton2"
		"zpos"				"2"
		"wide"				"150"
		"minimum-width"		"150"
		"tall"				"18"
		"minimum-height"	"18"
		"style"				"TagButton"
		"textalignment"		"west"
		"tabposition"		"2"
		"subtabposition"	"2"
	}
	
	"TagButton3"
	{
		"ControlName"		"RadioButton"
		"fieldName"			"TagButton3"
		"zpos"				"2"
		"wide"				"150"
		"minimum-width"		"150"
		"tall"				"18"
		"minimum-height"	"18"
		"style"				"TagButton"
		"textalignment"		"west"
		"tabposition"		"2"
		"subtabposition"	"3"
	}
	
	"TagButton4"
	{
		"ControlName"		"RadioButton"
		"fieldName"			"TagButton4"
		"zpos"				"2"
		"wide"				"150"
		"minimum-width"		"150"
		"tall"				"18"
		"minimum-height"	"18"
		"style"				"TagButton"
		"textalignment"		"west"
		"tabposition"		"2"
		"subtabposition"	"4"
	}
	
	"TagButton5"
	{
		"ControlName"		"RadioButton"
		"fieldName"			"TagButton5"
		"zpos"				"2"
		"wide"				"150"
		"minimum-width"		"150"
		"tall"				"18"
		"minimum-height"	"18"
		"style"				"TagButton"
		"textalignment"		"west"
		"tabposition"		"2"
		"subtabposition"	"5"
	}
		
	"TagButton6"
	{
		"ControlName"		"RadioButton"
		"fieldName"			"TagButton6"
		"zpos"				"2"
		"wide"				"150"
		"minimum-width"		"150"
		"tall"				"18"
		"minimum-height"	"18"
		"style"				"TagButton"
		"textalignment"		"west"
		"tabposition"		"2"
		"subtabposition"	"6"
	}
	
	"TagButton7"
	{
		"ControlName"		"RadioButton"
		"fieldName"			"TagButton7"
		"zpos"				"2"
		"wide"				"150"
		"minimum-width"		"150"
		"tall"				"18"
		"minimum-height"	"18"
		"style"				"TagButton"
		"textalignment"		"west"
		"tabposition"		"2"
		"subtabposition"	"7"
	}
	
	"TagButton8"
	{
		"ControlName"		"RadioButton"
		"fieldName"			"TagButton8"
		"zpos"				"2"
		"wide"				"150"
		"minimum-width"		"150"
		"tall"				"18"
		"minimum-height"	"18"
		"style"				"TagButton"
		"textalignment"		"west"
		"tabposition"		"2"
		"subtabposition"	"8"
	}
	
	"TagButton9"
	{
		"ControlName"		"RadioButton"
		"fieldName"			"TagButton9"
		"zpos"				"2"
		"wide"				"150"
		"minimum-width"		"150"
		"tall"				"18"
		"minimum-height"	"18"
		"style"				"TagButton"
		"textalignment"		"west"
		"tabposition"		"2"
		"subtabposition"	"9"
	}
	
	"TagButton10"
	{
		"ControlName"		"RadioButton"
		"fieldName"			"TagButton10"
		"zpos"				"2"
		"wide"				"150"
		"minimum-width"		"150"
		"tall"				"18"
		"minimum-height"	"18"
		"style"				"TagButton"
		"textalignment"		"west"
		"tabposition"		"2"
		"subtabposition"	"10"
	}
	
	"GridSectionHeader"
	{
		"ControlName"			"Label"
		"fieldName"				"GridSectionHeader"
		"zpos"					"2"
		"wide"					"335"
		"tall"					"26"
		"minimum-width"			"335"
		"minimum-height"		"26"
		"visible"				"0"
		"textAlignment"			"center"
		"labelText"				"#DOTA_SHOP_ITEMS"
		"style"					"GridSectionHeader"
	}
	
	"SearchResultsLabel"
	{
		"ControlName"			"Label"
		"zpos"					"2"
		"wide"					"370"
		"tall"					"26"
		"minimum-width"			"370"
		"minimum-height"		"26"
		"visible"				"0"
		"textAlignment"			"west"
		"labelText"				""
		"style"					"SearchResultsLabel"
	}
		
	"ItemDetails"
	{
		"ControlName"			"CHudFullscreenShopItemDetailsPanel"
		"wide"					"257"
		"tall"					"350"
		"minimum-width"			"257"
		"minimum-height"		"350"
		"visible"				"1"
	}
		
	"ItemBuild"
	{
		"ControlName"			"CDOTAHudItemBuildPanel"
		"zpos"					"300"	// really damn high to be above shop items
		"wide"					"900"
		"tall"					"87"
		"minimum-width"			"900"
		"minimum-height"		"87"
		"visible"				"1"
	}
	
	"CategoryBackground"
	{
		"ControlName"		"Panel"
		"zpos"				"1"
		"xpos"				"0"
		"ypos"				"63"
		"wide"				"900"
		"tall"				"33"
		"visible"			"1"
		"style"				"CategoryBackground"
	}
	
	"CategoryShadow"
	{
		"ControlName"		"Panel"
		"xpos"			"0"
		"ypos"			"96"
		"wide"			"900"
		"zpos"			"2"
		"tall"			"10"		
		"visible"		"1"
		"style"			"CategoryShadow"
	}
	
	
	"CategoryButton1"
	{
		"ControlName"		"RadioButton"
		"zpos"				"2"
		"wide"				"82"
		"minimum-width"		"82"
		"tall"				"36"
		"style"				"CategoryButton"
		"minimum-height"	"36"
		"textalignment"		"center"
		"command"			"category1"
		"tabposition"		"1"
		"subtabposition"	"0"
	}
	
	"CategoryButton2"
	{
		"ControlName"		"RadioButton"
		"zpos"				"2"
		"wide"				"82"
		"minimum-width"		"82"
		"tall"				"36"
		"style"				"CategoryButton"
		"minimum-height"	"36"
		"textalignment"		"center"
		"command"			"category2"
		"tabposition"		"1"
		"subtabposition"	"1"
	}
	
	"CategoryButton3"
	{
		"ControlName"		"RadioButton"
		"zpos"				"2"
		"wide"				"82"
		"minimum-width"		"82"
		"tall"				"36"
		"style"				"CategoryButton"
		"minimum-height"	"36"
		"textalignment"		"center"
		"command"			"category3"
		"tabposition"		"1"
		"subtabposition"	"2"
	}
	
	"CategoryButton4"
	{
		"ControlName"		"RadioButton"
		"zpos"				"2"
		"wide"				"82"
		"minimum-width"		"82"
		"tall"				"36"
		"style"				"CategoryButton"
		"minimum-height"	"36"
		"textalignment"		"center"
		"command"			"category4"
		"tabposition"		"1"
		"subtabposition"	"3"
	}
	
	"CategoryButton5"
	{
		"ControlName"		"RadioButton"
		"zpos"				"2"
		"wide"				"82"
		"minimum-width"		"82"
		"tall"				"36"
		"style"				"CategoryButton"
		"minimum-height"	"36"
		"textalignment"		"center"
		"command"			"category5"
		"tabposition"		"1"
		"subtabposition"	"4"
	}
	
	"CategoryButton6"
	{
		"ControlName"		"RadioButton"
		"zpos"				"2"
		"wide"				"82"
		"minimum-width"		"82"
		"tall"				"36"
		"style"				"CategoryButton"
		"minimum-height"	"36"
		"textalignment"		"center"
		"command"			"category6"
		"tabposition"		"1"
		"subtabposition"	"5"
	}
	
	"CategorySectionBlocker"
	{
		"ControlName"		"Panel"
		"zpos"				"3"
		"xpos"				"0"
		"ypos"				"76"
		"wide"				"900"
		"tall"				"33"
		"visible"			"1"
		"style"				"CategoryButton"
		"mouseinputenabled"	"1"
		"group"				"coverfilters"
	}
	
	"GoldDisplay"
	{
		"ControlName"		"CShopGoldDisplay"
		"wide"				"257"
		"tall"				"34"
		"zpos"				"2"
		"visible"			"1"
		"mouseinputenabled"	"1"
		"minimum-width"		"257"
		"minimum-height"	"34"
		"style"				"ShopItemBackground"
	}
	
	"AdvancedGoldButton"
	{	
		"ControlName"		"Button"
		"wide"				"65"
		"tall"				"17"
		"zpos"				"3"
		"labeltext"			"Advanced"
		"textalignment"		"center"
		"command"			"goldinfo"
		"minimum-width"		"65"
		"minimum-height"	"17"
		"visible"			"1"
		"enabled"			"0"
		"style"				"AdvancedGold"			
	}
	
	"CloseButton"
	{
		"ControlName"		"Button"
		"zpos"				"2"
		"wide"				"34"
		"tall"				"17"
		"tabPosition"		"0"
		"style"				"CloseButton"
		"minimum-width"		"34"
		"minimum-height"	"17"
		"textalignment"		"west"
		"labeltext"			""	
		"command"			"close"
	}
		
	colors
	{
		// shop button
		ShopButtonInactive="88 88 88 255"
		ShopButtonHover="255 255 255 255"
		ShopButtonActive="255 255 255 255"
		
		ShopButtonTop="174 195 199 255"
		
		SideShopButton="96 96 96 255"
		HomeShopButton="105 130 138 255"
		SecretShopButton="114 56 56 255"
				
		CategoryBGTop="100 100 100 255"		
		CategoryBGBottom="67 67 67 255"
		
		CategoryButtonInactiveTop="113 113 113 255"
		CategoryButtonInactiveBottom="80 80 80 255"
		
		CategoryButtonActiveTop="70 70 70 255"
		CategoryButtonActiveBottom="35 35 35 255"
		
		
		TagSectionBG="124 124 124 255"
		
		TagButtonHoverBG="80 80 80 255"
		TagButtonSelectedBG="50 50 50 255"
		
		ShopItemTop="110 110 110 255"
		ShopItemBottom="80 80 80 255"
		ShopItemHighlight="131 131 131 255"
		
		CloseButtonHover="150 150 150 255"
	}
	
	styles
	{
		Label
		{
			font=Arial12Thick
		}
		
		Background
		{
			bgcolor=LightGrey
		}
		
		CloseButton
		{
			font=DIN14Thick
			textcolor=white
			render_bg
			{
				0="image_scale( x0, y0, x1, y1, materials/vgui/hud/shop/button_close.vmat )"
			}
		}
		
		CloseButton:hover
		{
			font=DIN14Thick
			textcolor=CloseButtonHover
			render_bg
			{
				0="image_scale( x0, y0, x1, y1, materials/vgui/hud/shop/button_close.vmat )"
				1="line( x1-1, y0, x1, y1, black )"
				2="line( x0, y1-1, x1, y1, black )"
			}
		}
		
		ShopTitle
		{
			font=DefaultLargeTimer
			textcolor=white
			bgcolor=darkgrey
		}
		
		CategoryLabels
		{
			font=Arial10Thick
			textcolor=white
			bgcolor=LighterGrey
		}
		
		ClearSearchButton
		{
			font=Arial14Thick
			bgcolor=none
			render_bg
			{
				0="roundedfill( x0, y0, x1, y1, 7, LightGrey )"
			}
		}
		
		SearchText
		{
			font=DIN14Thick
			textcolor=white
			bgolor=none
			inset-left=24
			render_bg 
			{
				0="image_scale( x0, y0, x1, y1, materials/vgui/hud/shop/shop_search_field_on.vmat )"
			}
		} 
		
		SearchOverlay
		{
			font=DIN14Thick
			textcolor=white
			bgolor=none
			inset-left=24
			render_bg 
			{
				0="image_scale( x0, y0, x1, y1, materials/vgui/hud/shop/shop_search_field_off.vmat )"
			}
		}
		
		SectionHeaderLabel
		{
			font=Arial12Thick
			textcolor=white
			bgcolor=darkgrey
		}
		
		TagsSectionLabel
		{
			font=Arial12Thick
			textcolor=white
			bgcolor=LighterGrey			
		}
		
		GridSectionHeader
		{
			font=Arial12Thick
			textcolor=white
			bgcolor=black			
		}
		
		ItemDetailsLabel
		{
			font=Arial12Thick
			textcolor=white
			bgcolor=darkgrey			
		}
			
		CategoryBackground
		{
			render_bg
			{
				0="gradient( x0, y0, x1, y1, CategoryBGTop, CategoryBGBottom )"
			}
		}
		
		CategoryButton
		{
			font=DIN14Thick
			textcolor=white
			render_bg 
			{
				0="gradient( x0, y0, x1, y1, CategoryButtonInactiveTop, CategoryButtonInactiveBottom )"
				1="line( x1-1, y0, x1, y1, black )"
				2="line( x0, y0, x0+1, y1, black )"
			}
		}
		
		CategoryButton:selected
		{
			font=DIN14Thick
			textcolor=white
			render_bg 
			{
				0="gradient( x0, y0, x1, y1, CategoryButtonActiveTop, CategoryButtonActiveBottom )"
			}
		}
		
		TagSectionBG
		{
			render_bg
			{
				0="fill(x0,y0,x1,y1,TagSectionBG)"
			}
		}
		
		TagLabel
		{
			textcolor=white
			font=DIN12Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}			
		}
		
		TagButton
		{
			textcolor=white
			font=DIN14Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
			
		TagButton:hover
		{
			textcolor=white
			font=DIN14Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,TagButtonHoverBG)"
			}
		}
		
		TagButton:selected
		{
			textcolor=white
			font=DIN14Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,TagButtonSelectedBG)"
			}
		}
		
		ShopSelectorButton
		{
			textcolor=white
			font=DIN16Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,LighterGrey)"
				1="fill(x0+1,y0+1,x1-1,y1-1,HomeShopButton)"
			}
		}
		
		ShopSelectorButton:selected
		{
			textcolor=white
			font=DIN16Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,white)"
				1="gradient(x0+1,y0+1,x1-1,y1-1,ShopButtonTop,HomeShopButton)"
			}
		}
		
		ShopSelectorButton:disabled			// not active, away from the secret shop
		{
			textcolor=white
			font=DIN16Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,LighterGrey)"
				1="fill(x0+1,y0+1,x1-1,y1-1,SecretShopButton)"
			}
		}
		
		ShopSelectorButton:selected:disabled		// selected, but away from the secret shop
		{
			textcolor=white
			font=DIN16Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,white)"
				1="fill(x0+1,y0+1,x1-1,y1-1,SecretShopButton)"
			}
		}
		
		TopBarBackground
		{
			render_bg
			{
				0="gradient(x0,y0,x1,y1,TagButtonHoverBG,TagButtonSelectedBG)"
				1="fill(x0,y0,x1,y0+1,ShopItemHighlight)"
			}
		}
		
		SearchResultsLabel
		{
			font=DIN14Thick
			textcolor=white
			inset-left=5
			render_bg
			{
				0="roundedfill(x0,y0,x1,y1,4,black)"
			}
		}
		
		CategoryShadow
		{
			bgcolor=none
			render_bg
			{
				0="gradient( x0, y0, x1, y1, black, none )"
			}
		}
		
		AdvancedGold
		{
			font=DIN12Thick
			textcolor=black
			render_bg
			{
				0="gradient( x0, y0, x1, y1, CategoryButtonInactiveTop, CategoryButtonInactiveBottom )"
				1="fill( x0, y0, x1, y0+1, black )"  // top
 				2="fill( x0, y1 - 1, x1, y1, black )"  // bottom
 				3="fill( x0, y0 + 1, x0 + 1, y1 - 1, black )"  // left
 				4="fill( x1 - 1, y0 + 1, x1, y1 - 1, black )"  // right
			}
		}
	}
	
	layout
	{
		region { name=Everything x=0 y=0 height=max width=max }
		
		region { name=Top x=0 y=0 height=63 width=max }
		place { region=Top Control=TopBarBackground }
		place { region=Top margin-top=9 margin-left=11 Control=CloseButton }
		place { region=Top align=left spacing=10 margin-left=251 margin-top=12 Control=SideShopButton }
		place { region=Top start=SideShopButton align=left margin-left=10 margin-top=-5 Control=MainShopButton }
		place { region=Top start=MainShopButton align=left margin-left=10 margin-top=5 Control=SecretShopButton }
		
		region { name=Categories x=155 y=63 height=33 width=488 }
		place { region=Categories Control=CategoryButton1,CategoryButton2,CategoryButton3,CategoryButton4,CategoryButton5,CategoryButton6 }
		place { region=Categories Control=CategorySectionBlocker }
		
 		region { name=Search x=685 y=20 height=28 width=max }
 		place { region=Search Control=SearchTextEntry }
		place { region=Search Control=SearchOverlayLabel }
		place { region=Search start=SearchTextEntry margin-left=-20 margin-top=6 Control=ClearSearchButton }
		
 		region { name=Gold x=643 y=63 height=34 width=257 }
 		place { region=Gold Control=GoldDisplay }	
 		place { region=Gold margin-left=10 margin-top=8 Control=AdvancedGoldButton }
		
 		region { name=Tags x=0 y=96 height=350 width=156 }
 		place { region=Tags align=center Controls=TagSectionBG }
 		place { region=Tags align=center Controls=TagsSectionBlocker }
 		place { region=Tags margin-top=15 margin-left=14 Control=AllTagsButton } 		
 		place { region=Tags start=AllTagsButton dir=down margin-top=10 spacing=0 Controls=FilterByLabel,TagButton1,TagButton2,TagButton3,TagButton4,TagButton5,TagButton6,TagButton7,TagButton8,TagButton9,TagButton10 }
 		
 		region { name=ItemGrid x=155 y=96 height=350 width=488 overflow=scroll-vertical}
 		place { region=ItemGrid align=center Controls=GridSectionHeader } 
 		place { region=ItemGrid margin-top=7 margin-left=11 Control=SearchResultsLabel }
 		place { region=ItemGrid start=SearchResultsLabel margin-top=4 dir=down spacing=7 Controls=*ShopItemEven }
 		place { region=ItemGrid start=SearchResultsLabel margin-top=4 margin-left=231 dir=down spacing=7 Controls=*ShopItemOdd }
 		
 		region { name=ItemDetails x=643 y=96 height=350 width=max }
 		place { region=ItemDetails Controls=ItemDetails }
 		
 		region { name=ItemBuild x=0 y=431 height=89 width=max }
 		place { region=ItemBuild Controls=ItemBuild } 	
	}
}
