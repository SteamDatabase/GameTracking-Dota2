"Resource/UI/HUD_ActionPanel.res"
{

//=============================================================================
//
// Backgrounds.
//

	"HudDOTAHeroActions"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"HudDOTAHeroActions"
		"xpos"				"c-287"
		"ypos"				"r170"
		"zpos"				"-1"
		"wide"				"640"
		"tall"				"170"
		"visible"			"1"
		"enabled"			"1"
		"style"				"ActionsBackground"
	}
	
	"QueryBackground"
	{
		"ControlName"		"Panel"
		"fieldName"			"QueryBackground"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"2"
		"wide"				"640"
		"tall"				"170"
		"enabled"			"1"
		"visible"			"1"
		"style"				"QueryBackground"
	}

//=====================================================================================================================
//
// Portrait.
//

	"UnitPortraitModel"
	{
		"ControlName"		"CDOTA_Model_Panel"
		"fieldName"			"UnitPortraitModel"
		"xpos"				"4"
		"ypos"				"4"
		"zpos"				"3"
		"wide"				"128"
		"tall"				"163"
		"autoResize"		"0"
		"pinCorner"			"0"
		"visible"			"1"
		"enabled"			"1"
		"fov"				"20"
		"start_framed"		"0"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/portrait.vmat"
	}	
	
	"PortraitFadeImage"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"PortraitFadeImage"
		"xpos"				"4"
		"ypos"				"4"
		"zpos"				"4"
		"wide"				"128"
		"tall"				"163"
		"enabled"			"1"
		"visible"			"1"
		"bgcolor_override"	"0 0 0 0"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_portrait_gradient.vmat"
		"MouseInputEnabled"	"0"
	}

	"UnitName"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitName"
		"xpos"				"4"
		"ypos"				"6"
		"wide"				"128"
		"tall"				"14"
		"zpos"				"5"
		"enabled"			"1"
		"visible"			"1"
		"textAlignment"		"center"
		"labelText"			"%unitname%"
		"font" 				"Arial14Thick"
		"fgColor_override" 	"200 200 200 255"
		"bgcolor_override"	"51 51 51 0"
	}

	"UnitLevelLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"UnitLevelLabel"
		"xpos"					"4"
		"ypos"					"19"
		"zpos"					"5"
		"wide"					"128"
		"tall"					"12"
		"enabled"				"1"
		"visible"				"1"
		"textAlignment"			"center"
		"labelText"				"%levellabel%"
		"font" 					"Arial12Thick"
		"fgColor_override"		"200 200 100 255"
		"bgcolor_override"		"51 51 51 0"
	}

