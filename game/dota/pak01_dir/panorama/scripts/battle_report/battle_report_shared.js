
function GetShardsForHighlightTier( nTier )
{
	switch ( nTier )
	{
		case 1: return 200;
		case 2: return 300;
		case 3: return 400;
		default: return 0;
	}
}

function ShowHighlightsTableImmediate( tableID )
{
	let screen = $.GetContextPanel();
	let table = $( '#' + tableID );

	let nShards = 0;
	let nRows = table.GetChildCount();
	for ( let iRow = 0; iRow < nRows; ++iRow )
	{
		let row = table.GetChild( iRow );
		let nCols = row.GetChildCount();

		for ( let iCol = 0; iCol < nCols; ++iCol )
		{
			let highlight = row.GetChild( iCol );
			let nTier = highlight.GetTier();

			highlight.AddClass( "ShowHighlight" );
			highlight.AddClass( "ShowMedal" );

			nShards += GetShardsForHighlightTier( nTier );
		}
	}

	screen.SetDialogVariableInt( 'screen_shards_earned', nShards );
}

function AnimateHighlightsTable( tableID )
{
	let screen = $.GetContextPanel();
	screen.SetDialogVariableInt( 'screen_shards_earned', 0 );

	let table = $( '#' + tableID );
	let seq = new RunSequentialActions();

	seq.actions.push( new DispatchEventAction( 'DOTABattleReportSetNavEnabled', false ) );
	seq.actions.push( new WaitAction( 0.4 ) );

	let nShards = 0;
	let nRows = table.GetChildCount();
	for ( let iRow = 0; iRow < nRows; ++iRow )
	{
		let row = table.GetChild( iRow );
		let nCols = row.GetChildCount();

		for ( let iCol = 0; iCol < nCols; ++iCol )
		{
			let highlight = row.GetChild( iCol );
			let nTier = highlight.GetTier();

			seq.actions.push( new AddClassAction( highlight, "ShowHighlight" ) );

			let strSound = '';
			switch ( nTier )
			{
				case 0: strSound = 'BattleReport.HighlightReceived.NoTier';	break;
				case 1: strSound = 'BattleReport.HighlightReceived.Bronze';	break;
				case 2: strSound = 'BattleReport.HighlightReceived.Silver';	break;
				case 3: strSound = 'BattleReport.HighlightReceived.Gold';	break;
            }
			if ( strSound != '' )
			{
				seq.actions.push( new PlaySoundAction( strSound ) );
			}

			seq.actions.push( new WaitAction( 0.1 ) );

			let nShardsEarned = GetShardsForHighlightTier( nTier );
			if ( nShardsEarned > 0 )
			{
				seq.actions.push( new AddClassAction( highlight, 'ShowMedal' ) );
				seq.actions.push( new SetDialogVariableIntAction( highlight, 'highlight_shards_earned', nShardsEarned ) );
				seq.actions.push( new AddClassAction( highlight, 'ShowShardsEarned' ) );
				seq.actions.push( new WaitAction( 0.5 ) );

				let duration = RemapValClamped( nShardsEarned, 0, 300, 0.3, 1.0 );
				let par = new RunParallelActions();
				par.actions.push( new AnimateDialogVariableIntAction( screen, 'screen_shards_earned', nShards, nShards + nShardsEarned, duration ) );
				par.actions.push( new AnimateDialogVariableIntAction( highlight, 'highlight_shards_earned', nShardsEarned, 0, duration ) );
				par.actions.push( new PlaySoundForDurationAction( "Shards.Count", duration ) );
				seq.actions.push( new AddClassAction( screen, 'ShardsCounting' ) );
				seq.actions.push( par );

				seq.actions.push( new PlaySoundAction( "Shards.Stop" ) );
				seq.actions.push( new RemoveClassAction( highlight, 'ShowShardsEarned' ) );

				nShards += nShardsEarned;
			}

			seq.actions.push( new WaitAction( 0.1 ) );
			seq.actions.push( new RemoveClassAction( screen, 'ShardsCounting' ) );
		}
	}

	seq.actions.push( new DispatchEventAction( 'DOTABattleReportSetNavEnabled', true ) );

	RunSingleAction( seq );
}

