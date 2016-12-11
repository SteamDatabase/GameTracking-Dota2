"Resource/UI/HUD_TooltipShopTip.res"
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
		"wrap"			"1"
		"tall"			"20"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%message%"
		"textAlignment"	"center"
		"style"			"Message"
	}

	// Currently a fake button - since the tip doesn't get mouse input we will never click this
	// however, clicking outside the shop ( and on the tip ) closes the shop and we get the desired
	// effect.
	"CloseButton"
	{
		"ControlName"		"Button"
		"fieldName"			"CloseButton"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"3"
		"wide"				"15"
		"tall"				"15"
		"minimum-width"		"15"
		"minimum-height"	"15"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		"command"			"close"
		"labeltext"			"X"
		"style"				"CloseButton"	
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
		place { region=tooltip margin=5 dir=down Controls=Message }
		place { region=tooltip margin=5 align=right Control=CloseButton }
	}
}
