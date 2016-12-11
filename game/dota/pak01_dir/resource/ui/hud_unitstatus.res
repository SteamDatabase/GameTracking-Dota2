"Resource/UI/HUD_UnitStatus.res"
{

//=====================================================================================================================
//
// Portrait.
//

	"UnitPortraitModel"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"CDOTA_Portrait"
		"xpos"				"%1.9"
		"ypos"				"%2.4"
		"zpos"				"3"
		"wide"				"%10.8"
		"tall"				"%13.5"
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

//=====================================================================================================================
//
// Level & XP.
//

	"UnitXPBackground"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"UnitXPBackground"
		"fillcolor"				"36 36 36 255"
		"xpos"					"%13.3"
		"ypos"					"%2.4"
		"zpos"					"2"
		"wide"					"%1.5"
		"tall"					"%13.5"
		"enabled"				"1"
		"scaleImage"			"1"
		"visible"				"1"
		"PaintBackgroundType"	"2"	
	}

	"UnitXPLevel"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitXPLevel"
		"xpos"				"%13.3"
		"ypos"				"%2.4"
		"wide"				"%1.5"
		"tall"				"%1.6"
		"zpos"				"4"
		"enabled"			"1"
		"visible"			"1"
		"textAlignment"		"center"
		"labelText"			"%unitxplevel%"
		"font" 				"Arial10Thick"
		"fgColor_override" 	"255 255 139 255"
		"bgcolor_override"	"51 51 51 0"
	}

	"UnitXPBar"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"			"UnitXPBar"
		"xpos"				"%13.6"
		"ypos"				"%4.0"
		"zpos"				"4"
		"wide"				"%0.93"
		"tall"				"%11.5"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"vertical"			"1"
		"image"				"materials/vgui\hud\ui_progressbar_xp.vmat"
		"color" 			"255 255 139 255"
		"bgcolor_override"	"51 51 51 255"
	}

//=====================================================================================================================
//
// Name.
//

	"UnitStatsName"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitStatsName"
		"xpos"				"%15.4"
		"ypos"				"%2.15"
		"wide"				"%10"
		"tall"				"%2.0"
		"zpos"				"3"
		"enabled"			"1"
		"visible"			"1"
		"textAlignment"		"west"
		"labelText"			"%unitname%"
		"font" 				"Arial18Thick"
		"fgColor_override" 	"200 200 200 255"
		"bgcolor_override"	"51 51 51 0"
	}

	"UnitStatsLevel"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitStatsLevel"
		"xpos"				"%15.4"
		"ypos"				"%4.1"
		"wide"				"%8"
		"tall"				"%1.6"
		"zpos"				"3"
		"enabled"			"1"
		"visible"			"1"
		"textAlignment"		"west"
		"labelText"			"%unitlevel%"
		"font" 				"Arial14Thick"
		"fgColor_override" 	"255 255 139 255"
		"bgcolor_override"	"51 51 51 0"
	}

