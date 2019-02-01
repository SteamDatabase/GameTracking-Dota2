
// ----------------------------------------------------------------------------
//   Screen Handling functions
// ----------------------------------------------------------------------------

function CreateProgressScreen( panelID )
{
	var screenPanel = $.CreatePanel( 'Panel', $( '#ProgressScreens' ), panelID );
	screenPanel.AddClass( 'ProgressScreen' );
	return screenPanel;
}

function ShowProgressScreen( screenPanel )
{
	var screensContainer = $( '#ProgressScreens' );
	for ( var i = 0; i < screensContainer.GetChildCount() ; ++i )
	{
		var otherScreenPanel = screensContainer.GetChild( i );
		otherScreenPanel.SetHasClass( 'ShowScreen', otherScreenPanel == screenPanel );
	}
}

function StartNewScreen( panelID )
{
	var screenPanel = CreateProgressScreen( panelID );
	ShowProgressScreen( screenPanel );
	return screenPanel;
}


function GetScreenLinksContainer()
{
	// This is sorta hacky, but we need to reach into the parent's layout file to find our button container.
	return $.GetContextPanel().GetParent().FindPanelInLayoutFile( 'ProgressScreenButtons' );
}

/* Called from C++ code */
function ResetScreens()
{
	$( '#ProgressScreens' ).RemoveAndDeleteChildren();
	GetScreenLinksContainer().RemoveAndDeleteChildren();
}

function AddScreenLink( screenPanel, linkClass, tooltipText, activateFunction )
{
	var link = $.CreatePanel( 'Button', GetScreenLinksContainer(), '' );
	link.AddClass( 'ProgressScreenButton' );
	link.AddClass( linkClass );

	link.SetPanelEvent( 'onactivate', function ()
	{
		$.DispatchEvent( 'DOTAPostGameProgressShowSummary', screenPanel );
		ShowProgressScreen( screenPanel );
		if ( activateFunction )
		{
			activateFunction();
		}
	} );

	link.SetPanelEvent( 'onmouseover', function () { $.DispatchEvent( 'UIShowTextTooltip', link, tooltipText ); } );
	link.SetPanelEvent( 'onmouseout', function () { $.DispatchEvent( 'UIHideTextTooltip', link ); } );

	return link;
}

function AddScreenLinkAction( screenPanel, linkClass, tooltipText, activateFunction )
{
	RunFunctionAction.call( this, function () { AddScreenLink( screenPanel, linkClass, tooltipText, activateFunction ); } );
}
AddScreenLinkAction.prototype = new RunFunctionAction();


// ----------------------------------------------------------------------------
//   Skip Ahead Functions
// ----------------------------------------------------------------------------

var g_bSkipAheadActions = false;

function IsSkippingAhead()
{
	return g_bSkipAheadActions;
}

function SetSkippingAhead( bSkipAhead )
{
	if ( g_bSkipAheadActions == bSkipAhead )
		return;

	// $.Msg( "SetSkippingAhead( " + bSkipAhead + " )" );
	$.DispatchEvent( "PostGameProgressSkippingAhead" );
	$.GetContextPanel().SetHasClass( 'SkippingAhead', bSkipAhead );
	g_bSkipAheadActions = bSkipAhead;

	if ( bSkipAhead )
	{
		$.GetContextPanel().PlayUISoundScript( "ui_generic_button_click" );
	}
}
function StopSkippingAhead() { SetSkippingAhead( false ); }
function StartSkippingAhead() { SetSkippingAhead( true ); }

// ----------------------------------------------------------------------------
//   StopSkippingAheadAction
// 
//   Define a point at which we stop skipping (usually the end of a screen)
// ----------------------------------------------------------------------------

// Use a StopSkippingAheadAction to define a stopping point
function StopSkippingAheadAction()
{
}
StopSkippingAheadAction.prototype = new BaseAction();
StopSkippingAheadAction.prototype.update = function ()
{
	StopSkippingAhead();
	return false;
}


// ----------------------------------------------------------------------------
//   SkippableAction
// 
//   Wrap a SkippableAction around any other action to have it skip ahead
//   whenever we're supposed to skip ahead. SkippableAction guarantees that the
//   inner action will at least have start/update/finish called on it.
// ----------------------------------------------------------------------------
function SkippableAction( actionToMaybeSkip )
{
	this.innerAction = actionToMaybeSkip;
}
SkippableAction.prototype = new BaseAction();

SkippableAction.prototype.start = function ()
{
	this.innerAction.start();
}
SkippableAction.prototype.update = function ()
{
	return this.innerAction.update() && !IsSkippingAhead();
}
SkippableAction.prototype.finish = function ()
{
	this.innerAction.finish();
}


// Action to rum multiple actions in parallel, but with a slight stagger start between each of them
function RunSkippableStaggeredActions( staggerSeconds )
{
	this.actions = [];
	this.staggerSeconds = staggerSeconds;
}
RunSkippableStaggeredActions.prototype = new BaseAction();
RunSkippableStaggeredActions.prototype.start = function ()
{
	this.par = new RunParallelActions();

	for ( var i = 0; i < this.actions.length; ++i )
	{
		var delay = i * this.staggerSeconds;
		if ( delay > 0 )
		{
			var seq = new RunSequentialActions();
			seq.actions.push( new SkippableAction( new WaitAction( delay ) ) );
			seq.actions.push( this.actions[i] );
			this.par.actions.push( seq );
		}
		else
		{
			this.par.actions.push( this.actions[i] );
		}
	}

	this.par.start();
}
RunSkippableStaggeredActions.prototype.update = function ()
{
	return this.par.update();
}
RunSkippableStaggeredActions.prototype.finish = function ()
{
	this.par.finish();
}


// ----------------------------------------------------------------------------
//   OptionalSkippableAction
// 
//   Wrap a OptionalSkippableAction around any other action to have it skip it
//   if requested. OptionalSkippableAction will skip the inner action entirely
//   if skipping is currently enabled. However, if it starts the inner action
//   at all, then it will guarantee at least a call to start/update/finish.
// ----------------------------------------------------------------------------
function OptionalSkippableAction( actionToMaybeSkip )
{
	this.innerAction = actionToMaybeSkip;
}
OptionalSkippableAction.prototype = new BaseAction();

