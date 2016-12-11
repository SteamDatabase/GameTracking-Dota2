"Resource/UI/HUD_TooltipRune.res"
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
		"style"					"TooltipBackground"
		
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
		"style"			"TooltipName"
	}

	"divider"
	{
		"ControlName"	"Panel"
		"zpos"			"1"
		"wide"			"219"
		"tall"			"1"
		"visible"		"1"
		"enabled"		"1"
		"style"			"TooltipDivider"
	}

	"Description"
	{
		"ControlName"	"Label"
		"font" 			"Arial10Thick"
		"xpos"			"-5"
		"ypos"			"-3"
		"zpos"			"1"
		"wide"			"219"
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
		"minimum-width"	"235"
	}

	layout
	{
		region { name=tooltip x=0 y=0 width=235 height=600 }
		place { region=tooltip margin=7 overflow=allow-both dir=down Controls=Name,divider,Description spacing=4 }
	}
}
