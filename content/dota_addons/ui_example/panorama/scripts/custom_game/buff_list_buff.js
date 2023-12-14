function OnBuffClicked()
{
	var queryUnit = $.GetContextPanel().data().m_QueryUnit;
	var buffSerial = $.GetContextPanel().data().m_BuffSerial;
	var alertBuff = GameUI.IsAltDown();
	Players.BuffClicked( queryUnit, buffSerial, alertBuff );
}

function BuffShowTooltip()
{
	var queryUnit = $.GetContextPanel().data().m_QueryUnit;
	var buffSerial = $.GetContextPanel().data().m_BuffSerial;
	var isEnemy = Entities.IsEnemy( queryUnit );
	$.DispatchEvent( "DOTAShowBuffTooltip", $.GetContextPanel(), queryUnit, buffSerial, isEnemy );
}

function BuffHideTooltip()
{
	$.DispatchEvent( "DOTAHideBuffTooltip", $.GetContextPanel() );
}