"Resource/UI/HUD_TooltipBuff.res"
{
	"dota_tooltip"
	{
		"ControlName"			"EditablePanel"
		"fieldName"				"dota_tooltip"
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

	"Name"
	{
		"ControlName"	"Label"
		"zpos"			"1"
		"wide"			"235"
		"tall"			"15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%name%"
		"textAlignment"	"west"
		"style"			"AbilityName"
	}

	"LevelLabel"
	{
		"ControlName"	"Label"
		"zpos"			"1"
		"wide"			"235"
		"tall"			"15"
		"enabled"		"1"
		"visible"		"0"
		"labeltext"		"#DOTA_ToolTip_Level"
		"textAlignment"		"west"
		"style"			"Level"
		"minimum-height"	"15"
	}
	
	"LevelLabel_Result"
	{
		"ControlName"	"Label"
		"zpos"			"1"
		"wide"			"5"
		"tall"			"5"
		"enabled"		"1"
		"visible"		"0"
		"labeltext"		"%level%"
		"textAlignment"	"west"
		"style"			"Level"
		"minimum-height"	"15"
	}

	"divider"
	{
		"ControlName"			"Panel"
		"zpos"					"1"
		"wide"					"219"
		"tall"					"1"
		"visible"				"1"
		"enabled"				"1"
		"style"					"divider"
	}

	"Description"
	{
		"ControlName"		"Label"
		"font" 			"Arial10Thick"
		"zpos"			"1"
		"wide"			"216"
		"tall"			"5"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%description%"
		"textAlignment"		"west"
		"bgcolor_override"	"0 151 0 0"
		"fgcolor_override"	"255 255 255 175"
		"scrollbar"		"false"
		"wrap"	"1"
		"auto_tall_tocontents"	"1"
		"minimum-width"		"216"
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
		place { region=tooltip margin=7 overflow=allow-both dir=down Controls=Name,divider,Description spacing=4 }
		place { region=tooltip margin=7 overflow=allow-both dir=right align=right Controls=LevelLabel,LevelLabel_Result spacing=4 }

	}
}
