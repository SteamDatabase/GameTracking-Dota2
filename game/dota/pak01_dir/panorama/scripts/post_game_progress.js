
function StartNewScreen( panelID )
{
	// Mark all previous screens as finished
	var screensContainer = $( '#ProgressScreens' );
	for ( var i = 0; i < screensContainer.GetChildCount() ; ++i )
	{
		screensContainer.GetChild( i ).AddClass( 'Finished' );
	}

	var panel = $.CreatePanel( 'Panel', screensContainer, panelID );
	return panel;
}


function ResetScreens()
{
	$( '#ProgressScreens' ).RemoveAndDeleteChildren();
}


// ----------------------------------------------------------------------------
//   PlaySoundAction
// ----------------------------------------------------------------------------

function PlaySoundAction( soundName )
{
	this.soundName = soundName;
}
PlaySoundAction.prototype = new BaseAction();

PlaySoundAction.prototype.update = function ()
{
	$.GetContextPanel().PlayUISoundScript( this.soundName );
	return false;
}

// ----------------------------------------------------------------------------
//   PlaySoundForDurationAction
// ----------------------------------------------------------------------------

function PlaySoundForDurationAction( soundName, duration )
{
	this.soundName = soundName;
	this.duration = duration;
}
PlaySoundForDurationAction.prototype = new BaseAction();

PlaySoundForDurationAction.prototype.start = function ()
{
	this.soundEventGuid = $.GetContextPanel().PlayUISoundScript( this.soundName );

	this.waitAction = new WaitAction( this.duration );
	this.waitAction.start();
}
PlaySoundForDurationAction.prototype.update = function ()
{
	return this.waitAction.update();
}
PlaySoundForDurationAction.prototype.finish = function ()
{
	$.GetContextPanel().StopUISoundScript( this.soundEventGuid );
	this.waitAction.finish();
}


// ----------------------------------------------------------------------------
//   Hero Badge Level Screen
// ----------------------------------------------------------------------------

// Keep in sync with EHeroBadgeXPType
const HERO_BADGE_XP_TYPE_MATCH_FINISHED = 0;
const HERO_BADGE_XP_TYPE_MATCH_WON = 1;
const HERO_BADGE_XP_TYPE_CHALLENGE_COMPLETED = 2;

// Keep in sync with EHeroBadgeLevelReward
const HERO_BADGE_LEVEL_REWARD_TIER = 0;
const HERO_BADGE_LEVEL_REWARD_CHAT_WHEEL = 1;
const HERO_BADGE_LEVEL_REWARD_CURRENCY = 2;

// Keep in sync with the version in dota_plus.h
const k_unMaxHeroRewardLevel = 25;

function GetXPIncreaseAnimationDuration( xpAmount )
{
	return RemapValClamped( xpAmount, 0, 500, 0.7, 1.3 );
}

// Action to animate a hero badge xp increase
function AnimateHeroBadgeXPIncreaseAction( panel, progress, xpAmount, xpValueStart, xpEarnedStart, xpLevelStart, resumeFromPreviousRow )
{
	this.panel = panel;
	this.progress = progress;
	this.xpAmount = xpAmount;
	this.xpValueStart = xpValueStart;
	this.xpEarnedStart = xpEarnedStart;
	this.xpLevelStart = xpLevelStart;
	this.resumeFromPreviousRow = resumeFromPreviousRow;
}
AnimateHeroBadgeXPIncreaseAction.prototype = new BaseAction();

