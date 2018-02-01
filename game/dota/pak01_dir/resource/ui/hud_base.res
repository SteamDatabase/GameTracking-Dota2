"Resource/UI/HUD_Base.res"
{
	"HudDOTABase"
	{
		"ControlName"			"EditablePanel"
		"xpos"					"0"
		"ypos"					"0"
		"wide"					"f0"
		"tall"					"768"
		"zpos"					"-500"
		"autoResize"			"0"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"textAlignment"			"west"
		"dulltext"				"0"
		"brighttext"			"1"
		"bgcolor_override"		"0 0 0 0"
		"fgcolor_override"		"0 0 0 255"
		"mouseinputenabled"		"1"

		"multiunit_ypos_levelup"	"40"	// subtract from y pos when the level up button is visible`

		"multiunit_maxwidth"	"110"

		"multiunit_portrait_size"		"32"

		"multiunit_gap"			"4"

		"multiunit_group_gap"	"6"

		"portrait_width"	"110"	// UV coords are adjusted to not squish the portrait
		"portrait_height"	"130"
	}
	
	"MiniMap"
	{
		"ControlName"		"CDOTA_MinimapPanel"
		"bgcolor_override"	"0 0 0 0"
		"xpos_normal"		"0"
		"xpos_hud_flip"		"202"
		"ypos"				"r199"
		"zpos"				"3"
		"wide"				"205"		// account for inset
		"tall"				"200"

		"enabled"			"0"
		"visible"			"1"
	}
}
