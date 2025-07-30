function SetText(name, value)
{
	var element = $(name);

	if(element == null)
		return;

	element.text = value;
}

function Zeropad(number)
{
	if(number < 10)
		return "0" + number;

	return "" + number;
}

function UpdateTimer()
{
	if ( gGameInfo.m_fRoundStartTime == -1 )
	{
		SetText('#TimerRemaining', "...");
		$( "#TimerRemaining" ).SetHasClass( "overtime", false );
		$.Schedule( 1, UpdateTimer );
		return;
	}

	var maxSeconds = gGameInfo.m_fRoundDuration;
	var timeRemaining = maxSeconds - ( Game.GetGameTime() - gGameInfo.m_fRoundStartTime );

	if ( gGameInfo.m_bIsOverTime )
	{
		$( "#TimerRemaining" ).SetHasClass( "overtime", true );
	}
	else
	{
		$( "#TimerRemaining" ).SetHasClass( "overtime", false );
	}

	if ( timeRemaining >= 0 )
	{
		var minutes = Zeropad( Math.floor( timeRemaining / 60 ) );
		var seconds = Zeropad( Math.floor( timeRemaining - minutes * 60 ) );

		SetText( '#TimerRemaining', "" + minutes + ":" + seconds );
	}

	$.Schedule( 1, UpdateTimer );
}

function OnLastHitTrainerGameInfoUpdated( tableName, key, data )
{
	gGameInfo = data;
	UpdateTimer();
}

(function()
{
	CustomNetTables.SubscribeNetTableListener("last_hit_trainer_gameinfo", OnLastHitTrainerGameInfoUpdated);
})();
