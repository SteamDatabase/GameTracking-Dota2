
var OnRoomRevealed = function ( id, nPrevState )
{
	var seq = new RunSequentialActions();

	var center = $( '#Room0' );
	var panel = $( '#' + id );
	var fxPanel = $( '#FlareFX' );

	var x = panel.actualxoffset / panel.actualuiscale_x;
	var y = panel.actualyoffset / panel.actualuiscale_y;
	var cx = center.actualxoffset / center.actualuiscale_x;
	var cy = center.actualyoffset / center.actualuiscale_y;

	var w = 3072; //fxPanel.desiredlayoutwidth;
	var h = 3072; //fxPanel.desiredlayoutheight;
	x -= w / 2;
	y -= h / 2;
	y = -y;

	cx -= w / 2;
	cy -= h / 2;
	cy = -cy;

	var speed = 250;

	seq.actions.push( new ActionWithTimeout( new WaitForClassAction( fxPanel, 'SceneLoaded' ), 3.0 ) );

	seq.actions.push( new AddClassAction( fxPanel, 'ShowFlare' ) );
	seq.actions.push( new RunFunctionAction( function ()
	{
		$.DispatchEvent( 'PlaySoundEffect', 'ui_flare_fire' );
		fxPanel.FireEntityInput( 'flare_fx', 'SetControlPoint', '0: ' + cx + ' ' + cy + ' 0' );
		fxPanel.FireEntityInput( 'flare_fx', 'SetControlPoint', '1: ' + x + ' ' + y + ' 0' );
		fxPanel.FireEntityInput( 'flare_fx', 'SetControlPoint', '2: ' + speed + ' 0 0' );
		fxPanel.FireEntityInput( 'flare_fx', 'start', 0 );
	} ) );

	var dx = x - cx;
	var dy = y - cy;
	var duration = Math.sqrt( dx * dx + dy * dy ) / speed;
	duration = duration + 0.5;

	seq.actions.push( new WaitAction( duration ) );

	duration = 3.0;

	seq.actions.push( new RunFunctionAction( function ()
	{
		fxPanel.FireEntityInput( 'flare_fx', 'StopPlayEndCap', 0 );
		$.DispatchEvent( 'PlaySoundEffect', 'ui_flare_explode' );

		fxPanel.FireEntityInput( 'illumination_fx', 'SetControlPoint', '0: ' + x + ' ' + y + ' 0' );
		fxPanel.FireEntityInput( 'illumination_fx', 'SetControlPoint', '1: ' + ( duration - 1 ) + ' 0 0' );
		fxPanel.FireEntityInput( 'illumination_fx', 'start', 0 );
	} ) );

	seq.actions.push( new WaitAction( duration - 1.6 ) );

	seq.actions.push( new AddClassAction( panel, 'RewardRevealing' ) );
	seq.actions.push( new AddClassAction( panel, 'RewardRevealed' ) );
	seq.actions.push( new RemoveClassAction( panel, 'RewardUnavailable' ) );

	seq.actions.push( new WaitAction( 1.6 ) );

	seq.actions.push(new RemoveClassAction(panel, 'RewardRevealing'));
	seq.actions.push( new RemoveClassAction( fxPanel, 'ShowFlare' ) );

	seq.actions.push(new RunFunctionAction(function ()
	{
		fxPanel.FireEntityInput( 'flare_fx', 'stop', 0 );
		fxPanel.FireEntityInput( 'illumination_fx', 'stop', 0 );
		$.DispatchEvent( 'DOTACavernCrawlAdvanceUpdates', panel );
	}));

	RunSingleAction( seq );
}

var OnRoomAvailable = function (id, nPrevState)
{
    var seq = new RunSequentialActions();

    var panel = $('#' + id);

    if (nPrevState == 2)    // 2 is revealed
    {
        seq.actions.push(new AddClassAction(panel, 'RewardReavealedToAvailable'));
    }
    else
    {
        seq.actions.push(new AddClassAction(panel, 'RewardRevealing'));
    }
    seq.actions.push(new RemoveClassAction(panel, 'RewardRevealed'));
    seq.actions.push(new RemoveClassAction(panel, 'RewardUnavailable'));
    seq.actions.push(new WaitAction(1.3));

    seq.actions.push( new RunFunctionAction( function ()
    {
    	$.DispatchEvent( 'PlaySoundEffect', 'Relic.Received' );
    } ) );

    seq.actions.push(new WaitAction(0.3));

    seq.actions.push(new RemoveClassAction(panel, 'RewardRevealing'));
    seq.actions.push(new RemoveClassAction(panel, 'RewardReavealedToAvailable'));
    seq.actions.push(new AddClassAction(panel, 'RewardAvailable'));

    seq.actions.push( new WaitAction( 0.3 ) );

    seq.actions.push(new RunFunctionAction(function ()
    {
        $.DispatchEvent('DOTACavernCrawlAdvanceUpdates', panel);
    }));

    RunSingleAction(seq);
}

