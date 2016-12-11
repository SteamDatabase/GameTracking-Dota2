"Resource/UI/HUD_UnitMultiElem.res"
{
	"HudUnitMultiElem"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"HudUnitMultiElem"
		"xpos"				"%0.0"
		"ypos"				"%0.0"
		"zpos"				"-0.8"
		"wide"				"%3.75"
		"tall"				"%6.5"
		"visible"			"1"
		"enabled"			"1"
	}

	"UnitBackground1"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"UnitBackground1"
		"fillcolor"			"36 36 36 255"
		"xpos"				"0"
		"ypos"				"5"
		"zpos"				"0"
		"wide"				"37"
		"tall"				"45"
		"enabled"			"1"
		"visible"			"1"
	}

	"UnitHealth"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"			"UnitHealth"
		"xpos"				"2"
		"ypos"				"6"
		"wide"				"33"
		"tall"				"5"
		"zpos"				"6"
		"visible"			"1"
		"enabled"			"1"
		"horizontal"		"1"
		"image"				"materials/vgui\hud\bar_health_new.vmat"
 		"color"				"255 255 255 0"
		"bgcolor_override"	"51 51 51 255"
	}

	"UnitPortraitModel"
	{
		"ControlName"		"Button"
		"fieldName"			"UnitPortraitModel"
		"xpos"				"0"
		"ypos"				"5"
		"zpos"				"5"
		"wide"				"37"
		"tall"				"45"
		"autoResize"		"0"
		"pinCorner"			"0"
		"visible"			"1"
		"enabled"			"1"
		"fov"				"20"
		"start_framed"		"0"
		
		"model"
		{
			"modelname"			"models/heroes/windrunner.mdl"
			"skin"				"0"
			"angles_y"			"60"
			"origin_x"			"0"
			"origin_x_lodef"	"0"
			"origin_x_hidef"	"0"
			"origin_y"			"0"
			"origin_z"			"0"
		}
	}	
}
