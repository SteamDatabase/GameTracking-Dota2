"Resource/UI/scoreboard_enemy_player.res"
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
		}
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
		
		PlayerName
		{
			font=DefaultVeryTiny
			textcolor=white
		}
		
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
	}
}