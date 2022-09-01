// ----------------------------------------------------------------------------
//
// Coach Rating Screen
//
// ----------------------------------------------------------------------------

class WaitForRatingStateChange extends WaitForConditionAction
{
	constructor( panel )
	{
		super( () =>
		{
			var goodRatingButton = panel.FindChildInLayoutFile( 'GoodRatingButton' );
			if ( goodRatingButton.BHasClass( 'Selected' ) )
				return true;

			var badRatingButton = panel.FindChildInLayoutFile( 'BadRatingButton' );
			if ( badRatingButton.BHasClass( 'Selected' ) )
				return true;

			var abusiveRatingButton = panel.FindChildInLayoutFile( 'AbusiveRatingButton' );
			if ( abusiveRatingButton.BHasClass( 'Selected' ) )
				return true;

			return false;
		} );
	}
}

class WaitForAbusiveRatingPopupAction extends WaitForConditionAction
{
	constructor()
	{
		super( () => !this.popupActive );
		this.popupActive = false;
	}
}

class WaitForSurveyStateChange extends WaitForConditionAction
{
	constructor( panel )
	{
		super( () =>
		{
			var goodRatingContainer = panel.FindChildInLayoutFile( 'GoodRatingContainer' );
			if ( !goodRatingContainer.enabled )
				return true;

			var badRatingContainer = panel.FindChildInLayoutFile( 'BadRatingContainer' );
			if ( !badRatingContainer.enabled )
				return true;

			var skipButton = panel.FindChildInLayoutFile( 'SkipButton' );
			if ( skipButton.BHasClass( 'Selected' ) )
				return true;

			return false;

		} );
	}
}

class AnimateCoachRatingScreenAction extends RunSequentialActions
{
	constructor( data, coach_data )
	{
		super();
		this.data = data;
		this.coach_data = coach_data;
	}

	start()
	{
		var action_data = this.data;
		var rating_data = this.coach_data;

		// Create the screen and do a bunch of initial setup
		var panel = StartNewScreen( 'CoachRatingScreen' );
		panel.BLoadLayoutSnippet( "CoachRating" );

		var countdownProgressBar = panel.FindChildInLayoutFile( 'CoachTimeRemainingProgressBar' );
		var goodRatingButton = panel.FindChildInLayoutFile( 'GoodRatingButton' );
		var badRatingButton = panel.FindChildInLayoutFile( 'BadRatingButton' );
		var abusiveRatingButton = panel.FindChildInLayoutFile( 'AbusiveRatingButton' );

		var flCountdownDuration = 15.0;
		countdownProgressBar.max = flCountdownDuration;

		panel.SetDialogVariable( 'coach_player_name', rating_data.coach_player_name );
		panel.FindChildInLayoutFile( 'CoachAvatarImage' ).accountid = rating_data.coach_account_id;
		panel.FindChildInLayoutFile( 'CoachRatingBadge' ).rating = rating_data.coach_rating;

		var SubmitRating = function( strRating, strReason )
		{
			if ( action_data.match_id == '0' )
				return;

			$.DispatchEvent( 'DOTASubmitCoachRating', action_data.match_id, rating_data.coach_account_id, strRating, strReason );

			// Once a rating has been changed, disable all the other UI
			goodRatingButton.enabled = false;
			badRatingButton.enabled = false;
			abusiveRatingButton.enabled = false;
		};

		$.RegisterEventHandler( 'Activated', goodRatingButton, function()
		{
			goodRatingButton.AddClass( 'Selected' );
			SubmitRating( 'k_ECoachTeammateRating_Positive', '' );
		} );
		$.RegisterEventHandler( 'Activated', badRatingButton, function()
		{
			badRatingButton.AddClass( 'Selected' );
			SubmitRating( 'k_ECoachTeammateRating_Negative', '' );
		} );

		var waitForAbusiveRatingPopupAction = new WaitForAbusiveRatingPopupAction();
		$.RegisterEventHandler( 'Activated', abusiveRatingButton, function()
		{
			waitForAbusiveRatingPopupAction.popupActive = true;
			$.DispatchEvent( 'PostGameProgressConfirmAbusiveCoachRating', panel );
		} );
		$.RegisterEventHandler( 'PostGameProgressConfirmAbusiveCoachRatingFinished', panel, function( bSubmit, strReason )
		{
			if ( bSubmit )   
			{
				abusiveRatingButton.AddClass( 'Selected' );
				SubmitRating( 'k_ECoachTeammateRating_Abusive', strReason );
			}
			waitForAbusiveRatingPopupAction.popupActive = false;
		} );

		// Setup the sequence of actions to animate the screen
		this.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
		this.actions.push( new AddScreenLinkAction( panel, 'CoachRatingProgress', '#DOTA_CoachRatingPostGame_CoachRating', function()
		{
			panel.AddClass( 'RatingScreenForceVisible' );
		} ) );
		this.actions.push( new WaitAction( 0.5 ) );
		this.actions.push( new AddClassAction( panel, 'RatingScreenVisible' ) );

		var countdownActions = new RunParallelActions();
		countdownActions.actions.push( new AnimateDialogVariableIntAction( panel, 'countdown_seconds', flCountdownDuration, 0, flCountdownDuration ) );
		countdownActions.actions.push( new AnimateProgressBarAction( countdownProgressBar, flCountdownDuration, 0, flCountdownDuration ) );

		var durationAction = new RunUntilSingleActionFinishedAction();
		durationAction.actions.push( countdownActions );
		durationAction.actions.push( new WaitForRatingStateChange( panel ) );
		durationAction.actions.push( new WaitForClassAction( panel, 'CountdownFinished' ) );
		this.actions.push( durationAction );

		this.actions.push( new AddClassAction( panel, 'CountdownFinished' ) );
		this.actions.push( waitForAbusiveRatingPopupAction );

		this.actions.push( new WaitAction( 0.5 ) );
		this.actions.push( new RemoveClassAction( panel, 'RatingScreenVisible' ) );
		this.actions.push( new WaitAction( 0.5 ) );

		super.start();
	}
}


function TestAnimateCoachRating()
{
	var data =
	{
		//match_id: '123456789012345',
		match_id: '0',

		coaches_need_rating:
			[
				{
					coach_account_id: 85501006,
					coach_player_name: 'EricL',
					coach_rating: 2345
				}
				//{
				//	coach_account_id: 85501829,
				//	coach_player_name: 'Cameron',
				//	coach_rating: 5678
				//}
			]
	};

	TestProgressAnimation( data );
}
