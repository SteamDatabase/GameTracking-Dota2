"Resource/UI/HUD_SpectatorPlayer.res"
{
	// Base.
// 	"HudDOTASpectatorPlayer"
// 	{
// 		"ControlName"		"EditablePanel"
// 		"fieldName"			"HudDOTASpectatorPlayer"
// 		"xpos"				"0"
// 		"ypos"				"0"
// 		"zpos"				"3"
// 		"wide"				"386"
// 		"tall"				"31.5"
// 		"visible"			"1"
// 		"enabled"			"1"
// 		"bgcolor_override"	"0 0 0 0"
// 		"fgcolor_override"	"0 0 0 0"	
// 	}

	//------------------------------------------------------//
	// Spectator Bar
	//
	"SpecPlayerBackground"
	{
		"ControlName"			"ImagePanel"
		"fieldName"				"SpecPlayerBackground"
//		"fillcolor"				"30 30 30 255"
		"xpos"					"0"					// Spacing is 8, but the sticks 2 pixels in/out. 
		"ypos"					"0"
		"zpos"					"0"
		"wide"					"370"
		"tall"					"31.5"
		"enabled"				"1"
		"scaleImage"			"1"
		"visible"				"1"
		"style"					"TheFuture"
	}

	"SpecPlayerUnit"
	{
		"ControlName"		"CDOTAButtonQuery"
		"fieldName"			"SpecPlayerUnit"
		"xpos"				"-2"
		"ypos"				"-2"
		"zpos"				"4"
		"wide"				"30"
		"tall"				"28"
		"visible"			"1"
		"enabled"			"1"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
		"textAlignment"		"center"
		"font" 				"Arial14Thick"
		
		"pin_to_sibling"			"SpecPlayerBackground"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"0"	
	}	
	
	"SpecPlayerName"
	{
		"ControlName"			"Label"
		"fieldName"				"SpecPlayerName"
		"xpos"					"4"
		"ypos"					"0"
		"zpos"					"4"
		"wide"					"74"
		"tall"					"10"
		"visible"				"1"
		"enabled"				"1"
		"labelText"				"Name"
		"textAlignment"			"north-west"
		"font"					"Arial10Thick"
		"fgColor_override" 		"194 194 194 255"
		"bgcolor_override"		"0 0 0 0"

		"pin_to_sibling"			"SpecPlayerUnit"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"	
	}
	
	"SpecPlayerHealth"
	{
		"ControlName"			"CDOTAFilledImage"
		"fieldName"				"SpecPlayerHealth"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"4"
		"wide"					"74"
		"tall"					"7"
		"visible"				"1"
		"enabled"				"1"
		"horizontal"			"1"
		"image"					"materials/vgui\hud\ui_progressbar_horizontal.vmat"
		"color"					"139 195 58 255"
		"bgcolor_override"		"51 51 51 255"

		"pin_to_sibling"			"SpecPlayerName"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"	
	}

	"SpecPlayerMana"
	{
		"ControlName"			"CDOTAFilledImage"
		"fieldName"				"SpecPlayerMana"
		"xpos"					"0"
		"ypos"					"2"
		"zpos"					"4"
		"wide"					"74"
		"tall"					"7"
		"visible"				"1"
		"enabled"				"1"
		"horizontal"			"1"
		"image"					"materials/vgui\hud\ui_progressbar_horizontal.vmat"
		"color"					"2 87 170 255"
		"bgcolor_override"		"51 51 51 255"
		
		"pin_to_sibling"			"SpecPlayerHealth"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"	
	}
	
	"SpecPlayerLevel"
	{
		"ControlName"			"Label"
		"fieldName"				"SpecPlayerLevel"
		"xpos"					"4"
		"ypos"					"0"
		"zpos"					"4"
		"wide"					"97"
		"tall"					"10"
		"visible"				"1"
		"enabled"				"1"
		"labelText"				"%SpectatorLevel%"
		"textAlignment"			"north-west"
		"font"					"Arial10Thick"
		"fgColor_override" 		"194 194 194 255"
		"bgcolor_override"		"0 0 0 0"

		"pin_to_sibling"			"SpecPlayerName"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"	
	}
	
	"SpecPlayerAbility_0"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"SpecPlayerAbility_0"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"4"
		"wide"				"16"
		"tall"				"16"
		"textAlignment"		"center"
		"ability_tooltip"	"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
		"scaleImage"		"1"
		"style"				"SpecAbility"

		"pin_to_sibling"			"SpecPlayerLevel"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"	
	}

	"SpecPlayerAbility_1"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"SpecPlayerAbility_1"
		"xpos"				"1"
		"ypos"				"0"
		"zpos"				"4"
		"wide"				"16"
		"tall"				"16"
		"textAlignment"		"center"
		"ability_tooltip"	"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
		"scaleImage"		"1"
		"style"				"SpecAbility"

		"pin_to_sibling"			"SpecPlayerAbility_0"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"	
	}

	"SpecPlayerAbility_2"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"SpecPlayerAbility_2"
		"xpos"				"1"
		"ypos"				"0"
		"zpos"				"4"
		"wide"				"16"
		"tall"				"16"
		"textAlignment"		"center"
		"ability_tooltip"	"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
		"scaleImage"		"1"
		"style"				"SpecAbility"

		"pin_to_sibling"			"SpecPlayerAbility_1"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"	
 	}

	"SpecPlayerAbility_3"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"SpecPlayerAbility_3"
		"xpos"				"1"
		"ypos"				"0"
		"zpos"				"4"
		"wide"				"16"
		"tall"				"16"
		"textAlignment"		"center"
		"ability_tooltip"	"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
		"scaleImage"		"1"
		"style"				"SpecAbility"

		"pin_to_sibling"			"SpecPlayerAbility_2"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"	
	}

	"SpecPlayerAbility_4"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"SpecPlayerAbility_4"
		"xpos"				"1"
		"ypos"				"0"
		"zpos"				"4"
		"wide"				"16"
		"tall"				"16"
		"textAlignment"		"center"
		"ability_tooltip"	"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
		"scaleImage"		"1"
		"style"				"SpecAbility"

		"pin_to_sibling"			"SpecPlayerAbility_3"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"	
	}

	"SpecPlayerAbility_5"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"SpecPlayerAbility_5"
		"xpos"				"1"
		"ypos"				"0"
		"zpos"				"4"
		"wide"				"16"
		"tall"				"16"
		"textAlignment"		"center"
		"ability_tooltip"	"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
		"scaleImage"		"1"
		"style"				"SpecAbility"

		"pin_to_sibling"			"SpecPlayerAbility_4"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"	
	}
	
	"GoldBackground"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"GoldBackground"
		"xpos"				"4"
		"ypos"				"0"
		"zpos"				"4"
		"wide"				"32"
		"tall"				"10"
		"enabled"			"1"
		"scaleImage"		"1"
		"visible"			"1"
		"image"				"materials/vgui/hud/ui_gold_bg.vmat"

		"pin_to_sibling"			"SpecPlayerLevel"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"	
	}

	"GoldLabel"
	{
		"ControlName"		"Label"
		"fieldName"			"GoldLabel"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"5"
		"wide"				"32"
		"tall"				"10"
		"visible"			"1"
		"enabled"			"1"
		"labelText"			"%goldlabeltext%"
		"textAlignment"		"north-east"
		"font" 				"Arial10Thick"
		"fgcolor_override"	"194 194 194 255"
		"bgcolor_override"	"0 0 0 0"

		"pin_to_sibling"			"GoldBackground"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"0"	
	}
	
	"SpecPlayerInventory_0"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"SpecPlayerInventory_0"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"4"
		"wide"				"16"
		"tall"				"16"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"font" 				"Arial10Thick"
		"ability_tooltip"	"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
		"scaleImage"		"1"

		"pin_to_sibling"			"GoldBackground"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"	
	}
	
	"SpecPlayerInventory_1"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"SpecPlayerInventory_1"
		"xpos"				"1"
		"ypos"				"0"
		"zpos"				"4"
		"wide"				"16"
		"tall"				"16"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"font" 				"Arial10Thick"
		"ability_tooltip"	"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
		"scaleImage"		"1"

		"pin_to_sibling"			"SpecPlayerInventory_0"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"	
	}
	
	"SpecPlayerInventory_2"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"SpecPlayerInventory_2"
		"xpos"				"1"
		"ypos"				"0"
		"zpos"				"4"
		"wide"				"16"
		"tall"				"16"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"font" 				"Arial10Thick"
		"ability_tooltip"	"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
		"scaleImage"		"1"

		"pin_to_sibling"			"SpecPlayerInventory_1"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"	
	}
	
	"SpecPlayerInventory_3"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"SpecPlayerInventory_3"
		"xpos"				"1"
		"ypos"				"0"
		"zpos"				"4"
		"wide"				"16"
		"tall"				"16"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"font" 				"Arial10Thick"
		"ability_tooltip"	"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
		"scaleImage"		"1"

		"pin_to_sibling"			"SpecPlayerInventory_2"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"	
	}
	
	"SpecPlayerInventory_4"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"SpecPlayerInventory_4"
		"xpos"				"1"
		"ypos"				"0"
		"zpos"				"4"
		"wide"				"16"
		"tall"				"16"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"font" 				"Arial10Thick"
		"ability_tooltip"	"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
		"scaleImage"		"1"

		"pin_to_sibling"			"SpecPlayerInventory_3"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"	
	}
	
	"SpecPlayerInventory_5"
	{
		"ControlName"		"CDOTAButton"
		"fieldName"			"SpecPlayerInventory_5"
		"xpos"				"1"
		"ypos"				"0"
		"zpos"				"4"
		"wide"				"16"
		"tall"				"16"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"font" 				"Arial10Thick"
		"ability_tooltip"	"1"
		"image"				"materials/vgui/hud/ui_skill_notlearned.vmat"
		"scaleImage"		"1"

		"pin_to_sibling"			"SpecPlayerInventory_4"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"	
	}
	
	"SpecPlayerKDA"
	{
		"ControlName"			"Label"
		"fieldName"				"SpecPlayerKDA"
		"xpos"					"-100"
		"ypos"					"0"
		"zpos"					"4"
		"wide"					"40"
		"tall"					"10"
		"visible"				"1"
		"enabled"				"1"
		"labelText"				""
		"textAlignment"			"north-east"
		"font"					"Arial10Thick"
		"fgColor_override" 		"194 194 194 255"
		"bgcolor_override"		"0 0 0 0"

		"pin_to_sibling"			"GoldBackground"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"0"	
	}					

	"SpecPlayerLD"
	{
		"ControlName"			"Label"
		"fieldName"				"SpecPlayerLD"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"4"
		"wide"					"40"
		"tall"					"10"
		"visible"				"1"
		"enabled"				"1"
		"labelText"				""
		"textAlignment"			"north-east"
		"font"					"Arial10Thick"
		"fgColor_override" 		"194 194 194 255"
		"bgcolor_override"		"0 0 0 0"

		"pin_to_sibling"			"SpecPlayerKDA"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"	
	}					
	
	"DeathImage"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"DeathImage"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"4"
		"wide"				"16"
		"tall"				"16"
		"enabled"			"0"
		"visible"			"0"
		"scaleImage"		"1"
		"image"				"materials/vgui/hud/scoreboard_death.vmat"

		"pin_to_sibling"			"SpecPlayerName"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"2"	
	}	
	
	"DeathLabel"
	{
		"ControlName"			"Label"
		"fieldName"				"DeathLabel"
		"xpos"					"2"
		"ypos"					"0"
		"zpos"					"4"
		"wide"					"92"
		"tall"					"16"
		"enabled"				"0"
		"visible"				"0"
		"textAlignment"			"center"
		"labelText"				"%deathlabel%"
		"font" 					"Arial10Thick"
		"fgColor_override" 		"194 194 194 255"
		"bgcolor_override"		"0 0 0 0"

		"pin_to_sibling"			"DeathImage"
		"pin_corner_to_sibling"		"0"
		"pin_to_sibling_corner"		"1"	
	}	
	
	Colors
	{
		startblack="50 50 50 255"
		endblack="30 30 30 255"
	}
		
	"Styles"
	{
		SpecAbility	
		{ 
			font=Arial10Thick 
		}
		
		"TheFuture"		
		{
			render_bg
			{
				0="gradient(x0,y0,x1,y1,startblack,endblack)"
			} 
		}
	}
	
	
}