"Resource/UI/HUD_UnitQueryStatus.res"
{

	"HudUnitQueryStatus"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"HudUnitQueryStatus"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"10"
		"wide"				"120"
		"tall"				"83"
		"visible"			"0"
		"enabled"			"1"
	}
	
	"QueryStatusBackground"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"QueryStatusBackground"
		"fillcolor"			"36 36 36 255"
		"xpos"				"0"
		"ypos"				"10"
		"zpos"				"11"
		"wide"				"120"
		"tall"				"73"
		"enabled"			"1"
		"visible"			"1"	
//		"scaleImage"		"1"
//		"image"				"materials/vgui/hud\panel_query.vmat"
	}
		
//=====================================================================================================================
//
// Name and Level.
//

	"Name"
	{
		"ControlName"			"Label"
		"fieldName"				"Name"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"12"
		"wide"					"80"
		"tall"					"10"
		"visible"				"1"
		"enabled"				"1"
		"labelText"				""
		"textAlignment"			"west"
		"font"					"Arial12Thick"
		"fgColor_override" 		"36 36 36 255"
		"bgcolor_override"		"0 255 255 255"
	}

	"NameBar"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"NameBar"
		"fillcolor"				"0 255 255 255"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"12"
		"wide"					"5"
		"tall"					"73"
		"visible"				"1"
		"enabled"				"1"

		"pin_to_sibling"			"Name"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"	
	}

	"LevelLabel"
	{
		"ControlName"		"Label"
		"fieldName"			"LevelLabel"
		"xpos"				"8"
		"ypos"				"30"
		"zpos"				"13"
		"wide"				"30"
		"tall"				"7"
		"enabled"			"1"
		"textAlignment"		"west"
		"labelText"			"#DOTA_Scoreboard_Header_Level"
		"font" 				"Arial10Thick"
		"fgColor_override" 	"150 150 150 255"
		"bgcolor_override"	"51 51 51 0"		
	}

	"UnitQueryLevel"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitQueryLevel"
		"xpos"				"8"
		"ypos"				"38"
		"zpos"				"13"
		"wide"				"30"
		"tall"				"16"
		"enabled"			"1"
		"textAlignment"		"center"
		"labelText"			"%unitquerylevel%"
		"font" 				"Arial16Thick"
		"fgColor_override" 	"255 255 139 255"
		"bgcolor_override"	"51 51 51 0"
	}

//=====================================================================================================================
//
// Health & Mana.
//

// 	"UnitQueryBackground"
// 	{
// 		"ControlName"			"ImagePanel"
// 		"fieldName"				"UnitQueryBackground"
// 		"fillcolor"				"46 43 39 255"
// 		"xpos"					"%5.35"
// 		"ypos"					"%8.2"
// 		"zpos"					"7"
// 		"wide"					"%10.25"
// 		"tall"					"%2.7"
// 		"enabled"				"1"
// 		"scaleImage"			"1"
// 		"visible"				"1"
// 		"PaintBackgroundType"	"2"	
// 	}

	"UnitQueryHealth"
	{
		"ControlName"			"CDOTAFilledImage"
		"fieldName"				"UnitQueryHealth"
		"xpos"					"8"
		"ypos"					"12"
		"zpos"					"12"
		"wide"					"110"
		"tall"					"9"
		"visible"				"1"
		"enabled"				"1"
		"horizontal"			"1"
		"image"					"materials/vgui\hud\ui_progressbar_horizontal.vmat"
		"color"					"139 195 58 255"
		"bgcolor_override"		"51 51 51 255"
	}

	"UnitQueryHealthLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"UnitQueryHealthLabel"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"13"
		"wide"					"110"
		"tall"					"9"
		"enabled"				"1"
		"textAlignment"			"east"
		"labelText"				"%healthquerylabel%"
		"font" 					"Arial12Thick"
		"fgColor_override" 		"255 255 139 255"
		"bgcolor_override"		"26 26 26 0"

		"pin_to_sibling"			"UnitQueryHealth"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"0"	
	}

	"UnitQueryMana"
	{
		"ControlName"			"CDOTAFilledImage"
		"fieldName"				"UnitQueryMana"
		"xpos"					"0"
		"ypos"					"-1"
		"zpos"					"12"
		"wide"					"110"
		"tall"					"9"
		"visible"				"1"
		"enabled"				"1"
		"horizontal"			"1"
		"image"					"materials/vgui\hud\ui_progressbar_horizontal.vmat"
		"color"					"2 87 170 255"
		"bgcolor_override"		"51 51 51 255"
		
		"pin_to_sibling"			"UnitQueryHealth"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"	
	}

	"UnitQueryManaLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"UnitQueryManaLabel"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"13"
		"wide"					"110"
		"tall"					"9"
		"enabled"				"1"
		"textAlignment"			"east"
		"labelText"				"%manaquerylabel%"
		"font" 					"Arial12Thick"
		"fgColor_override" 		"0 197 229 255"
		"bgcolor_override"		"26 26 26 0"
		
		"pin_to_sibling"			"UnitQueryMana"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"0"			
	}