OptionalSkippableAction.prototype.start = function ()
{
	this.innerActionStarted = false;

	if ( !IsSkippingAhead() )
	{
		this.innerAction.start();
		this.innerActionStarted = true;
	}
}
OptionalSkippableAction.prototype.update = function ()
{
	if ( this.innerActionStarted )
		return this.innerAction.update() && !IsSkippingAhead();

	if ( IsSkippingAhead() )
		return false;

	this.innerAction.start();
	this.innerActionStarted = true;

	return this.innerAction.update();
}
OptionalSkippableAction.prototype.finish = function ()
{
	if ( this.innerActionStarted )
	{
		this.innerAction.finish();
	}
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
	return RemapValClamped( xpAmount, 0, 500, 0.5, 1.0 );
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
		this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
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


// Action to display victory prediction shards
function AnimateShardRewardAction( panel, label, shardAmount )
{
	this.panel = panel;
	this.label = label;
	this.shardAmount = shardAmount;

}
AnimateShardRewardAction.prototype = new BaseAction();

AnimateShardRewardAction.prototype.start = function ()
{
	var rowsContainer = this.panel.FindChildInLayoutFile( "HeroBadgeProgressRows" );
	var row = null;

	this.seq = new RunSequentialActions();

	row = $.CreatePanel( 'Panel', this.panel.FindChildInLayoutFile( "HeroBadgeProgressCenter" ), '' );
	row.BLoadLayoutSnippet( 'HeroBadgeProgressRow_ShardReward' );
	row.SetDialogVariable( 'reward_type', $.Localize( this.label ) );
	row.SetDialogVariableInt( 'shard_value', 0 );
	this.seq.actions.push( new AddClassAction( row, 'ShowRow' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
	this.seq.actions.push( new AddClassAction( row, 'ShowValue' ) );
	var duration = GetXPIncreaseAnimationDuration( this.shardAmount ) * 2;
	var par = new RunParallelActions();
	par.actions.push( new AnimateDialogVariableIntAction( row, 'shard_value', 0, this.shardAmount, duration ) );
	par.actions.push( new PlaySoundForDurationAction( "XP.Count", duration ) );
	this.seq.actions.push( par );
	this.seq.start();
}
AnimateShardRewardAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateShardRewardAction.prototype.finish = function ()
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
	this.seq.actions.push( new WaitAction( 0.5 ) );

	if ( this.data.hero_badge_progress )
	{
		this.seq.actions.push( new AddScreenLinkAction( panel, 'HeroBadgeProgress', '#DOTA_PlusPostGame_HeroProgress', function ()
		{
			panel.SwitchClass( 'current_screen', 'ShowHeroProgress' );
		} ) );

		this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', 'ShowHeroProgress' ) );

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
					this.seq.actions.push( new SkippableAction( new AnimateHeroBadgeXPIncreaseAction( panel, this.data.hero_badge_progress[i], xpToAnimate, xpEarnedOnRow, xpEarned, xpLevel, xpEarnedOnRow != 0 ) ) );

					xpEarned += xpToAnimate;
					xpLevel += xpToAnimate;
					xpEarnedOnRow += xpToAnimate;
					xpRemaining -= xpToAnimate;
				}

				xpToNextLevel = xpLevelNext - xpLevel;
				if ( xpToNextLevel == 0 && heroLevel < k_unMaxHeroRewardLevel )
				{
					heroLevel = heroLevel + 1;

					this.seq.actions.push( new StopSkippingAheadAction() );

					( function ( me, heroLevel )
					{
						me.seq.actions.push( new RunFunctionAction( function ()
						{
							panel.AddClass( "LeveledUp" );
							panel.SetDialogVariableInt( 'current_level', heroLevel );
						} ) );

						var levelUpData = me.data.hero_badge_level_up[ heroLevel ];
						if ( levelUpData )
						{
							var levelUpScene = panel.FindChildInLayoutFile( 'LevelUpRankScene' );

							me.seq.actions.push( new ActionWithTimeout( new WaitForClassAction( levelUpScene, 'SceneLoaded' ), 3.0 ) );

							var rewardsPanel = panel.FindChildInLayoutFile( "HeroBadgeProgressRewardsList" );

							me.seq.actions.push( new RunFunctionAction( function ()
							{
								rewardsPanel.RemoveAndDeleteChildren();
								panel.RemoveClass( 'RewardsFinished' );

								$.GetContextPanel().PlayUISoundScript( "HeroBadge.Levelup" );
								$.DispatchEvent( 'DOTASceneFireEntityInput', levelUpScene, 'light_rank_' + levelUpData.tier_number, 'TurnOn', '1' );
								$.DispatchEvent( 'DOTASceneFireEntityInput', levelUpScene, 'particle_rank_' + levelUpData.tier_number, 'start', '1' );
							} ) );

							me.seq.actions.push( new SkippableAction( new WaitAction( 4.0 ) ) );

							for ( var j = 0; j < levelUpData.rewards.length; ++j )
							{
								me.seq.actions.push( new SkippableAction( new AnimateHeroBadgeLevelRewardAction( levelUpData.rewards[j], rewardsPanel ) ) );
							}

							me.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
							me.seq.actions.push( new AddClassAction( panel, 'RewardsFinished' ) );
							me.seq.actions.push( new WaitForEventAction( panel.FindChildInLayoutFile( "RewardsFinishedButton" ), 'Activated' ) );
							me.seq.actions.push( new StopSkippingAheadAction() );

							me.seq.actions.push( new RunFunctionAction( function ()
							{
								$.DispatchEvent( 'DOTASceneFireEntityInput', levelUpScene, 'light_rank_' + levelUpData.tier_number, 'TurnOff', '1' );
								$.DispatchEvent( 'DOTASceneFireEntityInput', levelUpScene, 'particle_rank_' + levelUpData.tier_number, 'DestroyImmediately', '1' );
							} ) );
						}

						me.seq.actions.push( new RunFunctionAction( function ()
						{
							panel.RemoveClass( 'LeveledUp' );
							panel.FindChildInLayoutFile( "HeroBadgeProgressHeroBadge" ).herolevel = heroLevel;
						} ) );

					} )( this, heroLevel );
					
					this.seq.actions.push( new WaitAction( 1.0 ) );

					if ( heroLevel >= k_unMaxHeroRewardLevel )
					{
						xpLevel = xpLevelNext;
					}
					else
					{
						xpLevel = 0;
						xpLevelNext = $.GetContextPanel().GetHeroXPForNextHeroBadgeLevel( heroLevel );
					}

					( function ( me, xpLevelInternal, xpLevelNextInternal )
					{
						me.seq.actions.push( new RunFunctionAction( function ()
						{
							panel.SetDialogVariableInt( 'current_level_xp', xpLevelInternal );
							panel.SetDialogVariableInt( 'xp_to_next_level', xpLevelNextInternal );
							panel.FindChildInLayoutFile( "HeroBadgeLevelProgress" ).max = xpLevelNextInternal;
							panel.FindChildInLayoutFile( "HeroBadgeLevelProgress" ).value = xpLevelInternal;
						} ) );
					} )( this, xpLevel, xpLevelNext );
					
				}
			}

			this.seq.actions.push( new WaitAction( 0.2 ) );
		}

		if ( this.data.dota_plus_progress !== undefined && this.data.dota_plus_progress.tips !== undefined && this.data.dota_plus_progress.tips.length != 0 )
		{
			var nShardTips = 0;
			for ( var i = 0; i < this.data.dota_plus_progress.tips.length; ++i )
			{
				nShardTips += this.data.dota_plus_progress.tips[i].amount;
			}
			this.seq.actions.push( new AnimateShardRewardAction( panel, '#DOTA_PlusPostGame_PlayerTips', nShardTips ) );
		}

		if ( this.data.dota_plus_progress !== undefined && this.data.dota_plus_progress.victory_prediction_shard_reward > 0 )
		{
			this.seq.actions.push( new AnimateShardRewardAction( panel, '#DOTA_PlusPostGame_VictoryPrediction', this.data.dota_plus_progress.victory_prediction_shard_reward ) );
		}	

		this.seq.actions.push( new StopSkippingAheadAction() );
		this.seq.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );
		this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
		this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
	}

	// Now animate the relics
	if ( this.data.hero_relics_progress )
	{
		if ( this.data.hero_relics_progress.length > 0 )
		{
			this.seq.actions.push( new StopSkippingAheadAction() );
			this.seq.actions.push( new AddScreenLinkAction( panel, 'HeroRelicsProgress', '#DOTA_PlusPostGame_RelicsProgress', function ()
			{
				panel.SwitchClass( 'current_screen', 'ShowRelicsProgress' );
			} ) );

			this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', 'ShowRelicsProgress' ) );
			this.seq.actions.push( new WaitAction( 0.5 ) );
			var stagger = new RunStaggeredActions( 0.15 );
			this.seq.actions.push( new SkippableAction( stagger ));
			var relicsList = panel.FindChildInLayoutFile( "HeroRelicsProgressList" );
			for ( var i = 0; i < this.data.hero_relics_progress.length; ++i )
			{
				stagger.actions.push( new AnimateHeroRelicProgressAction( this.data.hero_relics_progress[i], relicsList ) )
			}

			this.seq.actions.push( new StopSkippingAheadAction() );
			this.seq.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );
			this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
			this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
		}
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

