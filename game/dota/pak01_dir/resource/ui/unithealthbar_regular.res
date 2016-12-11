"Resource/UI/UnitHealthBar_Regular.res"
{
	"HudDOTAUnitInfoElement"
	{
		"ControlName"		"EditablePanel"
		"fieldName"		"HudDOTAUnitInfoElement"
		"zpos"			"0"
		"visible"		"1"
		"enabled"		"1"
		"xpos"			"0"
		"ypos"			"0"
		"wide"			"75"
		"tall"			"32"
		"bgcolor_override"			"0 0 0 0"
		"fgcolor_override"			"0 0 0 0"	
		PaintBackgroundEnabled=0
		style=NoBackground
	}

	"HeroName"
	{
		"ControlName"		"Label"
		"fieldName"		"HeroName"
		"xpos"			"0"
		"ypos"			"0"
		"wide"			"24"
		"tall"			"14"
		"zpos"			"2"
		"autoResize"		"1"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"0"
		"labelText"		"Zeus"
		"textAlignment"		"center"
		"dulltext"		"0"
		"brighttext"		"1"
		"bgcolor_override"	"0 0 0 0"
		"fgcolor_override"	"200 200 200 255"
	}

	"UnitHealthBarBackground"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"		"UnitHealthBarBackground"
		"xpos"			"12"
		"ypos"			"1"
		"wide"			"60"
		"tall"			"10"
		"zpos"			"3"
		"enabled"		"1"
		"scaleImage"		"1"
		"visible"		"1"
		"image"			"materials/vgui/hud/hud_healthbar_creeps_bg.vmat"
		"horizontal"		"1"
	}

	"UnitHealthBarEmptyBackground"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"		"UnitHealthBarBackground"
		"xpos"			"12"
		"ypos"			"1"
		"wide"			"60"
		"tall"			"10"
		"zpos"			"4"
		"enabled"		"1"
		"scaleImage"	"1"
		"visible"		"1"
		"image"				"materials/vgui/hud/hud_healthbar_creepempty_team.vmat"
		"image_enemy"		"materials/vgui/hud/hud_healthbar_creepempty_enemy.vmat"
	}


	"UnitHealthBar"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"		"UnitHealthBar"
		"xpos"			"12"
		"ypos"			"1"
		"wide"			"60"
		"tall"			"10"
		"zpos"			"5"
		"enabled"		"1"
		"scaleImage"	"1"
		"visible"		"1"
		"horizontal"	"1"
		"image"						"materials/vgui/hud/hud_healthbar_creepfull_team.vmat"
		"image_enemy"				"materials/vgui/hud/hud_healthbar_creepfull_enemy.vmat"
		"progressbar_min"	"0.0703125"
		"progressbar_max"	"0.96"
	}

	"UnitManaBar"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"		"UnitManaBar"
		"xpos"			"12"
		"ypos"			"1"
		"wide"			"36"
		"tall"			"36"
		"zpos"			"5"
		"enabled"		"0"
		"scaleImage"		"1"
		"visible"		"0"
		"horizontal"		"1"
		"image"			"materials/vgui/hud/hud_healthbar_manafull_team.vmat"
		"image_enemy"		"materials/vgui/hud/hud_healthbar_manafull_enemy.vmat"
		"progressbar_min"	"0.07"
		"progressbar_max"	"0.9375"
	}
	
	
	"UnitLifeTimeBar"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"		"UnitLifeTimeBar"
		"xpos"			"0"
		"ypos"			"0"
		"wide"			"12"
		"tall"			"12"
		"zpos"			"6"
		"enabled"		"1"
		"scaleImage"		"1"
		"visible"		"1"
		"image"				"materials/vgui/hud/hud_timer_empty.vmat"
		"background_image"		"materials/vgui/hud/hud_timer_full.vmat" 
		"progressbar_min"	".98"
		"progressbar_max"	"0"
	}
	styles
	{
		NoBackground
		{
			bgcolor=none
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
	}
}