//=============================================================================
//
// Health and Mana Bars.
//

	"UnitHealth"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"			"UnitHealth"
		"xpos"				"4"
		"ypos"				"0"
		"zpos"				"4"
		"wide"				"401"
		"tall"				"16"
		"visible"			"1"
		"enabled"			"1"
		"horizontal"		"1"
		"image"				"materials/vgui\hud\bar_health_new.vmat"
 		"color"				"255 255 255 0"
		"bgcolor_override"	"51 51 51 255"
				
		"pin_to_sibling"			"UnitPortraitModel"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"			
	}
	
	"UnitHealthName"
	{
		"ControlName"			"Label"
		"fieldName"				"UnitHealthName"
		"xpos"					"-4"
		"ypos"					"0"
		"zpos"					"5"
		"wide"					"100"
		"tall"					"16"
		"visible"				"1"
		"enabled"				"1"
		"textAlignment"			"west"
		"labelText"				"#DOTA_Health"
		"font" 					"Arial10Thick"
		"fgColor_override" 		"255 255 139 255"
		"bgcolor_override"		"26 26 26 0"

		"pin_to_sibling"			"UnitHealth"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"0"				
	}
	
	"UnitHealthLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"UnitHealthLabel"
		"xpos"					"-210"
		"ypos"					"0"
		"zpos"					"5"
		"wide"					"100"
		"tall"					"16"
		"visible"				"1"
		"enabled"				"1"
		"textAlignment"			"center"
		"labelText"				"%healthlabel%"
		"font" 					"Arial10Thick"
		"fgColor_override" 		"255 255 139 255"
		"bgcolor_override"		"26 26 26 0"

		"pin_to_sibling"			"UnitHealth"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"0"			
	}
	
	"UnitHealthRegenLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"UnitHealthRegenLabel"
		"xpos"					"-363"
		"ypos"					"0"
		"zpos"					"6"
		"wide"					"36"
		"tall"					"16"
		"enabled"				"1"
		"textAlignment"			"east"
		"labelText"				"%healthregenlabel%"
		"font" 					"Arial14Thick"
		"fgColor_override"		"255 255 139 255"
		"bgcolor_override"		"26 26 26 0"

		"pin_to_sibling"			"UnitHealth"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"0"			
	}

	"UnitMana"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"			"UnitMana"
		"xpos"				"0"
		"ypos"				"2"
		"zpos"				"4"
		"wide"				"401"
		"tall"				"12"
		"visible"			"1"
		"enabled"			"1"
		"horizontal"		"1"
		"image"				"materials/vgui\hud\bar_mana_new.vmat"
		"color"				"255 255 255 0"
		"bgcolor_override"	"51 51 51 255"
		
		"pin_to_sibling"			"UnitHealth"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"					
	}

	"UnitManaName"
	{
		"ControlName"			"Label"
		"fieldName"				"UnitManaName"
		"xpos"					"-4"
		"ypos"					"0"
		"zpos"					"5"
		"wide"					"100"
		"tall"					"12"
		"visible"				"1"
		"enabled"				"1"
		"textAlignment"			"west"
		"labelText"				"#DOTA_Mana"
		"font" 					"Arial10Thick"
		"fgColor_override" 		"255 255 139 255"
		"bgcolor_override"		"26 26 26 0"

		"pin_to_sibling"			"UnitMana"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"0"				
	}

	"UnitManaLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"UnitManaLabel"
		"xpos"					"-210"
		"ypos"					"0"
		"zpos"					"5"
		"wide"					"100"
		"tall"					"12"
		"visible"				"1"
		"enabled"				"1"
		"textAlignment"			"center"
		"labelText"				"%manalabel%"
		"font" 					"Arial10Thick"
		"fgColor_override" 		"0 197 229 255"
		"bgcolor_override"		"26 26 26 0"

		"pin_to_sibling"			"UnitMana"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"0"				
	}
	
	"UnitManaRegenLabel"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitManaRegenLabel"
		"xpos"				"-363"
		"ypos"				"0"
		"zpos"				"5"
		"wide"				"36"
		"tall"				"12"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"east"
		"labelText"			"%manaregenlabel%"
		"font" 				"Arial10Thick"
		"fgColor_override" 	"48 148 255 255"
		"bgcolor_override"		"26 26 26 0"

		"pin_to_sibling"			"UnitMana"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"0"				
	}

//=====================================================================================================================
//
// Level & XP.
//

	"XPBackground"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"XPBackground"
		"fillcolor"				"36 36 36 255"
		"zpos"					"4"
		"wide"					"32"
		"tall"					"131"
		"minimum-width"			"32"
		"minimum-height"		"131"
		"PaintBackgroundType"	"2"
		"enabled"				"1"
		"visible"				"1"
	}

	"XPLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"XPLabel"
		"zpos"					"5"
		"wide"					"32"
		"tall"					"16"
		"textAlignment"			"center"
		"labelText"				"#DOTA_XP"
		"font" 					"Arial10Thick"
		"fgColor_override" 		"255 255 139 255"
		"bgcolor_override"		"26 26 26 0"
		"enabled"				"1"
		"visible"				"1"
	}

	"UnitXPBar"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"			"UnitXPBar"
		"zpos"				"5"
		"wide"				"24"
		"tall"				"111"
		"scaleImage"		"1"
		"vertical"			"1"
		"image"				"materials/vgui\hud\bar_xp_new.vmat"
		"color" 			"255 255 255 0"
		"bgcolor_override"	"51 51 51 255"
		"enabled"			"1"
		"visible"			"1"
		"mouseinputenabled"	"1"
	}
	
	"UnitXPPoints"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitXPPoints"
		"xpos"				"141"
		"ypos"				"141"
		"zpos"				"6"
		"wide"				"22"
		"tall"				"22"
		"enabled"			"1"
		"visible"			"1"
		"textAlignment"		"center"
		"labelText"			"12"
		"style"				"XPPoints"
	}