AnimateHeroBadgeXPIncreaseAction.prototype.start = function ()
{
	var rowsContainer = this.panel.FindChildInLayoutFile( "HeroBadgeProgressRows" );
	var totalsRow = this.panel.FindChildInLayoutFile( "TotalsRow" );
	var row = null;

	this.seq = new RunSequentialActions();

	if ( this.resumeFromPreviousRow )
	{
		row = rowsContainer.GetChild( rowsContainer.GetChildCount() - 1 );
	}
	else
	{
		row = $.CreatePanel( 'Panel', rowsContainer, '' );

		if ( this.progress.xp_type == HERO_BADGE_XP_TYPE_MATCH_FINISHED )
		{
			row.BLoadLayoutSnippet( 'HeroBadgeProgressRow' );
			row.SetDialogVariable( 'xp_type', $.Localize( '#DOTA_PlusPostGame_MatchFinished' ) );
		}
		else if ( this.progress.xp_type == HERO_BADGE_XP_TYPE_MATCH_WON )
		{
			row.BLoadLayoutSnippet( 'HeroBadgeProgressRow' );
			row.SetDialogVariable( 'xp_type', $.Localize( '#DOTA_PlusPostGame_Win' ) );
		}
		else if ( this.progress.xp_type == HERO_BADGE_XP_TYPE_CHALLENGE_COMPLETED )
		{
			row.BLoadLayoutSnippet( 'HeroBadgeProgressRow_Challenge' );
			row.SetDialogVariable( 'xp_type', $.Localize( '#DOTA_PlusPostGame_ChallengeCompleted' ) );
			row.SetDialogVariable( 'challenge_name', this.progress.challenge_description );
			row.SwitchClass( 'challenge_stars', "StarsEarned_" + this.progress.challenge_stars );
		}
		else
		{
			$.Msg( "Unknown XP type: " + this.progress.xp_type );
			row.BLoadLayoutSnippet( 'HeroBadgeProgressRow' );
			row.SetDialogVariable( 'xp_type', this.progress.xp_type );
		}

		row.SetDialogVariableInt( 'xp_value', this.xpValueStart );

		this.seq.actions.push( new AddClassAction( row, 'ShowRow' ) );
		this.seq.actions.push( new WaitAction( 0.5 ) );
		this.seq.actions.push( new AddClassAction( row, 'ShowValue' ) );
	}

	var duration = GetXPIncreaseAnimationDuration( this.xpAmount );
	var levelProgressBar = this.panel.FindChildInLayoutFile( 'HeroBadgeLevelProgress' );
	var minLevelXP = Math.min( this.xpLevelStart, levelProgressBar.max );
	var maxLevelXP = Math.min( this.xpLevelStart + this.xpAmount, levelProgressBar.max );
	var par = new RunParallelActions();
	par.actions.push( new AnimateDialogVariableIntAction( row, 'xp_value', this.xpValueStart, this.xpValueStart + this.xpAmount, duration ) );
	par.actions.push( new AnimateDialogVariableIntAction( totalsRow, 'xp_value', this.xpEarnedStart, this.xpEarnedStart + this.xpAmount, duration ) );
	par.actions.push( new AnimateDialogVariableIntAction( this.panel, 'current_level_xp', minLevelXP, maxLevelXP, duration ) );
	par.actions.push( new AnimateProgressBarAction( levelProgressBar, minLevelXP, maxLevelXP, duration ) );
	par.actions.push( new PlaySoundForDurationAction( "XP.Count", duration ) );
	this.seq.actions.push( par );

	this.seq.start();
}
AnimateHeroBadgeXPIncreaseAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateHeroBadgeXPIncreaseAction.prototype.finish = function ()
{
	this.seq.finish();
}



function AnimateHeroBadgeLevelRewardAction( data, containerPanel )
{
	this.data = data;
	this.containerPanel = containerPanel;
}
AnimateHeroBadgeLevelRewardAction.prototype = new BaseAction();
AnimateHeroBadgeLevelRewardAction.prototype.start = function ()
{
	this.seq = new RunSequentialActions();

	if ( this.data.reward_type == HERO_BADGE_LEVEL_REWARD_TIER )
	{
		var reward = $.CreatePanel( 'Panel', this.containerPanel, '' );
		reward.BLoadLayoutSnippet( 'HeroBadgeLevelUpRewardTier' );
		reward.AddClass( this.data.tier_class );
		reward.SetDialogVariable( "tier_name", $.Localize( this.data.tier_name ) );
		this.seq.actions.push( new AddClassAction( reward, 'ShowReward' ) );
	}
	else if ( this.data.reward_type == HERO_BADGE_LEVEL_REWARD_CHAT_WHEEL )
	{
		var reward = $.CreatePanel( 'Panel', this.containerPanel, '' );
		reward.BLoadLayoutSnippet( 'HeroBadgeLevelUpRewardChatWheel' );
		reward.SetDialogVariable( "all_chat_prefix", this.data.all_chat ? $.Localize( '#dota_all_chat_label_prefix' ) : "" );
		reward.SetDialogVariable( "chat_wheel_message", $.Localize( this.data.chat_wheel_message ) );
		var sound_event = this.data.sound_event;
		$.RegisterEventHandler( "Activated", reward, function ()
		{			
			$.GetContextPanel().PlayUISoundScript( sound_event );
		} );
		this.seq.actions.push( new AddClassAction( reward, 'ShowReward' ) );
	}
	else if ( this.data.reward_type == HERO_BADGE_LEVEL_REWARD_CURRENCY )
	{
		var reward = $.CreatePanel( 'Panel', this.containerPanel, '' );
		reward.BLoadLayoutSnippet( 'HeroBadgeLevelUpRewardCurrency' );
		reward.SetDialogVariableInt( "currency_amount", this.data.currency_amount );
		this.seq.actions.push( new AddClassAction( reward, 'ShowReward' ) );
	}
	else
	{
		$.Msg( "Unknown reward_type '" + this.data.reward_type + "', skipping" );
	}

	this.seq.actions.push( new WaitAction( 1.0 ) );

	this.seq.start();
}
AnimateHeroBadgeLevelRewardAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateHeroBadgeLevelRewardAction.prototype.finish = function ()
{
	this.seq.finish();
}


