"Resource/UI/HUD_TooltipItem.res"
{
	"dota_tooltip"
	{
		"ControlName"			"EditablePanel"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"0"
		"wide"					"240"
		"tall"					"600"
		"visible"				"0"
		"enabled"				"1"
		"style"					"tooltipbackground"
		
		"margin-right"			"7"
		"margin-bottom"			"7"
	}

	"AbilityName"
	{
		"ControlName"		"Label"
		"zpos"			"1"
		"wide"			"235"
		"tall"			"15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%abilityname%"
		"textAlignment"		"west"
		"style"			"AbilityName"
	}

	"LevelLabel"
	{
		"ControlName"		"Label"
		"zpos"			"1"
		"wide"			"235"
		"tall"			"15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"#DOTA_ToolTip_Level"
		"textAlignment"	"east"
		"style"			"Level"
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

	"divider1"
	{
		"ControlName"			"Panel"
		"zpos"					"1"
		"wide"					"240"
		"tall"					"1"
		"visible"				"1"
		"enabled"				"1"
		"style"					"divider"
	}

	"AbilityInfo_CastType"
	{
		"ControlName"		"Label"
		"zpos"			"1"
		"wide"			"200"
		"tall"			"15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"#DOTA_ToolTip_Ability"
		"textAlignment"		"west"
		"style"			"AbilityInfo"
		"auto_wide_tocontents"	"1"
	}

	"AbilityInfo_CastType_Result"
	{
		"ControlName"		"Label"
		"zpos"			"1"
		"wide"			"235"
		"tall"			"15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%casttype%"
		"textAlignment"		"west"
		"style"			"AbilityInfo"
	}

	"AbilityInfo_Targeting"
	{
		"ControlName"		"Label"
		"zpos"			"1"
		"wide"			"235"
		"tall"			"15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"#DOTA_ToolTip_Targeting"
		"textAlignment"		"center"
		"style"			"AbilityInfo"
	}

	"AbilityInfo_Targeting_Result"
	{
		"ControlName"	"Label"
		"fieldName"		"AbilityInfo_Targeting_Result"
		"zpos"			"1"
		"wide"			"235"
		"tall"			"15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%targettype%"
		"textAlignment"	"center"
		"style"			"AbilityInfo"
	}

	"divider2"
	{
		"ControlName"			"EditablePanel"
		"zpos"					"1"
		"wide"					"240"
		"tall"					"1"
		"visible"				"1"
		"enabled"				"1"
		"PaintBackgroundType"	"0"
		"style"					"divider"
	}

	"AbilityDescription"
	{
		"ControlName"		"Label"
		"font" 			"avenirmedium13"
		"zpos"			"1"
		"wide"			"226"
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
		"minimum-width"		"226"
	}

	"AbilityVariables"
	{
		"ControlName"		"RichText"
		"font" 			"avenirmedium12"
		"zpos"			"1"
		"wide"			"226"
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
		"minimum-width"		"226"
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
		"auto_tall_tocontents"	"1"
		"font"			"avenirmedium13"
	}

	"CooldownImage"
	{
		"ControlName"	"ImagePanel"
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
		"auto_tall_tocontents"	"1"
		"font"			"avenirmedium13"
	}
	
	styles
	{
		AbilityName
		{
			textcolor=white
			bgcolor=none
			font=avenirmedium19
		}
				
		Level
		{
			textcolor=white
			font=avenirmedium11
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
			font=avenirmedium11
		}
		
		IconInset
		{
		}
		
		IconProperty
		{
			// inset so it lines up with the text
			inset-left=2
			inset-top=-2
			textcolor=tooltipgrey			
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}	
		
	
	}
	
	layout
	{
		region { name=tooltip x=0 y=0 width=240 height=600 }
		place { region=tooltip margin=7 overflow=allow-both dir=down Controls=AbilityName,divider1,AbilityInfo_CastType,divider2,AbilityDescription,AbilityVariables,CooldownImage spacing=4 }
		
		place { region=tooltip margin=7 margin-top=9 overflow=allow-both dir=right align=right Controls=LevelLabel,LevelLabel_Result spacing=4 }
		
		place { start=CooldownImage dir=right Control=Cooldown,ManaImage,ManaCost }		

		place { start=AbilityInfo_CastType dir=right Controls=AbilityInfo_CastType_Result,AbilityInfo_Targeting margin-left=1 spacing=10 }
		
		place { start=AbilityInfo_Targeting dir=right Controls=AbilityInfo_Targeting_Result margin-left=1 }
	}
}