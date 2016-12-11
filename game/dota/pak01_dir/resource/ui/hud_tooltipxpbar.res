"Resource/UI/HUD_TooltipXPBar.res"
{
	"dota_tooltip"
	{
		"ControlName"			"EditablePanel"
		"fieldName"				"dota_tooltip"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"0"
		"wide"					"100"
		"tall"					"600"
		"visible"				"0"
		"enabled"				"1"
		"style"					"TooltipBackground"
		"inset"					"0"
		
		"margin-right"			"5"
		"margin-bottom"			"5"
	}

	"XP"
	{
		"ControlName"	"Label"
		"fieldName"		"XP"
		"zpos"			"1"
		"wide"			"100"
		"tall"			"15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%xp%"
		"textAlignment"	"west"
		"style"			"TooltipName"
	}

	layout
	{
		region { name=tooltip x=0 y=0 width=max height=600 }
		place { region=tooltip margin=5 Controls=XP }
	}
}
