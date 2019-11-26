var RunPageAnimation = function ()
{
	var seq = new RunSequentialActions();
	var page = $.GetContextPanel();

	// Disabling Fullscreen allows Menu UI to display
	$.DispatchEvent( 'DOTASetCurrentDashboardPageFullscreen', true );

	seq.actions.push( new WaitAction( 0.5 ) );
    seq.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'PlaySoundEffect', 'outlanders_takeover_stinger' ); } ) )
	seq.actions.push( new AddClassAction( page, 'ShowBackground' ) );
	seq.actions.push( new WaitAction( 3.0 ) );
	seq.actions.push( new AddClassAction( page, 'ShowTitle' ) );
	seq.actions.push( new WaitAction( 7.0 ) );
	seq.actions.push( new RemoveClassAction( page, 'ShowTitle' ) );
	seq.actions.push( new RemoveClassAction( page, 'ShowBackground' ) );
	seq.actions.push( new WaitAction( 2.0 ) );
	seq.actions.push( new RunFunctionAction( function () { $.DispatchEvent( 'DOTAShowVoidSpiritDebutPage', page ); } ) );
	
	RunSingleAction( seq );
}