//=====================================================================================================================
//
// Inventory.
//
	
		"InventoryButton_0"
		{
			"ControlName"		"CDOTAButton"
			"fieldName"			"InventoryButton_0"
			"xpos"				"43"
			"ypos"				"31"
			"zpos"				"14"
			"wide"				"24"
			"tall"				"24"
			"visible"			"0"
			"enabled"			"1"
			"textAlignment"		"center"
		}
	
		"InventoryButtonBackground_0"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"InventoryButtonBackground_0"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"13"
			"wide"				"24"
			"tall"				"24"
			"enabled"			"1"
			"visible"			"1"
			"scaleImage"		"1"
			"image"				"materials/vgui/hud\ui_skill_notlearned.vmat"

			"pin_to_sibling"			"InventoryButton_0"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"0"			
		}
	
		"InventoryButton_1"
		{
			"ControlName"		"CDOTAButton"
			"fieldName"			"InventoryButton_1"
			"xpos"				"2"
			"ypos"				"0"
			"zpos"				"14"
			"wide"				"24"
			"tall"				"24"
			"visible"			"0"
			"enabled"			"1"
			"textAlignment"		"center"
			
			"pin_to_sibling"			"InventoryButton_0"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"1"			
		}
	
		"InventoryButtonBackground_1"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"InventoryButtonBackground_1"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"13"
			"wide"				"24"
			"tall"				"24"
			"enabled"			"1"
			"visible"			"1"
			"scaleImage"		"1"
			"image"				"materials/vgui/hud\ui_skill_notlearned.vmat"

			"pin_to_sibling"			"InventoryButton_1"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"0"			
		}
	
		"InventoryButton_2"
		{
			"ControlName"		"CDOTAButton"
			"fieldName"			"InventoryButton_2"
			"xpos"				"2"
			"ypos"				"0"
			"zpos"				"14"
			"wide"				"24"
			"tall"				"24"
			"visible"			"0"
			"enabled"			"1"
			"textAlignment"		"center"

			"pin_to_sibling"			"InventoryButton_1"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"1"			
		}
	
		"InventoryButtonBackground_2"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"InventoryButtonBackground_2"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"13"
			"wide"				"24"
			"tall"				"24"
			"enabled"			"1"
			"scaleImage"		"1"
			"visible"			"1"
			"image"				"materials/vgui/hud\ui_skill_notlearned.vmat"

			"pin_to_sibling"			"InventoryButton_2"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"0"			
		}
	
		"InventoryButton_3"
		{
			"ControlName"		"CDOTAButton"
			"fieldName"			"InventoryButton_3"
			"xpos"				"0"
			"ypos"				"2"
			"zpos"				"14"
			"wide"				"24"
			"tall"				"24"
			"visible"			"0"
			"enabled"			"1"
			"textAlignment"		"center"

			"pin_to_sibling"			"InventoryButton_0"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"2"			
		}
	
		"InventoryButtonBackground_3"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"InventoryButtonBackground_3"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"13"
			"wide"				"24"
			"tall"				"24"
			"enabled"			"1"
			"scaleImage"		"1"
			"visible"			"1"
			"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"

			"pin_to_sibling"			"InventoryButton_3"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"0"			
		}
	
		"InventoryButton_4"
		{
			"ControlName"		"CDOTAButton"
			"fieldName"			"InventoryButton_4"
			"xpos"				"2"
			"ypos"				"0"
			"zpos"				"14"
			"wide"				"24"
			"tall"				"24"
			"visible"			"0"
			"enabled"			"1"
			"textAlignment"		"center"

			"pin_to_sibling"			"InventoryButton_3"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"1"			
		}
	
		"InventoryButtonBackground_4"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"InventoryButtonBackground_4"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"13"
			"wide"				"24"
			"tall"				"24"
			"enabled"			"1"
			"scaleImage"		"1"
			"visible"			"1"
			"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"

			"pin_to_sibling"			"InventoryButton_4"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"0"			
		}
	
		"InventoryButton_5"
		{
			"ControlName"		"CDOTAButton"
			"fieldName"			"InventoryButton_5"
			"xpos"				"2"
			"ypos"				"0"
			"zpos"				"14"
			"wide"				"24"
			"tall"				"24"
			"visible"			"0"
			"enabled"			"1"
			"textAlignment"		"center"

			"pin_to_sibling"			"InventoryButton_4"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"1"			
		}
	
		"InventoryButtonBackground_5"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"InventoryButtonBackground_5"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"13"
			"wide"				"24"
			"tall"				"24"
			"enabled"			"1"
			"scaleImage"		"1"
			"visible"			"1"
			"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"

			"pin_to_sibling"			"InventoryButton_5"
			"pin_corner_to_sibling"		"0"
			"pin_to_sibling_corner"		"0"			
		}
	
