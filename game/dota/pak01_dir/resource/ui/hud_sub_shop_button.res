"Resource/UI/HUD_Sub_Shop_Button.res"
{
	"Background"
	{
		"ControlName"		"Panel"
		"fieldName"			"Background"
		"xpos"				"0"
		"ypos"				"0"
		"wide"				"32"
		//"tall"				"45"
		"tall"				"18"
		"visible"			"1"
		"enabled"			"0"
		"style"				"Background"
		"mouseinputenabled"	"0"
	}
	
	"InactiveImage"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"InactiveImage"
		"xpos"				"6"
		"ypos"				"0"
		"zpos"				"2"
		"zpos"				"1"
		"wide"				"20"
		"tall"				"20"
		"visible"			"1"
		"ScaleImage"		"1"
		"mouseinputenabled"	"0"
	}
	
	"ActiveImage"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"ActiveImage"
		"xpos"				"6"
		"ypos"				"0"
		"zpos"				"2"
		"zpos"				"1"
		"wide"				"20"
		"tall"				"20"
		"visible"			"1"
		"ScaleImage"		"1"
		"mouseinputenabled"	"0"
	}
	
	colors
	{
		SubShopBGActive="0 0 0 50"
		SubShopBGInactive="0 0 0 200"
	}
	
	styles
	{	
		Background
		{		
			render_bg 
			{
				0="roundedfill( x0+1, y0, x1, y1, 3, SubShopBGActive )"
			}
		}
		
		Background:disabled
		{
			render_bg 
			{			
				0="roundedfill( x0, y0, x1, y1, 3, SubShopBGInactive )"
			}
		}
	}
}
