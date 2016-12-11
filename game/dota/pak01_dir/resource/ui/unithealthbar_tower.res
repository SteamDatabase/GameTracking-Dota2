"Resource/UI/UnitHealthBar_Tower.res"
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
		"wide"			"80"
		"tall"			"48"
		"bgcolor_override"			"0 0 0 0"
		"fgcolor_override"			"0 0 0 0"	
		PaintBackgroundEnabled=0
		style=NoBackground
	}

	"UnitHealthBarBackground"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"		"UnitHealthBarBackground"
		"xpos"			"0"
		"ypos"			"0"
		"wide"			"80"
		"tall"			"48"
		"zpos"			"3"
		"enabled"		"1"
		"scaleImage"		"1"
		"visible"		"1"
		"image"			"materials/vgui/hud/hud_healthbar_tower_bg.vmat"
		"horizontal"		"1"
		"color"			"0 0 0 255"
	}

	"UnitHealthBarEmptyBackground"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"		"UnitHealthBarBackground"
		"xpos"			"0"
		"ypos"			"0"
		"wide"			"80"
		"tall"			"48"
		"zpos"			"4"
		"enabled"		"0"
		"scaleImage"		"1"
		"visible"		"0"
		"image"			"materials/vgui/hud/hud_healthbar_towerempty_team.vmat"
		"image_enemy"		"materials/vgui/hud/hud_healthbar_towerempty_enemy.vmat"
	}


	"UnitHealthBar"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"		"UnitHealthBar"
		"xpos"			"0"
		"ypos"			"0"
		"wide"			"80"
		"tall"			"48"
		"zpos"			"4"
		"enabled"		"1"
		"scaleImage"		"1"
		"visible"		"1"
		"horizontal"		"1"
		"image"				"materials/vgui/hud/hud_healthbar_towerfull_team.vmat"
		"background_image"		"materials/vgui/hud/hud_healthbar_towerempty_team.vmat" 
		"image_enemy"			"materials/vgui/hud/hud_healthbar_towerfull_enemy.vmat"
		"background_image_enemy"	"materials/vgui/hud/hud_healthbar_towerempty_enemy.vmat" 
		"progressbar_min"	"0.01"
		"progressbar_max"	"0.99"
	}

	"UnitManaBar"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"		"UnitManaBar"
		"xpos"			"0"
		"ypos"			"0"
		"wide"			"36"
		"tall"			"36"
		"zpos"			"5"
		"enabled"		"0"
		"visible"		"0"
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