//=============================================================================
//
// Attributes
//

	"AttributeLearn"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"AttributeLearn"
		"xpos"						"4"
		"ypos"						"135"
		"zpos"						"6"
		"wide"						"128"
		"tall"						"16"
		"visible"					"1"
		"enabled"					"1"
		"textAlignment"				"center"
		"command"					"learnattribute"
		"labelText"					"%learnattrib%"
		"border"					"ButtonHUDBorder"
		"bindable"					"1"
		"style"						"AttributeLearn"
	}
	
	"AttributeDamageIcon"
	{
		"ControlName"		"Panel"
		"fieldName"			"AttributeDamageIcon"
		"zpos"				"6"
		"wide"				"16"
		"tall"				"16"
		"minimum-width"		"16"
		"minimum-height"	"16"
		"enabled"			"1"
		"visible"			"1"
		"style"				"DamageIcon"
	}
	
	"AttributeDamage"
	{
		"ControlName"		"Label"
		"fieldName"			"AttributeDamage"
		"zpos"				"6"
		"wide"				"30"
		"tall"				"16"
		"minimum-height"	"16"
		"minimum-width"		"16"
		"enabled"			"1"
		"visible"			"1"
		"textAlignment"		"west"
		"labelText"			"%attrib_damage%"
		"style"				"Attribute"
	}
	
	"AttributeDamageBonus"
	{
		"ControlName"		"Label"
		"fieldName"			"AttributeDamageBonus"
		"zpos"				"6"
		"wide"				"40"
		"tall"				"16"
		"minimum-height"	"16"
		"minimum-width"		"22"
		"enabled"			"1"
		"visible"			"1"
		"textAlignment"		"west"
		"labelText"			"%attrib_damage_bonus%"
		"style"				"AttributeBonus"
	}
		
	"AttributeArmorIcon"
	{
		"ControlName"		"Panel"
		"fieldName"			"AttributeArmorIcon"
		"zpos"				"6"
		"wide"				"16"
		"tall"				"16"
		"minimum-height"	"16"
		"enabled"			"1"
		"visible"			"1"
		"style"				"ArmorIcon"
	}
	"AttributeArmor"
	{
		"ControlName"		"Label"
		"fieldName"			"AttributeArmor"
		"zpos"				"6"
		"wide"				"30"
		"tall"				"16"
		"minimum-width"		"30"
		"minimum-height"	"16"
		"enabled"			"1"
		"visible"			"1"
		"textAlignment"		"west"
		"labelText"			"%attrib_armor%"
		"style"				"Attribute"
	}