function AnimateHeroRelicProgressAction( data, containerPanel )
{
	this.data = data;
	this.containerPanel = containerPanel;
}
AnimateHeroRelicProgressAction.prototype = new BaseAction();
AnimateHeroRelicProgressAction.prototype.start = function ()
{
	this.panel = $.CreatePanel( 'Panel', this.containerPanel, '' );
	this.panel.BLoadLayoutSnippet( 'SingleRelicProgress' );
	this.panel.SetDialogVariableInt( 'relic_type', this.data.relic_type );
	this.panel.SetDialogVariableInt( 'current_progress', this.data.starting_value );
	this.panel.SetDialogVariableInt( 'increment', this.data.ending_value - this.data.starting_value );

	var relicImage = this.panel.FindChildInLayoutFile( "SingleRelicImage" );
	relicImage.SetRelic( this.data.relic_type, this.data.relic_rarity, this.data.primary_attribute, false );

	this.seq = new RunSequentialActions();

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowProgress' ) );
	this.seq.actions.push( new WaitAction( 0.2 ) );
	this.seq.actions.push( new AddClassAction( this.panel, 'ShowIncrement' ) );
	this.seq.actions.push( new WaitAction( 0.4 ) );


	return this.seq.start();
}
AnimateHeroRelicProgressAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateHeroRelicProgressAction.prototype.finish = function ()
{
	this.seq.finish();
}


function AnimateHeroBadgeLevelScreenAction( data )
{
	this.data = data;
}

