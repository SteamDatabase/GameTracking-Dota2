"Resource/UI/HUD_InventoryStash.res"
{
//=====================================================================================================================
//
// Stash.
//

	"HudDOTAInventoryStash"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"HudDOTAInventoryStash"
		"fillcolor"			"0 0 0 255"
		"xpos"				"%70.1"
//		"ypos"				"%57.1"
		"ypos"				"%80.0"
		"zpos"				"-2"
		"wide"				"%11.0"
		"tall"				"%22.9"
		"enabled"			"0"
		"visible"			"1"	
	}

	"InventoryBackground1"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryBackground1"
		"fillcolor"			"0 0 0 255"
		"xpos"				"%0.0"
		"ypos"				"%0.0"
		"zpos"				"-1"
		"wide"				"%11.0"
		"tall"				"%22.9"
		"enabled"			"1"
		"visible"			"1"
	}

	"InventoryBackground2"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryBackground2"
		"fillcolor"			"36 36 36 255"
		"xpos"				"%0.3"
		"ypos"				"%0.4"
		"zpos"				"0"
		"wide"				"%10.4"
		"tall"				"%22.1"
		"enabled"			"1"
		"visible"			"1"
	}

//=====================================================================================================================
//
// Stash Heading.
//

	"InventoryLabel"
	{
		"ControlName"		"Label"
		"fieldName"			"InventoryLabel"
		"xpos"				"%0.6"
		"ypos"				"%0.0"
		"zpos"				"3"
		"wide"				"%4.0"
		"tall"				"%1.6"
		"enabled"			"1"
		"textAlignment"		"left"
		"labelText"			"#DOTA_InventoryStash"
		"font" 				"Arial10Thick"
		"fgColor_override" 	"150 150 150 255"
		"bgcolor_override"	"0 0 0 0"
	}

//=====================================================================================================================
//
// Stash Buttons.
//

	"InventoryButton_0"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"InventoryButton_0"
		"xpos"				"%0.6"
		"ypos"				"%1.6"
		"zpos"				"4"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		
	}

	"InventoryButtonBackground_0"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryButtonBackground_0"
		"xpos"				"%0.6"
		"ypos"				"%1.6"
		"zpos"				"3"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
	}

	"InventoryButton_1"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"InventoryButton_1"
		"xpos"				"%3.9"
		"ypos"				"%1.6"
		"zpos"				"4"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		
	}

	"InventoryButtonBackground_1"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryButtonBackground_1"
		"xpos"				"%3.9"
		"ypos"				"%1.6"
		"zpos"				"3"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
	}

	"InventoryButton_2"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"InventoryButton_2"
		"xpos"				"%7.2"
		"ypos"				"%1.6"
		"zpos"				"4"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		
	}

	"InventoryButtonBackground_2"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryButtonBackground_2"
		"xpos"				"%7.2"
		"ypos"				"%1.6"
		"zpos"				"3"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"enabled"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
	}

	"InventoryButton_3"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"InventoryButton_3"
		"xpos"				"%0.6"
		"ypos"				"%5.8"
		"zpos"				"4"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		
	}

	"InventoryButtonBackground_3"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryButtonBackground_3"
		"xpos"				"%0.6"
		"ypos"				"%5.8"
		"zpos"				"3"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
	}

	"InventoryButton_4"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"InventoryButton_4"
		"xpos"				"%3.9"
		"ypos"				"%5.8"
		"zpos"				"4"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		
	}

	"InventoryButtonBackground_4"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryButtonBackground_4"
		"xpos"				"%3.9"
		"ypos"				"%5.8"
		"zpos"				"3"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
	}

	"InventoryButton_5"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"InventoryButton_5"
		"xpos"				"%7.2"
		"ypos"				"%5.8"
		"zpos"				"4"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		
	}

	"InventoryButtonBackground_5"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryButtonBackground_5"
		"xpos"				"%7.2"
		"ypos"				"%5.8"
		"zpos"				"3"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
	}

	"InventoryButton_6"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"InventoryButton_6"
		"xpos"				"%0.6"
		"ypos"				"%9.9"
		"zpos"				"4"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		
	}

	"InventoryButtonBackground_6"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryButtonBackground_6"
		"xpos"				"%0.6"
		"ypos"				"%9.9"
		"zpos"				"3"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
	}

	"InventoryButton_7"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"InventoryButton_7"
		"xpos"				"%3.9"
		"ypos"				"%9.9"
		"zpos"				"4"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		
	}

	"InventoryButtonBackground_7"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryButtonBackground_7"
		"xpos"				"%3.9"
		"ypos"				"%9.9"
		"zpos"				"3"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
	}

	"InventoryButton_8"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"InventoryButton_8"
		"xpos"				"%7.2"
		"ypos"				"%9.9"
		"zpos"				"4"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		
	}

	"InventoryButtonBackground_8"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryButtonBackground_8"
		"xpos"				"%7.2"
		"ypos"				"%9.9"
		"zpos"				"3"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
	}

	"InventoryButton_9"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"InventoryButton_9"
		"xpos"				"%0.6"
		"ypos"				"%14.1"
		"zpos"				"4"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		
	}

	"InventoryButtonBackground_9"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryButtonBackground_9"
		"xpos"				"%0.6"
		"ypos"				"%14.1"
		"zpos"				"3"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
	}

	"InventoryButton_10"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"InventoryButton_10"
		"xpos"				"%3.9"
		"ypos"				"%14.1"
		"zpos"				"4"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		
	}

	"InventoryButtonBackground_10"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryButtonBackground_10"
		"xpos"				"%3.9"
		"ypos"				"%14.1"
		"zpos"				"3"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
	}

	"InventoryButton_11"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"InventoryButton_11"
		"xpos"				"%7.2"
		"ypos"				"%14.1"
		"zpos"				"4"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		
	}

	"InventoryButtonBackground_11"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryButtonBackground_11"
		"xpos"				"%7.2"
		"ypos"				"%14.1"
		"zpos"				"3"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
	}

	"InventoryButton_12"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"InventoryButton_12"
		"xpos"				"%0.6"
		"ypos"				"%18.3"
		"zpos"				"4"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		
	}

	"InventoryButtonBackground_12"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryButtonBackground_12"
		"xpos"				"%0.6"
		"ypos"				"%18.3"
		"zpos"				"3"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
	}

	"InventoryButton_13"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"InventoryButton_13"
		"xpos"				"%3.9"
		"ypos"				"%18.3"
		"zpos"				"4"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		
	}

	"InventoryButtonBackground_13"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryButtonBackground_13"
		"xpos"				"%3.9"
		"ypos"				"%18.3"
		"zpos"				"3"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
	}

	"InventoryButton_14"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"InventoryButton_14"
		"xpos"				"%7.2"
		"ypos"				"%18.3"
		"zpos"				"4"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		
	}

	"InventoryButtonBackground_14"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InventoryButtonBackground_14"
		"xpos"				"%7.2"
		"ypos"				"%18.3"
		"zpos"				"3"
		"wide"				"%3.0"
		"tall"				"%3.8"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
	}
}