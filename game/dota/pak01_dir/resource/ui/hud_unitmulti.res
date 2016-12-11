"Resource/UI/HUD_UnitMulti.res"
{
	"HudUnitMulti"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"HudUnitMulti"
		"bgcolor_override"  "0 0 0 0"
		"fgcolor_override"  "0 0 0 0"
		"xpos"				"225"
		"ypos"				"540"
		"zpos"				"0"
		"wide"				"%35.0"
		"tall"				"%7.0"
		"visible"			"1"
		"enabled"			"1"
		
		"style" "multistyle"
	}
	
	
	
	styles
	{
		multistyle 
		{ 
			render_bg
			{
				0="roundedfill( x0, y0, x1, y1, 5, killcamgrey)"
			//	1="fill( x0+1, y0+1, x1-1, y1-1, black)"
			}
		}
	}
	
	colors
	{
		killcamred="75 9 7 255"
		killcamgrey="125 125 125 255"
	}
}
