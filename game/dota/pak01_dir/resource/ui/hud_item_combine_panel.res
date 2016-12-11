"Resource/UI/hud_item_combine_panel.res"
{
	this
	{
		"upcombine_ypos_offset"			"-43"
		"requirement_ypos_offset"		"43"
		"style"							"CombinePanel"
	}
	
	"Border"
	{
		"ControlName"	"Panel"
		"xpos"			"0"
		"ypos"			"0"
		"wide"			"400"
		"tall"			"400"
		"zpos"			"3"
		"visible"		"1"
		"mouseinputenabled"	"0"
		"style"			"Border"	
	}
	
	"SelectedItemHighlight"
	{
		"ControlName"	"Panel"
		"xpos"			"0"
		"ypos"			"50"
		"wide"			"250"
		"tall"			"40"		
		"zpos"			"1"
		"visible"		"1"
		"mouseinputenabled"	"0"
		"style"			"SelectionHighlight"	
	}
	
	colors
	{

		GridBackground="30 30 30 255"
		GridBorder="150 150 150 255"	
		
		SelectionHighlight="231 172 22 255"
		SelectionTop="231 172 22 128"
		SelectionBottom="231 172 22 20"
	}
	
	styles
	{
		CombinePanel
		{
			render_bg
			{
				0="fill(x0,y0,x1,y1,GridBackground)"
			}
		}
		
		Border
		{			
			render_bg
			{
				0="fill(x0,y0,x0+3,y1,GridBorder)"
				1="fill(x1-3,y0,x1,y1,GridBorder)"
				2="fill(x0,y1-3,x1,y1,GridBorder)"
				3="fill(x0,y0,x1,y0+3,GridBorder)"
			}
		}
		
		SelectionHighlight
		{
 			render
 			{
 				0="image_scalable( x0, y0, x1, y1, materials/vgui/hud/shop/tree_focus.vmat, 32, 32, 12, 12, 1, 1 )"
 			}
		}	
	}
	
	layout
	{
		region { name=Everything x=0 y=0 wide=max tall=max }
		place { region=Everything Control=Border }
	}
}