//=====================================================================================================================
//
// Combat Stats.
//

	"UnitStatsBackground"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"UnitStatsBackground"
		"fillcolor"				"36 36 36 255"
		"xpos"					"%15.4"
		"ypos"					"%6.0"
		"zpos"					"2"
		"wide"					"%18.3"
		"tall"					"%9.9"
		"enabled"				"1"
		"scaleImage"			"1"
		"visible"				"1"
		"PaintBackgroundType"	"2"	
	}

	"UnitStatsDamage"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"UnitStatsDamage"
		"fillcolor"				"36 36 36 255"
		"xpos"					"%16.0"
		"ypos"					"%7.4"
		"zpos"					"3"
		"wide"					"%2.5"
		"tall"					"%3.1"
		"enabled"				"1"
		"visible"				"1"
		"image"					"materials/vgui/hud/hudicons/attr_damage.vmat"
	}

	"UnitStatsLabelDamageName"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitStatsLabelDamageName"
		"xpos"				"%19.0"
		"ypos"				"%7.4"
		"wide"				"%5"
		"tall"				"%1.6"
		"zpos"				"3"
		"enabled"			"1"
		"visible"			"1"
		"textAlignment"		"north-west"
		"labelText"			"#DOTA_AttribDamage"
		"font" 				"Arial14Thick"
		"fgColor_override" 	"200 200 200 255"
		"bgcolor_override"	"51 51 51 0"
	}

	"UnitStatsLabelDamage"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitStatsLabelDamage"
		"xpos"				"%19.0"
		"ypos"				"%9.0"
		"wide"				"%4.4"
		"tall"				"%1.6"
		"zpos"				"3"
		"enabled"			"1"
		"visible"			"1"
		"textAlignment"		"south-west"
		"labelText"			"%unitdamage%"
		"font" 				"Arial14Thick"
		"fgColor_override" 	"150 150 150 255"
		"bgcolor_override"	"51 51 51 0"
	}

	"UnitStatsLabelDamageBonus"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitStatsLabelDamageBonus"
		"xpos"				"%23.3"
		"ypos"				"%9.0"
		"wide"				"%3.2"
		"tall"				"%1.6"
		"zpos"				"3"
		"enabled"			"1"
		"visible"			"1"
		"textAlignment"		"south-west"
		"labelText"			"%unitdamagebonus%"
		"font" 				"Arial12Fine"
		"fgColor_override" 	"139 195 58 255"
		"bgcolor_override"	"51 51 51 0"
	}

	"UnitStatsArmor"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"UnitStatsArmor"
		"fillcolor"				"36 36 36 255"
		"xpos"					"%16.0"
		"ypos"					"%11.5"
		"zpos"					"3"
		"wide"					"%2.5"
		"tall"					"%3.1"
		"enabled"				"1"
		"visible"				"1"
		"image"					"materials/vgui/hud/hudicons/attr_armor.vmat"
	}

	"UnitStatsLabelArmorName"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitStatsLabelArmorName"
		"xpos"				"%19.0"
		"ypos"				"%11.5"
		"wide"				"%5"
		"tall"				"%1.6"
		"zpos"				"3"
		"enabled"			"1"
		"visible"			"1"
		"textAlignment"		"north-west"
		"labelText"			"#DOTA_AttribArmor"
		"font" 				"Arial14Thick"
		"fgColor_override" 	"200 200 200 255"
		"bgcolor_override"	"51 51 51 0"
	}

	"UnitStatsLabelArmor"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitStatsLabelArmor"
		"xpos"				"%19.0"
		"ypos"				"%13.1"
		"wide"				"%2.0"
		"tall"				"%1.6"
		"zpos"				"3"
		"enabled"			"1"
		"visible"			"1"
		"textAlignment"		"south-west"
		"labelText"			"%unitarmor%"
		"font" 				"Arial14Thick"
		"fgColor_override" 	"150 150 150 255"
		"bgcolor_override"	"51 51 51 0"
	}

	"UnitStatsLabelArmorBonus"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitStatsLabelArmorBonus"
		"xpos"				"%21.0"
		"ypos"				"%13.1"
		"wide"				"%3"
		"tall"				"%1.6"
		"zpos"				"3"
		"enabled"			"1"
		"visible"			"1"
		"textAlignment"		"south-west"
		"labelText"			"%unitarmorbonus%"
		"font" 				"Arial12Fine"
		"fgColor_override" 	"139 195 58 255"
		"bgcolor_override"	"51 51 51 0"
	}

