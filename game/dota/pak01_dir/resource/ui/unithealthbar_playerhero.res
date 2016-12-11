"Resource/UI/UnitHealthBar_PlayerHero.res"
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
		"wide"			"92"
		"tall"			"48"
		"bgcolor"		"0 0 0 0"
		"bgcolor_override"			"0 0 0 0"
		"fgcolor_override"			"0 0 0 0"	
		PaintBackgroundEnabled=0
		style=NoBackground
	}
	
	HeroName { ControlName=Label fieldName=HeroName xpos=0 ypos=0 wide=64 tall=14 zpos=2 textAlignment=center fgcolor_override="200 200 200 255" bgcolor_override="0 0 0 0" }

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
		"image"			"materials/vgui/hud/hud_healthbar_bg_self.vmat"
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
		"enabled"		"1"
		"scaleImage"		"1"
		"visible"		"1"
		"image"			"materials/vgui/hud/hud_healthbar_empty_self.vmat"
	}

	"UnitHealthBar"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"		"UnitHealthBar"
		"xpos"			"0"
		"ypos"			"0"
		"wide"			"80"
		"tall"			"48"
		"zpos"			"5"
		"enabled"		"1"
		"scaleImage"		"1"
		"visible"		"1"
		"horizontal"		"1"
		"image"			"materials/vgui/hud/hud_healthbar_healthfull_self.vmat"
		"progressbar_min"	"0.024"
		"progressbar_max"	"0.973"
	}

	"UnitManaBar"
	{
		"ControlName"		"CDOTAFilledImage"
		"fieldName"		"UnitManaBar"
		"xpos"			"0"
		"ypos"			"0"
		"wide"			"80"
		"tall"			"48"
		"zpos"			"5"
		"enabled"		"1"
		"scaleImage"		"1"
		"visible"		"1"
		"horizontal"		"1"
		"image"			"materials/vgui/hud/hud_healthbar_manafull_self.vmat"
		"progressbar_min"	"0.024"
		"progressbar_max"	"0.973"
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
