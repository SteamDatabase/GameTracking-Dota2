"Resource/UI/HUD_Shop_Tip_Panel.res"
{
	"HudShopTipPanel"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"HudShopTipPanel"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"22"
		"wide"				"f0"
		"tall"				"f0"
		"visible"			"1"
		"enabled"			"1"
		"style"				"TempBackground"
	}
	
// 	"Tip"
// 	{
// 		"ControlName"			"EditablePanel"
// 		"fieldName"				"TipBackground"
// 		"xpos"					"0"
// 		"ypos"					"0"
// 		"zpos"					"0"
// 		"wide"					"240"
// 		"tall"					"600"
// 		"visible"				"0"
// 		"enabled"				"1"
// 		"style"					"TooltipBackground"
// 		
// 		"Message"
// 		{	
// 			"ControlName"	"Label"
// 			"fieldName"		"Message"
// 			"zpos"			"1"
// 			"wide"			"235"
// 			"tall"			"10"
// 			"enabled"		"1"
// 			"visible"		"1"
// 			"labeltext"		"%message%"
// 			"textAlignment"	"center"
// 			"style"			"Message"
// 		}
// 		
// 		"CloseButton"
// 		{
// 			"ControlName"		"Button"
// 			"fieldName"			"CloseButton"
// 			"xpos"				"0"
// 			"ypos"				"0"
// 			"zpos"				"3"
// 			"wide"				"15"
// 			"tall"				"15"
// 			"visible"			"1"
// 			"enabled"			"1"
// 			"textAlignment"		"center"
// 			"command"			"close"
// 			"labeltext"			"X"
// 			"style"				"CloseButton"	
// 		}
// 	}
	
	Styles
	{	
		TempBackground
		{
			render
			{
				0="dashedrect( x0, y0, x1, y1, red )"
			}
		}
		
		Message
		{
			textcolor=white
			bgcolor=none
			font=DIN12Thick
		}
		
		CloseButton
		{
			textcolor=white
			bgcolor=none
			font=DIN14Thick
		}
	}	
}