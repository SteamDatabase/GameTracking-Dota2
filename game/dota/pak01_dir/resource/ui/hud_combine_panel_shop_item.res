"Resource/UI/HUD_Combine_Panel_Shop_Item.res"
{	
	this
	{
		"ControlName"		"CShopItemCombinePanel"
		"wide"				"40"
		"tall"				"30"
		"zpos"				"1"
		"visible"			"0"
		"mouseinputenabled"	"1"
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
		"wide"				"0"
		"tall"				"0"
		"visible"			"0"
		"scaleImage"		"1"
		"mouseinputenabled"	"0"
		"image"				"materials/vgui/hud/shop/link.vmat"
		"minimum-width"		"0"
		"minimum-height"	"0"
		
		"group"				"link"
	}
	
	// Used by Quick Buy Button
	"SecretShopImage"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"SecretShopImage"
		"zpos"				"2"
		"wide"				"10"
		"tall"				"10"
		"visible"			"0"
		"scaleImage"		"1"
		"mouseinputenabled"	"0"
		"image"				"materials/vgui/hud/shop/secret.vmat"
		"minimum-width"		"10"
		"minimum-height"	"10"
		
		"group"				"secretshop"
	}
				
	styles
	{
	}
	
	layout
	{
		region { name=Everything x=0 y=0 height=max width=max }
		
		place { region=Everything dir=right Control=LinkImage }
		place { region=Everything align=right dir=right Control=OwnedImage }
		place { region=Everything dir=down align=bottom Control=SecretShopImage }
	}
}