//=============================================================================
//
// Abilities.
//

	"AbilityBackground"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"AbilityBackground"
		"fillcolor"				"36 36 36 255"
		"zpos"					"4"
		"wide"					"487"
		"tall"					"131"
		"minimum-width"			"487"
		"minimum-height"		"131"
		"enabled"				"1"
		"visible"				"1"
		"PaintBackgroundType"	"2"
	}

	"AbilityLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"AbilityLabel"
		"zpos"					"5"
		"wide"					"40"
		"tall"					"16"
		"visible"				"1"
		"enabled"				"1"
		"textAlignment"			"west"
		"labelText"				"#DOTA_Abilities"
		"font" 					"Arial10Thick"
		"fgColor_override" 		"150 150 150 255"
		"bgcolor_override"		"0 0 0 0"
	}

	"AbilityButton_0"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"AbilityButton_0"
		"zpos"				"6"
		"wide"				"70"
		"tall"				"80"
		"minimum-width"		"70"
		"minimum-height"	"80"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"bindable"			"1"
		"style"				"AbilityButton"
		"cooldown_inset"	"3"
	}

	"AbilityLearn_0"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"AbilityLearn_0"
		"zpos"						"6"
		"wide"						"70"
		"tall"						"16"
		"minimum-width"				"70"
		"minimum-height"			"16"
		"visible"					"1"
		"enabled"					"1"
		"textAlignment"				"center"
		"command"					"learn 0"
		"labelText"					""
		"bindable"					"1"
		"style"						"AbilityLearnButton"
	}

	"AbilityBezel_0"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"AbilityBezel_0"
		"zpos"				"6"
		"wide"				"76"
		"tall"				"86"
		"minimum-width"		"76"
		"minimum-height"	"86"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"mouseinputenabled"	"false"
		"style"				"AbilityAutoCast"
	}

	"AbilityButton_1"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"AbilityButton_1"
		"zpos"				"6"
		"wide"				"70"
		"tall"				"80"
		"minimum-width"		"70"
		"minimum-height"	"80"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"bindable"			"1"
		"style"				"AbilityButton"
		"cooldown_inset"	"3"
	}
	
	"AbilityLevel_0"
	{
		"ControlName"		"CAbilityLevelPanel"
		"fieldName"			"AbilityLevel_0"
		"zpos"				"7"
		"wide"				"70"
		"tall"				"16"
		"minimum-width"		"70"
		"minimum-height"	"16"
		"visible"			"1"
		"spacing"			"2"
		"mouseinputenabled"	"0"
		"bgcolor_override"	"0 0 0 0"
	}
	
	"AbilityLevel_1"
	{
		"ControlName"		"CAbilityLevelPanel"
		"fieldName"			"AbilityLevel_1"
		"zpos"				"7"
		"wide"				"70"
		"tall"				"16"
		"minimum-width"		"70"
		"minimum-height"	"16"
		"visible"			"1"
		"spacing"			"2"
		"mouseinputenabled"	"0"
		"bgcolor_override"	"0 0 0 0"
	}
	
	"AbilityLevel_2"
	{
		"ControlName"		"CAbilityLevelPanel"
		"fieldName"			"AbilityLevel_2"
		"zpos"				"7"
		"wide"				"70"
		"tall"				"16"
		"minimum-width"		"70"
		"minimum-height"	"16"
		"visible"			"1"
		"spacing"			"2"
		"mouseinputenabled"	"0"
		"bgcolor_override"	"0 0 0 0"
	}
	
	"AbilityLevel_3"
	{
		"ControlName"		"CAbilityLevelPanel"
		"fieldName"			"AbilityLevel_3"
		"zpos"				"7"
		"wide"				"70"
		"tall"				"16"
		"minimum-width"		"70"
		"minimum-height"	"16"
		"visible"			"1"
		"spacing"			"2"
		"mouseinputenabled"	"0"
		"bgcolor_override"	"0 0 0 0"
	}
	
	"AbilityLevel_4"
	{
		"ControlName"		"CAbilityLevelPanel"
		"fieldName"			"AbilityLevel_4"
		"zpos"				"7"
		"wide"				"70"
		"tall"				"16"
		"minimum-width"		"70"
		"minimum-height"	"16"
		"visible"			"1"
		"spacing"			"2"
		"mouseinputenabled"	"0"
		"bgcolor_override"	"0 0 0 0"
	}
	
	"AbilityLevel_5"
	{
		"ControlName"		"CAbilityLevelPanel"
		"fieldName"			"AbilityLevel_5"
		"zpos"				"7"
		"wide"				"70"
		"tall"				"16"
		"minimum-width"		"70"
		"minimum-height"	"16"
		"visible"			"1"
		"spacing"			"2"
		"mouseinputenabled"	"0"
		"bgcolor_override"	"0 0 0 0"
	}

	"AbilityLearn_1"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"AbilityLearn_1"
		"zpos"						"6"
		"wide"						"70"
		"tall"						"16"
		"minimum-width"				"70"
		"minimum-height"			"16"
		"visible"					"1"
		"enabled"					"1"
		"textAlignment"				"center"
		"command"					"learn 1"
		"labelText"					""
		"bindable"					"1"
		"style"						"AbilityLearnButton"
	}

	"AbilityBezel_1"
	{
		"ControlName"		"Panel"
		"fieldName"			"AbilityBezel_1"
		"zpos"				"5"
		"wide"				"76"
		"tall"				"86"
		"minimum-width"		"76"
		"minimum-height"	"86"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"mouseinputenabled"	"false"
		"style"				"AbilityAutoCast"
	}

	"AbilityButton_2"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"AbilityButton_2"
		"zpos"				"6"
		"wide"				"70"
		"tall"				"80"
		"minimum-width"		"70"
		"minimum-height"	"80"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"bindable"			"1"
		"style"				"AbilityButton"
		"cooldown_inset"	"3"
	}

	"AbilityLearn_2"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"AbilityLearn_2"
		"zpos"						"6"
		"wide"						"70"
		"tall"						"16"
		"minimum-width"				"70"
		"minimum-height"			"16"
		"visible"					"1"
		"enabled"					"1"
		"textAlignment"				"center"
		"command"					"learn 2"
		"labelText"					""
		"bindable"					"1"
		"style"						"AbilityLearnButton"
	}

	"AbilityBezel_2"
	{
		"ControlName"		"Panel"
		"fieldName"			"AbilityBezel_2"
		"zpos"				"5"
		"wide"				"76"
		"tall"				"86"
		"minimum-width"		"76"
		"minimum-height"	"86"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"mouseinputenabled"	"false"
		"style"				"AbilityAutoCast"
	}

	"AbilityButton_3"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"AbilityButton_3"
		"zpos"				"6"
		"wide"				"70"
		"tall"				"80"
		"minimum-width"		"70"
		"minimum-height"	"80"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
 		"image"				""
		"bindable"			"1"
		"style"				"AbilityButton"
		"cooldown_inset"	"3"
	}

	"AbilityLearn_3"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"AbilityLearn_3"
		"zpos"						"6"
		"wide"						"70"
		"tall"						"16"
		"minimum-width"				"70"
		"minimum-height"			"16"
		"visible"					"1"
		"enabled"					"1"
		"textAlignment"				"center"
		"command"					"learn 3"
		"labelText"					""
		"bindable"					"1"
		"style"						"AbilityLearnButton"
	}

	"AbilityBezel_3"
	{
		"ControlName"		"Panel"
		"fieldName"			"AbilityBezel_3"
		"zpos"				"5"
		"wide"				"76"
		"tall"				"86"
		"minimum-width"		"76"
		"minimum-height"	"86"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"mouseinputenabled"	"false"
		"style"				"AbilityAutoCast"
	}

	"AbilityButton_4"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"AbilityButton_4"
		"zpos"				"5"
		"wide"				"70"
		"tall"				"80"
		"minimum-width"		"70"
		"minimum-height"	"80"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
 		"image"				""
		"bindable"			"1"
		"style"				"AbilityButton"
		"cooldown_inset"	"3"
	}

	"AbilityLearn_4"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"AbilityLearn_4"
		"zpos"						"6"
		"wide"						"70"
		"tall"						"16"
		"minimum-width"				"70"
		"minimum-height"			"16"
		"visible"					"1"
		"enabled"					"1"
		"textAlignment"				"center"
		"command"					"learn 4"
		"labelText"					""
		"bindable"					"1"
		"style"						"AbilityLearnButton"
	}

	"AbilityBezel_4"
	{
		"ControlName"		"Panel"
		"fieldName"			"AbilityBezel_4"
		"zpos"				"5"
		"wide"				"76"
		"tall"				"86"
		"minimum-width"		"76"
		"minimum-height"	"86"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"mouseinputenabled"	"false"
		"style"				"AbilityAutoCast"
	}

	"AbilityButton_5"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"AbilityButton_5"
		"zpos"				"5"
		"wide"				"70"
		"tall"				"80"
		"minimum-width"		"70"
		"minimum-height"	"80"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
 		"image"				""
		"bindable"			"1"
		"style"				"AbilityButton"
		"cooldown_inset"	"3"
	}

	"AbilityLearn_5"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"AbilityLearn_5"
		"zpos"						"6"
		"wide"						"70"
		"tall"						"16"
		"minimum-width"				"70"
		"minimum-height"			"16"
		"visible"					"1"
		"enabled"					"1"
		"textAlignment"				"center"
		"command"					"learn 5"
		"labelText"					""
		"bindable"					"1"
		"style"						"AbilityLearnButton"
	}

	"AbilityBezel_5"
	{
		"ControlName"		"Panel"
		"fieldName"			"AbilityBezel_5"
		"zpos"				"5"
		"wide"				"76"
		"tall"				"86"
		"minimum-width"		"76"
		"minimum-height"	"86"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"mouseinputenabled"	"false"
		"style"				"AbilityAutoCast"
	}
	
	"AbilityLevel_6"
	{
		"ControlName"		"CAbilityLevelPanel"
		"fieldName"			"AbilityLevel_6"
		"zpos"				"0"
		"wide"				"0"
		"tall"				"0"
		"minimum-width"		"0"
		"minimum-height"	"0"
		"visible"			"0"
		"spacing"			"2"
		"mouseinputenabled"	"0"
		"bgcolor_override"	"0 0 0 0"
	}
	
	"AbilityLearn_6"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"AbilityLearn_6"
		"xpos"						"0"
		"ypos"						"0"
		"zpos"						"0"
		"wide"						"0"
		"tall"						"0"
		"visible"					"0"
		"enabled"					"0"
		"font" 						"Arial12Thick"
		"textAlignment"				"center"
		"command"					"learn 5"
		"labelText"					""
		"border"					"ButtonHUDBorder"
		"bindable"					"0"
	}
	
	// Hotkey displays attached to ability buttons
	
	"AbilityHotkeyPanel_0" { ControlName=CDOTAHotkeyPanel fieldName=AbilityHotkeyPanel_0 zpos=10 wide=25 tall=25 OffsetX=-10 OffsetY=-10 mouseInputEnabled=0 }
	"AbilityHotkeyPanel_1" { ControlName=CDOTAHotkeyPanel fieldName=AbilityHotkeyPanel_1 zpos=10 wide=25 tall=25 OffsetX=-10 OffsetY=-10 mouseInputEnabled=0 }
	"AbilityHotkeyPanel_2" { ControlName=CDOTAHotkeyPanel fieldName=AbilityHotkeyPanel_2 zpos=10 wide=25 tall=25 OffsetX=-10 OffsetY=-10 mouseInputEnabled=0 }
	"AbilityHotkeyPanel_3" { ControlName=CDOTAHotkeyPanel fieldName=AbilityHotkeyPanel_3 zpos=10 wide=25 tall=25 OffsetX=-10 OffsetY=-10 mouseInputEnabled=0 }
	"AbilityHotkeyPanel_4" { ControlName=CDOTAHotkeyPanel fieldName=AbilityHotkeyPanel_4 zpos=10 wide=25 tall=25 OffsetX=-10 OffsetY=-10 mouseInputEnabled=0 }
	"AbilityHotkeyPanel_5" { ControlName=CDOTAHotkeyPanel fieldName=AbilityHotkeyPanel_5 zpos=10 wide=25 tall=25 OffsetX=-10 OffsetY=-10 mouseInputEnabled=0 }