AnimateHeroBadgeLevelScreenAction.prototype = new BaseAction();
AnimateHeroBadgeLevelScreenAction.prototype.start = function ()
{
	var xpHeroStart = this.data.hero_badge_xp_start;
	var heroLevelStart = $.GetContextPanel().GetHeroBadgeLevelForHeroXP( xpHeroStart );
	var heroID = this.data.hero_id;

	var xpTotalLevelStart = $.GetContextPanel().GetTotalHeroXPRequiredForHeroBadgeLevel( heroLevelStart );

	var xpLevelStart = 0;
	var xpLevelNext = 0;
	if ( heroLevelStart < k_unMaxHeroRewardLevel )
	{
		xpLevelStart = xpHeroStart - xpTotalLevelStart;
		xpLevelNext = $.GetContextPanel().GetHeroXPForNextHeroBadgeLevel( heroLevelStart );
	}
	else
	{
		xpLevelNext = $.GetContextPanel().GetHeroXPForNextHeroBadgeLevel( k_unMaxHeroRewardLevel - 1 );
		xpLevelStart = xpLevelNext;
	}

	// Create the screen and do a bunch of initial setup
	var panel = StartNewScreen( 'HeroBadgeProgressScreen' );
	panel.BLoadLayoutSnippet( "HeroBadgeProgress" );
	panel.FindChildInLayoutFile( "HeroBadgeProgressHeroBadge" ).herolevel = heroLevelStart;

	panel.FindChildInLayoutFile( "TotalsRow" ).SetDialogVariableInt( 'xp_value', 0 );
	panel.SetDialogVariableInt( 'current_level_xp', xpLevelStart );
	panel.SetDialogVariableInt( 'xp_to_next_level', xpLevelNext );
	panel.SetDialogVariableInt( 'current_level', heroLevelStart );

	panel.FindChildInLayoutFile( "HeroBadgeLevelProgress" ).max = xpLevelNext;
	panel.FindChildInLayoutFile( "HeroBadgeLevelProgress" ).value = xpLevelStart;

	var heroModel = panel.FindChildInLayoutFile( 'HeroBadgeHeroModel' );
	if ( typeof this.data.player_slot !== 'undefined' )
	{
		// Use this normally when viewing the details
		$.GetContextPanel().SetScenePanelToPlayerHero( heroModel, this.data.player_slot );
	}
	else
	{
		// Use this for testing when we don't actually have match data
		$.GetContextPanel().SetScenePanelToLocalHero( heroModel, this.data.hero_id );
	}

	// Setup the sequence of actions to animate the screen
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
	this.seq.actions.push( new ActionWithTimeout( new WaitForClassAction( heroModel, 'SceneLoaded' ), 3.0 ) );
	this.seq.actions.push( new WaitAction( 1.0 ) );

	var rankSuffixFromRankClassName = function( rankClassName ) {
		var mapping = { 'BronzeTier' : "1", "SilverTier" : "2", "GoldTier" : "3", "PlatinumTier" : "4", "MasterTier" : "5" };
		if ( rankClassName in mapping )
		{
			return mapping[ rankClassName ];
		}
		else
		{
			return "1";
		}
	}	
	var rankSuffix = rankSuffixFromRankClassName( this.data.tier_class );
	if ( this.data.hero_badge_level_up )
	{
		for( var j = 0; j < this.data.hero_badge_level_up.rewards.length; ++j )
		{
			if ( this.data.hero_badge_level_up.rewards[j].reward_type === HERO_BADGE_LEVEL_REWARD_TIER )
			{
				rankSuffix = rankSuffixFromRankClassName( this.data.hero_badge_level_up.rewards[j].tier_class );				
			}
		}
	}

	if ( this.data.hero_badge_progress )
	{
		this.seq.actions.push( new AddClassAction( panel, 'ShowHeroProgress' ) );

		var xpEarned = 0;
		var xpLevel = xpLevelStart;
		var heroLevel = heroLevelStart;
		for ( var i = 0; i < this.data.hero_badge_progress.length; ++i )
		{
			var xpRemaining = this.data.hero_badge_progress[i].xp_amount;
			var xpEarnedOnRow = 0;

			while ( xpRemaining > 0 )
			{
				var xpToAnimate = 0;
				var xpToNextLevel = 0;
				if ( heroLevel >= k_unMaxHeroRewardLevel )
				{
					xpToAnimate = xpRemaining;
				}
				else
				{
					xpToNextLevel = xpLevelNext - xpLevel;
					xpToAnimate = Math.min( xpRemaining, xpToNextLevel );
				}

				if ( xpToAnimate > 0 )
				{
					this.seq.actions.push( new AnimateHeroBadgeXPIncreaseAction( panel, this.data.hero_badge_progress[i], xpToAnimate, xpEarnedOnRow, xpEarned, xpLevel, xpEarnedOnRow != 0 ) );

					xpEarned += xpToAnimate;
					xpLevel += xpToAnimate;
					xpEarnedOnRow += xpToAnimate;
					xpRemaining -= xpToAnimate;
				}

				xpToNextLevel = xpLevelNext - xpLevel;
				if ( xpToNextLevel == 0 && heroLevel < k_unMaxHeroRewardLevel )
				{
					heroLevel = heroLevel + 1;

					this.seq.actions.push( new RunFunctionAction( function ()
					{
						panel.AddClass( "LeveledUp" );
						panel.SetDialogVariableInt( 'current_level', heroLevel );
					} ) );

					this.seq.actions.push( new ActionWithTimeout( new WaitForClassAction( $( '#LevelUpRankScene' ), 'SceneLoaded' ), 3.0 ) );

					this.seq.actions.push( new RunFunctionAction( function ()
					{
						$.GetContextPanel().PlayUISoundScript( "HeroBadge.Levelup" );
						$.DispatchEvent( 'DOTASceneFireEntityInput', $( '#LevelUpRankScene' ), 'light_rank_' + rankSuffix, 'TurnOn', '1' );
						$.DispatchEvent( 'DOTASceneFireEntityInput', $( '#LevelUpRankScene' ), 'particle_rank_' + rankSuffix, 'start', '1' );
					} ) );

					// Now animate the rewards
					if ( this.data.hero_badge_level_up )
					{
						this.seq.actions.push( new WaitAction( 4.0 ) );

						var rewardsPanel = panel.FindChildInLayoutFile( "HeroBadgeProgressRewardsList" );

						for ( var j = 0; j < this.data.hero_badge_level_up.rewards.length; ++j )
						{
							this.seq.actions.push( new AnimateHeroBadgeLevelRewardAction( this.data.hero_badge_level_up.rewards[j], rewardsPanel ) );
						}

						this.seq.actions.push( new WaitAction( 0.5 ) );
						this.seq.actions.push( new AddClassAction( panel, 'RewardsFinished' ) );
						this.seq.actions.push( new WaitForEventAction( panel.FindChildInLayoutFile( "RewardsFinishedButton" ), 'Activated' ) );
						this.seq.actions.push( new RunFunctionAction( function ()
						{
							panel.RemoveClass( 'LeveledUp' );
							panel.FindChildInLayoutFile( "HeroBadgeProgressHeroBadge" ).herolevel = heroLevel;
						} ) );
					}
					this.seq.actions.push( new WaitAction( 2.0 ) );

					if ( heroLevel >= k_unMaxHeroRewardLevel )
					{
						xpLevel = xpLevelNext;
					}
					else
					{
						xpLevel = 0;
						xpLevelNext = $.GetContextPanel().GetHeroXPForNextHeroBadgeLevel( heroLevel );
					}

					this.seq.actions.push( new RunFunctionAction( function ()
					{
						panel.SetDialogVariableInt( 'current_level_xp', xpLevel );
						panel.SetDialogVariableInt( 'xp_to_next_level', xpLevelNext );
						panel.FindChildInLayoutFile( "HeroBadgeLevelProgress" ).max = xpLevelNext;
						panel.FindChildInLayoutFile( "HeroBadgeLevelProgress" ).value = xpLevel;
					} ) );
				}
			}

			this.seq.actions.push( new WaitAction( 0.2 ) );
		}

		this.seq.actions.push( new AddClassAction( panel, 'WaitingForAdvance' ) );
		this.seq.actions.push( new WaitForEventAction( $('#AdvanceHeroBadgeProgressButton'), 'Activated' ) );
		this.seq.actions.push( new RemoveClassAction( panel, 'WaitingForAdvance' ) );
		this.seq.actions.push( new RemoveClassAction( panel, 'ShowHeroProgress' ) );
	}

	// Now animate the relics
	if ( this.data.hero_relics_progress )
	{
		this.seq.actions.push( new AddClassAction( panel, 'ShowRelicsProgress' ) );
		this.seq.actions.push( new WaitAction( 0.5 ) );

		var relicsList = panel.FindChildInLayoutFile( "HeroRelicsProgressList" );
		for ( var i = 0; i < this.data.hero_relics_progress.length; ++i )
		{
			this.seq.actions.push( new AnimateHeroRelicProgressAction( this.data.hero_relics_progress[i], relicsList ) );
		}
		this.seq.actions.push( new AddClassAction( panel, 'WaitingForAdvance' ) );
		this.seq.actions.push( new WaitForEventAction( $('#AdvanceHeroBadgeProgressButton'), 'Activated' ) );
		this.seq.actions.push( new RemoveClassAction( panel, 'WaitingForAdvance' ) );
		this.seq.actions.push( new RemoveClassAction( panel, 'ShowRelicsProgress' ) );
	}

	this.seq.start();
}
AnimateHeroBadgeLevelScreenAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateHeroBadgeLevelScreenAction.prototype.finish = function ()
{
	this.seq.finish();
}

