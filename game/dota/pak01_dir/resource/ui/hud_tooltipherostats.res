"Resource/UI/HUD_TooltipHeroStats.res"
{
	"dota_tooltip"
	{
		"ControlName"			"EditablePanel"
		"fieldName"				"dota_tooltip"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"0"
		"wide"					"150"
		"tall"					"600"
		"visible"				"0"
		"enabled"				"1"
		"style"					"tooltipbackground"
		
		"margin-right"			"7"
		"margin-bottom"			"7"
	}

	"unitname"
	{
		"ControlName"	"Label"
		"fieldName"		"unitname"
		"zpos"			"1"		
		"wide"			"235"
		"tall"			"15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%unitname%"
		"textAlignment"	"west"
		"style"			"AbilityName"
	}
	
	"divider"
	{
		"ControlName"			"Panel"
		"fieldName"				"divider"
		"zpos"					"1"
		"wide"					"219"
		"tall"					"1"
		"visible"				"1"
		"enabled"				"1"
		"style"					"divider"
	}

	"unitstrength"
	{
		"ControlName"		"Label"
		"fieldName"		"unitstrength"
		"font" 			"Arial10Thick"
		"xpos"			"-5"
		"ypos"			"-3"
		"zpos"			"1"
		"wide"			"219"
		"tall"			"16"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%unitstrength%"
		"textAlignment"		"west"
		"bgcolor_override"	"0 151 0 0"
		"fgcolor_override"	"255 255 255 175"
		"auto_tall_tocontents"	"1"
		"minimum-width"		"100"
		group=stats
		minimum-height=16
	}
	"unitintellect"
	{
		"ControlName"		"Label"
		"fieldName"		"unitintellect"
		"font" 			"Arial10Thick"
		"xpos"			"-5"
		"ypos"			"-3"
		"zpos"			"1"
		"wide"			"219"
		"tall"			"16"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%unitintellect%"
		"textAlignment"		"west"
		"bgcolor_override"	"0 151 0 0"
		"fgcolor_override"	"255 255 255 175"
		"auto_tall_tocontents"	"1"
		"minimum-width"		"100"
		group=stats
		minimum-height=16
	}
	"unitagility"
	{
		"ControlName"		"Label"
		"fieldName"		"unitagility"
		"font" 			"Arial10Thick"
		"xpos"			"-5"
		"ypos"			"-3"
		"zpos"			"1"
		"wide"			"219"
		"tall"			"16"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%unitagility%"
		"textAlignment"		"west"
		"bgcolor_override"	"0 151 0 0"
		"fgcolor_override"	"255 255 255 175"
		"auto_tall_tocontents"	"1"
		"minimum-width"		"100"
		group=stats
		minimum-height=16
	}
	
	// ----
	
	"unitstrengthicon"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"unitstrengthicon"
		"xpos"			"-5"
		"ypos"			"-3"
		"zpos"			"1"
		"wide"			"16"
		"tall"			"16"
		"minimum-width"	"16"
		"minimum-height""16"
		scaleimage=1
		image="hud/hudicons/attr_strength"
		group=stats
	}
	"unitintellecticon"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"unitintellecticon"
		"xpos"			"-5"
		"ypos"			"-3"
		"zpos"			"1"
		"wide"			"16"
		"tall"			"16"
		"minimum-width"	"16"
		"minimum-height""16"
		scaleimage=1
		image="hud/hudicons/attr_intelligence"
		group=stats
	}
	"unitagilityicon"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"unitagilityicon"
		"xpos"			"-5"
		"ypos"			"-3"
		"zpos"			"1"
		"wide"			"16"
		"tall"			"16"
		"minimum-width"	"16"
		"minimum-height""16"
		scaleimage=1
		image="hud/hudicons/attr_agility"
		group=stats
	}

	styles
	{
		AbilityName
		{
			textcolor=white
			bgcolor=none
			font=DIN14Thick
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
		region { name=tooltip x=0 y=0 width=150 height=600 margin=7 }
		place { region=tooltip dir=down Controls=unitname,divider,unitstrength,unitintellect,unitagility spacing=4 }
		
		place { start=divider dir=down Controls=unitstrengthicon,unitintellecticon,unitagilityicon spacing=4 margin-top=5 }
		
		region { name=stats x=15 y=10 width=235 height=600 margin=7 }
		place { start=unitstrengthicon dir=right Controls=unitstrength margin-left=5 }
		place { start=unitintellecticon dir=right Controls=unitintellect margin-left=5 }
		place { start=unitagilityicon dir=right Controls=unitagility margin-left=5 }
	}
}
