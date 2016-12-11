"Resource/UI/HUD_InventoryOverflow.res"
{

//=====================================================================================================================
//
// Overflow.
//

	"HudDOTAInventoryOverflow"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"HudDOTAInventoryOverflow"
		"fillcolor"			"0 0 0 255"
		"xpos"				"%83.0"
		"ypos"				"%80.0"
		"zpos"				"-2"
		"wide"				"%10.7"
		"tall"				"%9.3"
		"enabled"			"0"
		"visible"			"1"	
	}

	"InventoryOverflowBackground1"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryOverflowBackground1"
		"fillcolor"			"0 0 0 255"
		"xpos"				"%0.0"
		"ypos"				"%0.0"
		"zpos"				"-1"
		"wide"				"%10.7"
		"tall"				"%9.3"
		"enabled"			"1"
		"visible"			"1"
	}

	"InventoryOverflowBackground2"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryOverflowBackground2"
		"fillcolor"			"36 36 36 255"
		"xpos"				"%0.3"
		"ypos"				"%0.4"
		"zpos"				"0"
		"wide"				"%10.2"
		"tall"				"%8.5"
		"enabled"			"1"
		"visible"			"1"
	}
	
//=====================================================================================================================
//
// Overflow Heading.
//

	"OverflowLabel"
	{
		"ControlName"		"Label"
		"fieldName"			"OverflowLabel"
		"xpos"				"%0.6"
		"ypos"				"%0.0"
		"zpos"				"3"
		"wide"				"%4.0"
		"tall"				"%1.6"
		"enabled"			"1"
		"textAlignment"		"left"
		"labelText"			"#DOTA_InventoryOverflow"
		"font" 				"Arial10Thick"
		"fgColor_override" 	"150 150 150 255"
		"bgcolor_override"	"0 0 0 0"
	}
	
	"OverflowMessage"
	{
		"ControlName"		"Label"
		"fieldName"			"OverflowMessage"
		"xpos"				"%0.6"
		"ypos"				"%1.6"
		"zpos"				"3"
		"wide"				"%10.2"
		"tall"				"%3.2"
		"enabled"			"1"
		"wrap"				"1"
		"labelText"			"#DOTA_InventoryOverflowMsg"
		"font" 				"Arial10Thick"
		"fgColor_override" 	"150 150 150 255"
		"bgcolor_override"	"0 0 0 0"
	}

//=====================================================================================================================
//
// Stash Buttons.
//

	"OverflowButton_0"
	{
		"ControlName"		"Button"
		"fieldName"			"OverflowButton_0"
		"xpos"				"%0.6"
		"ypos"				"%4.8"
		"zpos"				"4"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		"ability_tooltip"	"1"
	}

	"OverflowButtonBackground_0"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"OverflowButtonBackground_0"
		"xpos"				"%0.6"
		"ypos"				"%4.8"
		"zpos"				"3"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
	}

	"OverflowButton_1"
	{
		"ControlName"		"Button"
		"fieldName"			"OverflowButton_1"
		"xpos"				"%3.9"
		"ypos"				"%4.8"
		"zpos"				"4"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		"ability_tooltip"	"1"
	}

	"OverflowButtonBackground_1"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"OverflowButtonBackground_1"
		"xpos"				"%3.9"
		"ypos"				"%4.8"
		"zpos"				"3"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
	}

	"OverflowButton_2"
	{
		"ControlName"		"Button"
		"fieldName"			"OverflowButton_2"
		"xpos"				"%7.2"
		"ypos"				"%4.8"
		"zpos"				"4"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		"ability_tooltip"	"1"
	}

	"OverflowButtonBackground_2"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"OverflowButtonBackground_2"
		"xpos"				"%7.2"
		"ypos"				"%4.8"
		"zpos"				"3"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"enabled"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
	}
}