function TestAnimateHeroBadgeLevel()
{
	var data =
	{
		hero_id: 11,
		hero_badge_xp_start: 26850,

		hero_badge_progress:
		[
			{
				xp_type: HERO_BADGE_XP_TYPE_MATCH_FINISHED,
				xp_amount: 50
			},
			{
				xp_type: HERO_BADGE_XP_TYPE_MATCH_WON,
				xp_amount: 50
			},
			{
				xp_type: HERO_BADGE_XP_TYPE_CHALLENGE_COMPLETED,
				xp_amount: 375,

				challenge_stars: 2,
				challenge_description: "Kill an enemy hero in 15 seconds after teleporting in 1/2/3 times."
			},
		],

		hero_badge_level_up:
		{
			new_hero_badge_level: 18,
			rewards:
			[
				{
					reward_type: HERO_BADGE_LEVEL_REWARD_TIER,
					tier_name: "#DOTA_HeroLevelBadgeTier_Platinum",
					tier_class: "PlatinumTier"
				},
				{
					reward_type: HERO_BADGE_LEVEL_REWARD_CHAT_WHEEL,
					chat_wheel_message: "#dota_chatwheel_message_nevermore_4",
					all_chat: 1,
					sound_event: "soundboard.ay_ay_ay"
				},
				{
					reward_type: HERO_BADGE_LEVEL_REWARD_CURRENCY,
					currency_amount: 3000
				},
			]
		},

		hero_relics_progress:
		[
			{
				relic_type: 0,
				relic_rarity: 1,
				primary_attribute: 1,
				starting_value: 25,
				ending_value: 29,
			},
			{
				relic_type: 1,
				relic_rarity: 1,
				primary_attribute: 1,
				starting_value: 25,
				ending_value: 29,
			},
			{
				relic_type: 2,
				relic_rarity: 1,
				primary_attribute: 1,
				starting_value: 25,
				ending_value: 29,
			},
			{
				relic_type: 3,
				relic_rarity: 1,
				primary_attribute: 1,
				starting_value: 25,
				ending_value: 29,
			},
			{
				relic_type: 4,
				relic_rarity: 0,
				primary_attribute: 1,
				starting_value: 25,
				ending_value: 29,
			},
			{
				relic_type: 5,
				relic_rarity: 0,
				primary_attribute: 1,
				starting_value: 25,
				ending_value: 29,
			},
			{
				relic_type: 6,
				relic_rarity: 0,
				primary_attribute: 1,
				starting_value: 25,
				ending_value: 29,
			},
			{
				relic_type: 7,
				relic_rarity: 0,
				primary_attribute: 1,
				starting_value: 25,
				ending_value: 29,
			},
			{
				relic_type: 8,
				relic_rarity: 0,
				primary_attribute: 1,
				starting_value: 25,
				ending_value: 29,
			},
			{
				relic_type: 9,
				relic_rarity: 0,
				primary_attribute: 1,
				starting_value: 25,
				ending_value: 29,
			},
			{
				relic_type: 10,
				relic_rarity: 0,
				primary_attribute: 1,
				starting_value: 25,
				ending_value: 29,
			},
			{
				relic_type: 11,
				relic_rarity: 0,
				primary_attribute: 1,
				starting_value: 25,
				ending_value: 29,
			},
			{
				relic_type: 12,
				relic_rarity: 0,
				primary_attribute: 1,
				starting_value: 25,
				ending_value: 29,
			},
			{
				relic_type: 13,
				relic_rarity: 0,
				primary_attribute: 1,
				starting_value: 25,
				ending_value: 29,
			}
		]
	};
	data.is_debug = true;
	StartProgressAnimation( data );
}


// ----------------------------------------------------------------------------
//   All Screens
// ----------------------------------------------------------------------------


/* Called from C++ to start the progress animation */
function StartProgressAnimation( data )
{
	$.Msg( "Showing progress for: " + JSON.stringify( data ) );
	$('#ProgressScreens').RemoveAndDeleteChildren();

	var seq = new RunSequentialActions();

	if ( data.hero_badge_progress != null || data.hero_relics_progress != null )
	{
		seq.actions.push( new AnimateHeroBadgeLevelScreenAction( data ) );
	}

	if ( data.is_debug !== true )
	{
		// Signal back to the C++ code that we're done displaying progress
		seq.actions.push( new RunFunctionAction( function ()
		{
			$.DispatchEvent( 'DOTAPostGameProgressAnimationComplete', $.GetContextPanel() );
		} ) );
	}

	RunSingleAction( seq );
}

function HideProgress()
{
	// Just tell the C++ code that we're done by dispatching the event
	$.DispatchEvent( 'DOTAPostGameProgressAnimationComplete', $.GetContextPanel() );
}