//=====================================================================================================================
//
// Combat Stats.
//
	
	"UnitQueryDamage"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"UnitQueryDamage"
		"fillcolor"				"36 36 36 255"
		"xpos"					"8"
		"ypos"					"57"
		"zpos"					"13"
		"wide"					"12"
		"tall"					"12"
		"enabled"				"1"
		"visible"				"1"
		"scaleImage"			"1"
		"image"					"materials/vgui/hud/hudicons/attr_damage.vmat"
	}

	"UnitQueryLabelDamage"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitQueryLabelDamage"
		"xpos"				"1"
		"ypos"				"0"
		"wide"				"22"
		"tall"				"12"
		"zpos"				"13"
		"enabled"			"1"
		"visible"			"1"
		"textAlignment"		"west"
		"labelText"			"%unitquerydamage%"
		"font" 				"Arial12Thick"
		"fgColor_override" 	"150 150 150 255"
		"bgcolor_override"	"51 51 51 0"

		"pin_to_sibling"			"UnitQueryDamage"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"			
	}

	"UnitQueryArmor"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"UnitQueryArmor"
		"fillcolor"				"36 36 36 255"
		"xpos"					"0"
		"ypos"					"-1"
		"zpos"					"13"
		"wide"					"12"
		"tall"					"12"
		"enabled"				"1"
		"visible"				"1"
		"scaleImage"			"1"	
		"image"					"materials/vgui/hud/hudicons/attr_armor.vmat"

		"pin_to_sibling"			"UnitQueryDamage"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"			
	}

	"UnitQueryLabelArmor"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitQueryLabelArmor"
		"xpos"				"1"
		"ypos"				"0"
		"zpos"				"13"
		"wide"				"20"
		"tall"				"12"
		"enabled"			"1"
		"visible"			"1"
		"textAlignment"		"west"
		"labelText"			"%unitqueryarmor%"
		"font" 				"Arial12Thick"
		"fgColor_override" 	"150 150 150 255"
		"bgcolor_override"	"51 51 51 0"

		"pin_to_sibling"			"UnitQueryArmor"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"			
	}
}
