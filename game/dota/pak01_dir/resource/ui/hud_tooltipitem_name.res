"Resource/UI/HUD_TooltipItem_Name.res"
{
	"dota_tooltip"
	{
		"ControlName"			"EditablePanel"
		"fieldName"				"dota_tooltip"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"0"
		"wide"					"240"
		"tall"					"610"
		"visible"				"0"
		"enabled"				"1"
		"style"					"TooltipBackground"
		"margin-right"		"5"
		"margin-bottom"		"5"
	}

	"AbilityName"
	{
		"ControlName"		"Label"
		"fieldName"		"AbilityName"
		"zpos"			"1"
		"wide"			"235"
		"tall"			"15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%abilityname%"
		"textAlignment"		"west"
		"style"			"AbilityName"
	}
	
	styles
	{
 		AbilityName
 		{
 			textcolor=white
 			bgcolor=none
 			font=DIN14Thick
 		}
	}
			
	layout
	{
		region { name=tooltip x=0 y=0 width=235 height=600 }
		place { region=tooltip margin=5 dir=down Controls=AbilityName }
	}
}
