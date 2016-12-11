"Resource/UI/HeroSelection_SelectionDetails.res"
{
	
	// Ability / Info Section
	// Break this into a HeroDetailPage_Ability
	//=======================
		
	"IntroPage"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"IntroPage"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"2"
		"wide"				"460"
		"tall"				"389"
		"visible"			"0"
		"enabled"			"1"	
		"bgcolor_override" "255 0 0 0"
	}
	
	"AbilityPage1"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"AbilityPage1"
		"xpos"				"-9"
		"ypos"				"-9"
		"zpos"				"2"
		"wide"				"460"
		"tall"				"389"
		"visible"			"0"
		"enabled"			"1"	
		"bgcolor_override" "255 0 0 0"
		
		"ability"			"1"
	}
	
	"AbilityPage2"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"AbilityPage2"
		"xpos"				"-9"
		"ypos"				"-9"
		"zpos"				"2"
		"wide"				"460"
		"tall"				"389"
		"visible"			"0"
		"enabled"			"1"	
		"bgcolor_override" "255 0 0 0"
		
		"ability"			"2"
	}
	
	"AbilityPage3"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"AbilityPage3"
		"xpos"				"-9"
		"ypos"				"-9"
		"zpos"				"2"
		"wide"				"460"
		"tall"				"389"
		"visible"			"0"
		"enabled"			"1"	
		"bgcolor_override" "255 0 0 0"
		
		"ability"			"3"
	}
	
	"AbilityPage4"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"AbilityPage4"
		"xpos"				"-9"
		"ypos"				"-9"
		"zpos"				"2"
		"wide"				"460"
		"tall"				"389"
		"visible"			"0"
		"enabled"			"1"	
		"bgcolor_override" "255 0 0 0"
		
		"ability"			"4"
	}
	
	"GuidePage"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"GuidePage"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"2"
		"wide"				"460"
		"tall"				"389"
		"visible"			"0"
		"enabled"			"1"	
		"bgcolor_override" "255 0 0 0"
		
		"default_page"		"media/web/%s_guide.htm"
	}
	
	"BackgroundInfoPage"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"BackgroundInfoPage"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"2"
		"wide"				"460"
		"tall"				"389"
		"visible"			"0"
		"enabled"			"1"
		"bgcolor_override" "255 0 0 0"	
		
		"default_page"		"media/web/%s_background.htm"
	}
	
	"StatisticsPage"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"StatisticsPage"
		"xpos"				"-9"
		"ypos"				"-9"
		"zpos"				"2"
		"wide"				"460"
		"tall"				"389"
		"visible"			"0"
		"enabled"			"1"	
		"bgcolor_override" "255 0 0 0"
		
		"primary_attribute_color"	"251 176 64 255"
		"other_attribute_color"	"230 230 230 255"
	}
		
	// Page Selection

	"SelectedAbilityArrow"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"SelectedAbilityArrow"
		"xpos"				"77"
		"ypos"				"300"
		"zpos"				"3"
		"wide"				"18"
		"tall"				"8"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"drawcolor"			"120 120 120 255"
		"image"				"materials/vgui/downarrow.vmat"
	}
	
	"PageButton_1"
	{
		"ControlName"		"DOTAButton"
		"fieldName"			"PageButton_1"
		"xpos"				"0"
		"ypos"				"310"
		"wide"				"39"
		"tall"				"39"
		"zpos"				"3"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"command"			"page_1"
		"font" 				"Default"
		"image"				"materials/vgui/hud/hudicons/model_icon.vmat"

		"defaultBgColor_override"	"72 72 72 255"
		"armedBgColor_override"		"119 119 119 255"
		"PaintBackgroundType"	"2"
	}
	
	"PageButton_2"
	{
		"ControlName"		"DOTAButton"
		"fieldName"			"PageButton_2"
		"xpos"				"4"
		"ypos"				"0"
		"wide"				"39"
		"tall"				"39"
		"zpos"				"3"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"command"			"page_2"
		"font" 				"Default"

		"defaultBgColor_override"	"72 72 72 255"
		"armedBgColor_override"		"119 119 119 255"
		"PaintBackgroundType"	"2"
		
		"pin_to_sibling"		"PageButton_1"
		"pin_corner_to_sibling"	"0"
		"pin_to_sibling_corner"	"1"
	}
	
	"PageButton_3"
	{
		"ControlName"		"DOTAButton"
		"fieldName"			"PageButton_3"
		"xpos"				"4"
		"ypos"				"0"
		"wide"				"39"
		"tall"				"39"
		"zpos"				"3"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"command"			"page_3"
		"font" 				"Default"

		"defaultBgColor_override"	"72 72 72 255"
		"armedBgColor_override"		"119 119 119 255"
		"PaintBackgroundType"	"2"
		
		"pin_to_sibling"		"PageButton_2"
		"pin_corner_to_sibling"	"0"
		"pin_to_sibling_corner"	"1"
	}
	
	"PageButton_4"
	{
		"ControlName"		"DOTAButton"
		"fieldName"			"PageButton_4"
		"xpos"				"4"
		"ypos"				"0"
		"wide"				"39"
		"tall"				"39"
		"zpos"				"3"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"command"			"page_4"
		"font" 				"Default"

		"defaultBgColor_override"	"72 72 72 255"
		"armedBgColor_override"		"119 119 119 255"
		"PaintBackgroundType"	"2"
		
		"pin_to_sibling"		"PageButton_3"
		"pin_corner_to_sibling"	"0"
		"pin_to_sibling_corner"	"1"
	}
	
	"PageButton_5"
	{
		"ControlName"		"DOTAButton"
		"fieldName"			"PageButton_5"
		"xpos"				"4"
		"ypos"				"0"
		"wide"				"39"
		"tall"				"39"
		"zpos"				"3"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"command"			"page_5"
		"font" 				"Default"

		"defaultBgColor_override"	"72 72 72 255"
		"armedBgColor_override"		"119 119 119 255"
		"PaintBackgroundType"	"2"
		
		"pin_to_sibling"		"PageButton_4"
		"pin_corner_to_sibling"	"0"
		"pin_to_sibling_corner"	"1"
	}
	
	"PageButton_6"
	{
		"ControlName"		"DOTAButton"
		"fieldName"			"PageButton_6"
		"xpos"				"4"
		"ypos"				"0"
		"wide"				"39"
		"tall"				"39"
		"zpos"				"3"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"command"			"page_6"
		"font" 				"Default"
		"image"				"materials/vgui/hud/hudicons/guide_icon.vmat"

		"defaultBgColor_override"	"72 72 72 255"
		"armedBgColor_override"		"119 119 119 255"
		"PaintBackgroundType"	"2"
		
		"pin_to_sibling"		"PageButton_5"
		"pin_corner_to_sibling"	"0"
		"pin_to_sibling_corner"	"1"
	}
	
	"PageButton_7"
	{
		"ControlName"		"DOTAButton"
		"fieldName"			"PageButton_7"
		"xpos"				"4"
		"ypos"				"0"
		"wide"				"39"
		"tall"				"39"
		"zpos"				"3"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"command"			"page_7"
		"font" 				"Default"
		"image"				"materials/vgui/hud/hudicons/lore_icon.vmat"

		"defaultBgColor_override"	"72 72 72 255"
		"armedBgColor_override"		"119 119 119 255"
		"PaintBackgroundType"	"2"
		
		"pin_to_sibling"		"PageButton_6"
		"pin_corner_to_sibling"	"0"
		"pin_to_sibling_corner"	"1"
	}
	
	"PageButton_8"
	{
		"ControlName"		"DOTAButton"
		"fieldName"			"PageButton_8"
		"xpos"				"4"
		"ypos"				"0"
		"wide"				"39"
		"tall"				"39"
		"zpos"				"3"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"command"			"page_8"
		"font" 				"Default"
		"image"				"materials/vgui/hud/hudicons/statistics_icon.vmat"

		"defaultBgColor_override"	"72 72 72 255"
		"armedBgColor_override"		"119 119 119 255"
		"PaintBackgroundType"	"2"
		
		"pin_to_sibling"		"PageButton_7"
		"pin_corner_to_sibling"	"0"
		"pin_to_sibling_corner"	"1"
	}
	
}