//=====================================================================================================================
//
// Attributes.
//

	"UnitAttributesBackground"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"UnitStatsBackground"
		"fillcolor"				"36 36 36 255"
		"xpos"					"%1.9"
		"ypos"					"%16.7"
		"zpos"					"2"
		"wide"					"%11.4"
		"tall"					"%3.12"
		"enabled"				"1"
		"scaleImage"			"1"
		"visible"				"1"
		"PaintBackgroundType"	"2"	
	}

	"UnitAttributesBackground2"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"UnitStatsBackground2"
		"fillcolor"				"36 36 36 255"
		"xpos"					"%14.9"
		"ypos"					"%16.7"
		"zpos"					"2"
		"wide"					"%18.9"
		"tall"					"%3.12"
		"enabled"				"1"
		"scaleImage"			"1"
		"visible"				"1"
		"PaintBackgroundType"	"2"	
	}

	"UnitAttributesBackground3"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"UnitStatsBackground3"
		"fillcolor"				"36 36 36 255"
		"xpos"					"%13.2"
		"ypos"					"%17.4"
		"zpos"					"2"
		"wide"					"%1.75"
		"tall"					"%1.6"
		"enabled"				"1"
		"scaleImage"			"1"
		"visible"				"1"
		"PaintBackgroundType"	"2"	
	}

	"UnitAttributesStrengthImage"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"UnitAttributesStrengthImage"
		"fillcolor"				"36 36 36 255"
		"xpos"					"%15.3"
		"ypos"					"%17.4"
		"zpos"					"4"
		"wide"					"%1.25"
		"tall"					"%1.6"
		"enabled"				"1"
		"visible"				"1"
		"scaleImage"			"1"
		"image"					"materials/vgui/hud/hudicons/attr_strength.vmat"
	}

	"UnitAttributesStrength"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitAttributesStrength"
		"xpos"				"%16.9"
		"ypos"				"%17.4"
		"zpos"				"4"
		"wide"				"%2.2"
		"tall"				"%1.6"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"textAlignment"		"south-west"
		"labelText"			"%unitstrength%"
		"font" 				"Arial14Thick"
		"fgColor_override" 	"150 150 150 255"
		"bgcolor_override"	"0 0 0 0"
	}

	"UnitAttributesStrengthBonus"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitAttributesStrengthBonus"
		"xpos"				"%18.9"
		"ypos"				"%17.4"
		"zpos"				"4"
		"wide"				"%2.2"
		"tall"				"%1.6"
		"enabled"			"1"
		"textAlignment"		"south-west"
		"labelText"			"%unitstrengthbonus%"
		"font" 				"Arial12Fine"
		"fgColor_override" 	"139 195 58 255"
		"bgcolor_override"	"0 0 0 0"
	}

	"UnitAttributesIntellectImage"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"UnitAttributesIntellectImage"
		"fillcolor"				"36 36 36 255"
		"xpos"					"%21.5"
		"ypos"					"%17.4"
		"zpos"					"4"
		"wide"					"%1.25"
		"tall"					"%1.6"
		"enabled"				"1"
		"visible"				"1"
		"scaleImage"			"1"
		"image"					"materials/vgui/hud/hudicons/attr_intelligence.vmat"
	}

	"UnitAttributesIntellect"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitAttributesIntellect"
		"xpos"				"%23.1"
		"ypos"				"%17.4"
		"zpos"				"4"
		"wide"				"%2.2"
		"tall"				"%1.6"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"textAlignment"		"south-west"
		"labelText"			"%unitintellect%"
		"font" 				"Arial14Thick"
		"fgColor_override" 	"150 150 150 255"
		"bgcolor_override"	"0 0 0 0"
	}

	"UnitAttributesIntellectBonus"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitAttributesIntellectBonus"
		"xpos"				"%25.05"
		"ypos"				"%17.4"
		"zpos"				"4"
		"wide"				"%2.2"
		"tall"				"%1.6"
		"enabled"			"1"
		"textAlignment"		"south-west"
		"labelText"			"%unitintellectbonus%"
		"font" 				"Arial12Fine"
		"fgColor_override" 	"139 195 58 255"
		"bgcolor_override"	"0 0 0 0"
	}
	
	"UnitAttributesAgilityImage"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"UnitAttributesAgilityImage"
		"fillcolor"				"36 36 36 255"
		"xpos"					"%27.6"
		"ypos"					"%17.4"
		"zpos"					"4"
		"wide"					"%1.25"
		"tall"					"%1.6"
		"enabled"				"1"
		"visible"				"1"
		"scaleImage"			"1"
		"image"					"materials/vgui/hud/hudicons/attr_agility.vmat"
	}

	"UnitAttributesAgility"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitAttributesAgility"
		"xpos"				"%29.25"
		"ypos"				"%17.4"
		"zpos"				"4"
		"wide"				"%2.2"
		"tall"				"%1.6"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"textAlignment"		"south-west"
		"labelText"			"%unitagility%"
		"font" 				"Arial14Thick"
		"fgColor_override" 	"150 150 150 255"
		"bgcolor_override"	"0 0 0 0"
	}

	"UnitAttributesAgilityBonus"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitAttributesAgilityBonus"
		"xpos"				"%31.25"
		"ypos"				"%17.4"
		"zpos"				"4"
		"wide"				"%2.2"
		"tall"				"%1.6"
		"enabled"			"1"
		"textAlignment"		"south-west"
		"labelText"			"%unitagilitybonus%"
		"font" 				"Arial12Fine"
		"fgColor_override" 	"139 195 58 255"
		"bgcolor_override"	"0 0 0 0"
	}
	
	"AttributeLearn"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"AttributeLearn"
		"xpos"						"%2.7"
		"ypos"						"%17.4"
		"zpos"						"4"
		"wide"						"%10.0"
		"tall"						"%1.6"
		"visible"					"1"
		"enabled"					"1"
		"font" 						"Arial12Thick"
		"textAlignment"				"center"
		"command"					"learnattribute"
		"labelText"					"%learnattrib%"
		"defaultFgColor_override"	"51 51 51 255"
		"defaultBgColor_override"	"201 119 20 255"
		"armedFgColor_override"		"51 51 51 255"
		"armedBgColor_override"		"201 119 20 255"
		"border"					"ButtonHUDBorder"
		"bindable"					"1"
		"ability_tooltip"			"1"
	}
	
