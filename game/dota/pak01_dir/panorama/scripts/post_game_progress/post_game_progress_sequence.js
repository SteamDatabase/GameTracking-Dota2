// ----------------------------------------------------------------------------
//   All Screens
// ----------------------------------------------------------------------------

function CreateProgressAnimationSequence( data )
{
	// Uncomment if you want to see the data coming from C++
	// $.Msg( JSON.stringify( data, null, 2 ) );

	var seq = new RunSequentialActions();

	// While the actions are animating, don't allow clicking links to other screens.
	seq.actions.push( new RunFunctionAction( function () 
	{
		GetScreenLinksContainer().enabled = false;
	}));

	if ( data.diretide_rewards_progress != null )
	{
		seq.actions.push( new AnimateDiretideRewardsScreenAction( data ) );
	}

	if ( data.mvp2 != null )
	{
		seq.actions.push( new AnimateMVP2ScreenAction( data ) );
	}

	if ( data.coaches_need_rating != null )
	{
		for (var i = 0; i < data.coaches_need_rating.length; ++i)
		{
			seq.actions.push( new AnimateCoachRatingScreenAction( data, data.coaches_need_rating[ i ] ) );
		}
	}

	if ( data.mvp_voting_progress != null )
	{
		seq.actions.push( new AnimateMVPVotingScreenAction( data ) );
	}

	if ( data.cavern_crawl_progress != null )
	{
		seq.actions.push( new AnimateCavernCrawlScreenAction( data ) );
	}

	// should be right before battle pass progress screen because it shares the "battle point progress" element
	if ( data.gauntlet_progress != null )
	{
		seq.actions.push( new AnimateGauntletProgressScreenAction( data, data.gauntlet_progress ) );
	}

	if ( data.battle_pass_progress != null )
	{
		seq.actions.push( new AnimateBattlePassScreenAction( data ) );
	}

	if ( data.rubick_arcana_progress != null )
	{
		seq.actions.push( new AnimateRubickArcanaScreenAction( data ) );
    }

	if ( data.wraith_king_arcana_progress != null )
	{
		seq.actions.push( new AnimateWraithKingArcanaScreenAction( data ) );
	}

	if ( data.hero_badge_progress_old != null || data.hero_relics_progress_old != null )
	{
		seq.actions.push( new AnimateHeroBadgeLevelScreenAction( data ) );
	}

	if ( data.hero_badge_progress != null || data.dota_plus_progress != null || data.guild_progress != null )
	{
		seq.actions.push( new AnimateMatchRewardsScreenAction( data ) );
	}

	if ( data.hero_relics_progress != null )
	{
		seq.actions.push( new AnimateHeroRelicsScreenAction( data ) );
	}

	if ( data.frostivus_progress != null )
	{
		seq.actions.push( new AnimateFrostivusScreenAction( data ) );
	}

	if ( data.event_points_progress != null )
	{
		seq.actions.push( new AnimateEventPointsScreenAction( data ) );
	}

	if ( data.player_match_survey_progress != null )
	{
		seq.actions.push( new AnimatePlayerMatchSurveyScreenAction( data ) );
	}

	seq.actions.push( new RunFunctionAction( function ()
	{
		GetScreenLinksContainer().enabled = true;
	} ) );

	return seq;
}

function TestProgressAnimation( data )
{
	StopSkippingAhead();
	RunSingleAction( CreateProgressAnimationSequence( data ) );
}

/* Called from C++ to start the progress animation */
function StartProgressAnimation( data )
{
	ResetScreens();
	StopSkippingAhead();

	var seq = CreateProgressAnimationSequence( data );
	// Signal back to the C++ code that we're done displaying progress
	seq.actions.push( new RunFunctionAction( function ()
	{
		$.DispatchEvent( 'DOTAPostGameProgressAnimationComplete', $.GetContextPanel() );
	} ) );

	RunSingleAction( seq );
}

function HideProgress()
{
	// Just tell the C++ code that we're done by dispatching the event
	$.DispatchEvent( 'DOTAPostGameProgressAnimationComplete', $.GetContextPanel() );
}
