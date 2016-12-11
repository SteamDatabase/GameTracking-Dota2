"Resource/UI/HUD_Fullscreen_Shop_QuickBuy.res"
{
	this
	{
		style=Background
	}
			
	"QuickBuyLabel"
	{
		"ControlName"	"Label"
		"zpos"			"1"
		"wide"			"200"
		"tall"			"15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"#DOTA_SHOP_QUICK_BUY"
		"textAlignment"	"west"
		"style"			"TitleLabel"
		"minimum-width"	"200"
		"minimum-height"	"15"
	}
	
	"QuickBuyItem"
	{
		"ControlName"		"QuickBuyButton"
		"wide"				"48"
		"tall"				"36"
		"zpos"				"1"
		"visible"			"0"
		"disallow_drag_out"	"1"
		"group"				"quickbuybuttons"
	}
	
	"Arrow"
	{
		"ControlName"		"Panel"
		"wide"				"12"
		"tall"				"12"
		"visible"			"0"
		"style"				"Arrow"
	}
			
	"QuickBuy1"
	{
		"ControlName"		"QuickBuyButton"
		"wide"				"22"
		"tall"				"16"
		"zpos"				"1"
		"visible"			"0"
		"disallow_drag_out"	"1"
		"group"				"quickbuybuttons"
	}
	
	"QuickBuy2"
	{
		"ControlName"		"QuickBuyButton"
		"wide"				"22"
		"tall"				"16"
		"zpos"				"1"
		"visible"			"0"
		"disallow_drag_out"	"1"
		"group"				"quickbuybuttons"
	}
	
	"QuickBuy3"
	{
		"ControlName"		"QuickBuyButton"
		"wide"				"22"
		"tall"				"16"
		"zpos"				"1"
		"visible"			"0"
		"disallow_drag_out"	"1"
		"group"				"quickbuybuttons"
	}
	
	"QuickBuy4"
	{
		"ControlName"		"QuickBuyButton"
		"wide"				"22"
		"tall"				"16"
		"zpos"				"1"
		"visible"			"0"
		"disallow_drag_out"	"1"
		"group"				"quickbuybuttons"
	}
	
	"QuickBuy5"
	{
		"ControlName"		"QuickBuyButton"
		"wide"				"22"
		"tall"				"16"
		"zpos"				"1"
		"visible"			"0"
		"disallow_drag_out"	"1"
		"group"				"quickbuybuttons"
	}
		
	colors
	{		
		BackgroundTop="48 48 48 255"
		BackgroundBottom="34 34 34 255"
		ActiveBgFill="204 147 23 255"
		ActiveBgFill2"158 114 17 255"
	}
	
	styles
	{		
		Background
		{
			bgcolor=none
		}
		
		TitleLabel
		{
			font=DIN14Thick
			textcolor=white
		}
		
		Background
		{
			render
			{
				0="gradient( x0, y0, x1, y1, BackgroundTop, BackgroundBottom )"
				1="fill( x0, y0, x1, y0+1, black )"
			}
		}
		
		Arrow
		{
			render
			{
				0="image_scale( x0, y0, x1, y1, materials/vgui/scroll_right.vmat )"
			}
		}
	}
	
	layout
	{
	
	
		region { name=Everything x=0 y=0 height=max width=max }
		place { region=Everything margin-left=10 margin-top=3 spacing=2 Controls=QuickBuyLabel }
		place { region=Everything margin-left=10 margin-top=25 Controls=QuickBuyItem }
		place { region=Everything dir=right margin-top=14 margin-left=4 spacing=1 Controls=QuickBuy1,QuickBuy2,QuickBuy3,QuickBuy4,QuickBuy5 }
		
		place { region=Everything start=QuickBuyItem margin-left=2 margin-top=15 Controls=Arrow }
		
		place { region=Everything start=QuickBuyItem margin-left=17 margin-top=4 spacing=3 Controls=QuickBuy1,QuickBuy2 }
		place { region=Everything start=QuickBuy1 dir=down margin-top=3 Controls=QuickBuy3 }
		place { region=Everything start=QuickBuy3 margin-left=3 Controls=QuickBuy4 }
		place { region=Everything start=QuickBuy2 dir=down margin-top=-35 Controls=QuickBuy5 }
		//Place { region=Everything Control=SetQuickBuyDropTarget }
		
		
	}
}