// ----------------------------------------------------------------------------
//
// Cavern Crawl Screen
//
// ----------------------------------------------------------------------------

function AnimateCavernCrawlScreenAction( data )
{
	this.data = data;
}

AnimateCavernCrawlScreenAction.prototype = new BaseAction();

AnimateCavernCrawlScreenAction.prototype.start = function ()
{
	var heroID = this.data.hero_id;
	var eventID = this.data.cavern_crawl_progress.event_id;

	// Create the screen and do a bunch of initial setup
	var panel = StartNewScreen( 'CavernCrawlProgressScreen' );
	panel.BLoadLayoutSnippet( "CavernCrawlProgress" );

	// Setup the sequence of actions to animate the screen
	this.seq = new RunSequentialActions();

	this.seq.actions.push( new AddScreenLinkAction( panel, 'CavernsProgress', '#DOTACavernCrawl_Title' ) );

	this.seq.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );

	var cavernCrawlPanel = panel.FindChildInLayoutFile( 'CavernCrawl' );

	this.seq.actions.push( new AddClassAction( panel, 'ShowCavernCrawlProgress' ) );
	this.seq.actions.push( new RunFunctionAction( function ()
	{
		cavernCrawlPanel.ShowPostGameProgress( eventID, 0, heroID );
	} ) );
	this.seq.actions.push( new WaitForEventAction( cavernCrawlPanel, 'DOTACavernCrawlPostGameProgressComplete' ) );
	this.seq.actions.push( new StopSkippingAheadAction() );

	this.seq.start();

	this.cavern_panel = panel.FindChildInLayoutFile( "CavernCrawl" );

	this.eventHandler = ( function ( me )
	{
		return function ()
		{
			me.cavern_panel.DisableUpdateDisplay( true );
		};
	}( this ) );

	$.RegisterForUnhandledEvent( "PostGameProgressSkippingAhead", this.eventHandler );
}

AnimateCavernCrawlScreenAction.prototype.update = function ()
{
	return this.seq.update();
}

AnimateCavernCrawlScreenAction.prototype.finish = function ()
{
	$.UnregisterForUnhandledEvent( "PostGameProgressSkippingAhead", this.eventHandler );
	this.cavern_panel.DisableUpdateDisplay( false );
	this.seq.finish();
}

// ----------------------------------------------------------------------------
//
// Battle Points
//
// ----------------------------------------------------------------------------


//-----------------------------------------------------------------------------
// Animates battle points within a single level
//-----------------------------------------------------------------------------
function GetBPIncreaseAnimationDuration( bpAmount )
{
	return RemapValClamped( bpAmount, 0, 500, 0.2, 0.6 );
}


// Action to animate a battle pass bp increase
function AnimateBattlePointsIncreaseAction( panel, bpAmount, bpValueStart, bpEarnedStart, bpLevelStart )
{
	this.panel = panel;
	this.bpAmount = bpAmount;
	this.bpValueStart = bpValueStart;
	this.bpEarnedStart = bpEarnedStart;
	this.bpLevelStart = bpLevelStart;
}
AnimateBattlePointsIncreaseAction.prototype = new BaseAction();

AnimateBattlePointsIncreaseAction.prototype.start = function ()
{
	this.seq = new RunParallelActions();

	var duration = GetBPIncreaseAnimationDuration( this.bpAmount );
	var levelProgressBar = this.panel.FindChildInLayoutFile( 'BattleLevelProgress' );
	var minLevelBP = Math.min( this.bpLevelStart, levelProgressBar.max );
	var maxLevelBP = Math.min( this.bpLevelStart + this.bpAmount, levelProgressBar.max );

	this.seq.actions.push( new AnimateDialogVariableIntAction( this.panel, 'current_level_bp', minLevelBP, maxLevelBP, duration ) );
	this.seq.actions.push( new AnimateProgressBarWithMiddleAction( levelProgressBar, minLevelBP, maxLevelBP, duration ) );
	this.seq.actions.push( new PlaySoundForDurationAction( "XP.Count", duration ) );

	this.seq.start();
}
AnimateBattlePointsIncreaseAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateBattlePointsIncreaseAction.prototype.finish = function ()
{
	this.seq.finish();
}


//-----------------------------------------------------------------------------
// Adds points to totals bar
//-----------------------------------------------------------------------------
function UpdateSubpanelTotalPoints( panel, ownerPanel, bpAmount, bpStartingSubTotal, displayOnly )
{
	panel.SetDialogVariableInt( 'xp_circle_points', bpAmount );
	panel.AddClass( 'ShowTotals' );
	if ( !displayOnly )
	{
		ownerPanel.SetDialogVariableInt( 'total_points_gained', bpStartingSubTotal + bpAmount );
	}
}


//-----------------------------------------------------------------------------
// Subpanel animation timings
//-----------------------------------------------------------------------------
var g_DelayAfterStart = 0.05;
var g_SubElementDelay = 0.05;

//-----------------------------------------------------------------------------
// Animates wagering subpanel
//-----------------------------------------------------------------------------
// Action to animate a battle pass bp increase
function AnimateWageringSubpanelAction( panel, ownerPanel, wagering_data, startingPoints )
{
	this.panel = panel;
	this.ownerPanel = ownerPanel;
	this.startingPoints = startingPoints;

	panel.AddClass( 'Visible' );

	var panelXPCircle = panel.FindChildInLayoutFile( "XPCircleContainer" );
	panelXPCircle.BLoadLayoutSnippet( 'BattlePassXPCircle' );

	panel.SetDialogVariableInt( 'wager_amount', wagering_data.wager_amount );
	panel.SetDialogVariableInt( 'wager_conversion_ratio', wagering_data.conversion_ratio );
	panel.SetDialogVariableInt( 'wager_count_250', wagering_data.wager_count_250 );
	panel.SetDialogVariableInt( 'wager_count_500', wagering_data.wager_count_500 );
	panel.SetDialogVariableInt( 'wager_count_1000', wagering_data.wager_count_1000 );

	this.total_points = wagering_data.wager_amount * wagering_data.conversion_ratio +
		250 * wagering_data.wager_count_250 +
		500 * wagering_data.wager_count_500 +
		1000 * wagering_data.wager_count_1000;
}

