function mysteryBoxMouseOver()
{
	$.Msg("Mystery Box MouseOver");
	var courierScenePanel = $("#Model");
	var MainPanel = $("#MainContainer");
	
	courierScenePanel.FireEntityInput( "selection", "Start", '' );
	courierScenePanel.SetHasClass( "Hovered", true );
	MainPanel.SetHasClass( "Hovered", true );
}

function mysteryBoxMouseOut()
{
	$.Msg("Mystery Box MouseOut");
	var courierScenePanel = $("#Model");
	var MainPanel = $("#MainContainer");
	courierScenePanel.FireEntityInput( "selection", "StopPlayEndCap", '' );
	courierScenePanel.SetHasClass( "Hovered", false );
	MainPanel.SetHasClass( "Hovered", false );
}

function mysteryBoxActivate()
{
}