var OnRoomCompleted = function (id, nPrevState, isSet)
{
    var seq = new RunSequentialActions();

    var panel = $('#' + id);
    seq.actions.push(new RemoveClassAction(panel, 'RewardAvailable'));
    seq.actions.push(new AddClassAction(panel, 'RewardClaiming'));

    seq.actions.push(new RunFunctionAction(function ()
    {
        $.DispatchEvent('PlaySoundEffect', 'Shards.Stop.Increase');
    }));

    if ( isSet )
    {
    	seq.actions.push( new WaitAction( 0.7 ) );
    	seq.actions.push( new RunFunctionAction( function ()
    	{
    		$.DispatchEvent( 'PlaySoundEffect', 'Relic.Received' );
    	} ) );
    	seq.actions.push( new WaitAction( 0.3 ) );
    }
    else
    {
    	seq.actions.push( new WaitAction( 1.0 ) );
    }

    seq.actions.push(new RemoveClassAction(panel, 'RewardClaiming'));
    seq.actions.push( new AddClassAction( panel, 'RewardClaimed' ) );

    seq.actions.push( new WaitAction( 0.5 ) );

    seq.actions.push(new RunFunctionAction(function ()
    {
        $.DispatchEvent('DOTACavernCrawlAdvanceUpdates', panel);
    }));

    RunSingleAction(seq);
}

var OnPathRevealed = function (id, nPrevState)
{
    var seq = new RunSequentialActions();

    var panel = $('#' + id);
    seq.actions.push(new AddClassAction(panel, 'ChallengeRevealing'));
    seq.actions.push( new RemoveClassAction( panel, 'ChallengeUnavailable' ) );
    seq.actions.push( new AddClassAction( panel, 'ChallengeRevealed' ) );

    seq.actions.push( new RunFunctionAction( function ()
    {
    	$.DispatchEvent( 'PlaySoundEffect', 'ui_flare_explode' );
    } ) );

    seq.actions.push( new WaitAction( 1.6 ) );
    seq.actions.push( new RemoveClassAction( panel, 'ChallengeRevealing' ) );

    seq.actions.push(new RunFunctionAction(function ()
    {
        $.DispatchEvent('DOTACavernCrawlAdvanceUpdates', panel);
    }));

    RunSingleAction( seq );
}

var OnPathAvailable = function (id, nPrevState)
{
    var seq = new RunSequentialActions();

    var panel = $( '#' + id );

    if (nPrevState == 2)    // 2 is revealed
    {
        seq.actions.push(new AddClassAction(panel, 'ChallengeReavealedToAvailable'));
    }
    else
    {
        seq.actions.push(new AddClassAction(panel, 'ChallengeRevealing'));
    }

    seq.actions.push( new RemoveClassAction( panel, 'ChallengeUnavailable' ) );
    seq.actions.push( new RemoveClassAction( panel, 'ChallengeRevealed' ) );
    seq.actions.push(new WaitAction(1.3));

    seq.actions.push(new RunFunctionAction(function ()
    {
        $.DispatchEvent('PlaySoundEffect', 'Relic.Received');
    }));

    seq.actions.push( new WaitAction( 0.3 ) );

    seq.actions.push(new RemoveClassAction(panel, 'ChallengeRevealing'));
    seq.actions.push(new RemoveClassAction(panel, 'ChallengeReavealedToAvailable'));
    seq.actions.push(new AddClassAction(panel, 'ChallengeAvailable'));

    seq.actions.push(new RunFunctionAction(function ()
    {
        $.DispatchEvent('DOTACavernCrawlAdvanceUpdates', panel);
    }));

    RunSingleAction(seq);
}

var OnPathRetired = function ( id, nPrevState )
{
	var seq = new RunSequentialActions();

	var panel = $( '#' + id );

	seq.actions.push( new AddClassAction( panel, 'ChallengeRetiring' ) );

	seq.actions.push( new WaitAction( 1.6 ) );
	seq.actions.push( new RemoveClassAction( panel, 'ChallengeRetiring' ) );
	seq.actions.push( new AddClassAction( panel, 'ChallengeRetired' ) );
	seq.actions.push( new RemoveClassAction( panel, 'ChallengeAvailable' ) );
	seq.actions.push( new RemoveClassAction( panel, 'ChallengeRevealed' ) );

	seq.actions.push( new RunFunctionAction( function ()
	{
		$.DispatchEvent( 'DOTACavernCrawlAdvanceUpdates', panel );
	} ) );

	RunSingleAction( seq );
}