AnimateWageringSubpanelAction.prototype = new BaseAction();

AnimateWageringSubpanelAction.prototype.start = function ()
{
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowWager' ) );
	this.seq.actions.push( new AddClassAction( this.panel, 'ShowTeamWager250' ) );
	this.seq.actions.push( new AddClassAction( this.panel, 'ShowTeamWager500' ) );
	this.seq.actions.push( new AddClassAction( this.panel, 'ShowTeamWager1000' ) );

	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	var panel = this.panel;
	var ownerPanel = this.ownerPanel;
	var total_points = this.total_points;
	var startingPoints = this.startingPoints;
	this.seq.actions.push( new RunFunctionAction( function ()
	{
		UpdateSubpanelTotalPoints( panel, ownerPanel, total_points, startingPoints, false );
	} ) );

	this.seq.start();
}
AnimateWageringSubpanelAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateWageringSubpanelAction.prototype.finish = function ()
{
	this.seq.finish();
}


//-----------------------------------------------------------------------------
// Animates tipping subpanel
//-----------------------------------------------------------------------------
// Action to animate a battle pass bp increase
function AnimateTippingSubpanelAction( panel, ownerPanel, tips, startingPoints )
{
	this.panel = panel;
	this.ownerPanel = ownerPanel;
	this.startingPoints = startingPoints;

	panel.AddClass( 'Visible' );

	var panelXPCircle = panel.FindChildInLayoutFile( "XPCircleContainer" );
	panelXPCircle.BLoadLayoutSnippet( 'BattlePassXPCircle' );

	var totalTipCount = 0;
	this.panelCount = 0;
	this.total_points = 0;

	var tipContainer = panel.FindChildInLayoutFile( "TipContainer" );
	var tipContainer2 = panel.FindChildInLayoutFile( "TipContainer2" );
	var tipParent = tipContainer;
	for ( var i = 0; i < tips.length; ++i )
	{
		if ( i == 4 )
		{
			tipParent = tipContainer2;
			panel.AddClass( "TwoTipColumns" );
		}

		var tipperPanel = $.CreatePanel( 'Panel', tipParent, 'Tipper' + i );
		tipperPanel.BLoadLayoutSnippet( 'BattlePassTip' );

		var avatarPanel = tipperPanel.FindChildInLayoutFile( "Avatar" );
		avatarPanel.SetAccountID( tips[i].account_id );

		tipperPanel.SetDialogVariableInt( 'tip_points', tips[i].amount );
		tipperPanel.AddClass( 'TipCount' + tips[i].count );

		totalTipCount += tips[i].count;
		this.panelCount = this.panelCount + 1;
		this.total_points += tips[i].count * tips[i].amount
	}
	panel.SetDialogVariableInt( 'total_tip_count', totalTipCount );
}

AnimateTippingSubpanelAction.prototype = new BaseAction();

AnimateTippingSubpanelAction.prototype.start = function ()
{
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowTotalTips' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	for ( var i = 0; i < this.panelCount; ++i )
	{
		var tipperPanel = this.panel.FindChildInLayoutFile( 'Tipper' + i );
		this.seq.actions.push( new AddClassAction( tipperPanel, 'ShowTip' ) );
	}

	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	var panel = this.panel;
	var ownerPanel = this.ownerPanel;
	var total_points = this.total_points;
	var startingPoints = this.startingPoints;
	this.seq.actions.push( new RunFunctionAction( function ()
	{
		UpdateSubpanelTotalPoints( panel, ownerPanel, total_points, startingPoints, false );
	} ) );

	this.seq.start();
}

AnimateTippingSubpanelAction.prototype.update = function ()
{
	return this.seq.update();
}

AnimateTippingSubpanelAction.prototype.finish = function ()
{
	this.seq.finish();
}


//-----------------------------------------------------------------------------
// Animates cavern crawl subpanel
//-----------------------------------------------------------------------------
// Action to animate a battle pass bp increase
function AnimateCavernCrawlSubpanelAction( panel, ownerPanel, cavern_data, startingPoints )
{
	this.panel = panel;
	this.ownerPanel = ownerPanel;
	this.startingPoints = startingPoints;

	panel.AddClass( 'Visible' );

	var panelXPCircle = panel.FindChildInLayoutFile( "XPCircleContainer" );
	panelXPCircle.BLoadLayoutSnippet( 'BattlePassXPCircle' );

	panel.FindChildInLayoutFile( "CavernCrawlHero" ).SetImage( 'file://{images}/heroes/icons/' + cavern_data.hero_name + '.png' );

	this.total_points = cavern_data.bp_amount;
}

AnimateCavernCrawlSubpanelAction.prototype = new BaseAction();

AnimateCavernCrawlSubpanelAction.prototype.start = function ()
{
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowMap' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowCompleted' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	var panel = this.panel;
	var ownerPanel = this.ownerPanel;
	var total_points = this.total_points;
	var startingPoints = this.startingPoints;
	this.seq.actions.push( new RunFunctionAction( function ()
	{
		UpdateSubpanelTotalPoints( panel, ownerPanel, total_points, startingPoints, false );
	} ) );

	this.seq.start();
}
AnimateCavernCrawlSubpanelAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateCavernCrawlSubpanelAction.prototype.finish = function ()
{
	this.seq.finish();
}


//-----------------------------------------------------------------------------
// Animates daily challenge subpanel
//-----------------------------------------------------------------------------
// Action to animate a battle pass bp increase
function AnimateDailyChallengeSubpanelAction( panel, ownerPanel, daily_challenge, startingPoints )
{
	this.panel = panel;
	this.ownerPanel = ownerPanel;
	this.startingPoints = startingPoints;

	panel.AddClass( 'Visible' );

	var panelXPCircle = panel.FindChildInLayoutFile( "XPCircleContainer" );
	panelXPCircle.BLoadLayoutSnippet( 'BattlePassXPCircle' );

	panel.FindChildInLayoutFile( "DailyChallengeHeroMovie" ).heroid = daily_challenge.hero_id;

	this.total_points = daily_challenge.bp_amount;
}

AnimateDailyChallengeSubpanelAction.prototype = new BaseAction();

AnimateDailyChallengeSubpanelAction.prototype.start = function ()
{
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowHero' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowCompleted' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	var panel = this.panel;
	var ownerPanel = this.ownerPanel;
	var total_points = this.total_points;
	var startingPoints = this.startingPoints;
	this.seq.actions.push( new RunFunctionAction( function ()
	{
		UpdateSubpanelTotalPoints( panel, ownerPanel, total_points, startingPoints, false );
	} ) );

	this.seq.start();
}
AnimateDailyChallengeSubpanelAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateDailyChallengeSubpanelAction.prototype.finish = function ()
{
	this.seq.finish();
}


