"Resource/UI/RootUI.res"
{
controls
{		
	"econ_sample_rootui"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"econ_sample_rootui"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"1"
		"wide"				"f0"
		"tall"				"480"
		"autoResize"		"0"
		"pinCorner"			"0"
		"visible"			"1"
		"enabled"			"1"
		"style"				"EconRootStyle"
	}
	
	"ClassLabel"
	{
		"ControlName"	"CExLabel"
		"fieldName"		"ClassLabel"
		"font"			"DefaultVeryLarge"
		"labelText"		"#ValveEcon_RootUI_Title"
		"textAlignment"	"west"
		"xpos"			"c-320"
		"ypos"			"15"
		"zpos"			"1"
		"wide"			"560"
		"tall"			"25"
		"autoResize"	"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
	}
	
	"StoreButton"
	{
		"ControlName"	"CExButton"
		"fieldName"		"StoreButton"
		"xpos"			"c-50"
		"ypos"			"125"
		"wide"			"100"
		"tall"			"75"
		"autoResize"	"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"labelText"		"#ValveEcon_RootUI_OpenStore"
		"font"			"Default"
		"textAlignment"	"center"
		"dulltext"		"0"
		"brighttext"	"0"
		"default"		"1"
		"Command"		"store"
		"sound_depressed"	"UI/buttonclick.wav"
		"sound_released"	"UI/buttonclickrelease.wav"
	}		
	"BackpackButton"
	{
		"ControlName"	"CExButton"
		"fieldName"		"BackpackButton"
		"xpos"			"c-275"
		"ypos"			"250"
		"wide"			"100"
		"tall"			"75"
		"autoResize"	"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"labelText"		"#ValveEcon_RootUI_OpenBackpack"
		"font"			"Default"
		"textAlignment"	"center"
		"dulltext"		"0"
		"brighttext"	"0"
		"default"		"1"
		"Command"		"backpack"
		"sound_depressed"	"UI/buttonclick.wav"
		"sound_released"	"UI/buttonclickrelease.wav"
	}		
	"LoadoutButton"
	{
		"ControlName"	"CExButton"
		"fieldName"		"LoadoutButton"
		"xpos"			"c-125"
		"ypos"			"250"
		"wide"			"100"
		"tall"			"75"
		"autoResize"	"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"labelText"		"#ValveEcon_RootUI_OpenLoadout"
		"font"			"Default"
		"textAlignment"	"center"
		"dulltext"		"0"
		"brighttext"	"0"
		"default"		"1"
		"Command"		"loadout"
		"sound_depressed"	"UI/buttonclick.wav"
		"sound_released"	"UI/buttonclickrelease.wav"
	}		
	"CraftingButton"
	{
		"ControlName"	"CExButton"
		"fieldName"		"CraftingButton"
		"xpos"			"c25"
		"ypos"			"250"
		"wide"			"100"
		"tall"			"75"
		"autoResize"	"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"labelText"		"#ValveEcon_RootUI_OpenCrafting"
		"font"			"Default"
		"textAlignment"	"center"
		"dulltext"		"0"
		"brighttext"	"0"
		"default"		"1"
		"Command"		"crafting"
		"sound_depressed"	"UI/buttonclick.wav"
		"sound_released"	"UI/buttonclickrelease.wav"
	}		
	"TradingButton"
	{
		"ControlName"	"CExButton"
		"fieldName"		"TradingButton"
		"xpos"			"c175"
		"ypos"			"250"
		"wide"			"100"
		"tall"			"75"
		"autoResize"	"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"labelText"		"#ValveEcon_RootUI_OpenTrading"
		"font"			"Default"
		"textAlignment"	"center"
		"dulltext"		"0"
		"brighttext"	"0"
		"default"		"1"
		"Command"		"trading"
		"sound_depressed"	"UI/buttonclick.wav"
		"sound_released"	"UI/buttonclickrelease.wav"
	}		
	
	"CloseButton"
	{
		"ControlName"	"CExButton"
		"fieldName"		"CloseButton"
		"xpos"			"c200"
		"ypos"			"400"
		"wide"			"100"
		"tall"			"25"
		"autoResize"	"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"labelText"		"#GameUI_Close"
		"font"			"Default"
		"textAlignment"	"center"
		"dulltext"		"0"
		"brighttext"	"0"
		"default"		"1"
		"Command"		"close"
		"sound_depressed"	"UI/buttonclick.wav"
		"sound_released"	"UI/buttonclickrelease.wav"
	}
	
	"backpack_panel"
	{
		"ControlName"		"CBackpackPanel"
		"fieldName"			"backpack_panel"
		"xpos"				"0"
		"ypos"				"50"
		"zpos"				"2"
		"wide"				"f0"
		"tall"				"430"
		"visible"			"0"
		"enable"			"1"
	}
}

colors
{
	backgroundcolor="36 36 36 255"
}

styles
{
	EconRootStyle
	{
		render_bg
		{
			0="fill( x0, y0, x1, y1, backgroundcolor )"
		}
	}
}


}
