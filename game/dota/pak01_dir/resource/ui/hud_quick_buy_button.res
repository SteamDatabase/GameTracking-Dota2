"Resource/UI/HUD_quick_buy_button.res"
{	
	"OwnedImage"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"OwnedImage"
		"xpos"				"19"
		"ypos"				"12"
		"zpos"				"3"
		"wide"				"10"
		"tall"				"10"
		"visible"			"0"
		"scaleImage"		"1"
		"mouseinputenabled"	"0"
		"image"				"materials/vgui/hud/shop/owned.vmat"
		
		"group"				"owned"
	}	
	
	"LinkImage"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"LinkImage"
		"xpos"				"19"
		"ypos"				"13"
		"zpos"				"3"
		"wide"				"10"
		"tall"				"10"
		"visible"			"1"
		"scaleImage"		"1"
		"mouseinputenabled"	"0"
		"image"				"materials/vgui/hud/shop/link.vmat"
		
		"group"				"link"
	}	
	
	"CannotBuy"
	{
		"ControlName"		"Panel"
		"fieldName"			"CannotBuy"
		"xpos"				"0"
		"ypos"				"0"
		"wide"				"100"
		"tall"				"100"
		"zpos"				"2"
		"visible"			"0"
		"mouseinputenabled"	"0"
		
		"style"				"CannotBuy"
		
		"group"				"canafford"
	}
	
	"PurchasableFlash"
	{
		"ControlName"		"Panel"
		"fieldName"			"PurchasableFlash"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"2"
		"wide"				"100"
		"tall"				"100"
		"visible"			"1"
		"mouseinputenabled"	"0"
		
		"style"				"flash"
	}
	
	colors
	{		
		CannotBuy="0 0 0 160"
	}
	
	styles
	{	
		CannotBuy
		{
			render
			{
				0="fill( x0, y0, x1, y1, CannotBuy )"
			}
		}
		
		flash
		{
			render
			{
				0="fill( x0, y0, x1, y1, white )"
			}	
		}
	}
	
	layout
	{
		region { name=Everything x=0 y=0 height=max width=max }
		
		place { region=Everything dir=right Control=LinkImage }
		place { region=Everything align=right dir=right Control=OwnedImage }
	}
}
