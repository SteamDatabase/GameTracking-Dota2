"Resource/UI/HUD_TooltipItem.res"
{
	"dota_tooltip"
	{
		"ControlName"			"EditablePanel"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"0"
		"wide"					"240"
		"tall"					"610"
		"visible"				"0"
		"enabled"				"1"
		"style"					"TooltipBackground"
		
		"margin-right"		"0"
		"margin-bottom"		"7"
	}

	"AbilityName"
	{
		"ControlName"		"Label"
		"zpos"				"1"
		"wide"				"235"
		"tall"				"15"
		"enabled"			"1"
		"visible"			"1"
		"labeltext"			"%abilityname%"
		"textAlignment"		"west"
		"style"				"AbilityName"
	}

	"LevelLabel"
	{
		"ControlName"		"Label"
		"zpos"				"1"
		"wide"				"235"
		"tall"				"15"
		"enabled"			"1"
		"visible"			"1"
		"labeltext"			"#DOTA_ToolTip_Level"
		"textAlignment"		"east"
		"style"				"Level"
		"minimum-height"	"15"
	}
	
	"LevelLabel_Result"
	{
		"ControlName"		"Label"
		"zpos"			"1"
		"wide"			"5"
		"tall"			"5"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%level%"
		"textAlignment"	"west"
		"style"			"Level"
		"minimum-height"	"15"
	}

	"divider"
	{
		"ControlName"			"Panel"
		"zpos"					"1"
		"wide"					"226"
		"tall"					"1"
		"visible"				"1"
		"enabled"				"1"
		"style"					"divider"
	}

	"AbilityDescription"
	{
		"ControlName"		"Label"
		"font" 			"Arial10Thick"
		"zpos"			"1"
		"wide"			"219"
		"tall"			"5"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%abilitydesc%"
		"textAlignment"		"west"
		"bgcolor_override"	"0 151 0 0"
		"fgcolor_override"	"255 255 255 175"
		"scrollbar"		"false"
		"wrap"	"1"
		"auto_tall_tocontents"	"1"
		"minimum-width"		"221"
	}

	"AbilityVariables"
	{
		"ControlName"		"RichText"
		"fieldName"		"AbilityVariables"
		"font" 			"Arial12Thick"
		"zpos"			"1"
		"wide"			"219"
		"tall"			"5"
		"enabled"		"1"
		"visible"		"1"
		"textAlignment"		"west"
		"bgcolor_override"	"151 0 0 0"
		"fgcolor_override"	"175 175 175 255"
		"scrollbar"		"false"
		"text"			"[ missing variables ? ]"
		"wrap"	"0"
		"auto_tall_tocontents"	"1"
		"minimum-width"		"235"
	}
	
	"ManaImage"
	{
		"ControlName"			"ImagePanel"
		"fieldName"			"ManaImage"
		"zpos"				"2"
		"wide"				"10"
		"tall"				"10"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"			"1"
		"fillcolor"			"255 255 255 0"
		"image"				"materials/vgui/hud/tool_tip-icon_2.vmat"
		"style"				"IconInset"
	}

	"ManaCost"
	{
		"ControlName"		"RichText"
		"fieldName"		"ManaCost"
		"xpos"			"0"
		"ypos"			"3"
		"zpos"			"2"
		"wide"			"100"
		"tall"			"5"
		"enabled"		"1"
		"visible"		"1"
		"text"			""
		"textAlignment"		"east"
		"scrollbar"		"false"
		"minimum-width"		"100"
		"style"			"IconProperty"
		
		"font"			"Arial12Med"
	}

	"CooldownImage"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"CooldownImage"
		"zpos"			"2"
		"wide"			"10"
		"tall"			"10"
		"enabled"		"1"
		"visible"		"1"
		"scaleImage"	"1"
		"fillcolor"		"255 255 255 0"
		"image"			"materials/vgui/hud/tool_tip-icon_1.vmat"
		"style"			"IconInset"
	}
	
	"Cooldown"
	{
		"ControlName"		"RichText"
		"fieldName"		"Cooldown"
		"zpos"			"2"
		"wide"			"100"
		"tall"			"10"
		"enabled"		"1"
		"visible"		"1"
		"text"			""
		"textAlignment"	"north-west"
		"scrollbar"		"false"
		"style"			"IconProperty"
		
		"font"			"Arial12Med"
	}
	
	"SellPrice"
	{
		"ControlName"	"Label"
		"fieldName"		"SellPrice"
		"font" 			"Arial10Thick"
		"zpos"			"1"
		"wide"			"219"
		"minimum-width"	"219"
		"tall"			"0"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%sellprice%"
		"textAlignment"	"west"
		"auto_tall_tocontents"	"1"
		"style"			"sellprice"
	}
	
	styles
	{
 		AbilityName
 		{
 			textcolor=white
 			bgcolor=none
 			font=DIN14Thick
 		}
 				
 		Level
 		{
 			textcolor=white
 			font=DIN11Thick
 			bgcolor=none
 		}
 		
		divider
		{
			render
			{
				0="fill(x0,y0,x1,y1,dividergrey)"
			}
		}
 		
 		AbilityInfo
 		{
 			textcolor=tooltipgrey
 			font=Arial8Thick
 		}
 		
 		IconInset
 		{
 		}
 		
 		IconProperty
 		{
 			// inset so it lines up with the text
 			inset-left=2
 			inset-top=-3
 			textcolor=tooltipgrey			
 			render_bg
 			{
 				0="fill(x0,y0,x1,y1,none)"
 			}
 		}		
 		
 		sellprice
 		{
 			textcolor=GoldLabelColor
 			bgcolor=none
 			font=Arial10Thick
 		}	
	}
			
	layout
	{
		region { name=tooltip x=0 y=0 width=240 height=600 }
		
		place { region=tooltip overflow=allow-both margin=7 dir=down Controls=AbilityName,divider,AbilityDescription,AbilityVariables,CooldownImage spacing=4 }
		
		place { region=tooltip overflow=allow-both margin-right=7 dir=right align=right Controls=LevelLabel,LevelLabel_Result spacing=4 }
		
		place { start=CooldownImage overflow=allow-both margin-right=7 dir=right Control=Cooldown,ManaImage,ManaCost }
		
		place { start=CooldownImage overflow=allow-both margin-bottom=7 dir=down ignore_invis=1 Control=SellPrice }
		
		
		
		
				
		//size_region_to_contents { region=tooltip }
		
		//size_panel_to_region { region=tooltip }	// implies relocating the region to 0,0. if it was not there to start with, controls moved by it must be moved
	}
}


