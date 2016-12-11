"Resource/UI/HUD_UnitStatus.res"
{
	"HudDOTAUnitSingleDebuff"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"HudDOTAUnitSingleDebuff"
		"xpos"				"0"
		"ypos"				"5"
		"zpos"				"10"
		"wide"				"42"
		"tall"				"42"
		"visible"			"1"
		"enabled"			"1"
		"fgcolor_override"	"0 0 0 0"
		"bgcolor_override"	"0 0 0 0"
	}

	"BackgroundImage"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"			"BackgroundImage"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"1"
		"wide"				"42"
		"tall"				"42"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"image"				"materials/vgui/hud/ui_debuff_tab_red.vmat"
		"background_image"	"materials/vgui/hud/ui_debuff_tab_timer.vmat"
	}

	"DebuffImage"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"			"DebuffImage"
		"xpos"				"9"
		"ypos"				"9"
		"zpos"				"2"
		"wide"				"25"
		"tall"				"25"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
	}
	
	"StackCount"
	{
		"ControlName"		"Label"
		"fieldName"			"StackCount"
		"xpos"				"9"
		"ypos"				"10"
		"zpos"				"3"
		"wide"				"25"
		"tall"				"25"
		"enabled"			"1"
		"textAlignment"		"south-east"
		"labelText"			""
		"font" 				"HudUnitSmall"
		"fgColor_override" 	"255 255 255 255"
		"bgcolor_override"	"26 26 26 0"	
	}
}
