"Resource/UI/HUD_Shop.res"
{
	"shop"
	{
		"ControlName"		"Frame"
		"fieldName"			"shop"
 		"xpos"					"c-287"
 		"ypos"					"r0"
		"wide"				"640"
		"tall"				"200"
		"zpos"				"5"
		"visible"			"0"
		"style"				"TempBackground"
 		
 		"ypos_open"				"600"
	}
		
	"Background"
	{
		"ControlName"	"Panel"
		"fieldName"	"Background"
		"xpos"		"0"
		"ypos"		"0"
		"wide"		"660"
		"tall"		"200"
		"visible"	"1"
		"style"		"TempBackground"
	}
	
	"SearchIcon"
	{
		"ControlName"	"Panel"
		"fieldName"	"SearchIcon"
		"zpos"		"3"
		"wide"		"12"
		"tall"		"12"
		"minimum-width"	"12"
		"minimum-height"	"12"
		"visible"	"1"
		"style"		"SearchIcon"
	}
	
	"SearchTextEntry"
	{
		"ControlName"		"TextEntry"
		"fieldName"			"SearchTextEntry"
		"tall"				"16"
		"wide"				"170"
		"minimum-width"		"170"
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
	
	SearchOverlayLabel { ControlName=Label fieldName=SearchOverlayLabel zpos=2 wide=166 tall=16 minimum-width=166 minimum-height=16 style=SearchText mouseInputEnabled=0 labelText="#DOTA_Shop_Search_Field_Default" }
	
	"ClearSearchButton"
	{
		"ControlName"		"Button"
		"fieldName"			"ClearSearchButton"
		"zpos"				"2"
		"wide"				"13"
		"tall"				"13"
		"tabPosition"		"0"
		"style"				"ClearSearchButton"
		"minimum-height"	"13"
		"minimum-width"		"13"
		"textalignment"		"center"
		"labeltext"			"X"	
		"command"			"clearsearch"
	}
	
	"SubShopTitle"
	{
		"ControlName"			"Label"
		"fieldName"				"SubShopTitle"
		"zpos"					"2"
		"wide"					"300"
		"tall"					"15"
		"visible"				"1"
		"textAlignment"			"west"
		"labelText"				""
		"mouseinputenabled"		"0"
	}
	
	"SubShopSubTitle"
	{
		"ControlName"			"Label"
		"fieldName"				"SubShopSubTitle"
		"xpos"					"172"
		"ypos"					"32"
		"zpos"					"2"
		"wide"					"300"
		"tall"					"15"
		"visible"				"0"
		"textAlignment"			"west"
		"labelText"				""
		"mouseinputenabled"		"0"
	}
	
	"SubShopBackground"
	{
		"ControlName"			"Panel"
		"fieldName"				"SubShopBackground"
		"zpos"					"1"
		"wide"					"182"
		"tall"					"112"
		"visible"				"1"
		"textAlignment"			"west"
		"labelText"				""
		"mouseinputenabled"		"0"	
		"paintbackgroundtype"	"2"
	}
	
	"ShopButton1"
	{
		"ControlName"		"Button"
		"fieldName"			"ShopButton1"
		"zpos"				"1"
		"wide"				"80"
		"tall"				"16"
		"tabPosition"		"0"
		"style"				"ShopButton"
		"minimum-height"	"20"
		"textalignment"		"center"
	}
	
	"ShopButton2"
	{
		"ControlName"		"Button"
		"fieldName"			"ShopButton2"
		"zpos"				"1"
		"wide"				"80"
		"tall"				"16"
		"tabPosition"		"0"
		"style"				"ShopButton"
		"minimum-height"	"20"
		"textalignment"		"center"
	}
	
	"ShopButton3"
	{
		"ControlName"		"Button"
		"fieldName"			"ShopButton3"
		"zpos"				"1"
		"wide"				"80"
		"tall"				"16"
		"tabPosition"		"0"
		"style"				"ShopButton"
		"minimum-height"	"20"
		"textalignment"		"center"
	}
			
	// through 4
	
	"SubShopButton1"
	{
		"ControlName"		"CSubShopButton"
		"fieldName"			"SubShopButton1"
		"zpos"				"1"
		"wide"				"32"
		"tall"				"18"
		"tabPosition"		"1"
		"style"				"SubShopButton"
		"enabled"			"0"
		"paintbackgroundtype"	"2"
		"bgcolor_override"	"115 127 138 255"
	}
	
	"SubShopButton2"
	{
		"ControlName"		"CSubShopButton"
		"fieldName"			"SubShopButton2"
		"zpos"				"1"
		"wide"				"32"
		"tall"				"18"
		"tabPosition"		"1"
		"style"				"SubShopButton"
		"enabled"			"0"
		"paintbackgroundtype"	"2"
		"bgcolor_override"	"115 127 138 255"
	}
	
	"SubShopButton3"
	{
		"ControlName"		"CSubShopButton"
		"fieldName"			"SubShopButton3"
		"zpos"				"1"
		"wide"				"32"
		"tall"				"18"
		"tabPosition"		"1"
		"style"				"SubShopButton"
		"enabled"			"0"
		"paintbackgroundtype"	"2"
		"bgcolor_override"	"115 127 138 255"
	}
	
	"SubShopButton4"
	{
		"ControlName"		"CSubShopButton"
		"fieldName"			"SubShopButton4"
		"zpos"				"1"
		"wide"				"32"
		"tall"				"18"
		"tabPosition"		"1"
		"style"				"SubShopButton"
		"enabled"			"0"
		"paintbackgroundtype"	"2"
		"bgcolor_override"	"115 127 138 255"
	}
	
	"SubShopButton5"
	{
		"ControlName"		"CSubShopButton"
		"fieldName"			"SubShopButton5"
		"zpos"				"1"
		"wide"				"32"
		"tall"				"18"
		"tabPosition"		"1"
		"style"				"SubShopButton"
		"enabled"			"0"
		"paintbackgroundtype"	"2"
		"bgcolor_override"	"115 138 118 255"
	}
	
	"SubShopButton6"
	{
		"ControlName"		"CSubShopButton"
		"fieldName"			"SubShopButton6"
		"zpos"				"1"
		"wide"				"32"
		"tall"				"18"
		"tabPosition"		"1"
		"style"				"SubShopButton"
		"enabled"			"0"
		"paintbackgroundtype"	"2"
		"bgcolor_override"	"115 138 118 255"
	}
	
	"SubShopButton7"
	{
		"ControlName"		"CSubShopButton"
		"fieldName"			"SubShopButton7"
		"zpos"				"1"
		"wide"				"32"
		"tall"				"18"
		"tabPosition"		"1"
		"style"				"SubShopButton"
		"enabled"			"0"
		"paintbackgroundtype"	"2"
		"bgcolor_override"	"115 138 118 255"
	}
	
	"SubShopButton8"
	{
		"ControlName"		"CSubShopButton"
		"fieldName"			"SubShopButton8"
		"zpos"				"1"
		"wide"				"32"
		"tall"				"18"
		"tabPosition"		"1"
		"style"				"SubShopButton"
		"enabled"			"0"
		"paintbackgroundtype"	"2"
		"bgcolor_override"	"115 138 118 255"
	}
	
	"SubShopButton9"
	{
		"ControlName"		"CSubShopButton"
		"fieldName"			"SubShopButton9"
		"zpos"				"1"
		"wide"				"32"
		"tall"				"18"
		"tabPosition"		"1"
		"style"				"SubShopButton"
		"enabled"			"0"
		"paintbackgroundtype"	"2"
		"bgcolor_override"	"115 138 118 255"
	}
	
	"SubShopButton10"
	{
		"ControlName"		"CSubShopButton"
		"fieldName"			"SubShopButton10"
		"zpos"				"1"
		"wide"				"32"
		"tall"				"18"
		"tabPosition"		"1"
		"style"				"SubShopButton"
		"enabled"			"0"
		"paintbackgroundtype"	"2"
		"bgcolor_override"	"115 138 118 255"
	}
	
	//MORE HERE
	// through 6
	// start invis
	
	"ShopItemBackground"
	{
		"ControlName"	"Panel"
		"fieldName"		"ShopItemBackground"
		"wide"			"210"
		"tall"			"140"
		"zpos"			"0"
		"visible"		"0"
	}
	
	"ShopItem1"
	{
		"ControlName"	"CShopItemPanel"
		"fieldName"		"ShopItem1"
		"zpos"			"2"
		"wide"				"44"
		"tall"				"33"
		"visible"		"1"
		"style"			"ShopItemBG"
		"bgcolor_override"	"0 0 0 0"
	}
	
	"ShopItem2"
	{
		"ControlName"	"CShopItemPanel"
		"fieldName"		"ShopItem2"
		"zpos"			"2"
		"wide"				"44"
		"tall"				"33"
		"visible"		"1"
		"style"			"ShopItemBG"
	}
	
	"ShopItem3"
	{
		"ControlName"	"CShopItemPanel"
		"fieldName"		"ShopItem3"
		"zpos"			"2"
		"wide"				"44"
		"tall"				"33"
		"visible"		"1"
		"style"			"ShopItemBG"
	}
	
	"ShopItem4"
	{
		"ControlName"	"CShopItemPanel"
		"fieldName"		"ShopItem4"
		"zpos"			"2"
		"wide"				"44"
		"tall"				"33"
		"visible"		"1"
		"bgcolor_override"	"0 0 0 0"
		"style"			"ShopItemBG"
	}
	
	"ShopItem5"
	{
		"ControlName"	"CShopItemPanel"
		"fieldName"		"ShopItem5"
		"zpos"			"2"
		"wide"				"44"
		"tall"				"33"
		"visible"		"1"
		"bgcolor_override"	"0 0 0 0"
		"style"			"ShopItemBG"
	}
	
	"ShopItem6"
	{
		"ControlName"	"CShopItemPanel"
		"fieldName"		"ShopItem6"
		"zpos"			"2"
		"wide"				"44"
		"tall"				"33"
		"visible"		"1"
		"bgcolor_override"	"0 0 0 0"
		"style"			"ShopItemBG"
	}
	
	"ShopItem7"
	{
		"ControlName"	"CShopItemPanel"
		"fieldName"		"ShopItem7"
		"zpos"			"2"
		"wide"				"44"
		"tall"				"33"
		"visible"		"1"
		"style"			"ShopItemBG"
	}
	
	"ShopItem8"
	{
		"ControlName"	"CShopItemPanel"
		"fieldName"		"ShopItem8"
		"zpos"			"2"
		"wide"				"44"
		"tall"				"33"
		"visible"		"1"
		"style"			"ShopItemBG"
	}
	
	"ShopItem9"
	{
		"ControlName"	"CShopItemPanel"
		"fieldName"		"ShopItem9"
		"zpos"			"2"
		"wide"				"44"
		"tall"				"33"
		"visible"		"1"
		"style"			"ShopItemBG"
	}
	
	"ShopItem10"
	{
		"ControlName"	"CShopItemPanel"
		"fieldName"		"ShopItem10"
		"zpos"			"2"
		"wide"				"44"
		"tall"				"33"
		"visible"		"1"
		"style"			"ShopItemBG"
	}
	
	"ShopItem11"
	{
		"ControlName"	"CShopItemPanel"
		"fieldName"		"ShopItem11"
		"zpos"			"2"
		"wide"				"44"
		"tall"				"33"
		"visible"		"1"
		"style"			"ShopItemBG"
	}
	
	"ShopItem12"
	{
		"ControlName"	"CShopItemPanel"
		"fieldName"		"ShopItem12"
		"zpos"			"2"
		"wide"				"44"
		"tall"				"33"
		"visible"		"1"
		"style"			"ShopItemBG"
		
	}		

	"ItemDetails"
	{
		"ControlName"	"CHudShopItemDetailsPanel"
		"fieldName"		"ItemDetails"
		"wide"			"260"
		"tall"			"193"
		"zpos"			"1"
		"visible"		"0"
		"minimum-width"	"208"
		"minimum-height"	"193"
	}
	
	colors
	{
		ShopCategoryLabel="220 220 220 255"
		
		// shop button
		ShopButtonInactive="88 88 88 255"
		ShopButtonHover="255 255 255 255"
		ShopButtonActive="255 255 255 255"
		ShopButtonBGInactive="24 24 24 255"		
		ShopButtonBGActive="45 45 45 255"
		
		
		SubShopBGActive="124 124 124 255"
		
		
		ItemBackgroundEnd="54 54 54 255"
	}
	
	styles
	{
		Label
		{
			font=Arial12Thick
		}
		
		"ShopCategory"
		{
			font=Arial10Thick
			textcolor=ShopCategoryLabel
		}	
		
		TempBackground
		{
			render_bg
			{
				0="fill( x0, y0, x1, y1, darkgrey )"			
			}		
		}	
		
		ShopItemBackground
		{
			render_bg
			{
				0="gradient( x0, y0, x1, y1, SubShopBGActive, ItemBackgroundEnd )"
			}
		}
			
		ShopButton
		{
			font=Arial10Thick
			textcolor=ShopButtonInactive
			padding-left=10
			padding-right=10
			render_bg 
			{
				0="fill( x0, y0, x1, y1, ShopButtonBGInactive )"
				1="fill( x1-1, y0, x1, y1, LightGrey )"
			}
		}
		
		ShopButton:active
		{
			font=Arial10Thick
			textcolor=ShopButtonActive
			render_bg 
			{
				0="fill( x0, y0, x1, y1, ShopButtonBGActive )"
				1="fill( x1-1, y0, x1, y1, LightGrey )"
			}
		}
		
		ShopButton:selected
		{
			font=Arial10Thick
			textcolor=ShopButtonActive
			render_bg 
			{
				0="fill( x0, y0, x1, y1, ShopButtonBGActive )"
				1="fill( x1-1, y0, x1, y1, LightGrey )"
			}
		}
		
		ShopButton:hover:active
		{
			font=Arial10Thick
			textcolor=ShopButtonHover
			render_bg 
			{
				0="fill( x0, y0, x1, y1, ShopButtonBGActive )"
				1="fill( x1-1, y0, x1, y1, LightGrey )"
			}
		}
		
		ClearSearchButton
		{
			font=Arial10Thick
			render_bg
			{
				//0="roundedfill( x0, y0, x1, y1, 7, ShopButtonBGActive )"
			}
		}
		
		SearchText
		{
			font=DefaultVeryTiny
			textcolor=white
			bgolor=none
			render_bg 
			{
				0="fill( x0, y0, x1, y1, black )"
				1="fill( x1-1, y0, x1, y1, LightGrey )"
			}
		}
		
		SearchIcon
		{
			render_bg
			{		
				0="image_scale( x0, y0, x1, y1, materials/vgui/hud/shop/search.vmat )"
			}
		}
	}
	
	layout
	{
		region { name=Everything x=0 y=0 height=max width=max }
		place { region=Everything dir=right margin-top=0 align=right Control=ItemDetails }
		
		region { name=Search x=0 y=0 height=20 width=max }
		place { region=Search Control=SearchTextEntry }
		place { region=Search margin-left=4 Control=SearchOverlayLabel }
		place { region=Search start=SearchTextEntry margin-left=-16 margin-top=2 Control=ClearSearchButton }
		place { region=Search start=SearchTextEntry margin-left=-16 margin-top=2 Control=SearchIcon }
		
		region { name=ShopButtons x=170 y=0 height=16 width=max }
		place { region=ShopButtons spacing=0 dir=right Controls=ShopButton1,ShopButton2,ShopButton3 }
		
		region { name=SubShopButtons x=170 y=18 height=45 width=max }
		place { region=SubShopButtons margin-left=1 spacing=2 dir=right Controls=SubShopButton1,SubShopButton2,SubShopButton3,SubShopButton4 }
						
		region { name=Items x=171 y=37 height=115 width=190 }
		place { region=Items Control=SubShopBackground }
		place { region=Items margin-left=5 margin-top=1 Control=SubShopTitle }

		place { region=Items Control=ShopItemBackground }
		place { region=Items margin=5 margin-top=12 spacing=0 dir=right Controls=ShopItem1,ShopItem2,ShopItem3,ShopItem4 }
		
		place { region=Items spacing=0 dir=down start=ShopItem1 Controls=ShopItem5 }
		place { region=Items spacing=0 dir=right start=ShopItem5 Controls=ShopItem6,ShopItem7,ShopItem8 }
		
		place { region=Items spacing=0 dir=down start=ShopItem5 Controls=ShopItem9 }
		place { region=Items spacing=0 dir=right start=ShopItem9 Controls=ShopItem10,ShopItem11,ShopItem12 }
				
		region { name=SubShopButtonsBottom x=170 y=150 height=45 width=max }
		place { region=SubShopButtonsBottom margin-left=1 spacing=2 dir=right Controls=SubShopButton5,SubShopButton6,SubShopButton7,SubShopButton8,SubShopButton9,SubShopButton10 }
	}
}