//=============================================================================
//
// Death Panel
//

	"DeathBackground"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"DeathBackground"
		"fillcolor"				"36 36 36 255"
		"xpos"					"4"
		"ypos"					"0"
		"zpos"					"9"
		"wide"					"501"
		"tall"					"30"
		"enabled"				"1"
		"scaleImage"			"1"
		"visible"				"1"
		"PaintBackgroundType"	"2"
	
		"pin_to_sibling"			"UnitPortraitModel"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"				
	}

	"DeathIcon"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"DeathIcon"
		"xpos"				"-165"
		"ypos"				"0"
		"zpos"				"10"
		"wide"				"30"
		"tall"				"30"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"image"				"materials/vgui/hud/scoreboard_death.vmat"	

		"pin_to_sibling"			"DeathBackground"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"0"				
	}
	
	"DeathRespawnLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"DeathRespawnLabel"
		"xpos"					"4"
		"ypos"					"0"
		"zpos"					"10"
		"wide"					"150"
		"tall"					"30"
		"enabled"				"1"
		"textAlignment"			"west"
		"visible"				"1"
		"labelText"				"%deathrespawnlabel%"
		"font" 					"Arial14Thick"
		"fgColor_override"		"200 32 32 255"
		"bgcolor_override"		"26 26 26 0"

		"pin_to_sibling"			"DeathIcon"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"				
	}

	Colors
	{
	}

	Styles
	{
	}
	
	Layout
	{
		Region { name=XPRegion x=136 y=36 width=32 height=131 }
		Place { Region=XPRegion x=0 y=0 Margin-Top=4 Controls=XPBackground }
		Place { Region=XPRegion x=2 y=2 width=32 height=16 Align=Center Controls=XPLabel }
		Place { Region=XPRegion x=4 y=18 width=24 height=111 Controls=UnitXPBar }
		
		Region { name=AbilityRegion x=172 y=36 width=465 height=131 }
		Place { Region=AbilityRegion x=0 y=0 Margin-Top=4 Controls=AbilityBackground }
		Place { Region=AbilityRegion x=4 y=2 width=40 height=16 Align=West Controls=AbilityLabel }
		Place { Region=AbilityRegion x=4 y=24 Margin-Left=8 Spacing=5 Controls=AbilityButton_0,AbilityButton_1,AbilityButton_2,AbilityButton_3,AbilityButton_4,AbilityButton_5 }
		
		Place { Region=AbilityRegion margin-left=-73 margin-top=-3 start=AbilityButton_0 Controls=AbilityBezel_0 }
		Place { Region=AbilityRegion margin-left=-73 margin-top=-3 start=AbilityButton_1 Controls=AbilityBezel_1 }
		Place { Region=AbilityRegion margin-left=-73 margin-top=-3 start=AbilityButton_2 Controls=AbilityBezel_2 }
		Place { Region=AbilityRegion margin-left=-73 margin-top=-3 start=AbilityButton_3 Controls=AbilityBezel_3 }
		Place { Region=AbilityRegion margin-left=-73 margin-top=-3 start=AbilityButton_4 Controls=AbilityBezel_4 }
		Place { Region=AbilityRegion margin-left=-73 margin-top=-3 start=AbilityButton_5 Controls=AbilityBezel_5 }
		
		Region { name=FooterRegion x=172 y=144 width=465 height=60 }
		Place { Region=FooterRegion x=4 y=2 Margin-left=8 spacing=5 Controls=AbilityLevel_0,AbilityLevel_1,AbilityLevel_2,AbilityLevel_3,AbilityLevel_4,AbilityLevel_5 }
		Place { Region=FooterRegion x=4 Margin-Left=8 Spacing=5 Controls=AbilityLearn_0,AbilityLearn_1,AbilityLearn_2,AbilityLearn_3,AbilityLearn_4,AbilityLearn_5 }
		
		Region { name=Attributes x=4 y=150 width=128 height=16 }
		Place { region=Attributes dir=right spacing=2 margin-left=15 Controls=AttributeDamageIcon,AttributeDamage,AttributeDamageBonus }
		Place { region=Attributes dir=right align=right spacing=2 Controls=AttributeArmorIcon,AttributeArmor }
	}		
}