//=====================================================================================================================
//
// Stats.
//
	
	"UnitStatsKillsImage"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"UnitStatsKillsImage"
		"fillcolor"				"36 36 36 255"
		"xpos"					"%32.1"
		"ypos"					"%6.2"
		"zpos"					"4"
		"wide"					"%1.3"
		"tall"					"%1.6"
		"enabled"				"1"
		"visible"				"1"
		"image"					"materials/vgui\hud\ui_skill_notlearned.vmat"
	}

	"UnitStatsKills"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitStatsKills"
		"xpos"				"%29.8"
		"ypos"				"%6.2"
		"zpos"				"4"
		"wide"				"%2"
		"tall"				"%1.6"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"textAlignment"		"east"
		"labelText"			"%unitstatskills%"
		"font" 				"Arial14Thick"
		"fgColor_override" 	"150 150 150 255"
		"bgcolor_override"	"0 0 0 0"
	}

	"UnitStatsDeathsImage"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"UnitStatsDeathsImage"
		"fillcolor"				"36 36 36 255"
		"xpos"					"%32.1"
		"ypos"					"%8.2"
		"zpos"					"4"
		"wide"					"%1.3"
		"tall"					"%1.6"
		"enabled"				"1"
		"visible"				"1"
		"image"					"materials/vgui\hud\ui_skill_notlearned.vmat"
	}

	"UnitStatsDeaths"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitStatsDeaths"
		"xpos"				"%29.8"
		"ypos"				"%8.2"
		"zpos"				"4"
		"wide"				"%2"
		"tall"				"%1.6"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"textAlignment"		"east"
		"labelText"			"%unitstatsdeaths%"
		"font" 				"Arial14Thick"
		"fgColor_override" 	"150 150 150 255"
		"bgcolor_override"	"0 0 0 0"
	}

	"UnitStatsAssistsImage"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"UnitStatsAssistsImage"
		"fillcolor"				"36 36 36 255"
		"xpos"					"%32.1"
		"ypos"					"%10.2"
		"zpos"					"4"
		"wide"					"%1.3"
		"tall"					"%1.6"
		"enabled"				"1"
		"visible"				"1"
		"image"					"materials/vgui\hud\ui_skill_notlearned.vmat"
	}

	"UnitStatsAssists"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitStatsAssists"
		"xpos"				"%29.8"
		"ypos"				"%10.2"
		"zpos"				"4"
		"wide"				"%2"
		"tall"				"%1.6"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"textAlignment"		"east"
		"labelText"			"%unitstatsassists%"
		"font" 				"Arial14Thick"
		"fgColor_override" 	"150 150 150 255"
		"bgcolor_override"	"0 0 0 0"
	}

	"UnitStatsCreepsImage"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"UnitStatsCreepsImage"
		"fillcolor"				"36 36 36 255"
		"xpos"					"%32.1"
		"ypos"					"%12.2"
		"zpos"					"4"
		"wide"					"%1.3"
		"tall"					"%1.6"
		"enabled"				"1"
		"visible"				"1"
		"image"					"materials/vgui\hud\ui_skill_notlearned.vmat"
	}

	"UnitStatsCreeps"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitStatsCreeps"
		"xpos"				"%29.8"
		"ypos"				"%12.2"
		"zpos"				"4"
		"wide"				"%2"
		"tall"				"%1.6"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"textAlignment"		"east"
		"labelText"			"%unitstatscreeps%"
		"font" 				"Arial14Thick"
		"fgColor_override" 	"150 150 150 255"
		"bgcolor_override"	"0 0 0 0"
	}

	"UnitStatsDeniesImage"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"UnitStatsDeniesImage"
		"fillcolor"				"36 36 36 255"
		"xpos"					"%32.1"
		"ypos"					"%14.2"
		"zpos"					"4"
		"wide"					"%1.3"
		"tall"					"%1.6"
		"enabled"				"1"
		"visible"				"1"
		"image"					"materials/vgui\hud\ui_skill_notlearned.vmat"
	}

	"UnitStatsDenies"
	{
		"ControlName"		"Label"
		"fieldName"			"UnitStatsDenies"
		"xpos"				"%29.8"
		"ypos"				"%14.2"
		"zpos"				"4"
		"wide"				"%2"
		"tall"				"%1.6"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"textAlignment"		"east"
		"labelText"			"%unitstatsdenies%"
		"font" 				"Arial14Thick"
		"fgColor_override" 	"150 150 150 255"
		"bgcolor_override"	"0 0 0 0"
	}

//=====================================================================================================================
//
// More...
//

	"More"
	{
		"ControlName"				"CDOTAButton"
		"fieldName"					"More"
		"xpos"						"%31.1"
		"ypos"						"%2.4"
		"zpos"						"4"
		"wide"						"%2.6"
		"tall"						"%3.2"
		"visible"					"1"
		"enabled"					"1"
		"font" 						"Arial10Fine"
		"textAlignment"				"center"
		"command"					"unitmore"
		"labelText"					"#DOTA_More"
		"defaultFgColor_override"	"150 150 150 255"
		"defaultBgColor_override"	"36 36 36 255"
		"armedFgColor_override"		"150 150 150 255"
		"armedBgColor_override"		"36 36 36 255"
		"border"					"ButtonHUDBorder"
	}
}
