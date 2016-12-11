"Resource/UI/HUD_QuickBuy.res"
{
	"this"
	{
		"ControlName"		"EditablePanel"
		"xpos"				"r155"
		"ypos"				"r170"
		"zpos"				"-1"
		"wide"				"160"
		"tall"				"47"
		"visible"			"1"
		"enabled"			"1"
		"style"				"QuickBuyBackground"
	}
	
	"QuickBuyLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"QuickBuyLabel"
		"zpos"					"1"
		"wide"					"32"
		"minimum-width"			"132"
		"minimum-height"		"12"
		"tall"					"20"
		"textAlignment"			"west"
		"labelText"				"#DOTA_InventoryQuickBuy"
		"visible"				"1"
		"enabled"				"1"
		"style"					"SectionLabel"
		"mouseinputenabled"		"0"
	}
	
	"InstructionLabel"
	{
		"ControlName"			"Label"
		"zpos"					"1"
		"xpos"					"20"
		"ypos"					"15"
		"wide"					"120"
		"minimum-width"			"120"
		"minimum-height"		"47"
		"tall"					"47"
		"textAlignment"			"center"
		"labelText"				"#DOTA_QuickBuy_Instruction"
		"centerwrap"					"1"
		"visible"				"1"
		"enabled"				"1"
		"style"					"SectionLabel"
		"mouseinputenabled"		"0"
		"group"					"instructions"
	}

	"QuickBuyItem"
	{
		"ControlName"		"QuickBuyButton"
		"wide"				"44"
		"tall"				"33"
		"zpos"				"1"
		"visible"			"1"
		"disallow_drag_out"	"1"
		"group"				"quickbuybuttons"
	}
	
	"Arrow"
	{
		"ControlName"		"Panel"
		"wide"				"12"
		"tall"				"12"
		"visible"			"1"
		"style"				"Arrow"
	}
	
	// 5 quick buy buttons
	"QuickBuy1"
	{
		"ControlName"		"QuickBuyButton"
		"wide"				"29"
		"tall"				"22"
		"zpos"				"1"
		"visible"			"0"
		"group"				"quickbuybuttons"
		"disallow_drag_out"	"1"
	}
	
	"QuickBuy2"
	{
		"ControlName"		"QuickBuyButton"
		"wide"				"29"
		"tall"				"22"
		"zpos"				"1"
		"visible"			"0"
		"group"				"quickbuybuttons"
		"disallow_drag_out"	"1"
	}
	
	"QuickBuy3"
	{
		"ControlName"		"QuickBuyButton"
		"wide"				"29"
		"tall"				"22"
		"zpos"				"1"
		"visible"			"0"
		"group"				"quickbuybuttons"
		"disallow_drag_out"	"1"
	}
	
	"QuickBuy4"
	{
		"ControlName"		"QuickBuyButton"
		"wide"				"29"
		"tall"				"22"
		"zpos"				"1"
		"visible"			"0"
		"group"				"quickbuybuttons"
		"disallow_drag_out"	"1"
	}
	
	"QuickBuy5"
	{
		"ControlName"		"QuickBuyButton"
		"wide"				"29"
		"tall"				"22"
		"zpos"				"1"
		"visible"			"0"
		"group"				"quickbuybuttons"
		"disallow_drag_out"	"1"
	}
		
	Colors
	{
		SectionLabel="150 150 150 255"
	}
	
	Styles
	{				
		SectionLabel
		{
			font=Arial10Thick
			textcolor=SectionLabel
		}
			
		QuickBuyBackground
		{
			render_bg
			{
				0="image_scale( x0, y0, x1, y1, materials/vgui/hud/gold_bg.vmat )"
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
			

	Layout
	{
		Region { name=Everything x=0 y=0 width=max height=max }
		Place { Region=Everything Controls=QuickBuyBackground }
		Place { Region=Everything margin-left=4 margin-top=1 spacing=2 Controls=QuickBuyLabel }	
		place { region=Everything margin-left=4 margin-top=12 Controls=QuickBuyItem }
		place { region=Everything start=QuickBuyItem margin-left=1 margin-top=7 Controls=Arrow }
		
		place { region=Everything margin-left=61 margin-top=2 spacing=1 Controls=QuickBuy1,QuickBuy2 }
		place { region=Everything start=QuickBuy1 dir=down margin-top=1 Controls=QuickBuy3 }
		place { region=Everything start=QuickBuy3 margin-left=1 Controls=QuickBuy4 }
		place { region=Everything start=QuickBuy2 dir=right margin-left=1 Controls=QuickBuy5 }
	}		
}