//-----------------------------------------------------------------------------
// Animates weekly challenge subpanel
//-----------------------------------------------------------------------------
// Action to animate a battle pass bp increase
function AnimateWeeklyChallengeSubpanelAction( panel, ownerPanel, weekly_challenge, startingPoints )
{
	this.panel = panel;
	this.ownerPanel = ownerPanel;
	this.startingPoints = startingPoints;

	panel.AddClass( 'Visible' );

	var panelXPCircle = panel.FindChildInLayoutFile( "XPCircleContainer" );
	panelXPCircle.BLoadLayoutSnippet( 'BattlePassXPCircle' );

	panel.SetDialogVariable( 'weekly_challenge_description', weekly_challenge.challenge_description );
	panel.SetDialogVariableInt( 'weekly_progress', weekly_challenge.progress );
	panel.SetDialogVariableInt( 'weekly_complete_limit', weekly_challenge.complete_limit );
	panel.SetDialogVariableInt( 'weekly_increment', weekly_challenge.end_progress - weekly_challenge.progress );

	var progressBar = panel.FindChildInLayoutFile( "WeeklyChallengeProgress" );
	progressBar.max = weekly_challenge.complete_limit;
	progressBar.lowervalue = weekly_challenge.progress;
	progressBar.uppervalue = weekly_challenge.end_progress;

	this.points_for_display = weekly_challenge.bp_amount;
	this.total_points = 0;
	if ( weekly_challenge.end_progress == weekly_challenge.complete_limit )
	{
		this.total_points = weekly_challenge.bp_amount;
	}
	else
	{
		panel.AddClass( "HideXPCircle" );
	}
}

AnimateWeeklyChallengeSubpanelAction.prototype = new BaseAction();

AnimateWeeklyChallengeSubpanelAction.prototype.start = function ()
{
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowChallenge' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	if ( this.total_points != 0 )
	{
		this.seq.actions.push( new AddClassAction( this.panel, 'ShowCompleted' ) );
		this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );
	}

	var panel = this.panel;
	var ownerPanel = this.ownerPanel;
	var total_points = this.points_for_display;
	var displayOnly = ( this.total_points == 0 );
	var startingPoints = this.startingPoints;

	this.seq.actions.push( new RunFunctionAction( function ()
	{
		UpdateSubpanelTotalPoints( panel, ownerPanel, total_points, startingPoints, displayOnly );
	} ) );

	this.seq.start();
}
AnimateWeeklyChallengeSubpanelAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateWeeklyChallengeSubpanelAction.prototype.finish = function ()
{
	this.seq.finish();
}


//-----------------------------------------------------------------------------
// Main entry point for battle points animation
//-----------------------------------------------------------------------------


function AnimateBattlePassScreenAction( data )
{
	this.data = data;
}

function ComputeBattlePassTier( tier_list, level )
{
	if ( !tier_list )
		return;

	var tier = 0;
	for ( var i = 0; i < tier_list.length; ++i )
	{
		if ( level >= tier_list[i] )
		{
			tier = i;
		}
	}

	return tier;
}


AnimateBattlePassScreenAction.prototype = new BaseAction();

AnimateBattlePassScreenAction.prototype.start = function ()
{
	var battlePointsStart = this.data.battle_pass_progress.battle_points_start;
	var battleLevelStart = Math.floor( battlePointsStart / this.data.battle_pass_progress.battle_points_per_level );
	var heroID = this.data.hero_id;

	var battlePointsAtLevelStart = battleLevelStart * this.data.battle_pass_progress.battle_points_per_level;

	var bpLevelStart = 0;
	var bpLevelNext = 0;
	bpLevelStart = battlePointsStart - battlePointsAtLevelStart;
	bpLevelNext = this.data.battle_pass_progress.battle_points_per_level;

	// Create the screen and do a bunch of initial setup
	var panel = StartNewScreen( 'BattlePassProgressScreen' );
	panel.BLoadLayoutSnippet( "BattlePassProgress" );

	panel.SetDialogVariableInt( 'total_points_gained', 0 );

	// Setup the sequence of actions to animate the screen
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	this.seq.actions.push( new AddScreenLinkAction( panel, 'BattlePassProgress', '#DOTA_PlusPostGame_BattlePassProgress', function ()
	{
		panel.SwitchClass( 'current_screen', 'ShowBattlePassProgress' );
	} ) );
	this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', 'ShowBattlePassProgress' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	var subPanelActions = new RunSkippableStaggeredActions( .3 );

	var startingPointsToAdd = 0;
	if ( this.data.battle_pass_progress.wagering != null )
	{
		var wagerPanel = panel.FindChildInLayoutFile( "BattlePassWagerProgress" );
		var subpanelAction = new AnimateWageringSubpanelAction( wagerPanel, panel, this.data.battle_pass_progress.wagering, startingPointsToAdd );
		startingPointsToAdd += subpanelAction.total_points;
		subPanelActions.actions.push( subpanelAction );
	}

	if ( this.data.battle_pass_progress.tips != null && this.data.battle_pass_progress.tips.length != 0 )
	{
		var tipPanel = panel.FindChildInLayoutFile( "BattlePassTipsProgress" );
		var subpanelAction = new AnimateTippingSubpanelAction( tipPanel, panel, this.data.battle_pass_progress.tips, startingPointsToAdd );
		startingPointsToAdd += subpanelAction.total_points;
		subPanelActions.actions.push( subpanelAction );
	}

	if ( this.data.battle_pass_progress.cavern_crawl != null )
	{
		var cavernPanel = panel.FindChildInLayoutFile( "BattlePassCavernCrawlProgress" );
		var subpanelAction = new AnimateCavernCrawlSubpanelAction( cavernPanel, panel, this.data.battle_pass_progress.cavern_crawl, startingPointsToAdd );
		startingPointsToAdd += subpanelAction.total_points;
		subPanelActions.actions.push( subpanelAction );
	}

	if ( this.data.battle_pass_progress.daily_challenge != null )
	{
		var dailyPanel = panel.FindChildInLayoutFile( "BattlePassDailyChallengeProgress" );
		var subpanelAction = new AnimateDailyChallengeSubpanelAction( dailyPanel, panel, this.data.battle_pass_progress.daily_challenge, startingPointsToAdd );
		startingPointsToAdd += subpanelAction.total_points;
		subPanelActions.actions.push( subpanelAction );
	}

	if ( this.data.battle_pass_progress.weekly_challenge_1 != null )
	{
		var dailyPanel = panel.FindChildInLayoutFile( "BattlePassWeeklyChallengeProgress" );
		var subpanelAction = new AnimateWeeklyChallengeSubpanelAction( dailyPanel, panel, this.data.battle_pass_progress.weekly_challenge_1, startingPointsToAdd );
		startingPointsToAdd += subpanelAction.total_points;
		subPanelActions.actions.push( subpanelAction );
	}

	this.seq.actions.push( subPanelActions );

	var weeklyPanel = panel.FindChildInLayoutFile( "BattlePassWeeklyChallengeProgress" );
	var weeklyPanelXPCircle = weeklyPanel.FindChildInLayoutFile( "XPCircleContainer" );
	weeklyPanelXPCircle.BLoadLayoutSnippet( 'BattlePassXPCircle' );
	weeklyPanelXPCircle.SetDialogVariableInt( 'points', 1000 );

	panel.FindChildInLayoutFile( "BattlePassTotalsRow" ).SetDialogVariableInt( 'bp_value', 0 );
	panel.SetDialogVariableInt( 'current_level_bp', bpLevelStart );
	panel.SetDialogVariableInt( 'bp_to_next_level', bpLevelNext );
	panel.FindChildInLayoutFile( 'BattlePassLevelShield' ).SetEventLevel( this.data.battle_pass_progress.battle_points_event_id, battleLevelStart );

	var progressBar = panel.FindChildInLayoutFile( "BattleLevelProgress" );
	progressBar.max = bpLevelNext;
	progressBar.lowervalue = bpLevelStart;
	progressBar.uppervalue = bpLevelStart;

	var bpEarned = 0;
	var bpLevel = bpLevelStart;
	var battleLevel = battleLevelStart;

	var bpRemaining = startingPointsToAdd;
	var bpEarnedOnRow = 0;

	while ( bpRemaining > 0 )
	{
		var bpToAnimate = 0;
		var bpToNextLevel = 0;
		bpToNextLevel = bpLevelNext - bpLevel;
		bpToAnimate = Math.min( bpRemaining, bpToNextLevel );

		if ( bpToAnimate > 0 )
		{
			this.seq.actions.push( new SkippableAction( new AnimateBattlePointsIncreaseAction( panel, bpToAnimate, bpEarnedOnRow, bpEarned, bpLevel ) ) );

			bpEarned += bpToAnimate;
			bpLevel += bpToAnimate;
			bpEarnedOnRow += bpToAnimate;
			bpRemaining -= bpToAnimate;
		}

		bpToNextLevel = bpLevelNext - bpLevel;

		if ( bpToNextLevel != 0 )
			continue;

		battleLevel = battleLevel + 1;
		bpLevel = 0;

		this.seq.actions.push( new AddClassAction(panel, 'LeveledUpStart') );

		( function ( me, battleLevelInternal )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				var levelShield = panel.FindChildInLayoutFile( 'BattlePassLevelShield' );
				levelShield.AddClass( 'LeveledUp' );
				levelShield.SetEventLevel( me.data.battle_pass_progress.battle_points_event_id, battleLevelInternal );
			} ) );
		} )( this, battleLevel );

		this.seq.actions.push( new RemoveClassAction( panel, 'LeveledUpStart' ) );
		this.seq.actions.push( new AddClassAction( panel, 'LeveledUpEnd' ) );
		this.seq.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );

		( function ( me, battleLevelInternal )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				var levelShield = panel.FindChildInLayoutFile( 'BattlePassLevelShield' );
				levelShield.RemoveClass( 'LeveledUp' );
			} ) );
		} )( this, battleLevel );
		this.seq.actions.push( new RemoveClassAction( panel, 'LeveledUpEnd' ) );

		( function ( me, bpLevelInternal, bpLevelNextInternal )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				progressBar.lowervalue = 0;
				progressBar.uppervalue = 0;
				panel.SetDialogVariableInt( 'current_level_bp', bpLevelInternal );
				panel.SetDialogVariableInt( 'bp_to_next_level', bpLevelNextInternal );
				panel.FindChildInLayoutFile( "BattleLevelProgress" ).max = bpLevelNextInternal;
				panel.FindChildInLayoutFile( "BattleLevelProgress" ).value = bpLevelInternal;
			} ) );
		} )( this, bpLevel, bpLevelNext );
	}

	this.seq.actions.push( new WaitAction( 0.2 ) );

	this.seq.actions.push( new StopSkippingAheadAction() );
	this.seq.actions.push( new SkippableAction( new WaitAction( 1.5 ) ) );
	this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	this.seq.start();
}
AnimateBattlePassScreenAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateBattlePassScreenAction.prototype.finish = function ()
{
	this.seq.finish();
}

