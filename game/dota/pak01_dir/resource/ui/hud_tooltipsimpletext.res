"Resource/UI/HUD_Tooltip_ShopTip.res"
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
		
		"margin-right"			"5"
		"margin-bottom"			"5"
	}

	"Message"
	{	
		"ControlName"	"Label"
		"fieldName"		"Message"
		"zpos"			"1"
		"wide"			"235"
		"tall"			"10"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%message%"
		"textAlignment"	"center"
		"style"			"Message"
	}
	
	styles
	{
		Message
		{
			textcolor=white
			bgcolor=none
			font=DIN12Thick
		}
	}

	layout
	{
		region { name=tooltip x=0 y=0 width=235 height=600 }
		place { region=tooltip margin=5 dir=down overflow=allow-both Controls=Message }
	}
}
