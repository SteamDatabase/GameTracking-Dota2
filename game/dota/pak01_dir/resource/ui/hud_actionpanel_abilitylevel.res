"Resource/UI/HUD_ActionPanel_AbilityLevel.res"
{
	"Level1"
	{
		"ControlName"		"Panel"
		"fieldName"			"Level1"
		"wide"				"12"
		"tall"				"12"
		"minimum-width"		"12"
		"minimum-height"	"12"
		"visible"			"1"
		"enabled"			"0"
		"style"				"pip"
	}
	
	"Level2"
	{
		"ControlName"		"Panel"
		"fieldName"			"Level2"
		"wide"				"12"
		"tall"				"12"
		"minimum-width"		"12"
		"minimum-height"	"12"
		"visible"			"1"
		"enabled"			"0"
		"style"				"pip"
	}
	
	"Level3"
	{
		"ControlName"		"Panel"
		"fieldName"			"Level3"
		"wide"				"12"
		"tall"				"12"
		"minimum-width"		"12"
		"minimum-height"	"12"
		"visible"			"1"
		"enabled"			"0"
		"style"				"pip"
	}
	
	"Level4"
	{	
		"ControlName"		"Panel"
		"fieldName"			"Level4"
		"wide"				"12"
		"tall"				"12"
		"minimum-width"		"12"
		"minimum-height"	"12"
		"visible"			"0"
		"enabled"			"0"
		"style"				"pip"
	}	
	
	Styles
	{
		pip
		{
			render
			{
				0="image_scale( x0, y0, x1, y1, materials/vgui/hud/skill_pip_full_64.vmat )"	//
			}
		}
		
		pip:disabled
		{
			render
			{
				0="image_scale( x0, y0, x1, y1, materials/vgui/hud/skill_pip_empty_64.vmat )"
			}
		}	
	}
	
	Layout
	{
	}
}