// Rubick Arcana

function AnimateRubickArcanaScreenAction( data )
{
	this.data = data;
}

AnimateRubickArcanaScreenAction.prototype = new BaseAction();

AnimateRubickArcanaScreenAction.prototype.start = function ()
{
	var heroID = this.data.hero_id;

	// Create the screen and do a bunch of initial setup
	var panel = StartNewScreen( 'RubickArcanaProgressScreen' );
	panel.BLoadLayoutSnippet( "RubickArcanaProgress" );
	
	var heroModel = panel.FindChildInLayoutFile( 'RubickArcanaModel' );
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

	var progress = panel.FindChildInLayoutFile('RubickArcanaProgress');
	progress.current_score = this.data.rubick_arcana_progress.arcana_start_score;
	progress.ScrollToCurrentScore();

	var endScore = this.data.rubick_arcana_progress.arcana_end_score;

	// Setup the sequence of actions to animate the screen
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
	this.seq.actions.push( new AddScreenLinkAction( panel, 'RubickArcanaProgress', '#DOTA_PlusPostGame_RubickArcanaProgress' ) );
	this.seq.actions.push( new ActionWithTimeout( new WaitForClassAction( heroModel, 'SceneLoaded' ), 3.0 ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
	this.seq.actions.push( new AddClassAction( panel, 'ShowProgress' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 1.5 ) ) );
	this.seq.actions.push( new RunFunctionAction( function ()
	{
		progress.current_score = endScore;
		progress.ScrollToCurrentScore();
		progress.TriggerClass('PulseScore');
	} ) );
	this.seq.actions.push( new StopSkippingAheadAction() );
	this.seq.actions.push( new SkippableAction( new WaitAction( 1.5 ) ) );
	this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	this.seq.start();
}
AnimateRubickArcanaScreenAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateRubickArcanaScreenAction.prototype.finish = function ()
{
	this.seq.finish();
}


// Frostivus 2018

function AnimateFrostivusScreenAction( data )
{
	this.data = data;
}

AnimateFrostivusScreenAction.prototype = new BaseAction();

AnimateFrostivusScreenAction.prototype.start = function ()
{
	var battlePointsStart = this.data.frostivus_progress.battle_points_start;
	var battleLevelStart = Math.floor( battlePointsStart / this.data.frostivus_progress.battle_points_per_level );
	var heroID = this.data.hero_id;

	var battlePointsAtLevelStart = battleLevelStart * this.data.frostivus_progress.battle_points_per_level;

	var bpLevelStart = 0;
	var bpLevelNext = 0;
	bpLevelStart = battlePointsStart - battlePointsAtLevelStart;
	bpLevelNext = this.data.frostivus_progress.battle_points_per_level;

	// Create the screen and do a bunch of initial setup
	var panel = StartNewScreen( 'Frostivus2018ProgressScreen' );
	panel.BLoadLayoutSnippet( "Frostivus2018Progress" );

	panel.SetDialogVariableInt( 'total_points_gained', 0 );

	// Setup the sequence of actions to animate the screen
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	this.seq.actions.push( new AddScreenLinkAction( panel, 'Frostivus2018Progress', '#DOTA_PlusPostGame_Frostivus2018Progress', function ()
	{
		panel.SwitchClass( 'current_screen', 'ShowFrostivus2018Progress' );
	} ) );
	this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', 'ShowFrostivus2018Progress' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	( function ( me, myPanel )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				myPanel.SetDialogVariableInt( 'total_points_gained', me.data.frostivus_progress.battle_points_earned );
			} ) );
	} )( this, panel );

	//panel.FindChildInLayoutFile( "Frostivus2018TotalsRow" ).SetDialogVariableInt( 'bp_value', 0 );
	panel.SetDialogVariableInt( 'current_level_bp', bpLevelStart );
	panel.SetDialogVariableInt( 'bp_to_next_level', bpLevelNext );
	panel.FindChildInLayoutFile( 'Frostivus2018LevelShield' ).SetEventLevel( this.data.frostivus_progress.battle_points_event_id, battleLevelStart );

	this.seq.actions.push( new SkippableAction( new WaitAction( 0.75 ) ) );

	var progressBar = panel.FindChildInLayoutFile( "BattleLevelProgress" );
	progressBar.max = bpLevelNext;
	progressBar.lowervalue = bpLevelStart;
	progressBar.uppervalue = bpLevelStart;

	var bpEarned = 0;
	var bpLevel = bpLevelStart;
	var battleLevel = battleLevelStart;

	var bpRemaining = this.data.frostivus_progress.battle_points_earned;
	var bpEarnedOnRow = 0;

	while ( bpRemaining > 0 )
	{
		var bpToAnimate = 0;
		var bpToNextLevel = 0;
		bpToNextLevel = bpLevelNext - bpLevel;
		bpToAnimate = Math.min( bpRemaining, bpToNextLevel );

		if ( bpToAnimate > 0 )
		{
			this.seq.actions.push( new SkippableAction( new AnimateBattlePointsIncreaseAction( panel, bpToAnimate, bpEarnedOnRow, bpEarned, bpLevel ) ) );

			bpEarned += bpToAnimate;
			bpLevel += bpToAnimate;
			bpEarnedOnRow += bpToAnimate;
			bpRemaining -= bpToAnimate;
		}

		bpToNextLevel = bpLevelNext - bpLevel;

		if ( bpToNextLevel != 0 )
			continue;

		battleLevel = battleLevel + 1;
		bpLevel = 0;

		this.seq.actions.push( new AddClassAction(panel, 'LeveledUpStart') );

		( function ( me, battleLevelInternal )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				var levelShield = panel.FindChildInLayoutFile( 'Frostivus2018LevelShield' );
				levelShield.AddClass( 'LeveledUp' );
				levelShield.SetEventLevel( me.data.frostivus_progress.battle_points_event_id, battleLevelInternal );
			} ) );
		} )( this, battleLevel );

		this.seq.actions.push( new RemoveClassAction( panel, 'LeveledUpStart' ) );
		this.seq.actions.push( new AddClassAction( panel, 'LeveledUpEnd' ) );
		this.seq.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );

		( function ( me, battleLevelInternal )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				var levelShield = panel.FindChildInLayoutFile( 'Frostivus2018LevelShield' );
				levelShield.RemoveClass( 'LeveledUp' );
			} ) );
		} )( this, battleLevel );
		this.seq.actions.push( new RemoveClassAction( panel, 'LeveledUpEnd' ) );

		( function ( me, bpLevelInternal, bpLevelNextInternal )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				progressBar.lowervalue = 0;
				progressBar.uppervalue = 0;
				panel.SetDialogVariableInt( 'current_level_bp', bpLevelInternal );
				panel.SetDialogVariableInt( 'bp_to_next_level', bpLevelNextInternal );
				panel.FindChildInLayoutFile( "BattleLevelProgress" ).max = bpLevelNextInternal;
				panel.FindChildInLayoutFile( "BattleLevelProgress" ).value = bpLevelInternal;
			} ) );
		} )( this, bpLevel, bpLevelNext );
	}

	this.seq.actions.push( new WaitAction( 0.2 ) );

	this.seq.actions.push( new StopSkippingAheadAction() );
	this.seq.actions.push( new SkippableAction( new WaitAction( 1.5 ) ) );
	this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	this.seq.start();
}
AnimateFrostivusScreenAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateFrostivusScreenAction.prototype.finish = function ()
{
	this.seq.finish();
}

