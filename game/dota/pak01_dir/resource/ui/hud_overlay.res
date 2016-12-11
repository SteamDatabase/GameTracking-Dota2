"Resource/UI/HUD_Overlay.res"
{
	"HudDOTAOverlay"
	{
		"ControlName"			"EditablePanel"
		"fieldName"				"HudDOTAOverlay"
		"xpos"					"0"
		"ypos"					"0"
		"wide"					"f0"
		"tall"					"768"
		"zpos"					"0"
		"visible"				"1"
		"enabled"				"1"
		"bgcolor_override"		"0 0 0 0"
		"mouseinputenabled"		"0"
	}
	
	"LeftTop"
	{
		"ControlName"		"Panel"
		"fieldName"			"LeftTop"
		"xpos"				"0"
		"ypos"				"r315"
		"zpos"				"1"
		"wide"				"320"
		"tall"				"325"
		"visible"			"0"
		"style"				"LeftTop"
		"bgcolor_override"	"0 0 0 0"	
	}
	
	"MidTop"
	{
		"ControlName"		"Panel"
		"fieldName"			"MidTop"
		"xpos"				"0"
		"ypos"				"r216"
		"zpos"				"2"
		"wide"				"f0"
		"tall"				"82"
		"visible"			"1"
		"style"				"MidTop"
		"bgcolor_override"	"0 0 0 0"		
	}
	
	"RightTop"
	{
		"ControlName"		"Panel"
		"fieldName"			"RightTop"
		"xpos"				"r322"
		"ypos"				"r304"
		"zpos"				"1"
		"wide"				"325"
		"tall"				"332"
		"visible"			"0"
		"style"				"RightTop"	
		"bgcolor_override"	"0 0 0 0"
	}
	
	"BackgroundClock"
	{
		"ControlName"		"Label"
		"fieldName"			"BackgroundClock"
		"zpos"				"3"
		"xpos"				"c-30"
		"ypos"				"15"
		"wide"				"60"
		"tall"				"15"
		"minimum-width"		"60"
		"minimum-height"	"15"
		"enabled"			"1"
		"visible"			"1"
		"textAlignment"		"center"
		"labelText"			""
		"style"				"Clock"
	}	
	
	Colors
	{
	}
	
	styles
	{
		LeftTop
		{
			render
			{			
				0="image_scale( x0, y0, x1, y1, materials/vgui/hud/left_cap.vmat )"
			}
		}
		
		MidTop
		{
			render
			{
				0="image_tiled_horiz( x0, y0, x1, y1, hud/top_cap )"
			}
		}
					
		RightTop
		{
			render
			{
				0="image_scale( x0, y0, x1, y1, materials/vgui/hud/right_cap.vmat )"
			}
		}
		
		Clock
		{
			textcolor=Text
			font=Arial14Thick
		}
	}
	
	Layout
	{	
	}	
}
