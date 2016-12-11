"Resource/UI/UnitHealthBar_Hero.res"
{
	"HudDOTAHeroInfoElement"
	{
		"ControlName"		"EditablePanel"
		"fieldName"		"HudDOTAHeroInfoElement"
		"zpos"			"0"
		"visible"		"1"
		"enabled"		"1"
		"xpos"			"0"
		"ypos"			"0"
		"wide"			"128"
		"tall"			"64"
		"bgcolor"		"0 0 0 0"
		"bgcolor_override"			"0 0 0 0"
		"fgcolor_override"			"0 0 0 0"	
		PaintBackgroundEnabled=0
		style=NoBackground
	}
	
	HeroName { ControlName=Label fieldName=HeroName xpos=0 ypos=0 wide=128 tall=14 zpos=2 textAlignment=center style=HeroNameStyle }

	"UnitHealthBarBackground"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"		"UnitHealthBarBackground"
		"xpos"			"32"
		"ypos"			"6"
		"wide"			"75"
		"tall"			"40"
		"zpos"			"3"
		"enabled"		"1"
		"scaleImage"		"1"
		"visible"		"1"
		"image"			"materials/vgui/hud/hud_healthbar_bg_team.vmat"
		"image_enemy"		"materials/vgui/hud/hud_healthbar_bg_enemy.vmat"
	}

	"UnitHealthBarEmptyBackground"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"		"UnitHealthBarBackground"
		"xpos"			"32"
		"ypos"			"6"
		"wide"			"75"
		"tall"			"40"
		"zpos"			"4"
		"enabled"		"1"
		"scaleImage"		"1"
		"visible"		"1"
		"image"			"materials/vgui/hud/hud_healthbar_empty_team.vmat"
		"image_enemy"		"materials/vgui/hud/hud_healthbar_empty_enemy.vmat"
	}

	"UnitHealthBar"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"		"UnitHealthBar"
		"xpos"			"32"
		"ypos"			"6"
		"wide"			"75"
		"tall"			"40"
		"zpos"			"5"
		"enabled"		"1"
		"scaleImage"		"1"
		"visible"		"1"
		"horizontal"		"1"
		"image"			"materials/vgui/hud/hud_healthbar_healthfull_team.vmat"
		"image_enemy"		"materials/vgui/hud/hud_healthbar_healthfull_enemy.vmat"
		"progressbar_min"	"0.039"
		"progressbar_max"	"0.961"
	}

	"UnitManaBar"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"		"UnitManaBar"
		"xpos"			"32"
		"ypos"			"6"
		"wide"			"75"
		"tall"			"40"
		"zpos"			"5"
		"enabled"		"1"
		"scaleImage"		"1"
		"visible"		"1"
		"horizontal"		"1"
		"image"			"materials/vgui/hud/hud_healthbar_manafull_team.vmat"
		"image_enemy"	"materials/vgui/hud/hud_healthbar_manafull_enemy.vmat"
		"progressbar_min"	"0.039"	
		"progressbar_max"	"0.961"
	}
	
	"UnitLifeTimeBar"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"		"UnitLifeTimeBar"
		"xpos"			"19"
		"ypos"			"12"
		"wide"			"12"
		"tall"			"12"
		"zpos"			"4"
		"enabled"		"1"
		"scaleImage"		"1"
		"visible"		"1"
		"image"				"materials/vgui/hud/hud_timer_empty.vmat"
		"background_image"		"materials/vgui/hud/hud_timer_full.vmat" 
		"progressbar_min"	".98"
		"progressbar_max"	"0"
	}
	"colors"
	{
		HeroNameColor="230 230 230 220"
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
		HeroNameStyle
		{
			textcolor=HeroNameColor
			font=UnitInfoHeroNameFont
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
	}
}