// Event Points [New Bloom 2019, etc]

function AnimateEventPointsScreenAction( data )
{
	this.data = data;
}

AnimateEventPointsScreenAction.prototype = new BaseAction();

AnimateEventPointsScreenAction.prototype.start = function ()
{
	var battlePointsStart = this.data.event_points_progress.battle_points_start;
	var battleLevelStart = Math.floor( battlePointsStart / this.data.event_points_progress.battle_points_per_level );
	var heroID = this.data.hero_id;

	var battlePointsAtLevelStart = battleLevelStart * this.data.event_points_progress.battle_points_per_level;

	var bpLevelStart = 0;
	var bpLevelNext = 0;
	bpLevelStart = battlePointsStart - battlePointsAtLevelStart;
	bpLevelNext = this.data.event_points_progress.battle_points_per_level;

	// Create the screen and do a bunch of initial setup
	var panel = StartNewScreen( 'EventPointsProgressScreen' );
	panel.BLoadLayoutSnippet( "EventPointsProgress" );

	panel.SetDialogVariableInt( 'total_points_gained', 0 );

	panel.SetDialogVariable( 'event_name', $.Localize( this.data.event_points_progress.battle_points_event_name ) );

	// Setup the sequence of actions to animate the screen
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	this.seq.actions.push( new AddScreenLinkAction( panel, 'EventPointsProgress', '#DOTA_PlusPostGame_EventPointsProgress', function ()
	{
		panel.SwitchClass( 'current_screen', 'ShowEventPointsProgress' );
	} ) );
	this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', 'ShowEventPointsProgress' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	( function ( me, myPanel )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				myPanel.SetDialogVariableInt( 'total_points_gained', me.data.event_points_progress.battle_points_earned );
			} ) );
	} )( this, panel );

	//panel.FindChildInLayoutFile( "EventPointsTotalsRow" ).SetDialogVariableInt( 'bp_value', 0 );
	panel.SetDialogVariableInt( 'current_level_bp', bpLevelStart );
	panel.SetDialogVariableInt( 'bp_to_next_level', bpLevelNext );
	panel.FindChildInLayoutFile( 'EventPointsLevelShield' ).SetEventLevel( this.data.event_points_progress.battle_points_event_id, battleLevelStart );

	this.seq.actions.push( new SkippableAction( new WaitAction( 0.75 ) ) );

	var wonGameRow = panel.FindChildInLayoutFile( "EventPointsWonGameRow" );
	this.seq.actions.push( new AddClassAction( wonGameRow, 'ShowRow' ) );
	this.seq.actions.push( new AddClassAction( wonGameRow, 'ShowValue' ) );

	var progressBar = panel.FindChildInLayoutFile( "BattleLevelProgress" );
	progressBar.max = bpLevelNext;
	progressBar.lowervalue = bpLevelStart;
	progressBar.uppervalue = bpLevelStart;

	var bpEarned = 0;
	var bpLevel = bpLevelStart;
	var battleLevel = battleLevelStart;

	var bpRemaining = this.data.event_points_progress.battle_points_earned;
	var bpEarnedOnRow = 0;

	while ( bpRemaining > 0 )
	{
		var bpToAnimate = 0;
		var bpToNextLevel = 0;
		bpToNextLevel = bpLevelNext - bpLevel;
		bpToAnimate = Math.min( bpRemaining, bpToNextLevel );

		if ( bpToAnimate > 0 )
		{
			this.seq.actions.push( new SkippableAction( new AnimateBattlePointsIncreaseAction( panel, bpToAnimate, bpEarnedOnRow, bpEarned, bpLevel ) ) );

			bpEarned += bpToAnimate;
			bpLevel += bpToAnimate;
			bpEarnedOnRow += bpToAnimate;
			bpRemaining -= bpToAnimate;
		}

		bpToNextLevel = bpLevelNext - bpLevel;

		if ( bpToNextLevel != 0 )
			continue;

		battleLevel = battleLevel + 1;
		bpLevel = 0;

		this.seq.actions.push( new AddClassAction(panel, 'LeveledUpStart') );

		( function ( me, battleLevelInternal )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				var levelShield = panel.FindChildInLayoutFile( 'EventPointsLevelShield' );
				levelShield.AddClass( 'LeveledUp' );
				levelShield.SetEventLevel( me.data.event_points_progress.battle_points_event_id, battleLevelInternal );
			} ) );
		} )( this, battleLevel );

		this.seq.actions.push( new RemoveClassAction( panel, 'LeveledUpStart' ) );
		this.seq.actions.push( new AddClassAction( panel, 'LeveledUpEnd' ) );
		this.seq.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );

		( function ( me, battleLevelInternal )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				var levelShield = panel.FindChildInLayoutFile( 'EventPointsLevelShield' );
				levelShield.RemoveClass( 'LeveledUp' );
			} ) );
		} )( this, battleLevel );
		this.seq.actions.push( new RemoveClassAction( panel, 'LeveledUpEnd' ) );

		( function ( me, bpLevelInternal, bpLevelNextInternal )
		{
			me.seq.actions.push( new RunFunctionAction( function ()
			{
				progressBar.lowervalue = 0;
				progressBar.uppervalue = 0;
				panel.SetDialogVariableInt( 'current_level_bp', bpLevelInternal );
				panel.SetDialogVariableInt( 'bp_to_next_level', bpLevelNextInternal );
				panel.FindChildInLayoutFile( "BattleLevelProgress" ).max = bpLevelNextInternal;
				panel.FindChildInLayoutFile( "BattleLevelProgress" ).value = bpLevelInternal;
			} ) );
		} )( this, bpLevel, bpLevelNext );
	}

	this.seq.actions.push( new WaitAction( 0.2 ) );

	this.seq.actions.push( new StopSkippingAheadAction() );
	this.seq.actions.push( new SkippableAction( new WaitAction( 1.5 ) ) );
	this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	this.seq.start();
}
AnimateEventPointsScreenAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateEventPointsScreenAction.prototype.finish = function ()
{
	this.seq.finish();
}