var OnPathCompleted = function (id, nPrevState)
{
    var seq = new RunSequentialActions();

    var panel = $('#' + id);

    var fxPanel = $('#ChallengeFX');
    var x = panel.actualxoffset / panel.actualuiscale_x;
    var y = panel.actualyoffset / panel.actualuiscale_y;
    fxPanel.SetPositionInPixels( x, y, 0 );

    seq.actions.push( new ActionWithTimeout( new WaitForClassAction( fxPanel, 'SceneLoaded' ), 2.0 ) );

    seq.actions.push(new AddClassAction(panel, 'ChallengeCompleting'));
    seq.actions.push(new RunFunctionAction(function ()
    {
        $.DispatchEvent('PlaySoundEffect', 'powerup_03');
    }));
    seq.actions.push(new WaitAction(2.0));
    seq.actions.push(new RemoveClassAction(panel, 'ChallengeCompleting'));
    seq.actions.push(new AddClassAction(fxPanel, 'ShowExplosion'));
    seq.actions.push(new RunFunctionAction(function ()
    {
        fxPanel.FireEntityInput('burst_fx', 'start', 0);
        $.DispatchEvent('PlaySoundEffect', 'ui_explosion');
    }));
    seq.actions.push(new WaitAction(0.2));
    seq.actions.push( new AddClassAction( panel, 'ChallengeCompleted' ) );

    seq.actions.push(new WaitAction(1.2));
    seq.actions.push(new RemoveClassAction(fxPanel, 'ShowExplosion'));
    seq.actions.push(new RunFunctionAction(function ()
    {			 
    	$.DispatchEvent( 'DOTACavernCrawlShowPathParticles', panel );
    	fxPanel.FireEntityInput( 'burst_fx', 'stop', 0 );
    }));
    seq.actions.push(new RunFunctionAction(function ()
    {
        $.DispatchEvent('DOTACavernCrawlAdvanceUpdates', panel );
    }));

    RunSingleAction(seq);
}

var OnPathSwapped = function ( id, id2, newImage, newImage2 )
{
	var seq = new RunSequentialActions();

	var panel = $( '#' + id );
	var fxPanel = $( '#ChallengeFX' );
	var x = panel.actualxoffset / panel.actualuiscale_x;
	var y = panel.actualyoffset / panel.actualuiscale_y;
	fxPanel.SetPositionInPixels( x, y, 0 );

	var panel2 = $( '#' + id2 );
	var fxPanel2 = null;
	if ( panel2 != null )
	{
		fxPanel2 = $( '#ChallengeFX2' );
		var x2 = panel2.actualxoffset / panel.actualuiscale_x;
		var y2 = panel2.actualyoffset / panel.actualuiscale_y;
		fxPanel2.SetPositionInPixels( x2, y2, 0 );
	}

	seq.actions.push( new ActionWithTimeout( new WaitForClassAction( fxPanel, 'SceneLoaded' ), 3.0 ) );
	if ( fxPanel2 != null )
	{
		seq.actions.push( new ActionWithTimeout( new WaitForClassAction( fxPanel2, 'SceneLoaded' ), 3.0 ) );
	}

	seq.actions.push( new AddClassAction( panel, 'ChallengeSwappingOut' ) );
	seq.actions.push( new AddClassAction( fxPanel, 'ShowSwap' ) );
	seq.actions.push( new RunFunctionAction( function ()
	{
		$.DispatchEvent( 'PlaySoundEffect', 'ui_swap' );
		fxPanel.FireEntityInput( 'swap_fx', 'start', 0 );
	} ) );

	if ( panel2 != null )
	{
		seq.actions.push( new AddClassAction( panel2, 'ChallengeSwappingOut' ) );
		seq.actions.push( new AddClassAction( fxPanel2, 'ShowSwap' ) );
		seq.actions.push( new RunFunctionAction( function ()
		{
			fxPanel2.FireEntityInput( 'swap_fx', 'start', 0 );
		} ) );
	}

	seq.actions.push( new WaitAction( 0.2 ) );

	seq.actions.push( new RemoveClassAction( panel, 'ChallengeSwappingOut' ) );
	seq.actions.push( new AddClassAction( panel, 'ChallengeSwappingIn' ) );
	seq.actions.push( new RunFunctionAction( function ()
	{
		var image = panel.FindChildTraverse( "Image" );
		image.SetImage( newImage );
	} ) );

	if ( panel2 != null )
	{
		seq.actions.push( new RemoveClassAction( panel2, 'ChallengeSwappingOut' ) );
		seq.actions.push( new AddClassAction( panel2, 'ChallengeSwappingIn' ) );
		seq.actions.push( new RunFunctionAction( function ()
		{
			image2 = panel2.FindChildTraverse( "Image" );
			image2.SetImage( newImage2 );
		} ) );
	}
	seq.actions.push( new WaitAction( 0.2 ) );

	seq.actions.push( new RemoveClassAction( panel, 'ChallengeSwappingIn' ) );
	seq.actions.push( new RemoveClassAction( fxPanel, 'ShowSwap' ) );
	seq.actions.push( new RunFunctionAction( function ()
	{
		fxPanel.FireEntityInput( 'swap_fx', 'stop', 0 );
	} ) );

	if ( panel2 != null )
	{
		seq.actions.push( new RemoveClassAction( panel2, 'ChallengeSwappingIn' ) );
		seq.actions.push( new RemoveClassAction( fxPanel2, 'ShowSwap' ) );
		seq.actions.push( new RunFunctionAction( function ()
		{
			fxPanel2.FireEntityInput( 'swap_fx', 'stop', 0 );
		} ) );
	}

	seq.actions.push( new RunFunctionAction( function ()
	{
		$.DispatchEvent( 'DOTACavernCrawlAdvanceUpdates', panel );
	} ) );

	RunSingleAction( seq );
}