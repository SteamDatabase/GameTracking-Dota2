"Resource/UI/scoreboard_friendly_player.res"
{
	controls
	{		
		"HeroImage"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"HeroImage"
			"zpos"				"2"
			"xpos"				"6"
			"ypos"				"2"
			"wide"				"20"
			"tall"				"20"
			"enabled"			"1"
			"visible"			"1"
			"scaleImage"		"1"
			"fillcolor"			"0 0 0 255"
			"mouseinputenabled"		"0"
		}
		
		"HeroModelBorder"
		{
			"ControlName"		"Panel"
			"fieldName"			"HeroModelBorder"
			"xpos"				"2"
			"ypos"				"2"
			"zpos"				"3"
			"wide"				"4"
			"tall"				"20"
			"enabled"			"1"
			"visible"			"1"
			"scaleImage"		"1"
			"paintbackgroundtype"	"0"
			"backgroundtype"	"2"
			"bgcolor_override"	"255 0 0 255"
			"mouseinputenabled"		"0"
		}
			
		"HeroDeadOverlay"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"HeroDeadOverlay"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"3"
			"wide"				"216"
			"tall"				"24"
			"enabled"			"1"
			"visible"			"0"
			"fillcolor"			"0 0 0 230"
			"mouseinputenabled"	"0"
		}
				
		"PlayerName"
		{
			"ControlName"			"Label"
			"fieldName"				"PlayerName"
			"xpos"					"30"
			"ypos"					"1"
			"zpos"					"1"
			"wide"					"200"
			"tall"					"12"
			"enabled"				"1"
			"textAlignment"			"north-west"
			"labelText"				"%playername%"
			"font" 					"Default"
			"style"					"PlayerName"
			"mouseinputenabled"		"0"
		}
				
		"KDALabel"
		{
			"ControlName"			"Label"
			"fieldName"				"KDALabel"
			"xpos"					"112"
			"ypos"					"1"
			"zpos"					"1"
			"wide"					"100"
			"tall"					"12"
			"enabled"				"1"
			"textAlignment"			"north-east"
			"labelText"				"99 / 99 / 99"
			"style"					"PlayerName"
			"mouseinputenabled"		"0"
		}
		
		"LastHitDenyLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"LastHitDenyLabel"
			"xpos"					"172"
			"ypos"					"12"
			"zpos"					"1"
			"wide"					"40"
			"tall"					"12"
			"enabled"				"1"
			"textAlignment"			"north-east"
			"labelText"				"99 / 99"
			"style"					"PlayerName"
			"mouseinputenabled"		"0"
		}	
		
		"LevelLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"LevelLabel"
			"xpos"					"103"
			"ypos"					"1"
			"zpos"					"1"
			"wide"					"200"
			"tall"					"12"
			"enabled"				"1"
			"textAlignment"			"north-west"
			"labelText"				"25"
			"style"					"PlayerName"
			"mouseinputenabled"		"0"
		}
		
		"UnitHealth"
		{
			"ControlName"		"CDOTAFilledImage"
			"fieldName"			"UnitHealth"
			"xpos"				"30"
			"ypos"				"14"
			"zpos"				"1"
			"wide"				"70"
			"tall"				"4"
			"visible"			"1"
			"enabled"			"1"
			"horizontal"		"1"
			"image"				"materials/vgui\hud\ui_progressbar_horizontal.vmat"
			"color"				"139 195 58 255"
			"bgcolor_override"	"51 51 51 255"
			"mouseinputenabled"		"0"
		}
		
		"UnitMana"
		{
			"ControlName"		"CDOTAFilledImage"
			"fieldName"			"UnitMana"
			"xpos"				"30"
			"ypos"				"19"
			"zpos"				"1"
			"wide"				"70"
			"tall"				"2"
			"visible"			"1"
			"enabled"			"1"
			"horizontal"		"1"
			"image"				"materials/vgui\hud\ui_progressbar_horizontal.vmat"
			"color"				"2 87 170 255"
			"bgcolor_override"	"51 51 51 255"
			"mouseinputenabled"		"0"
		}
		
		"DeathImage"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"DeathImage"
			"xpos"				"28"
			"ypos"				"10"
			"zpos"				"4"
			"wide"				"14"
			"tall"				"14"
			"enabled"			"1"
			"visible"			"1"
			"scaleImage"		"1"
			"image"				"materials/vgui/hud\scoreboard_death.vmat"
			"mouseinputenabled"		"0"
		}
		
		"HeroRespawnLabel"
		{
			"ControlName"			"Label"
			"fieldName"				"HeroRespawnLabel"
			"xpos"					"42"
			"ypos"					"10"
			"zpos"					"4"
			"wide"					"50"
			"tall"					"13"
			"enabled"				"1"
			"textAlignment"			"west"
			"labelText"				""
			"font" 					"DefaultTiny"
			"fgColor_override" 		"255 255 255 255"
			"bgcolor_override"		"0 0 0 0"
			"mouseinputenabled"		"0"
		}
				
		"Ability1"
		{
			"ControlName"		"CDOTAButton"
			"fieldName"			"Ability1"
			"xpos"				"103"
			"ypos"				"11"
			"zpos"				"1"
			"wide"				"12"
			"tall"				"12"
			"enabled"			"1"
			"visible"			"1"
			"mouseinputenabled"	"1"
		}
		
		"Ability2"
		{
			"ControlName"		"CDOTAButton"
			"fieldName"			"Ability2"
			"xpos"				"116"
			"ypos"				"11"
			"zpos"				"1"
			"wide"				"12"
			"tall"				"12"
			"enabled"			"1"
			"visible"			"1"		
			"ability_tooltip"	"1"
		}
		
		"Ability3"
		{
			"ControlName"		"CDOTAButton"
			"fieldName"			"Ability3"
			"xpos"				"129"
			"ypos"				"11"
			"zpos"				"1"
			"wide"				"12"
			"tall"				"12"
			"enabled"			"1"
			"visible"			"1"		
			"ability_tooltip"	"1"
		}
		
		"Ability4"
		{
			"ControlName"		"CDOTAButton"
			"fieldName"			"Ability4"
			"xpos"				"142"
			"ypos"				"11"
			"zpos"				"1"
			"wide"				"12"
			"tall"				"12"
			"enabled"			"1"
			"visible"			"1"	
			"ability_tooltip"	"1"
		}
		
		"Ability5"
		{
			"ControlName"		"CDOTAButton"
			"fieldName"			"Ability5"
			"xpos"				"154"
			"ypos"				"11"
			"zpos"				"10"
			"wide"				"12"
			"tall"				"12"
			"enabled"			"1"
			"visible"			"0"		
			"ability_tooltip"	"1"
		}
		
		"Ability6"
		{
			"ControlName"		"CDOTAButton"
			"fieldName"			"Ability6"
			"xpos"				"167"
			"ypos"				"11"
			"zpos"				"10"
			"wide"				"12"
			"tall"				"12"
			"enabled"			"1"
			"visible"			"0"		
			"ability_tooltip"	"1"
		}
	}
	
	color
	{
		playerbackground="238 38 38 255"
	}
	
	styles
	{
		PlayerBackground
		{
			render_bg
			{
				0="image_scalable( x0, y0, x1, y1, materials/vgui/hud/scoreboard_default_bg.vmat, 8, 8, 3, 3, 1, 1 )"
			}		
		}
		
		// mouseover player
		PlayerBackground:hover
		{
			render_bg
			{
				0="image_scalable( x0, y0, x1, y1, materials/vgui/hud/scoreboard_default_bg_over.vmat, 8, 8, 3, 3, 1, 1 )"
			}
		}
		
		// local player
		PlayerBackground:active
		{
			render_bg
			{
				0="image_scalable( x0, y0, x1, y1, materials/vgui/hud/scoreboard_me_bg.vmat, 8, 8, 3, 3, 1, 1 )"
			}
		}
		
		// local player mouseover
		PlayerBackground:active:hover
		{
			render_bg
			{
				0="image_scalable( x0, y0, x1, y1, materials/vgui/hud/scoreboard_me_bg_over.vmat, 8, 8, 3, 3, 1, 1 )"
			}
		}
		
		// dead player
		PlayerBackground:disabled
		{
			render_bg
			{
				0="image_scalable( x0, y0, x1, y1, materials/vgui/hud/scoreboard_default_bg.vmat, 8, 8, 3, 3, 1, 1 )"
			}
		}
		
		PlayerName
		{
			font=DefaultVeryTiny
			textcolor=white
		}
	}
}