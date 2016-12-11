"Resource/UI/HUD_Shop_Item_Name_Gold.res"
{
	"this"
	{
		"ControlName"		"CShopItemPanelNameAndGold"
		"wide"				"181"
		"tall"				"32"
		"visible"			"1"
		"mouseinputenabled"	"1"
		"minimum-width"		"225"
		"minimum-height"	"33"
		"style"				"ShopItemBackground"
	}
	
	// Used by Quick Buy Button
	"OwnedImage"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"OwnedImage"
		"zpos"				"2"
		"wide"				"10"
		"tall"				"10"
		"visible"			"0"
		"scaleImage"		"1"
		"mouseinputenabled"	"0"
		"image"				"materials/vgui/hud/shop/owned.vmat"
		"minimum-width"		"10"
		"minimum-height"	"10"
		
		"group"				"owned"
	}	
	
	// Used by Quick Buy Button
	"LinkImage"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"LinkImage"
		"zpos"				"2"
		"wide"				"10"
		"tall"				"10"
		"visible"			"0"
		"scaleImage"		"1"
		"mouseinputenabled"	"0"
		"image"				"materials/vgui/hud/shop/link.vmat"
		"minimum-width"		"10"
		"minimum-height"	"10"
		
		"group"				"link"
	}
		
	"NameLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"NameLabel"
		"xpos"					"44"
		"ypos"					"4"
		"zpos"					"1"
		"wide"					"150"
		"tall"					"74"
		"visible"				"1"
		"textAlignment"			"north-west"
		"labelText"				"%name%"
		"style"					"NameLabel"
		"mouseinputenabled"		"0"
	}
	
	"GoldLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"GoldLabel"
		"zpos"					"2"
		"xpos"					"44"
		"ypos"					"16"
		"wide"					"150"
		"tall"					"16"
		"visible"				"1"
		"textAlignment"			"west"
		"labelText"				"%cost%"
		"style"					"GoldLabel"
		"mouseinputenabled"		"0"
	}
	
	"ItemImage"
	{
		"ControlName"	"ImagePanel"
		"xpos"			"4"
		"ypos"			"4"
		"wide"			"36"
		"tall"			"24"
		"zpos"			"1"
		"scaleImage"	"1"
		"visible"		"1"
		"enabled"		"1"
		"style"			"ItemImage"
		"mouseinputenabled"	"0"
	}
	
	"SecretShopIcon"
	{
		"ControlName"	"Panel"
		"wide"			"24"
		"tall"			"24"
		"zpos"			"1"
		"visible"		"0"
		"enabled"		"1"
		"style"			"SecretShopIcon"
		"mouseinputenabled"	"0"
		"group"			"secretshop"	
	}
	
	colors
	{
		ShopItemTop="110 110 110 255"
		ShopItemBottom="80 80 80 255"
		ShopItemHighlight="131 131 131 255"
		ShopItemInactiveTop="70 70 70 255"
		ShopItemInactiveBottom="30 30 30 255"
	}
				
	styles
	{	
		NameLabel
		{
			textcolor=white
			font=DIN14Thick
		}
		
		GoldLabel
		{
			textcolor=GoldLabelColor
			font=DIN12Thick
		}
		
		ShopItemBackground
		{
			render_bg
			{
				0="gradient(x0,y0,x1,y1,ShopItemTop,ShopItemBottom)"
				1="fill(x0,y0,x1,y0+1,ShopItemHighlight)"
			}
		}
		
		ShopItemBackground:disabled
		{	
			render_bg
			{
				0="gradient(x0,y0,x1,y1,ShopItemInactiveTop,ShopItemInactiveBottom)"
				1="fill(x0,y0,x1,y0+1,ShopItemHighlight)"
			}
		}
		
		ItemImage
		{
			render
			{
				0="image_scale( x0, y0, x1, y1, materials/vgui/hud/hud_generic_inner_shadow.vmat )"
			}
		}
		
		SecretShopIcon
		{
			render
			{
				0="image_scale( x0, y0, x1, y1, materials/vgui/hud/shop/button_secret_nearby.vmat )"
			}
		}
		
		SecretShopIcon:disabled
		{
			render
			{
				0="image_scale( x0, y0, x1, y1, materials/vgui/hud/shop/button_secret_error.vmat )"
			}
		}
	}
	
	layout
	{
		region { name=Everything x=0 y=0 height=max width=max }
		
		place { region=Everything Control=ItemNameLabel }
		
		place { region=Everything dir=right Control=LinkImage }
		place { region=Everything align=right dir=right Control=OwnedImage }
		place { region=Everything margin=5 dir=right align=right Control=SecretShopIcon }
	}
}
