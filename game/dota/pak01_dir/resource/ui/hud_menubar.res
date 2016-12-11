"Resource/UI/HUD_MenuBar.res"
{
	"HudDOTAMenuBar"
	{
		"ControlName"			"EditablePanel"
		"fieldName"				"HudDOTAMenuBar"
		"xpos"					"r108"
		"ypos"					"r198"
		"wide"					"100"
		"tall"					"12"
		"zpos"					"0"
		"visible"				"1"
		"enabled"				"1"
		"bgcolor_override"		"0 0 0 0"
		"mouseinputenabled"		"1"
	}
			
	"CombatLogButton"
	{
		"ControlName"		"Button"
		"fieldName"			"CombatLogButton"
		"zpos"				"1"
		"wide"				"100"
		"tall"				"12"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"east"
		"command"			"togglecombatlog"
		"labeltext"			"LOG"
		"style"				"MenuButton"
		"mouseinputenabled"	"1"
		"minimum-width"		"40"
	}
	
	Colors
	{
		MenuHighlight="50 50 50 255"
	}
	
	styles
	{		
		MenuButton
		{
			font=Arial12Thick
			bgcolor=none
			render_bg
			{
				0="fill(x0, y0, x1, y1, none)"
			}
		}
		
		MenuButton:hover
		{
			render_bg
			{
				0="fill(x0, y0, x1, y1, MenuHighlight)"
			}
		}
	}
	
	Layout
	{	
		region { name=Everything x=0 y=0 width=max height=max }
		place { region=Everything align=right Controls=CombatLogButton }
	}	
}
