"Resource/UI/DOTAPlayContainer.res"
{
	controls
	{
		"DOTAPlayContainer"
		{
			"ControlName"		"EditablePanel"
			"xpos"			"0"
			//"ypos"			"56"
			"wide"	 		"f0"
			"tall"	 		"416"
			"zpos"			"21"
			"PaintBackground"	"1"
			"PaintBackgroundType"	"0"
			"bgcolor_override" "58 58 58 255"
		}
		
		"Background" {	ControlName=ImagePanel xpos=0 ypos=0 zpos=0 wide=f0 tall=f0 mouseInputEnabled=0 scaleImage=1 image=dashboard/dash_play_bg.vmt visible=0 }
		
		"DOTAPlayPanel" { ControlName=Panel zpos=5 }
		"DOTATutorialPanel" { ControlName=Panel zpos=2 }
		"DOTATournamentsPanel" { ControlName=Panel zpos=2 }
		
		"LockedOverlay" { ControlName=Panel zpos=20 xpos=0 ypos=0 wide=f0 tall=f0 mouseInputEnabled=1 style=LockedOverlayStyle }
		"DOTAMatchmakingStatusPanelBig" { ControlName=Panel zpos=22 xpos="c-250" ypos=0 wide=500 tall=416 }
	}
	include="resource/UI/dashboard_style.res"
	
	colors
	{
		LockedOverlayColor="0 0 0 220"
	}
	
	styles
	{
		include="resource/UI/dashboard_style.res"
		
		LockedOverlayStyle
		{
			render_bg
			{
				0="fill(x0,y0,x1,y1,LockedOverlayColor)"
			}
		}
	}	
}