// ----------------------------------------------------------------------------
//
// Debugging
//
// ----------------------------------------------------------------------------

function TestAnimateHeroBadgeLevel()
{
	var data =
	{
		hero_id: 11,
		hero_badge_xp_start: 22850,

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
			18:
				{
					tier_number: 4,
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
						}
					],
				},
			19:
				{
					tier_number: 4,
					rewards: 
					[
						{
							reward_type: HERO_BADGE_LEVEL_REWARD_CURRENCY,
							currency_amount: 3000
						}
					]
				}
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
		],

		dota_plus_progress:
		{
			tips:
			[
				{
					account_id: 172258,
					count: 2,
					amount: 50,
				},
			],

			victory_prediction_shard_reward: 20
		}

	};

	TestProgressAnimation( data );
}

function TestAnimateBattlePass()
{
	var data =
	{
		hero_id: 87,

		battle_pass_progress:
		{
			battle_points_event_id: 22,
			battle_points_start: 74850,
			battle_points_per_level: 1000,

			wagering:
			{
				wager_amount: 250,
				conversion_ratio: 2,
				wager_count_250: 2,
				wager_count_500: 0,
				wager_count_1000: 0
			},

			tips:
			[
				{
					account_id: 172258,
					count: 2,
					amount: 250,
				},
//				{
//					account_id: 236096,
//					count: 1,
//					amount: 500,
//				},
//				{
//					account_id: 236096,
//					count: 3,
//					amount: 500,
//				},
//				{
//					account_id: 236096,
//					count: 1,
//					amount: 500,
//				},
//				{
//					account_id: 172258,
//					count: 2,
//					amount: 250,
//				},
//				{
//					account_id: 236096,
//					count: 1,
//					amount: 500,
//				},
//				{
//					account_id: 236096,
//					count: 3,
//					amount: 500,
//				},
//				{
//					account_id: 236096,
//					count: 1,
//					amount: 500,
//				},
//				{
//					account_id: 236096,
//					count: 1,
//					amount: 500,
//				},
			],

			cavern_crawl:
			{
				hero_name: 'npc_dota_hero_disruptor',
				bp_amount: 375,
			},

			daily_challenge:
			{
				hero_id: 87,
				bp_amount: 125,
			},

			weekly_challenge_1:
			{
				challenge_description: 'Kill 50 enemy heroes',
				progress: 20000,
				end_progress: 30000,
				complete_limit: 50000,
				bp_amount: 250,
			},
		}
	};

	TestProgressAnimation( data );
}

function TestAnimateCavernCrawl()
{
	var data =
	{
		hero_id: 92,
		cavern_crawl_progress:
		{
			event_id: 22,
		},
	};

	TestProgressAnimation( data );
}


function TestAnimateRubickArcanaProgress()
{
	var data =
	{
		hero_id: 86,

		rubick_arcana_progress:
		{
			arcana_start_score: 34,
			arcana_end_score: 36
		}
	};

	TestProgressAnimation( data );
}

function TestAnimateFrostivusProgress()
{
	var data =
	{
		hero_id: 87,
		frostivus_progress:
		{
			battle_points_event_id: 24,
			battle_points_start: 2200,
			battle_points_per_level: 1000,
			battle_points_earned: 1250,
			battle_points_daily_bonus_earned: 1000,
		}
	};

	TestProgressAnimation( data );
}

function TestAnimateEventPointsProgress()
{
	$.GetContextPanel().AddClass( 'Season_NewBloom2019' );
	var data =
	{
		hero_id: 87,
		event_points_progress:
		{
			battle_points_event_id: 24,
			battle_points_start: 2200,
			battle_points_per_level: 1000,
			battle_points_earned: 1250,
			battle_points_event_name: '#DOTA_EventName_NewBloom2019',
		}
	};

	TestProgressAnimation( data );
}



// ----------------------------------------------------------------------------
//   All Screens
// ----------------------------------------------------------------------------

function CreateProgressAnimationSequence( data )
{
	var seq = new RunSequentialActions();

	// While the actions are animating, don't allow clicking links to other screens.
	seq.actions.push( new RunFunctionAction( function () 
	{
		GetScreenLinksContainer().enabled = false;
	} ) );

	if ( data.cavern_crawl_progress != null )
	{
		seq.actions.push( new AnimateCavernCrawlScreenAction( data ) );
	}

	if ( data.battle_pass_progress != null )
	{
		seq.actions.push( new AnimateBattlePassScreenAction( data ) );
	}

	if ( data.rubick_arcana_progress != null )
	{
		seq.actions.push( new AnimateRubickArcanaScreenAction( data ) );
	}

	if ( data.hero_badge_progress != null || data.hero_relics_progress != null )
	{
		seq.actions.push( new AnimateHeroBadgeLevelScreenAction( data ) );
	}

	if ( data.frostivus_progress != null )
	{
		seq.actions.push( new AnimateFrostivusScreenAction( data ) );
	}

	if ( data.event_points_progress != null )
	{
		seq.actions.push( new AnimateEventPointsScreenAction( data ) );
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
	$.Msg( "Showing progress for: " + JSON.stringify( data ) );
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
