"Resource/UI/HUD_Fullscreen_Shop_Gold.res"
{
	"this"
	{
		"ControlName"		"CShopGoldDisplay"
		"wide"				"257"
		"tall"				"34"
		"visible"			"1"
	}
		
	"GoldImage"
	{
		"ControlName"	"Panel"
		"xpos"			"0"
		"ypos"			"0"
		"zpos"			"5"
		"wide"			"30"
		"tall"			"30"
		"minimum-width"	"30"
		"minimum-height""30"
		"visible"		"1"
		"style"			"GoldImage"
		"fgcolor_override"	"0 0 0 0"
		"bgcolor_override"	"0 0 0 0"
	}

	"GoldLabel"
	{
		"ControlName"		"Label"
		"zpos"				"5"
		"wide"				"90"
		"tall"				"27"
		"minimum-width"		"90"
		"minimum-height"	"27"
		"textAlignment"		"east"
		"labelText"			""
		"visible"			"1"
		"enabled"			"1"
		"style"				"GoldLabel"
	}
	
	styles
	{
		GoldLabel
		{
			bgcolor=none
			font=DefaultLargeTimer
			textcolor=GoldLabelColor
			inset-left=32			
			render
			{
				0="image_scale( x0, y0, x0+30, y1, materials/vgui/hud/shop/icon_gold.vmat )"
			}
		}
		
		GoldImage
		{
			bgcolor=none
			render
			{				
				//0="image_scale( x0, y0, x1, y1, materials/vgui/hud/shop/icon_gold.vmat )"
			}			
		}
	}
	
	layout
	{
 		region { name=Gold2 x=0 y=0 height=max width=max }
 		place { region=Gold2 spacing=2 margin-right=6 dir=right align=right margin-top=2 Controls=GoldImage,GoldLabel }
 	}
}
