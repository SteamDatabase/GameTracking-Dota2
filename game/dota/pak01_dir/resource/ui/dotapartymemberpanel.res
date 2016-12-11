"Resource/UI/DOTAPartyMemberPanel.res"
{
	controls
	{
		Avatar { ControlName=Panel fieldName=Avatar scaleImage=1 xpos=8 ypos=8 wide=64 zpos=1 tall=64 mouseInputEnabled=1 }
		MenuButton { ControlName=Button fieldName=MenuButton xpos=8 ypos=8 wide=64 tall=64 zpos=2 mouseInputEnabled=1 command="UserMenu" style=InvisibleButtonStyle }
		LeaderIcon { ControlName=ImagePanel fieldName=LeaderIcon scaleImage=1 xpos=4 ypos=4 wide=25 tall=25 zpos=3 image="hud/itemicons/item_circlet" mouseInputEnabled=0 }
	}
	include="resource/UI/dashboard_style.res"
	
	colors
	{
	}
	
	styles
	{
		include="resource/UI/dashboard_style.res"		
	}	
	
	layout
	{
		
	}
}
