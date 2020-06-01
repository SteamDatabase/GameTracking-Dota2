
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

	if ( bSkipAhead )
	{
		$.DispatchEvent( "PostGameProgressSkippingAhead" );
	}
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
//   Battle pass level progress bar
// ----------------------------------------------------------------------------

function AnimateBattlePassLevelsAction( panel, eventId, bpPointsStart, bpPointsPerLevel, bpPointsAdd )
{
    this.panel = panel;
    this.eventId = eventId;
    this.bpPointsStart = bpPointsStart;
    this.bpPointsPerLevel = bpPointsPerLevel;
    this.bpPointsAdd = bpPointsAdd;
    this.seq = new RunSequentialActions();

    var battlePointsStart = this.bpPointsStart;
    var battleLevelStart = Math.floor( battlePointsStart / this.bpPointsPerLevel );
    var battlePointsAtLevelStart = battleLevelStart * this.bpPointsPerLevel;
    var bpLevelStart = battlePointsStart - battlePointsAtLevelStart;
    var bpLevelNext = this.bpPointsPerLevel;

    panel.SetDialogVariableInt( 'current_level_bp', bpLevelStart );
    panel.SetDialogVariableInt( 'bp_to_next_level', bpLevelNext );
    panel.FindChildInLayoutFile( 'BattlePassLevelShield' ).SetEventLevel( this.eventId, battleLevelStart );

    var progressBar = panel.FindChildInLayoutFile( "BattleLevelProgress" );
    progressBar.max = bpLevelNext;
    progressBar.lowervalue = bpLevelStart;
    progressBar.uppervalue = bpLevelStart;

    var bpEarned = 0;
    var bpLevel = bpLevelStart;
    var battleLevel = battleLevelStart;

    var bpRemaining = this.bpPointsAdd;
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

        this.seq.actions.push( new AddClassAction( panel, 'LeveledUpStart' ) );

        ( function ( me, battleLevelInternal ) {
            me.seq.actions.push( new RunFunctionAction( function () {
                var levelShield = panel.FindChildInLayoutFile( 'BattlePassLevelShield' );
                levelShield.AddClass( 'LeveledUp' );
                levelShield.SetEventLevel( me.eventId, battleLevelInternal );
            } ) );
        } )( this, battleLevel );

        this.seq.actions.push( new RemoveClassAction( panel, 'LeveledUpStart' ) );
        this.seq.actions.push( new AddClassAction( panel, 'LeveledUpEnd' ) );
        this.seq.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );

        ( function ( me, battleLevelInternal ) {
            me.seq.actions.push( new RunFunctionAction( function () {
                var levelShield = panel.FindChildInLayoutFile( 'BattlePassLevelShield' );
                levelShield.RemoveClass( 'LeveledUp' );
            } ) );
        } )( this, battleLevel );
        this.seq.actions.push( new RemoveClassAction( panel, 'LeveledUpEnd' ) );

        ( function ( me, bpLevelInternal, bpLevelNextInternal ) {
            me.seq.actions.push( new RunFunctionAction( function () {
                progressBar.lowervalue = 0;
                progressBar.uppervalue = 0;
                panel.SetDialogVariableInt( 'current_level_bp', bpLevelInternal );
                panel.SetDialogVariableInt( 'bp_to_next_level', bpLevelNextInternal );
                panel.FindChildInLayoutFile( "BattleLevelProgress" ).max = bpLevelNextInternal;
                panel.FindChildInLayoutFile( "BattleLevelProgress" ).value = bpLevelInternal;
            } ) );
        } )( this, bpLevel, bpLevelNext );
    }
}

AnimateBattlePassLevelsAction.prototype = new BaseAction();
AnimateBattlePassLevelsAction.prototype.start = function () {
    return this.seq.start();
}
AnimateBattlePassLevelsAction.prototype.update = function () {
    return this.seq.update();
}
AnimateBattlePassLevelsAction.prototype.finish = function () {
    this.seq.finish();
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

		if ( this.data.dota_plus_progress !== undefined )
		{
			if ( this.data.dota_plus_progress.tips !== undefined && this.data.dota_plus_progress.tips.length != 0 )
			{
				var nShardTips = 0;
				for ( var i = 0; i < this.data.dota_plus_progress.tips.length; ++i )
				{
					nShardTips += this.data.dota_plus_progress.tips[i].amount;
				}
				this.seq.actions.push( new AnimateShardRewardAction( panel, '#DOTA_PlusPostGame_PlayerTips', nShardTips ) );
			}

			if ( this.data.dota_plus_progress.victory_prediction_shard_reward > 0 )
			{
				this.seq.actions.push( new AnimateShardRewardAction( panel, '#DOTA_PlusPostGame_VictoryPrediction', this.data.dota_plus_progress.victory_prediction_shard_reward ) );
			}

			if ( this.data.dota_plus_progress.cavern_crawl !== undefined )
			{
				this.seq.actions.push( new AnimateShardRewardAction( panel, '#DOTA_PlusPostGame_CavernCrawlProgress', this.data.dota_plus_progress.cavern_crawl.shard_amount ) );
			}

			if ( this.data.dota_plus_progress.role_call_shard_reward > 0 )
			{
			    this.seq.actions.push( new AnimateShardRewardAction( panel, '#DOTA_PlusPostGame_RoleCallProgress', this.data.dota_plus_progress.role_call_shard_reward ) );
			}
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
    var mapVariant = this.data.cavern_crawl_progress.map_variant;
	var turboMode = this.data.cavern_crawl_progress.turbo_mode;
	var mapProgress = this.data.cavern_crawl_progress.map_progress;

	// Create the screen and do a bunch of initial setup
	var panel = StartNewScreen( 'CavernCrawlProgressScreen' );
	panel.BLoadLayoutSnippet( "CavernCrawlProgress" );

	// Setup the sequence of actions to animate the screen
	this.seq = new RunSequentialActions();
    this.eventHandler = null;

    ( function (me) 
    {
        me.seq.actions.push( new RunFunctionAction( function ()
        {
            var hHandler = (function (me2)
            {
                return function ()
                {
                    if ( !me2.disabled_update )
                    {
                        me2.disabled_update = true;
                        me2.cavern_panel.DisableUpdateDisplay(true);
                    }
                };
            }(me));

            me.eventHandler = $.RegisterForUnhandledEvent("PostGameProgressSkippingAhead", hHandler);
        }));
    })(this);

	this.seq.actions.push( new AddScreenLinkAction( panel, 'CavernsProgress', '#DOTACavernCrawl_Title_TI2020' ) );

	this.seq.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );

    var cavernCrawlPanel = panel.FindChildInLayoutFile('CavernCrawl');

	this.seq.actions.push( new AddClassAction( panel, 'ShowCavernCrawlProgress' ) );
	this.seq.actions.push( new RunFunctionAction( function ()
	{
		cavernCrawlPanel.ClearMapResults();
		if ( mapProgress )
		{
			for ( var i = 0; i < mapProgress.length; ++i )
			{
				var result = mapProgress[i]
				cavernCrawlPanel.AddMapResult( result.path_id_completed, result.room_id_claimed );
			}
		}
        cavernCrawlPanel.ShowPostGameProgress( eventID, 0, mapVariant, heroID, turboMode );
	} ) );
	this.seq.actions.push( new WaitForEventAction( cavernCrawlPanel, 'DOTACavernCrawlPostGameProgressComplete' ) );
	this.seq.actions.push( new StopSkippingAheadAction() );

	this.seq.start();

	this.cavern_panel = panel.FindChildInLayoutFile( "CavernCrawl" );
}

AnimateCavernCrawlScreenAction.prototype.update = function ()
{
	return this.seq.update();
}

AnimateCavernCrawlScreenAction.prototype.finish = function ()
{
    if ( this.eventHandler != null )
    {
        $.UnregisterForUnhandledEvent("PostGameProgressSkippingAhead", this.eventHandler);
        this.eventHandler = null;
    }

	if ( this.disabled_update )
	{
        this.cavern_panel.DisableUpdateDisplay(false);
        this.disabled_update = false;
	}
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
	panel.SetDialogVariableInt( 'wager_token_bonus_pct', wagering_data.wager_token_bonus_pct );
	panel.SetDialogVariableInt( 'wager_streak_bonus_pct', wagering_data.wager_streak_bonus_pct );

	this.total_points = wagering_data.wager_amount * wagering_data.conversion_ratio * ( 100 + wagering_data.wager_streak_bonus_pct + wagering_data.wager_token_bonus_pct ) / 100;
}

AnimateWageringSubpanelAction.prototype = new BaseAction();

AnimateWageringSubpanelAction.prototype.start = function ()
{
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowWager' ) );
	this.seq.actions.push( new AddClassAction( this.panel, 'ShowTeamWagerBonus' ) );

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
// Animates actions granted subpanel
//-----------------------------------------------------------------------------
// Action to animate a battle pass bp increase
function AnimateActionsGrantedSubpanelAction( panel, ownerPanel, actions_granted, startingPoints )
{
	this.panel = panel;
	this.ownerPanel = ownerPanel;
	this.startingPoints = startingPoints;

	panel.AddClass( 'Visible' );

	var panelXPCircle = panel.FindChildInLayoutFile( "XPCircleContainer" );
	panelXPCircle.BLoadLayoutSnippet( 'BattlePassXPCircle' );

	this.panelCount = 0;
	this.total_points = 0;

	var actionContainer = panel.FindChildInLayoutFile( "ActionContainer" );
	for ( var i = 0; i < actions_granted.length; ++i )
	{
		var actionPanel = $.CreatePanel( 'Panel', actionContainer, 'Action' + i );
		actionPanel.BLoadLayoutSnippet( 'BattlePassAction' );

		if ( actions_granted[i].action_image != null )
		{
			var imagePanel = actionPanel.FindChildInLayoutFile( "ConsumableImage" );
			imagePanel.SetImage( actions_granted[i].action_image );
		}

		actionPanel.SetDialogVariableInt( 'action_points', actions_granted[i].bp_amount );
		actionPanel.SetDialogVariableInt( 'action_quantity', actions_granted[i].quantity );

		this.panelCount = this.panelCount + 1;
		this.total_points += actions_granted[i].quantity * actions_granted[i].bp_amount
	}
}

AnimateActionsGrantedSubpanelAction.prototype = new BaseAction();

AnimateActionsGrantedSubpanelAction.prototype.start = function ()
{
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowTotalActions' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

	for ( var i = 0; i < this.panelCount; ++i )
	{
		var actionPanel = this.panel.FindChildInLayoutFile( 'Action' + i );
		this.seq.actions.push( new AddClassAction( actionPanel, 'ShowAction' ) );
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

AnimateActionsGrantedSubpanelAction.prototype.update = function ()
{
	return this.seq.update();
}

AnimateActionsGrantedSubpanelAction.prototype.finish = function ()
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

	panel.FindChildInLayoutFile( "CavernCrawlHero" ).heroid = cavern_data.hero_id;

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
// Event game bp progress
//-----------------------------------------------------------------------------
function AnimateEventGameSubpanelAction( panel, ownerPanel, event_game, startingPoints ) {
    var kWinPointsBase = 300;

    this.panel = panel;
    this.ownerPanel = ownerPanel;
    this.startingPoints = startingPoints;
    this.total_points = event_game.bp_amount;
    this.show_win = ( event_game.win_points > 0 );
    this.show_loss = ( event_game.loss_points > 0 );
    this.show_daily_bonus = ( event_game.win_points > kWinPointsBase );
    this.show_treasure = ( event_game.treasure_points > 0 );

    panel.AddClass( 'Visible' );

    if ( this.show_win )
    {
        panel.AddClass( "EventGame_HasWin" );
    }

    if ( this.show_loss )
    {
        panel.AddClass( "EventGame_HasLoss" );
    }

    if ( this.show_daily_bonus )
    {
        panel.AddClass( "EventGame_HasDailyBonus" );
    }

    if ( this.show_treasure )
    {
        panel.AddClass( "EventGame_HasTreasure" );
    }

    var panelXPCircle = panel.FindChildInLayoutFile( "XPCircleContainer" );
    panelXPCircle.BLoadLayoutSnippet( 'BattlePassXPCircle' );

    panel.SetDialogVariableInt( "win_points", event_game.win_points > kWinPointsBase ? kWinPointsBase : event_game.win_points );
    panel.SetDialogVariableInt( "bonus_points", event_game.win_points - kWinPointsBase );
	panel.SetDialogVariableInt( "loss_points",  event_game.loss_points );
    panel.SetDialogVariableInt( "treasure_points", event_game.treasure_points );

    var progressMax = event_game.weekly_cap_total;
    var progressEnd = progressMax - event_game.weekly_cap_remaining;
    var progressStart = progressEnd - event_game.bp_amount;

    panel.SetDialogVariableInt( "weekly_progress", progressEnd );
    panel.SetDialogVariableInt( "weekly_complete_limit", progressMax );

    var progressBar = panel.FindChildInLayoutFile( "EventGameWeeklyProgress" );
    progressBar.max = progressMax;
    progressBar.lowervalue = progressStart;
    progressBar.uppervalue = progressEnd;

}

AnimateEventGameSubpanelAction.prototype = new BaseAction();

AnimateEventGameSubpanelAction.prototype.start = function () {
    this.seq = new RunSequentialActions();
    this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

    if ( this.show_win )
    {
        this.seq.actions.push( new AddClassAction( this.panel, 'EventGame_ShowWin' ) );
        this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

        if ( this.show_daily_bonus )
        {
            this.seq.actions.push( new AddClassAction( this.panel, 'EventGame_ShowDailyBonus' ) );
            this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );
        }
    }

	if ( this.show_loss )
    {
        this.seq.actions.push( new AddClassAction( this.panel, 'EventGame_ShowLoss' ) );
        this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );
    }

    if ( this.show_treasure )
    {
        this.seq.actions.push( new AddClassAction( this.panel, 'EventGame_ShowTreasure' ) );
        this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );
    }

    this.seq.actions.push( new AddClassAction( this.panel, 'EventGame_ShowWeeklyProgress' ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

    var panel = this.panel;
    var ownerPanel = this.ownerPanel;
    var total_points = this.total_points;
    var startingPoints = this.startingPoints;
    this.seq.actions.push( new RunFunctionAction( function () {
        UpdateSubpanelTotalPoints( panel, ownerPanel, total_points, startingPoints, false );
    } ) );

    this.seq.start();
}
AnimateEventGameSubpanelAction.prototype.update = function () {
    return this.seq.update();
}
AnimateEventGameSubpanelAction.prototype.finish = function () {
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
	panelXPCircle.SetDialogVariableInt( 'points', 1000 ); // Not sure why this is necesssary, we used to do this?

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
// Animates Guild subpanel
//-----------------------------------------------------------------------------
// Action to animate a battle pass bp increase
function AnimateGuildSubpanelAction( panel, ownerPanel, guild_progress, startingPoints, event_id )
{
	this.panel = panel;
	this.ownerPanel = ownerPanel;
	this.startingPoints = startingPoints;
	this.total_points = 0;
	this.guild_progress = guild_progress;

	panel.AddClass( 'Visible' );

	if ( guild_progress.guild_contracts != null && guild_progress.guild_contracts.length > 0 )
	{
		var contractsList = panel.FindChildInLayoutFile( "GuildContractList" );
		for ( var i = 0; i < guild_progress.guild_contracts.length; ++i )
		{
			var guildContract = guild_progress.guild_contracts[i];

			var contractPanel = $.CreatePanel( 'Panel', contractsList, '' );
			contractPanel.BLoadLayoutSnippet( 'BattlePassGuildContract' );
			var contract = contractPanel.FindChildInLayoutFile( 'GuildContract' );
			contract.SetContract( event_id, guildContract.challenge_instance_id, guildContract.challenge_parameter, guildContract.completed );
			contractPanel.SetHasClass( "ContractCompleted", guildContract.completed );
			if (guildContract.completed )
				this.total_points += guildContract.battle_point_reward;
		}

		panel.AddClass( "HasGuildContracts" );
	}

	if ( guild_progress.guild_challenge != null )
	{
		var guildChallenge = guild_progress.guild_challenge;

		var challengeImage = panel.FindChildInLayoutFile( "GuildChallengeImage" );
		challengeImage.SetImage( guildChallenge.challenge_image );

		panel.SetDialogVariableInt( "challenge_start_value", guildChallenge.challenge_start_value );
		panel.SetDialogVariableInt( "challenge_max_value", guildChallenge.challenge_max_value );
		panel.SetDialogVariableInt( "challenge_progress", guildChallenge.challenge_progress );

		var challengeProgressBar = panel.FindChildInLayoutFile( "GuildChallengeProgressBar" );
		challengeProgressBar.min = 0;
		challengeProgressBar.max = guildChallenge.challenge_max_value;
		challengeProgressBar.lowervalue = guildChallenge.challenge_start_value;
		challengeProgressBar.uppervalue = guildChallenge.challenge_start_value + guildChallenge.challenge_progress;

		panel.AddClass( "HasGuildChallenge" );
    }

	var panelXPCircle = panel.FindChildInLayoutFile( "XPCircleContainer" );
	panelXPCircle.BLoadLayoutSnippet( 'BattlePassXPCircle' );
}

AnimateGuildSubpanelAction.prototype = new BaseAction();

AnimateGuildSubpanelAction.prototype.start = function ()
{
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

	var contractsList = this.panel.FindChildInLayoutFile( "GuildContractList" );
	if ( contractsList.GetChildCount() > 0 )
	{
		this.seq.actions.push( new AddClassAction( this.panel, "ShowGuildContracts" ) );
		for ( var i = 0; i < contractsList.GetChildCount(); ++i )
		{
			var contractPanel = contractsList.GetChild( i );

			this.seq.actions.push( new RunFunctionAction( ( function ( contract )
			{
				return function () { contract.AddClass( "ShowGuildContract" ) };
			} )( contractPanel ) ) );
			this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );
        }
	}

	if ( this.guild_progress.guild_challenge != null )
	{
		this.seq.actions.push( new AddClassAction( this.panel, 'ShowGuildChallenge' ) );
		this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );
    }

	if ( this.total_points != 0 )
	{
		this.seq.actions.push( new AddClassAction( this.panel, 'ShowCompleted' ) );
		this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );
	}

	var panel = this.panel;
	var ownerPanel = this.ownerPanel;
	var total_points = this.total_points;
	var displayOnly = ( this.total_points == 0 );
	var startingPoints = this.startingPoints;

	this.seq.actions.push( new RunFunctionAction( function ()
	{
		UpdateSubpanelTotalPoints( panel, ownerPanel, total_points, startingPoints, displayOnly );
	} ) );

	this.seq.start();
}
AnimateGuildSubpanelAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateGuildSubpanelAction.prototype.finish = function ()
{
	this.seq.finish();
}


//-----------------------------------------------------------------------------
// Main entry point for MVP Voting
//-----------------------------------------------------------------------------

function AnimateMVPVotingScreenAction( data )
{
    this.data = data;
}

AnimateMVPVotingScreenAction.prototype = new BaseAction();

AnimateMVPVotingScreenAction.prototype.start = function ()
{
    // Create the screen and do a bunch of initial setup
    var panel = StartNewScreen( 'MVPVotingProgressScreen' );
    panel.BLoadLayoutSnippet( "MVPVotingProgress" );
    var mvpVotePanel = panel.FindChildInLayoutFile( 'PostGameMVPVote' );
    mvpVotePanel.SetMatchID( this.data.mvp_voting_progress.match_id );
    var heroContainer = mvpVotePanel.FindChildInLayoutFile( 'HeroContainer' );
    for ( var i = 0; i < this.data.mvp_voting_progress.match_players.length; ++i )
    {
        var match_player = this.data.mvp_voting_progress.match_players[i];
        var player_slot = match_player.player_slot;
		var player_hero_id = match_player.hero_id;
        var heroInfoPanel = mvpVotePanel.AddHeroPanel( match_player.account_id, match_player.vote_count );
		
        heroInfoPanel.SetDialogVariable( "hero_name_mvp", $.Localize( '#' + match_player.hero_name ) );
        heroInfoPanel.SetDialogVariable( "player_name_mvp", match_player.player_name );
        heroInfoPanel.SetDialogVariableInt( "mvp_kills", match_player.kills );
        heroInfoPanel.SetDialogVariableInt( "mvp_assists", match_player.assists );
        heroInfoPanel.SetDialogVariableInt( "mvp_deaths", match_player.deaths );
		heroInfoPanel.SetDialogVariableInt( "vote_count", match_player.vote_count );
		
        var voteClickArea = heroInfoPanel.FindChildInLayoutFile( 'VoteAreaPanel' );
		var j = i + 1;
		if ( typeof player_slot !== 'undefined' )
        {
			
            // Use this normally when viewing the details
            mvpVotePanel.SetPortraitUnitToPlayerHero( player_slot, player_hero_id, "background_hero_" + j );
			( function ( panel, account_id )
			{
				voteClickArea.SetPanelEvent( 'onactivate', function ()
				{
					$.DispatchEvent( 'PostGameMVPSubmitVote', voteClickArea, account_id );
				});
			})( voteClickArea, match_player.account_id )
        }
        else
        {
            // Use this for testing when we don't actually have match data
            mvpVotePanel.SetPortraitUnitToPlayerHero( i, player_hero_id, "background_hero_" + j );
			( function ( panel, account_id, player_index )
			{
				voteClickArea.SetPanelEvent( 'onactivate', function ()
				{
					$.DispatchEvent( 'PostGameMVPSubmitVoteTest', voteClickArea, player_index + 1 );
				});
			})( voteClickArea, match_player.account_id, i )
        }

        if( match_player.owns_event == 0 )
        {
            heroInfoPanel.AddClass( "NoCurrentBattlepass" );
        }
        else
        {
            var eventShieldPanel = heroInfoPanel.FindChildInLayoutFile( 'BPLevel' );
            eventShieldPanel.SetEventPoints(match_player.event_id, match_player.event_points);
        }
        
    }
    // Setup the sequence of actions to animate the screen
    this.seq = new RunSequentialActions();
    this.seq.actions.push( new AddClassAction( mvpVotePanel, 'ShowScreen'));
    this.seq.actions.push( new AddScreenLinkAction( panel, 'MVPProgress', '#DOTAMVPVote_TitleLink' ) );
    this.seq.actions.push( new ActionWithTimeout( new WaitForClassAction( mvpVotePanel, 'HasVotedForMVP' ), 25.0 ) );
    this.seq.actions.push( new StopSkippingAheadAction() );
	this.seq.actions.push( new ActionWithTimeout( new WaitForClassAction( mvpVotePanel, 'DidNotVoteForMVP' ), 1.8 ) );
    this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );

    this.seq.start();
}
AnimateMVPVotingScreenAction.prototype.update = function ()
{
    return this.seq.update();
}
AnimateMVPVotingScreenAction.prototype.finish = function ()
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
	var panelCount = 0;
	var kMaxPanels = 6;

	if ( this.data.battle_pass_progress.event_game != null )
	{
	    var eventPanel = panel.FindChildInLayoutFile( "BattlePassEventGameProgress" );
	    var subpanelAction = new AnimateEventGameSubpanelAction( eventPanel, panel, this.data.battle_pass_progress.event_game, startingPointsToAdd );
	    startingPointsToAdd += subpanelAction.total_points;
	    subPanelActions.actions.push( subpanelAction );
	    if ( ++panelCount > kMaxPanels )
	        eventPanel.RemoveClass( 'Visible' );
	}

	if ( this.data.battle_pass_progress.cavern_crawl != null )
	{
	    var cavernPanel = panel.FindChildInLayoutFile( "BattlePassCavernCrawlProgress" );
	    var subpanelAction = new AnimateCavernCrawlSubpanelAction( cavernPanel, panel, this.data.battle_pass_progress.cavern_crawl, startingPointsToAdd );
	    startingPointsToAdd += subpanelAction.total_points;
	    subPanelActions.actions.push( subpanelAction );
	    if ( ++panelCount > kMaxPanels )
	        cavernPanel.RemoveClass( 'Visible' );
	}

	if ( this.data.battle_pass_progress.wagering != null )
	{
		var wagerPanel = panel.FindChildInLayoutFile( "BattlePassWagerProgress" );
		var subpanelAction = new AnimateWageringSubpanelAction( wagerPanel, panel, this.data.battle_pass_progress.wagering, startingPointsToAdd );
		startingPointsToAdd += subpanelAction.total_points;
		subPanelActions.actions.push( subpanelAction );
		if ( ++panelCount > kMaxPanels )
		    wagerPanel.RemoveClass( 'Visible' );
    }

	if ( this.data.battle_pass_progress.tips != null && this.data.battle_pass_progress.tips.length != 0 )
	{
		var tipPanel = panel.FindChildInLayoutFile( "BattlePassTipsProgress" );
		var subpanelAction = new AnimateTippingSubpanelAction( tipPanel, panel, this.data.battle_pass_progress.tips, startingPointsToAdd );
		startingPointsToAdd += subpanelAction.total_points;
		subPanelActions.actions.push( subpanelAction );
		if ( ++panelCount > kMaxPanels )
		    tipPanel.RemoveClass( 'Visible' );
    }

	if ( this.data.battle_pass_progress.actions_granted != null && this.data.battle_pass_progress.actions_granted.length != 0 )
	{
		var actionPanel = panel.FindChildInLayoutFile( "BattlePassActionsGrantedProgress" );
		var subpanelAction = new AnimateActionsGrantedSubpanelAction( actionPanel, panel, this.data.battle_pass_progress.actions_granted, startingPointsToAdd );
		startingPointsToAdd += subpanelAction.total_points;
		subPanelActions.actions.push( subpanelAction );
		if ( ++panelCount > kMaxPanels )
		    actionPanel.RemoveClass( 'Visible' );
    }

	if ( this.data.battle_pass_progress.daily_challenge != null )
	{
		var dailyPanel = panel.FindChildInLayoutFile( "BattlePassDailyChallengeProgress" );
		var subpanelAction = new AnimateDailyChallengeSubpanelAction( dailyPanel, panel, this.data.battle_pass_progress.daily_challenge, startingPointsToAdd );
		startingPointsToAdd += subpanelAction.total_points;
		subPanelActions.actions.push( subpanelAction );
		if ( ++panelCount > kMaxPanels )
		    dailyPanel.RemoveClass( 'Visible' );
    }

	if ( this.data.battle_pass_progress.weekly_challenge_1 != null )
	{
		var weeklyPanel = panel.FindChildInLayoutFile( "BattlePassWeeklyChallengeProgress" );
		var subpanelAction = new AnimateWeeklyChallengeSubpanelAction( weeklyPanel, panel, this.data.battle_pass_progress.weekly_challenge_1, startingPointsToAdd );
		startingPointsToAdd += subpanelAction.total_points;
		subPanelActions.actions.push( subpanelAction );
		if ( ++panelCount > kMaxPanels )
		    weeklyPanel.RemoveClass( 'Visible' );
	}

	if ( this.data.battle_pass_progress.guild_progress != null )
	{
		var guildPanel = panel.FindChildInLayoutFile( "BattlePassGuildProgress" );
		var subpanelAction = new AnimateGuildSubpanelAction( guildPanel, panel, this.data.battle_pass_progress.guild_progress, startingPointsToAdd, this.data.battle_pass_progress.battle_points_event_id );
		startingPointsToAdd += subpanelAction.total_points;
		subPanelActions.actions.push( subpanelAction );
		if ( ++panelCount > kMaxPanels )
			guildPanel.RemoveClass( 'Visible' );
    }

	this.seq.actions.push( subPanelActions );

	this.seq.actions.push( new AnimateBattlePassLevelsAction( panel,
        this.data.battle_pass_progress.battle_points_event_id,
        this.data.battle_pass_progress.battle_points_start,
        this.data.battle_pass_progress.battle_points_per_level,
        startingPointsToAdd ) );

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


// Wraith King Arcana

function AnimateWraithKingArcanaScreenAction( data )
{
	this.data = data;
}

AnimateWraithKingArcanaScreenAction.prototype = new BaseAction();

AnimateWraithKingArcanaScreenAction.prototype.start = function ()
{
	var heroID = this.data.hero_id;

	// Create the screen and do a bunch of initial setup
	var panel = StartNewScreen( 'WraithKingArcanaProgressScreen' );
    panel.BLoadLayoutSnippet( "WraithKingArcanaProgress" );

    panel.RemoveClass('ShowProgress');
    panel.AddClass('ShowScreen');

    var wraithKingPanel = panel.FindChildInLayoutFile('WraithKingArcanaProgress');
    var heroesKilled = this.data.wraith_king_arcana_progress.heroes_killed;
    var previousHeroesKilledMask = this.data.wraith_king_arcana_progress.previous_heroes_killed_mask;
    wraithKingPanel.Reset();
    wraithKingPanel.RemoveClass('ShowProgressSection');

	// Setup the sequence of actions to animate the screen
	this.seq = new RunSequentialActions();
    this.seq.actions.push(new SkippableAction(new WaitAction(0.1)));	
    this.seq.actions.push(new SkippableAction( new WaitForClassAction( wraithKingPanel, 'BackgroundImageLoaded') ) );
    this.seq.actions.push(new SkippableAction(new WaitAction(0.2)));
    this.seq.actions.push(new AddClassAction(panel, 'ShowProgress'));
    this.seq.actions.push(new SkippableAction(new WaitAction(0.2)));	    
    this.seq.actions.push(new RunFunctionAction(function ()
    {
        wraithKingPanel.ClearPreviousHeroKilledMask();
        for (var i = 0; i < previousHeroesKilledMask.length; ++i)
        {
            wraithKingPanel.AppendPreviousHeroKilledMask(previousHeroesKilledMask[i]);
        }
        wraithKingPanel.ShowPostGameProgress();
    }));
    this.seq.actions.push(new RunFunctionAction(function () { $.DispatchEvent('PlaySoundEffect', 'wraith_king_arcana_postgame_stinger'); }))
    this.seq.actions.push(new AddScreenLinkAction(panel, 'WraithKingArcanaProgress', '#DOTA_PostGame_WraithKingArcanaProgress' ) );
    this.seq.actions.push(new SkippableAction(new WaitAction(1.0)));
    this.seq.actions.push(new RunFunctionAction(function () { $.DispatchEvent('PlaySoundEffect', 'wraith_king_arcana_postgame_vo'); }))
    this.seq.actions.push(new SkippableAction(new AddClassAction(panel, 'HasHeroFocus')));

    for (var i = 0; i < heroesKilled.length; ++i)
    {
        ( function (me, heroIdKilled)
        {
            if (heroesKilled.length > 1) {
                me.seq.actions.push(new AddClassAction(wraithKingPanel, 'ShowProgressSection'));
            }

            wraithKingPanel.SetHasClass('MultipleHeroesKilled', heroesKilled.length > 1);

            me.seq.actions.push(new SkippableAction(new RunFunctionAction(function () {
                wraithKingPanel.SetDialogVariableInt('killed_hero_id', heroIdKilled);
                wraithKingPanel.CenterOnHero(heroIdKilled);
            })));
            me.seq.actions.push(new SkippableAction(new WaitAction(1.3)));
            me.seq.actions.push(new SkippableAction(new RunFunctionAction(function () {
                $.DispatchEvent('PlaySoundEffect', 'wraith_king_arcana_postgame_sfx');
            })));
            me.seq.actions.push(new RunFunctionAction(function () {
                wraithKingPanel.FillInHero(heroIdKilled);
            }));
            me.seq.actions.push(new SkippableAction(new WaitAction(1.0)));

        })(this, heroesKilled[i]);
    }

    this.seq.actions.push( new AddClassAction(panel, 'ShowFinalDetails'));
    this.seq.actions.push(new SkippableAction(new WaitForClassAction(wraithKingPanel, 'OnReadyToContinue')));
	this.seq.actions.push( new StopSkippingAheadAction() );
	this.seq.actions.push( new SkippableAction( new WaitAction( 1.5 ) ) );
	this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

	this.seq.start();
}
AnimateWraithKingArcanaScreenAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateWraithKingArcanaScreenAction.prototype.finish = function ()
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
// Gauntlet Progress screen
//
// ----------------------------------------------------------------------------
function AnimateGauntletProgressScreenAction( data, gauntlet )
{
    this.data = data;
    this.gauntlet = gauntlet;
}

AnimateGauntletProgressScreenAction.prototype = new BaseAction();

AnimateGauntletProgressScreenAction.prototype.start = function ()
{
    // n.b. these are before this update
    var nWins = this.gauntlet.wins;
    var nLosses = this.gauntlet.losses;
    var bWin = !!this.gauntlet.win_game;
    var nTier = this.gauntlet.tier;
    var nTierBPAward = this.gauntlet.bp_award;
    var nGoldAward = this.gauntlet.gold_award;
    var nShardAward = this.gauntlet.shard_award;

    var bFinished = ( bWin && nWins >= 2 ) || ( !bWin && nLosses >= 1 );
    
    var nBPAwarded = 0;
    if ( bFinished && bWin )
    {
        nBPAwarded = nTierBPAward;
    }

    var panel = StartNewScreen( 'GauntletProgressScreen' );
    panel.BLoadLayoutSnippet( "GauntletProgress" );

    panel.SetDialogVariableInt( 'total_points_gained', 0 );
    panel.SetDialogVariableInt( 'gauntlet_gold', 0 );
    panel.SetDialogVariableInt( 'gauntlet_shards', 0 );
    panel.SetDialogVariable( 'gauntlet_tier_name', $.Localize( '#DOTA_GauntletTierName_' + nTier ) );

    // Set initial state
    for ( var i = 0; i < nWins; ++i )
    {
        var pipPanel = panel.FindChildInLayoutFile( 'GauntletWin' + i );
        if ( pipPanel == null )
            break;

        pipPanel.AddClass( 'PipActive' );
    }

    for ( var i = 0; i < nLosses; ++i )
    {
        var pipPanel = panel.FindChildInLayoutFile( 'GauntletLose' + i );
        if ( pipPanel == null )
            break;

        pipPanel.AddClass( 'PipActive' );
    }

    // Only show additional points if we won the whole gauntlet
    if ( nBPAwarded == 0 )
    {
        panel.AddClass( 'HideAdditionalBattlePoints' );
    }

    const ANIMATE_PIP_WIN_X = 841;
    const ANIMATE_PIP_WIN_Y = 624;
    const ANIMATE_PIP_WIN_OFFSET = 64;
    const ANIMATE_PIP_LOSE_X = 1070;
    const ANIMATE_PIP_LOSE_Y = 624;
    const ANIMATE_PIP_LOSE_OFFSET = 64;

    var newPipPanel = panel.FindChildInLayoutFile( 'GauntletAnimatePip' );
    var resultPipPanel = null;
    if( newPipPanel )
    {
        if ( bWin )
        {
            newPipPanel.AddClass( 'GauntletWin' );
            newPipPanel.SetPositionInPixels( ANIMATE_PIP_WIN_X + ANIMATE_PIP_WIN_OFFSET * nWins, ANIMATE_PIP_WIN_Y, 0 );
            resultPipPanel = panel.FindChildInLayoutFile( 'GauntletWin' + nWins );
        }
        else
        {
            newPipPanel.AddClass( 'GauntletLose' );
            newPipPanel.SetPositionInPixels( ANIMATE_PIP_LOSE_X + ANIMATE_PIP_LOSE_OFFSET * nLosses, ANIMATE_PIP_LOSE_Y, 0 );
            resultPipPanel = panel.FindChildInLayoutFile( 'GauntletLose' + nLosses );
        }
    }

    // animation begins 

    this.seq = new RunSequentialActions();
    this.seq.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
    this.seq.actions.push( new AddScreenLinkAction( panel, 'GauntletProgress', '#DOTA_GauntletPostGame_Tooltip' ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

    // gauntlet-specific stuff starts here

    if ( newPipPanel != null )
    {
        this.seq.actions.push( new AddClassAction( newPipPanel, 'Animate' ) );
        this.seq.actions.push( new AddClassAction( panel, 'GauntletScreenShake' ) );

        // wait for anim to complete, then remove anim classes and replace with active pip directly
        this.seq.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );
        this.seq.actions.push( new OptionalSkippableAction( new PlaySoundAction( bWin ? 'UI.Gauntlet.WinStamp' : 'UI.Gauntlet.LoseStamp' ) ) );

        if ( resultPipPanel != null )
        {
            this.seq.actions.push( new AddClassAction( resultPipPanel, 'PipActive' ) );
        }

        this.seq.actions.push( new SkippableAction( new WaitAction( 0.7 ) ) );

        this.seq.actions.push( new RemoveClassAction( newPipPanel, 'Animate' ) );
        this.seq.actions.push( new RemoveClassAction( panel, 'GauntletScreenShake' ) );
    }

    var resultClass = 'GauntletShowInProgress';
    if ( bFinished )
    {
        if ( bWin )
        {
            resultClass = 'GauntletShowWin';
            if( nTier < 10 )
            {
                resultClass = 'GauntletShowPromote';
                panel.SetDialogVariable( 'promote_tier_name', $.Localize( '#DOTA_GauntletTierName_' + (nTier+1) ) );
            }
        }
        else
        {
            resultClass = 'GauntletShowLose';
        }
    }

    this.seq.actions.push( new AddClassAction( panel, resultClass ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
    if ( bFinished && bWin )
        this.seq.actions.push( new OptionalSkippableAction( new PlaySoundAction( 'UI.Gauntlet.Award' ) ) );

    if ( bFinished && bWin && nGoldAward > 0 )
    {
        this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
        var par = new RunParallelActions();
        var duration = GetXPIncreaseAnimationDuration( nGoldAward );
        par.actions.push( new AnimateDialogVariableIntAction( panel, 'gauntlet_gold', 0, nGoldAward, duration ) );
        par.actions.push( new PlaySoundAction( "Plus.shards_tally", duration ) );
        this.seq.actions.push( new SkippableAction( par ) );
    }

    if ( bFinished && bWin && nShardAward > 0 )
    {
        this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
        var par = new RunParallelActions();
        var duration = GetXPIncreaseAnimationDuration( nShardAward );
        par.actions.push( new AnimateDialogVariableIntAction( panel, 'gauntlet_shards', 0, nShardAward, duration ) );
        par.actions.push( new PlaySoundAction( "Plus.shards_tally" ) );
        this.seq.actions.push( new SkippableAction( par ) );
    }

    if ( nBPAwarded > 0 )
    {
        this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

        this.seq.actions.push( new RunFunctionAction( function () {
            panel.SetDialogVariableInt( 'total_points_gained', nBPAwarded );
        } ) );

        var par = new RunParallelActions();
        par.actions.push( new AnimateDialogVariableIntAction( panel, 'total_points_gained', 0, nBPAwarded, 1 ) );
        par.actions.push( new AnimateBattlePassLevelsAction( panel,
            this.gauntlet.battle_points_event_id,
            this.gauntlet.battle_points_start,
            this.gauntlet.battle_points_per_level,
            nBPAwarded ) );
        this.seq.actions.push( new SkippableAction( par ) );
    }
    else
    {
        // Need to create this to initialize state even when no BP awarded
        this.seq.actions.push( new AnimateBattlePassLevelsAction( panel,
            this.gauntlet.battle_points_event_id,
            this.gauntlet.battle_points_start,
            this.gauntlet.battle_points_per_level,
            nBPAwarded ) );
    }

    // end of gauntlet-specific stuff

    this.seq.actions.push( new StopSkippingAheadAction() );
    this.seq.actions.push( new SkippableAction( new WaitAction( 1.5 ) ) );
    this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

    // animation done, start it
    this.seq.start();
}

AnimateGauntletProgressScreenAction.prototype.update = function () {
    return this.seq.update();
}
AnimateGauntletProgressScreenAction.prototype.finish = function () {
    this.seq.finish();
}


// ----------------------------------------------------------------------------
//
// Coach Rating Screen
//
// ----------------------------------------------------------------------------

function WaitForRatingStateChange( panel )
{
	this.panel = panel;
}
WaitForRatingStateChange.prototype = new BaseAction();
WaitForRatingStateChange.prototype.update = function ()
{
	var goodRatingButton = this.panel.FindChildInLayoutFile( 'GoodRatingButton' );
	if ( goodRatingButton.BHasClass( 'Selected' ) )
		return false;

	var badRatingButton = this.panel.FindChildInLayoutFile( 'BadRatingButton' );
	if ( badRatingButton.BHasClass( 'Selected' ) )
		return false;

	var abusiveRatingButton = this.panel.FindChildInLayoutFile( 'AbusiveRatingButton' );
	if ( abusiveRatingButton.BHasClass( 'Selected' ) )
		return false;

	return true;
}

function WaitForAbusiveRatingPopupAction()
{
	this.popupActive = false;
}
WaitForAbusiveRatingPopupAction.prototype = new BaseAction();
WaitForAbusiveRatingPopupAction.prototype.update = function ()
{
	return this.popupActive;
}

function AnimateCoachRatingScreenAction( data, coach_data )
{
	this.data = data;
	this.coach_data = coach_data;
}

function WaitForSurveyStateChange( panel )
{
	this.panel = panel;
}
WaitForSurveyStateChange.prototype = new BaseAction();
WaitForSurveyStateChange.prototype.update = function ()
{
	var goodRatingContainer = this.panel.FindChildInLayoutFile( 'GoodRatingContainer' );
	if ( !goodRatingContainer.enabled )
		return false;

	var badRatingContainer = this.panel.FindChildInLayoutFile( 'BadRatingContainer' );
	if ( !badRatingContainer.enabled)
		return false;

	var skipButton = this.panel.FindChildInLayoutFile( 'SkipButton' );
	if ( skipButton.BHasClass( 'Selected' ) )
		return false;

	return true;
}

AnimateCoachRatingScreenAction.prototype = new BaseAction();

AnimateCoachRatingScreenAction.prototype.start = function ()
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

	var SubmitRating = function ( strRating, strReason )
	{
		if ( action_data.match_id == '0')
			return;

		$.DispatchEvent( 'DOTASubmitCoachRating', action_data.match_id, rating_data.coach_account_id, strRating, strReason );

		// Once a rating has been changed, disable all the other UI
		goodRatingButton.enabled = false;
		badRatingButton.enabled = false;
		abusiveRatingButton.enabled = false;
	};

	$.RegisterEventHandler( 'Activated', goodRatingButton, function ()
	{
		goodRatingButton.AddClass( 'Selected' );
		SubmitRating( 'k_ECoachTeammateRating_Positive', '' );
	});
	$.RegisterEventHandler( 'Activated', badRatingButton, function ()
	{
		badRatingButton.AddClass( 'Selected' );
		SubmitRating( 'k_ECoachTeammateRating_Negative', '' );
	});

	var waitForAbusiveRatingPopupAction = new WaitForAbusiveRatingPopupAction();
	$.RegisterEventHandler( 'Activated', abusiveRatingButton, function ()
	{
		waitForAbusiveRatingPopupAction.popupActive = true;
		$.DispatchEvent( 'PostGameProgressConfirmAbusiveCoachRating', panel );
	});
	$.RegisterEventHandler( 'PostGameProgressConfirmAbusiveCoachRatingFinished', panel, function ( bSubmit, strReason )
	{
		if ( bSubmit )   
		{   
			abusiveRatingButton.AddClass( 'Selected' );
			SubmitRating( 'k_ECoachTeammateRating_Abusive', strReason );
		}
		waitForAbusiveRatingPopupAction.popupActive = false;
	});

	// Setup the sequence of actions to animate the screen
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
	this.seq.actions.push( new AddScreenLinkAction( panel, 'CoachRatingProgress', '#DOTA_CoachRatingPostGame_CoachRating', function ()
	{
		panel.AddClass( 'RatingScreenForceVisible' );
	}));
	this.seq.actions.push( new WaitAction( 0.5 ) );
	this.seq.actions.push( new AddClassAction( panel, 'RatingScreenVisible' ) );

	var countdownActions = new RunParallelActions();
	countdownActions.actions.push( new AnimateDialogVariableIntAction( panel, 'countdown_seconds', flCountdownDuration, 0, flCountdownDuration ) );
	countdownActions.actions.push( new AnimateProgressBarAction( countdownProgressBar, flCountdownDuration, 0, flCountdownDuration ) );

	var durationAction = new RunUntilSingleActionFinishedAction();
	durationAction.actions.push( countdownActions );
	durationAction.actions.push( new WaitForRatingStateChange( panel ) );
	durationAction.actions.push( new WaitForClassAction( panel, 'CountdownFinished' ) );
	this.seq.actions.push( durationAction );

	this.seq.actions.push( new AddClassAction( panel, 'CountdownFinished' ) );
	this.seq.actions.push( waitForAbusiveRatingPopupAction );

	this.seq.actions.push( new WaitAction( 0.5 ) );
	this.seq.actions.push( new RemoveClassAction( panel, 'RatingScreenVisible' ) );
	this.seq.actions.push( new WaitAction( 0.5 ) );

	this.seq.start();
}
AnimateCoachRatingScreenAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateCoachRatingScreenAction.prototype.finish = function ()
{
	this.seq.finish();
}




// ----------------------------------------------------------------------------
//
// Player Match Survey Screen
//
// ----------------------------------------------------------------------------
function AnimatePlayerMatchSurveyScreenAction( data )
{
	this.data = data;
}

AnimatePlayerMatchSurveyScreenAction.prototype = new BaseAction();

AnimatePlayerMatchSurveyScreenAction.prototype.start = function ()
{
	var data = this.data;

	// Create the screen and do a bunch of initial setup
	var panel = StartNewScreen( 'PlayerMatchSurveyScreen' );
	panel.BLoadLayoutSnippet( "PlayerMatchSurvey" );

	var goodRatingContainer = panel.FindChildInLayoutFile( 'GoodRatingContainer' );
	var badRatingContainer = panel.FindChildInLayoutFile( 'BadRatingContainer' );
	var skipButton = panel.FindChildInLayoutFile( 'SkipButton' );

	var SubmitRating = function ( nRating, nFlags )
	{
		if( !data.match_id || data.match_id == '0' )
		{
			data.match_id = 0;
		}
		$.DispatchEvent( 'DOTAMatchSubmitPlayerMatchSurvey', data.match_id, nRating, nFlags );

		// Once a rating has been changed, disable all the other UI
		goodRatingContainer.enabled = false;
		badRatingContainer.enabled = false;
		
		$.GetContextPanel().PlayUISoundScript( "ui_goto_player_page" );	
	};

	for ( var i = 1; i < goodRatingContainer.GetChildCount() ; ++i )
	{
		var goodRatingButton = goodRatingContainer.GetChild( i );
		var nRating = goodRatingButton.GetAttributeInt("rating_flag", 0);

		var reg = function( goodRatingButton, nRating )
		{
			$.RegisterEventHandler('Activated', goodRatingButton, function ( )
			{
				goodRatingButton.AddClass( 'Selected' );
				SubmitRating( 1, nRating );
			});
		};
		reg( goodRatingButton, nRating );
	}

	for ( var i = 1; i < badRatingContainer.GetChildCount() ; ++i )
	{
		var badRatingButton = badRatingContainer.GetChild( i );
		var nRating = badRatingButton.GetAttributeInt("rating_flag", 0);
		var reg = function( badRatingButton, nRating )
		{
			$.RegisterEventHandler('Activated', badRatingButton, function ( )
			{
				badRatingButton.AddClass( 'Selected' );
				SubmitRating( -1, nRating );
			});
		};
		reg( badRatingButton, nRating );
	}

	// scramble the buttons to avoid bias
	for ( var k = 0 ; k < 5 ; ++ k)
	{
		for ( var i = 1; i < goodRatingContainer.GetChildCount() ; ++i )
		{
			var randint = Math.floor( (goodRatingContainer.GetChildCount()-1)*Math.random() ) + 1; 
			var button = goodRatingContainer.GetChild( i );
			goodRatingContainer.MoveChildAfter( button, goodRatingContainer.GetChild(randint) );
		}
		for ( var i = 1; i < badRatingContainer.GetChildCount() ; ++i )
		{
			var randint = Math.floor( (badRatingContainer.GetChildCount()-1)*Math.random() ) + 1; 
			var button = badRatingContainer.GetChild( i );
			badRatingContainer.MoveChildAfter( button, badRatingContainer.GetChild(randint) );
		}
	}


	$.RegisterEventHandler('Activated', skipButton, function ()
	{
		skipButton.AddClass( 'Selected' );
		panel.AddClass("Skipped")
		SubmitRating( 0, 0 );
	});

	// Setup the sequence of actions to animate the screen
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
	this.seq.actions.push( new AddScreenLinkAction( panel, 'PlayerMatchSurveyProgress', '#DOTA_PlayerMatchSurveyPostGame_PlayerMatchSurvey', function ()
	{
		panel.AddClass( 'RatingScreenForceVisible' );
	}));
	this.seq.actions.push( new WaitAction( 0.25 ) );
	this.seq.actions.push( new AddClassAction( panel, 'RatingScreenVisible' ) );

	var durationAction = new RunUntilSingleActionFinishedAction();
	durationAction.actions.push( new WaitForSurveyStateChange( panel ) );
	this.seq.actions.push( durationAction );

	this.seq.actions.push( new AddClassAction( panel, 'HideSkipButton' ) );
	this.seq.actions.push( new WaitAction( 0.5 ) );
	
	this.seq.actions.push( new PlaySoundAction( "ui_hero_select_slide_late" ) );
	this.seq.actions.push( new AddClassAction( panel, 'SubmitFeedbackVisible' ) );

	this.seq.actions.push( new WaitAction( 1.25 ) );
	this.seq.actions.push( new RemoveClassAction( panel, 'RatingScreenVisible' ) );
	this.seq.actions.push( new WaitAction( 0.5 ) );

	this.seq.start();
}

AnimatePlayerMatchSurveyScreenAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimatePlayerMatchSurveyScreenAction.prototype.finish = function ()
{
	this.seq.finish();
}

// MVP v2

function AnimateMVP2ScreenAction( data )
{
	this.data = data;
}

AnimateMVP2ScreenAction.prototype = new BaseAction();

AnimateMVP2ScreenAction.prototype.start = function ()
{
	// Create the screen and do a bunch of initial setup
	var mvp2ScreenPanel = StartNewScreen( 'MVP2Screen' );
	mvp2ScreenPanel.BLoadLayoutSnippet("MVP2Screen");

	var mapContainer = mvp2ScreenPanel.FindChildInLayoutFile("MVPMapContainer");

	var mvpDetails = this.data.mvp2.mvps[0];
	var bDireWon = mvpDetails.was_dire;

	if ( bDireWon )
	{
		mapContainer.BLoadLayoutSnippet("MVP2MapDire");
	}
	else
	{
		mapContainer.BLoadLayoutSnippet("MVP2MapRadiant");
	}

	//// Helper functions/containers for sequence actions
	
	var mvp2Data = this.data.mvp2;

	var flMaxCountUpDuration = 0.75;
	var flMinCountUpDuration = 0.25;
	var flCountUpDuration = Math.random() * (flMaxCountUpDuration - flMinCountUpDuration) + flMinCountUpDuration;

    //helper for accolades
	var addAccolade = function (nAccoladeIndex, accoladeObject, accoladeContainer, wasDire)
	{
        var accolade_panel = $.CreatePanel( 'Panel', accoladeContainer, '' );
		accolade_panel.BLoadLayoutSnippet('MVPAccolade');

		var accolade_id = accoladeObject.type;
		var accolade_value = accoladeObject.detail_value;
		var accolade = g_MVP_Accolade_TypeMap[accolade_id];

		if (accolade == undefined)
		{
			$.Msg('No accolade of type ' + accolade_id.toString());
		}

		var gradient_colour = wasDire ? "red" : "green";
		accolade_panel.FindChildInLayoutFile('gradient').AddClass('mvp_gradient_' + gradient_colour);
		accolade_panel.FindChildInLayoutFile('icon').AddClass('mvp_icon_' + accolade.icon);
		accolade_panel.FindChildInLayoutFile('icon').style.backgroundImage = 'url("' + accolade.icon + '")';
		accolade_panel.FindChildInLayoutFile('icon').style.backgroundRepeat = 'no-repeat';
		accolade_panel.FindChildInLayoutFile('icon').style.backgroundPosition = 'center';
		accolade_panel.FindChildInLayoutFile('icon').style.backgroundSize = 'cover';

		if (accolade.ability_name != undefined)
		{
			accolade_panel.FindChildInLayoutFile('ability_icon').abilityname = accolade.ability_name
		}
		else
		{
			accolade_panel.FindChildInLayoutFile('ability_icon').style.opacity = 0;
        }

		accolade_panel.SetDialogVariable('title', $.Localize(accolade.title_loc_token));
		accolade_panel.AddClass('Accolade' + nAccoladeIndex);

		var details_panel = accolade_panel.FindChildInLayoutFile('details');

		if (accolade.detail_loc_token != undefined)
		{
			details_panel.SetLocString(accolade.detail_loc_token);
			accolade_panel.SetDialogVariableInt('detailvalue', accolade_value);
		}
		else
		{
			$.Msg('accolade ' + accolade_id.toString() + ' missing detail_loc_token');
		}

        return accolade_panel;
	};

    var map = mapContainer.FindChildInLayoutFile('MVPMap');

	////
	// Setup the sequence of actions to animate the screen
	this.seq = new RunSequentialActions();

    this.seq.actions.push( new AddScreenLinkAction( mvp2ScreenPanel, 'MVPProgress', '#DOTAMVP2_TitleLink' ) );
	this.seq.actions.push( new AddClassAction( mvp2ScreenPanel, 'ShowScreen' ) );

	// Wait for map to load
    this.seq.actions.push( new WaitForClassAction( map, 'SceneLoaded' ) );

	var mvpPanel = null;
    var mvpAccolades = [];
	// Load up the MVP and HMs
	this.seq.actions.push( new RunFunctionAction( function () 
        {
            // Setup mvp model
            {
                mvpPanel = mvp2ScreenPanel.FindChildInLayoutFile('MVPDetails');
				mvpPanel.SetDialogVariableInt("user_account_id", mvpDetails.accountid );
				mvpPanel.SetDialogVariable("hero", $.Localize('#' + mvpDetails.heroname));

				if (mvpDetails.guildid != undefined)
				{
					mvpPanel.FindChildInLayoutFile('GuildImage').guildid = mvpDetails.guildid;
					mvpPanel.SetDialogVariableInt("user_guild_id", mvpDetails.guildid);
				}
				else
				{
					var guildPanel = mvpPanel.FindChildInLayoutFile('GuildDetails');
					if (guildPanel != undefined)
					{
						guildPanel.RemoveAndDeleteChildren();
					}
				}

                if (mvpDetails.overrideheroid == undefined)
                {
                    $.GetContextPanel().SpawnHeroInScenePanelByPlayerSlot( map, mvpDetails.slot, "featured_hero" );
                }
                else
                {
					var econId = mvpDetails.overrideeconid;
					if(econId == undefined)
                    {
						econId = -1;
                    }

                    $.GetContextPanel().SpawnHeroInScenePanelByHeroId( map, mvpDetails.overrideheroid, "featured_hero", econId );
                }

                //setup accolades for mvp
                var accoladeContainer = mvpPanel.FindChildInLayoutFile('Accolades');

                for (var i in mvpDetails.accolades)
                {
                    var accolade = mvpDetails.accolades[i];

                    var accoladePanel = addAccolade(i, accolade, accoladeContainer, mvpDetails.was_dire);

                    if (accoladePanel != null)
                    {
                        mvpAccolades.push(accoladePanel);
                    }
                }
			}

            // Setup honorable mentions
            var honorableMentions = mvp2ScreenPanel.FindChildInLayoutFile('HonorableMentions');

            for (var i = 1; i < 3 && i < mvp2Data.mvps.length; ++i)
            {
                var honorableMentionData = mvp2Data.mvps[i];
                var honorableMentionPanel = $.CreatePanel('Panel', honorableMentions, '');
                honorableMentionPanel.BLoadLayoutSnippet('HonorableMention');
                honorableMentionPanel.SetDialogVariableInt("user_account_id", honorableMentionData.accountid);
                if (honorableMentionData.guildid != undefined)
                {
                    honorableMentionPanel.SetDialogVariableInt("user_guild_id", honorableMentionData.guildid);
                }
                else
                {
                    var guildPanel = honorableMentionPanel.FindChildInLayoutFile('GuildName');
                    if (guildPanel != null)
                    {
                        guildPanel.style.opacity = 0;
                    }
                }
                honorableMentionPanel.AddClass(honorableMentionData.was_dire ? "dire" : "radiant");
                honorableMentionPanel.AddClass('HonorableMention' + i.toString());
                var model = honorableMentionPanel.FindChildInLayoutFile('HonorableMentionModel');

                honorableMentionPanel.AddClass(honorableMentionData.heroname);
                if (honorableMentionData.overrideheroid == undefined)
                {
                    $.GetContextPanel().SetScenePanelToPlayerHero(model, honorableMentionData.slot);
                }
                else
                {
                    $.GetContextPanel().SetScenePanelToLocalHero(model, honorableMentionData.overrideheroid);
                }

                var accoladeContainer = honorableMentionPanel.FindChildInLayoutFile('Accolades');
                for (var j in honorableMentionData.accolades)
                {
                    var accolade = honorableMentionData.accolades[j];

                    if (accolade != undefined)
                    {
                        addAccolade(j, accolade, accoladeContainer, honorableMentionData.was_dire);
                        break; // THERE CAN BE ONLY ONE
                    }
                    else
                    {
                        $.Msg("Unable to find accolade of type " + j.toString());
                    }
                }
            }
        } )
	);


	this.seq.actions.push( new SkippableAction( new WaitAction(0.5)));
	var honorableMentionsContainer = mvp2ScreenPanel.FindChildInLayoutFile('HonorableMentionsContainer');
	this.seq.actions.push( new AddClassAction( honorableMentionsContainer, 'HMAnimateIn') );
	this.seq.actions.push( new SkippableAction( new WaitAction(0.5)));
	this.seq.actions.push( new RunFunctionAction( function () 
    {
		mvpPanel.AddClass('MVPDetailsAnimateIn');
        for (var i in mvpAccolades)
        {
            mvpAccolades[i].AddClass( 'MVPAnimateIn' );
        }
    }));

	// first mvp accolade
	this.seq.actions.push( new WaitAction(0.2) );
	this.seq.actions.push( new PlaySoundAction("ui_hero_select_slide_late"));

	// second mvp accolade
	this.seq.actions.push( new WaitAction(0.4) );
	this.seq.actions.push( new PlaySoundAction("ui_hero_select_slide_late"));

	// third mvp accolade
	this.seq.actions.push( new WaitAction(0.5) );
	this.seq.actions.push( new PlaySoundAction("ui_hero_select_slide_late"));

	this.seq.actions.push( new SkippableAction( new WaitAction(0.5)));

	this.seq.actions.push( new StopSkippingAheadAction() );
	this.seq.actions.push( new SkippableAction( new WaitAction( 1.5 ) ) );
	this.seq.actions.push( new SwitchClassAction( mvp2ScreenPanel, 'current_screen', '' ) );
	this.seq.actions.push( new SkippableAction( new WaitAction( 10.0 ) ) );

	this.seq.start();
}
AnimateMVP2ScreenAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateMVP2ScreenAction.prototype.finish = function ()
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

		    cavern_crawl:
			{
			    event_id: 29,
			    hero_id: 87,
			    hero_name: 'disruptor',
			    shard_amount: 150,
			},

		    victory_prediction_shard_reward: 20,

		    role_call_shard_reward: 25
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
			battle_points_event_id: 29,
			battle_points_start: 74850,
			battle_points_per_level: 1000,

			wagering:
			{
				wager_amount: 2,
				conversion_ratio: 100,
				wager_token_bonus_pct: 25,
				wager_streak_bonus_pct: 10,
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
				hero_id: 87,
				bp_amount: 375,
			},
			
			event_game:
            {
                bp_amount: 1200,
                win_points: 1000,
                loss_points: 0,
                treasure_points: 200,
                weekly_cap_remaining: 1000,
                weekly_cap_total: 3000,
            },

			//daily_challenge:
			//{
			//	hero_id: 87,
			//	bp_amount: 125,
			//},

			//weekly_challenge_1:
			//{
			//	challenge_description: 'Kill 50 enemy heroes',
			//	progress: 20000,
			//	end_progress: 30000,
			//	complete_limit: 50000,
			//	bp_amount: 250,
			//},

			actions_granted:
			[
				{
					action_id: 704,
					quantity: 2,
					bp_amount: 100,
					action_image: "file://{images}/spellicons/consumables/seasonal_ti9_shovel.png"
				},
				{
					action_id: 705,
					quantity: 1,
					bp_amount: 5000,
					action_image: "file://{images}/spellicons/consumables/seasonal_ti9_shovel.png"
				},
			],

			guild_progress:
			{
				guild_contracts:
				[
					{
						challenge_instance_id: 2152900061,
						challenge_parameter: 23,
						completed: true,
						battle_point_reward: 150,
						guild_point_reward: 150
					},
					{
						challenge_instance_id: 2506886225,
						challenge_parameter: 22000,
						completed: true,
						battle_point_reward: 150,
						guild_point_reward: 150
					},
					{
						challenge_instance_id: 2506886225,
						challenge_parameter: 22000,
						completed: false,
						battle_point_reward: 150,
						guild_point_reward: 150
					},
				],

				guild_challenge:
				{
					challenge_image: "file://{images}/guilds/challenges/guild_networth_by_time.png",
					challenge_start_value: 1234,
					challenge_max_value: 4500,
					challenge_progress: 400
                }
            }
		}
	};

	TestProgressAnimation( data );
}

function TestAnimateGauntletProgress()
{
    var data =
    {
        hero_id: 87,
        gauntlet_progress:
        {
            tier: 4,
            wins: 2,
            losses: 0,
            win_game: 1,
            bp_award: 1500,
            gold_award: 200,
            shard_award: 1000,

            battle_points_event_id: 29,
            battle_points_start: 73295,
            battle_points_per_level: 1000
        }
    }

    TestProgressAnimation( data );
}


function TestAnimateCavernCrawl()
{
	var data =
	{
		hero_id: 92,
		cavern_crawl_progress:
		{
            event_id: 29,
            map_variant: 0,
            turbo_mode: false,
            map_progress:
                [
                    {
                        path_id_completed: 0,
                        room_id_claimed: 1,
                    }
                ],
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


function TestAnimateWraithKingArcanaProgress()
{
	var data =
	{
		hero_id: 42,

		wraith_king_arcana_progress:
        {
            previous_heroes_killed_mask:
                [  
                    1, 2, 3, 4, 5
                ],
            heroes_killed:
                [
                    6, 82
                ]
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

function TestMVPVotingProgress() {
 
    var data =
	{
	    mvp_voting_progress:
        {
            match_id: '123456789',
            match_players:
            [
                {
                    hero_id: 34,
                    hero_name: 'Tinker',
                    event_points: 0,
                    event_id: 25,
                    vote_count: 2,
                    player_name: 'Eric L',
                    account_id: 1,
                    kills: 7,
                    assists: 3,
                    deaths: 6,
					owns_event: 0
                },
                {
                    hero_id: 29,
                    hero_name: 'Tidehunter',
                    event_points: 8000,
                    event_id: 25,
                    vote_count: 0,
                    player_name: 'Brett S',
                    account_id: 2,
                    kills: 14,
                    assists: 3,
                    deaths: 8,
					owns_event: 1
                },
                {
                    hero_id: 86,
                    hero_name: 'Rubick',
                    event_points: 12000,
                    event_id: 25,
                    vote_count: 3,
                    player_name: 'Kyle',
                    account_id: 3,
                    kills: 2,
                    assists: 12,
                    deaths: 0,
					owns_event: 1
                },
                {
                    hero_id: 102,
                    hero_name: 'Abaddon',
                    event_points: 5000,
                    event_id: 25,
                    vote_count: 0,
                    player_name: 'Sergei',
                    account_id: 4,
                    kills: 21,
                    assists: 12,
                    deaths: 14,
					owns_event: 1
                },
                {
                    hero_id: 59,
                    hero_name: 'Huskar',
                    event_points: 200,
                    event_id: 25,
                    vote_count: 5,
                    player_name: 'Alex',
                    account_id: 5,
                    kills: 8,
                    assists: 4,
                    deaths: 2,
					owns_event: 0
                }
            ]
        }
	};

    TestProgressAnimation(data);
}

// The indices need to line up with dota_gcmessages_common_match_management.proto
g_MVP_Accolade_TypeMap = {
	/* common */ 
	1:	// total kills
	{
        title_loc_token: "#DOTA_mvp2_accolade_title_total_kills",
		icon: 's2r://panorama/images/challenges/icon_challenges_kills.png',
        gradient: 'red',
        detail_loc_token: '#DOTA_mvp2_accolade_detail_total_kills',
	},
	2:	// total deaths
	{
        title_loc_token: "#DOTA_mvp2_accolade_title_total_deaths",
		icon: 's2r://panorama/images/challenges/icon_challenges_tombstone.png',
        gradient: 'red',
        detail_loc_token: '#DOTA_mvp2_accolade_detail_total_deaths',
	},
	3:	// total assists
	{
        title_loc_token: "#DOTA_mvp2_accolade_title_total_assists",
		icon: 's2r://panorama/images/challenges/icon_challenges_xassists.png',
        gradient: 'red',
        detail_loc_token: '#DOTA_mvp2_accolade_detail_total_assists',
	},
	5:	// total net_worth
	{
        title_loc_token: "#DOTA_mvp2_accolade_title_total_net_worth",
		icon: 's2r://panorama/images/challenges/icon_challenges_networth.png',
        gradient: 'red',
        detail_loc_token: '#DOTA_mvp2_accolade_detail_total_net_worth',
	},
	7:	// total support_gold_spent
	{
        title_loc_token: "#DOTA_mvp2_accolade_title_total_support_gold_spent",
		icon: 's2r://panorama/images/challenges/icon_challenges_assistgold.png',
        gradient: 'red',
        detail_loc_token: '#DOTA_mvp2_accolade_detail_total_support_gold_spent',
	},
	8:	// total wards_placed
	{
        title_loc_token: "#DOTA_mvp2_accolade_title_total_wards_placed",
		icon: 's2r://panorama/images/challenges/icon_challenges_ward.png',
        gradient: 'red',
        detail_loc_token: '#DOTA_mvp2_accolade_detail_total_wards_placed',
	},
	9:	// total wards_spotted_for_dewarding
	{
        title_loc_token: "#DOTA_mvp2_accolade_title_total_wards_spotted_for_dewarding",
		icon: 's2r://panorama/images/challenges/icon_challenges_deward.png',
        gradient: 'red',
        detail_loc_token: '#DOTA_mvp2_accolade_detail_total_wards_spotted_for_dewarding',
	},
	10:	// total camps_stacked
	{
        title_loc_token: "#DOTA_mvp2_accolade_title_total_camps_stacked",
		icon: 's2r://panorama/images/challenges/icon_challenges_campsstacked.png',
        gradient: 'red',
        detail_loc_token: '#DOTA_mvp2_accolade_detail_total_camps_stacked',
	},
	11:	// total last_hits
	{
        title_loc_token: "#DOTA_mvp2_accolade_title_total_last_hits",
		icon: 's2r://panorama/images/challenges/icon_challenges_lasthits.png',
        gradient: 'red',
        detail_loc_token: '#DOTA_mvp2_accolade_detail_total_last_hits',
	},
	12:	// total denies
	{
        title_loc_token: "#DOTA_mvp2_accolade_title_total_denies",
		icon: 's2r://panorama/images/challenges/icon_challenges_denies.png',
        gradient: 'red',
        detail_loc_token: '#DOTA_mvp2_accolade_detail_total_denies',
	},
	15 : // kKillEaterEvent_Towers_Destroyed
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Towers_Destroyed",
		icon: 's2r://panorama/images/challenges/icon_challenges_tower.png',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEvent_Towers_Destroyed',
	},

	19 : // kKillEaterEventType_LowHealthKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_LowHealthKills",
		icon: 's2r://panorama/images/challenges/icon_challenges_neardeathkills.png',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_LowHealthKills',
	},
	28 : // kKillEaterEventType_RoshanKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_RoshanKills",
		icon: 's2r://panorama/images/challenges/icon_challenges_roshan.png',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_RoshanKills',
	},
	33 : // kKillEaterEventType_HeroesRevealedWithDust
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_HeroesRevealedWithDust",
		icon: 's2r://panorama/images/challenges/icon_challenges_totaldust.png',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_HeroesRevealedWithDust',
	},
	115 : // kKillEaterEvent_Barracks_Destroyed
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Barracks_Destroyed",
		icon: 's2r://panorama/images/challenges/icon_challenges_barracksdestroyed.png',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEvent_Barracks_Destroyed',
	},
	161 : // kKillEaterEventType_ThreeManMeks
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_ThreeManMeks",
		icon: 's2r://panorama/images/challenges/icon_challenges_mekthree.png',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_ThreeManMeks',
	},
	164 : // kKillEaterEventType_ThreeHeroVeils
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_ThreeHeroVeils",
		icon: 's2r://panorama/images/challenges/icon_challenges_veilthree.png',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_ThreeHeroVeils',
	},
	224 : // kKillEaterEventType_VeilsLeadingToKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_VeilsLeadingToKills",
		icon: 's2r://panorama/images/challenges/icon_challenges_veil.png',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_VeilsLeadingToKills',
	},
	225 : // kKillEaterEventType_DustLeadingToKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_DustLeadingToKills",
		icon: 's2r://panorama/images/challenges/icon_challenges_killsdust.png',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_DustLeadingToKills',
	},
	274: // Custom_KillStreak
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_Custom_KillStreak",
		icon: 's2r://panorama/images/challenges/icon_challenges_xkills.png',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_Custom_KillStreak',
    },

	// Hero specific
	16 : // kKillEaterEventType_Invoker_SunstrikeKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Invoker_SunstrikeKills",
		ability_name: 'invoker_sun_strike',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Invoker_SunstrikeKills',
	},
	17 : // kKillEaterEventType_Axe_Culls
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Axe_Culls",
		ability_name: 'axe_culling_blade',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Axe_Culls',
	},
	18 : // kKillEaterEventType_Axe_BattleHungerKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Axe_BattleHungerKills",
		ability_name: 'axe_battle_hunger',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Axe_BattleHungerKills',
	},
	20 : // kKillEaterEventType_Invoker_TornadoKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Invoker_TornadoKills",
		ability_name: 'invoker_tornado',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Invoker_TornadoKills',
	},
	21 : // kKillEaterEventType_Sven_DoubleStuns
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Sven_DoubleStuns",
		ability_name: 'sven_storm_bolt',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Sven_DoubleStuns',
	},
	22 : // kKillEaterEventType_Sven_WarcryAssists
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Sven_WarcryAssists",
		ability_name: 'sven_warcry',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Sven_WarcryAssists',
	},
	23 : // kKillEaterEventType_Sven_CleaveDoubleKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Sven_CleaveDoubleKills",
		ability_name: 'sven_great_cleave',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Sven_CleaveDoubleKills',
	},
	/*
	24 : // kKillEaterEventType_Sven_TeleportInterrupts
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Sven_TeleportInterrupts",
		ability_name: 'sven_',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Sven_TeleportInterrupts',
	},*/
	25 : // kKillEaterEventType_Faceless_MultiChrono
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Faceless_MultiChrono",
		ability_name: 'faceless_void_chronosphere',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Faceless_MultiChrono',
	},
	26 : // kKillEaterEventType_Faceless_ChronoKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Faceless_ChronoKills",
		ability_name: 'faceless_void_chronosphere',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Faceless_ChronoKills',
	},
	27 : // kKillEaterEventType_Ursa_MultiShocks
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Ursa_MultiShocks",
		ability_name: 'ursa_earthshock',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Ursa_MultiShocks',
	},
	29 : // kKillEaterEventType_Lion_FingerKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Lion_FingerKills",
		ability_name: 'lion_finger_of_death',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Lion_FingerKills',
	},
	32 : // kKillEaterEventType_Riki_SmokedHeroKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Riki_SmokedHeroKills",
		ability_name: 'riki_smoke_screen',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Riki_SmokedHeroKills',
	},
	34 : // kKillEaterEventType_SkeletonKing_ReincarnationKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_SkeletonKing_ReincarnationKills",
		ability_name: 'skeleton_king_reincarnation',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_SkeletonKing_ReincarnationKills',
	},
	35 : // kKillEaterEventType_Skywrath_FlareKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Skywrath_FlareKills",
		ability_name: 'skywrath_mage_mystic_flare',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Skywrath_FlareKills',
	},
	36 : // kKillEaterEventType_Leshrac_SplitEarthStuns
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Leshrac_SplitEarthStuns",
		ability_name: 'leshrac_split_earth',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Leshrac_SplitEarthStuns',
	},
	37 : // kKillEaterEventType_Mirana_MaxStunArrows
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Mirana_MaxStunArrows",
		ability_name: 'mirana_arrow',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Mirana_MaxStunArrows',
	},
	38 : // kKillEaterEventType_PhantomAssassin_CoupdeGraceCrits
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_PhantomAssassin_CoupdeGraceCrits",
		ability_name: 'phantom_assassin_coup_de_grace',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_PhantomAssassin_CoupdeGraceCrits',
	},
	39 : // kKillEaterEventType_PhantomAssassin_DaggerCrits
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_PhantomAssassin_DaggerCrits",
		ability_name: 'phantom_assassin_stifling_dagger',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_PhantomAssassin_DaggerCrits',
	},
	40 : // kKillEaterEventType_Meepo_Earthbinds
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Meepo_Earthbinds",
		ability_name: 'meepo_earthbind',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Meepo_Earthbinds',
	},
	41 : // kKillEaterEventType_Bloodseeker_RuptureKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Bloodseeker_RuptureKills",
		ability_name: 'bloodseeker_rupture',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Bloodseeker_RuptureKills',
	},
	42 : // kKillEaterEventType_Slark_LeashedEnemies
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Slark_LeashedEnemies",
		ability_name: 'slark_pounce',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Slark_LeashedEnemies',
	},
	43 : // kKillEaterEventType_Disruptor_FountainGlimpses
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Disruptor_FountainGlimpses",
		ability_name: 'disruptor_glimpse',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Disruptor_FountainGlimpses',
	},
	44 : // kKillEaterEventType_Rubick_SpellsStolen
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Rubick_SpellsStolen",
		ability_name: 'rubick_spell_steal',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Rubick_SpellsStolen',
	},
	45 : // kKillEaterEventType_Rubick_UltimatesStolen
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Rubick_UltimatesStolen",
		ability_name: 'rubick_spell_steal',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Rubick_UltimatesStolen',
	},
	46 : // kKillEaterEventType_Doom_EnemiesDoomed
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Doom_EnemiesDoomed",
		ability_name: 'doom_bringer_doom',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Doom_EnemiesDoomed',
	},
	47 : // kKillEaterEventType_Omniknight_Purifications
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Omniknight_Purifications",
		ability_name: 'omniknight_purification',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Omniknight_Purifications',
	},
	48 : // kKillEaterEventType_Omniknight_AlliesRepelled
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Omniknight_AlliesRepelled",
		ability_name: 'omniknight_repel',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Omniknight_AlliesRepelled',
	},
	49 : // kKillEaterEventType_Omniknight_EnemiesRepelled
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Omniknight_EnemiesRepelled",
		ability_name: 'omniknight_repel',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Omniknight_EnemiesRepelled',
	},
	50 : // kKillEaterEventType_Warlock_FiveHeroFatalBonds
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Warlock_FiveHeroFatalBonds",
		ability_name: 'warlock_fatal_bonds',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Warlock_FiveHeroFatalBonds',
	},
	51 : // kKillEaterEventType_CrystalMaiden_FrostbittenEnemies
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_CrystalMaiden_FrostbittenEnemies",
		ability_name: 'crystal_maiden_frostbite',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_CrystalMaiden_FrostbittenEnemies',
	},
	52 : // kKillEaterEventType_CrystalMaiden_CrystalNovas
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_CrystalMaiden_CrystalNovas",
		ability_name: 'crystal_maiden_crystal_nova',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_CrystalMaiden_CrystalNovas',
	},
	53 : // kKillEaterEventType_Kunkka_DoubleHeroTorrents
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Kunkka_DoubleHeroTorrents",
		ability_name: 'kunkka_torrent',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Kunkka_DoubleHeroTorrents',
	},
	54 : // kKillEaterEventType_Kunkka_TripleHeroGhostShips
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Kunkka_TripleHeroGhostShips",
		ability_name: 'kunkka_ghostship',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Kunkka_TripleHeroGhostShips',
	},
	55 : // kKillEaterEventType_NagaSiren_EnemiesEnsnared
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_NagaSiren_EnemiesEnsnared",
		ability_name: 'naga_siren_ensnare',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_NagaSiren_EnemiesEnsnared',
	},
	56 : // kKillEaterEventType_NagaSiren_TripleHeroRipTides
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_NagaSiren_TripleHeroRipTides",
		ability_name: 'naga_siren_rip_tide',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_NagaSiren_TripleHeroRipTides',
	},
	57 : // kKillEaterEventType_Lycan_KillsDuringShapeshift
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Lycan_KillsDuringShapeshift",
		ability_name: 'lycan_shapeshift',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Lycan_KillsDuringShapeshift',
	},
	58 : // kKillEaterEventType_Pudge_DismemberKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Pudge_DismemberKills",
		ability_name: 'pudge_dismember',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Pudge_DismemberKills',
	},
	59 : // kKillEaterEventType_Pudge_EnemyHeroesHooked
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Pudge_EnemyHeroesHooked",
		ability_name: 'pudge_meat_hook',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Pudge_EnemyHeroesHooked',
	},
	60 : // kKillEaterEventType_Pudge_HookKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Pudge_HookKills",
		ability_name: 'pudge_meat_hook',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Pudge_HookKills',
	},
	61 : // kKillEaterEventType_Pudge_UnseenEnemyHeroesHooked
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Pudge_UnseenEnemyHeroesHooked",
		ability_name: 'pudge_meat_hook',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Pudge_UnseenEnemyHeroesHooked',
	},
	62 : // kKillEaterEventType_DrowRanger_EnemiesSilenced
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_DrowRanger_EnemiesSilenced",
		ability_name: 'drow_ranger_silence',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_DrowRanger_EnemiesSilenced',
	},
	63 : // kKillEaterEventType_DrowRanger_MultiHeroSilences
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_DrowRanger_MultiHeroSilences",
		ability_name: 'drow_ranger_silence',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_DrowRanger_MultiHeroSilences',
	},
	64 : // kKillEaterEventType_DrowRanger_SilencedKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_DrowRanger_SilencedKills",
		ability_name: 'drow_ranger_silence',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_DrowRanger_SilencedKills',
	},
	65 : // kKillEaterEventType_DrowRanger_FrostArrowKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_DrowRanger_FrostArrowKills",
		ability_name: 'drow_ranger_frost_arrows',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_DrowRanger_FrostArrowKills',
	},
	66 : // kKillEaterEventType_DragonKnight_KillsInDragonForm
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_DragonKnight_KillsInDragonForm",
		ability_name: 'dragon_knight_elder_dragon_form',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_DragonKnight_KillsInDragonForm',
	},
	67 : // kKillEaterEventType_DragonKnight_BreatheFireKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_DragonKnight_BreatheFireKills",
		ability_name: 'dragon_knight_breathe_fire',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_DragonKnight_BreatheFireKills',
	},
	68 : // kKillEaterEventType_DragonKnight_SplashKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_DragonKnight_SplashKills",
		ability_name: 'dragon_knight_elder_dragon_form',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_DragonKnight_SplashKills',
	},
	69 : // kKillEaterEventType_WitchDoctor_CaskStuns
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_WitchDoctor_CaskStuns",
		ability_name: 'witch_doctor_paralyzing_cask',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_WitchDoctor_CaskStuns',
	},
	70 : // kKillEaterEventType_WitchDoctor_MaledictKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_WitchDoctor_MaledictKills",
		ability_name: 'witch_doctor_maledict',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_WitchDoctor_MaledictKills',
	},
	71 : // kKillEaterEventType_WitchDoctor_MultiHeroMaledicts
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_WitchDoctor_MultiHeroMaledicts",
		ability_name: 'witch_doctor_maledict',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_WitchDoctor_MultiHeroMaledicts',
	},
	72 : // kKillEaterEventType_WitchDoctor_DeathWardKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_WitchDoctor_DeathWardKills",
		ability_name: 'witch_doctor_death_ward',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_WitchDoctor_DeathWardKills',
	},
	73 : // kKillEaterEventType_Disruptor_ThunderStrikeKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Disruptor_ThunderStrikeKills",
		ability_name: 'disruptor_thunder_strike',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Disruptor_ThunderStrikeKills',
	},
	74 : // kKillEaterEventType_Disruptor_HeroesGlimpsed
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Disruptor_HeroesGlimpsed",
		ability_name: 'disruptor_glimpse',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Disruptor_HeroesGlimpsed',
	},
	75 : // kKillEaterEventType_CrystalMaiden_FreezingFieldKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_CrystalMaiden_FreezingFieldKills",
		ability_name: 'crystal_maiden_freezing_field',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_CrystalMaiden_FreezingFieldKills',
	},

	77 : // kKillEaterEventType_Medusa_EnemiesPetrified
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Medusa_EnemiesPetrified",
		ability_name: 'medusa_stone_gaze',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Medusa_EnemiesPetrified',
	},
	78 : // kKillEaterEventType_Warlock_FatalBondsKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Warlock_FatalBondsKills",
		ability_name: 'warlock_fatal_bonds',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Warlock_FatalBondsKills',
	},
	79 : // kKillEaterEventType_Warlock_GolemKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Warlock_GolemKills",
		ability_name: 'warlock_golem_flaming_fists',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Warlock_GolemKills',
	},
	80 : // kKillEaterEventType_Tusk_WalrusPunches
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Tusk_WalrusPunches",
		ability_name: 'tusk_walrus_punch',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Tusk_WalrusPunches',
	},
	81 : // kKillEaterEventType_Tusk_SnowballStuns
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Tusk_SnowballStuns",
		ability_name: 'tusk_snowball',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Tusk_SnowballStuns',
	},
	82 : // kKillEaterEventType_Earthshaker_FissureStuns
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Earthshaker_FissureStuns",
		ability_name: 'earthshaker_fissure',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Earthshaker_FissureStuns',
	},
	83 : // kKillEaterEventType_Earthshaker_3HeroEchoslams
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Earthshaker_3HeroEchoslams",
		ability_name: 'earthshaker_echo_slam',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_Earthshaker_3HeroEchoslams',
	},
	84 : // kKillEaterEventType_SandKing_BurrowstrikeStuns
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_SandKing_BurrowstrikeStuns",
		ability_name: 'sandking_burrowstrike',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_SandKing_BurrowstrikeStuns',
	},
	85 : // kKillEaterEventType_SandKing_EpicenterKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_SandKing_EpicenterKills",
		ability_name: 'sandking_epicenter',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_SandKing_EpicenterKills',
	},
	86 : // kKillEaterEventType_SkywrathMage_AncientSealKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_SkywrathMage_AncientSealKills",
		ability_name: 'skywrath_mage_ancient_seal',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_SkywrathMage_AncientSealKills',
	},
	87 : // kKillEaterEventType_SkywrathMage_ConcussiveShotKills
	{
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_SkywrathMage_ConcussiveShotKills",
		ability_name: 'skywrath_mage_concussive_shot',
		gradient: 'red',
		detail_loc_token: '#DOTA_mvp2_accolade_detail_kKillEaterEventType_SkywrathMage_ConcussiveShotKills',
	},
	88:
	{	// kKillEaterEventType_Luna_LucentBeamKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Luna_LucentBeamKills",
		ability_name: "luna_lucent_beam",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Luna_LucentBeamKills",
	},
	89:
	{	// kKillEaterEventType_Luna_EclipseKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Luna_EclipseKills",
		ability_name: "luna_eclipse",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Luna_EclipseKills",
	},
	90:
	{	// kKillEaterEventType_KeeperOfTheLight_IlluminateKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_KeeperOfTheLight_IlluminateKills",
		ability_name: "keeper_of_the_light_illuminate",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_KeeperOfTheLight_IlluminateKills",
	},
	91:
	{	// kKillEaterEventType_KeeperOfTheLight_ManaLeakStuns
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_KeeperOfTheLight_ManaLeakStuns",
		ability_name: "keeper_of_the_light_mana_leak",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_KeeperOfTheLight_ManaLeakStuns",
	},
	92:
	{	// kKillEaterEventType_KeeperOfTheLight_TeammatesRecalled
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_KeeperOfTheLight_TeammatesRecalled",
		ability_name: "keeper_of_the_light_blinding_light",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_KeeperOfTheLight_TeammatesRecalled",
	},
	93:
	{	// kKillEaterEventType_LegionCommander_DuelsWon
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_LegionCommander_DuelsWon",
		ability_name: "legion_commander_duel",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_LegionCommander_DuelsWon",
	},
	94:
	{	// kKillEaterEventType_Beastmaster_RoarKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Beastmaster_RoarKills",
		ability_name: "beastmaster_primal_roar",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Beastmaster_RoarKills",
	},
	95:
	{	// kKillEaterEventType_Beastmaster_RoarMultiKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Beastmaster_RoarMultiKills",
		ability_name: "beastmaster_primal_roar",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Beastmaster_RoarMultiKills",
	},
	96:
	{	// kKillEaterEventType_Windrunner_FocusFireBuildings
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Windrunner_FocusFireBuildings",
		ability_name: "windrunner_focusfire",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Windrunner_FocusFireBuildings",
	},
	97:
	{	// kKillEaterEventType_Windrunner_PowershotKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Windrunner_PowershotKills",
		ability_name: "windrunner_powershot",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Windrunner_PowershotKills",
	},
	98:
	{	// kKillEaterEventType_PhantomAssassin_DaggerLastHits
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_PhantomAssassin_DaggerLastHits",
		ability_name: "phantom_assassin_stifling_dagger",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_PhantomAssassin_DaggerLastHits",
	},
	99:
	{	// kKillEaterEventType_PhantomAssassin_PhantomStrikeKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_PhantomAssassin_PhantomStrikeKills",
		ability_name: "phantom_assassin_phantom_strike",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_PhantomAssassin_PhantomStrikeKills",
	},
	100:
	{	// kKillEaterEventType_DeathProphet_CryptSwarmKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_DeathProphet_CryptSwarmKills",
		ability_name: "death_prophet_carrion_swarm",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_DeathProphet_CryptSwarmKills",
	},
	101:
	{	// kKillEaterEventType_DeathProphet_ExorcismBuildingKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_DeathProphet_ExorcismBuildingKills",
		ability_name: "death_prophet_exorcism",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_DeathProphet_ExorcismBuildingKills",
	},
	102:
	{	// kKillEaterEventType_DeathProphet_ExorcismSpiritsSummoned
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_DeathProphet_ExorcismSpiritsSummoned",
		ability_name: "death_prophet_exorcism",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_DeathProphet_ExorcismSpiritsSummoned",
	},
	103:
	{	// kKillEaterEventType_DeathProphet_MultiHeroSilences
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_DeathProphet_MultiHeroSilences",
		ability_name: "death_prophet_carrion_swarm",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_DeathProphet_MultiHeroSilences",
	},
	104:
	{	// kKillEaterEventType_Abaddon_MistCoilKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Abaddon_MistCoilKills",
		ability_name: "abaddon_death_coil",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Abaddon_MistCoilKills",
	},
	105:
	{	// kKillEaterEventType_Abaddon_MistCoilHealed
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Abaddon_MistCoilHealed",
		ability_name: "abaddon_death_coil",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Abaddon_MistCoilHealed",
	},
	106:
	{	// kKillEaterEventType_Abaddon_AphoticShieldKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Abaddon_AphoticShieldKills",
		ability_name: "abaddon_aphotic_shield",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Abaddon_AphoticShieldKills",
	},
	107:
	{	// kKillEaterEventType_Lich_ChainFrostTripleKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Lich_ChainFrostTripleKills",
		ability_name: "lich_chain_frost",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Lich_ChainFrostTripleKills",
	},
	108:
	{	// kKillEaterEventType_Lich_ChainFrostMultiKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Lich_ChainFrostMultiKills",
		ability_name: "lich_chain_frost",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Lich_ChainFrostMultiKills",
	},
	109:
	{	// kKillEaterEventType_Lich_ChainFrostBounces
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Lich_ChainFrostBounces",
		ability_name: "lich_chain_frost",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Lich_ChainFrostBounces",
	},
	110:
	{	// kKillEaterEventType_Ursa_EnragedKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Ursa_EnragedKills",
		ability_name: "enraged_wildkin_tornado",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Ursa_EnragedKills",
	},
	111:
	{	// kKillEaterEventType_Ursa_EarthshockKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Ursa_EarthshockKills",
		ability_name: "ursa_earthshock",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Ursa_EarthshockKills",
	},
	112:
	{	// kKillEaterEventType_Lina_LagunaBladeKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Lina_LagunaBladeKills",
		ability_name: "lina_laguna_blade",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Lina_LagunaBladeKills",
	},
	113:
	{	// kKillEaterEventType_Lina_DragonSlaveKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Lina_DragonSlaveKills",
		ability_name: "lina_dragon_slave",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Lina_DragonSlaveKills",
	},
	114:
	{	// kKillEaterEventType_Lina_LightStrikeArrayStuns
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Lina_LightStrikeArrayStuns",
		ability_name: "lina_light_strike_array",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Lina_LightStrikeArrayStuns",
	},
	33:
	{	// kKillEaterEventType_HeroesRevealedWithDust
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_HeroesRevealedWithDust",
		ability_name: "None",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_HeroesRevealedWithDust",
	},
	115:
	{	// kKillEaterEvent_Barracks_Destroyed
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Barracks_Destroyed",
		ability_name: "None",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Barracks_Destroyed",
	},
	116:
	{	// kKillEaterEvent_TemplarAssassin_MeldKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_TemplarAssassin_MeldKills",
		ability_name: "templar_assassin_meld",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_TemplarAssassin_MeldKills",
	},
	117:
	{	// kKillEaterEvent_TemplarAssassin_HeroesSlowed
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_TemplarAssassin_HeroesSlowed",
		ability_name: "special_bonus_unique_templar_assassin",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_TemplarAssassin_HeroesSlowed",
	},
	118:
	{	// kKillEaterEvent_Sniper_AssassinationKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Sniper_AssassinationKills",
		ability_name: "sniper_assassinate",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Sniper_AssassinationKills",
	},
	119:
	{	// kKillEaterEvent_Sniper_HeadshotStuns
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Sniper_HeadshotStuns",
		ability_name: "sniper_headshot",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Sniper_HeadshotStuns",
	},
	120:
	{	// kKillEaterEvent_EarthSpirit_SmashStuns
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_EarthSpirit_SmashStuns",
		ability_name: "earth_spirit_boulder_smash",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_EarthSpirit_SmashStuns",
	},
	121:
	{	// kKillEaterEvent_EarthSpirit_GripSilences
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_EarthSpirit_GripSilences",
		ability_name: "earth_spirit_geomagnetic_grip",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_EarthSpirit_GripSilences",
	},
	122:
	{	// kKillEaterEvent_ShadowShaman_ShackleKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_ShadowShaman_ShackleKills",
		ability_name: "shadow_shaman_shackles",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_ShadowShaman_ShackleKills",
	},
	123:
	{	// kKillEaterEvent_ShadowShaman_HexKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_ShadowShaman_HexKills",
		ability_name: "shadow_shaman_ether_shock",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_ShadowShaman_HexKills",
	},
	124:
	{	// kKillEaterEvent_Centaur_EnemiesStomped
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Centaur_EnemiesStomped",
		ability_name: "centaur_double_edge",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Centaur_EnemiesStomped",
	},
	125:
	{	// kKillEaterEvent_Centaur_DoubleEdgeKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Centaur_DoubleEdgeKills",
		ability_name: "centaur_double_edge",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Centaur_DoubleEdgeKills",
	},
	126:
	{	// kKillEaterEvent_Centaur_ReturnKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Centaur_ReturnKills",
		ability_name: "centaur_return",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Centaur_ReturnKills",
	},
	127:
	{	// kKillEaterEvent_EmberSpirit_EnemiesChained
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_EmberSpirit_EnemiesChained",
		ability_name: "ember_spirit_activate_fire_remnant",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_EmberSpirit_EnemiesChained",
	},
	128:
	{	// kKillEaterEvent_EmberSpirit_SleightOfFistMultiKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_EmberSpirit_SleightOfFistMultiKills",
		ability_name: "ember_spirit_sleight_of_fist",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_EmberSpirit_SleightOfFistMultiKills",
	},
	129:
	{	// kKillEaterEvent_Puck_OrbKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Puck_OrbKills",
		ability_name: "puck_illusory_orb",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Puck_OrbKills",
	},
	130:
	{	// kKillEaterEvent_VengefulSpirit_EnemiesStunned
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_VengefulSpirit_EnemiesStunned",
		ability_name: "special_bonus_unique_vengeful_spirit_1",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_VengefulSpirit_EnemiesStunned",
	},
	131:
	{	// kKillEaterEvent_Lifestealer_RageKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Lifestealer_RageKills",
		ability_name: "alchemist_chemical_rage",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Lifestealer_RageKills",
	},
	132:
	{	// kKillEaterEvent_Lifestealer_OpenWoundsKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Lifestealer_OpenWoundsKills",
		ability_name: "life_stealer_open_wounds",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Lifestealer_OpenWoundsKills",
	},
	133:
	{	// kKillEaterEvent_Lifestealer_InfestKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Lifestealer_InfestKills",
		ability_name: "life_stealer_infest",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Lifestealer_InfestKills",
	},
	134:
	{	// kKillEaterEvent_ElderTitan_SpiritKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_ElderTitan_SpiritKills",
		ability_name: "elder_titan_ancestral_spirit",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_ElderTitan_SpiritKills",
	},
	135:
	{	// kKillEaterEvent_ElderTitan_GoodStomps
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_ElderTitan_GoodStomps",
		ability_name: "elder_titan_ancestral_spirit",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_ElderTitan_GoodStomps",
	},
	136:
	{	// kKillEaterEvent_Clockwerk_RocketKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Clockwerk_RocketKills",
		ability_name: "gyrocopter_rocket_barrage",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Clockwerk_RocketKills",
	},
	137:
	{	// kKillEaterEvent_Clockwerk_BlindRocketKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Clockwerk_BlindRocketKills",
		ability_name: "gyrocopter_rocket_barrage",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Clockwerk_BlindRocketKills",
	},
	138:
	{	// kKillEaterEvent_StormSpirit_BallKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_StormSpirit_BallKills",
		ability_name: "storm_spirit_ball_lightning",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_StormSpirit_BallKills",
	},
	139:
	{	// kKillEaterEvent_StormSpirit_DoubleRemnantKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_StormSpirit_DoubleRemnantKills",
		ability_name: "storm_spirit_static_remnant",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_StormSpirit_DoubleRemnantKills",
	},
	140:
	{	// kKillEaterEvent_StormSpirit_VortexKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_StormSpirit_VortexKills",
		ability_name: "storm_spirit_electric_vortex",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_StormSpirit_VortexKills",
	},
	141:
	{	// kKillEaterEvent_Tinker_DoubleMissileKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Tinker_DoubleMissileKills",
		ability_name: "tinker_heat_seeking_missile",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Tinker_DoubleMissileKills",
	},
	142:
	{	// kKillEaterEvent_Tinker_LaserKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Tinker_LaserKills",
		ability_name: "tinker_laser",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Tinker_LaserKills",
	},
	143:
	{	// kKillEaterEvent_Techies_SuicideKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Techies_SuicideKills",
		ability_name: "techies_suicide",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Techies_SuicideKills",
	},
	144:
	{	// kKillEaterEvent_Techies_LandMineKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Techies_LandMineKills",
		ability_name: "techies_land_mines",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Techies_LandMineKills",
	},
	145:
	{	// kKillEaterEvent_Techies_StatisTrapStuns
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Techies_StatisTrapStuns",
		ability_name: "techies_stasis_trap",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Techies_StatisTrapStuns",
	},
	146:
	{	// kKillEaterEvent_Techies_RemoteMineKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Techies_RemoteMineKills",
		ability_name: "techies_remote_mines",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Techies_RemoteMineKills",
	},
	147:
	{	// kKillEaterEvent_ShadowFiend_TripleRazeKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_ShadowFiend_TripleRazeKills",
		ability_name: "nevermore_shadowraze1",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_ShadowFiend_TripleRazeKills",
	},
	148:
	{	// kKillEaterEvent_ShadowFiend_RequiemMultiKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_ShadowFiend_RequiemMultiKills",
		ability_name: "nevermore_requiem",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_ShadowFiend_RequiemMultiKills",
	},
	149:
	{	// kKillEaterEvent_ShadowFiend_QRazeKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_ShadowFiend_QRazeKills",
		ability_name: "nevermore_shadowraze1",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_ShadowFiend_QRazeKills",
	},
	150:
	{	// kKillEaterEvent_ShadowFiend_WRazeKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_ShadowFiend_WRazeKills",
		ability_name: "nevermore_shadowraze2",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_ShadowFiend_WRazeKills",
	},
	151:
	{	// kKillEaterEvent_ShadowFiend_ERazeKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_ShadowFiend_ERazeKills",
		ability_name: "nevermore_shadowraze3",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_ShadowFiend_ERazeKills",
	},
	152:
	{	// kKillEaterEvent_Oracle_FatesEdictKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Oracle_FatesEdictKills",
		ability_name: "oracle_fates_edict",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Oracle_FatesEdictKills",
	},
	153:
	{	// kKillEaterEvent_Oracle_FalsePromiseSaves
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Oracle_FalsePromiseSaves",
		ability_name: "oracle_false_promise",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Oracle_FalsePromiseSaves",
	},
	154:
	{	// kKillEaterEvent_Juggernaut_OmnislashKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEvent_Juggernaut_OmnislashKills",
		ability_name: "juggernaut_blade_dance",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEvent_Juggernaut_OmnislashKills",
	},
	157:
	{	// kKillEaterEventType_SkeletonKing_SkeletonHeroKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_SkeletonKing_SkeletonHeroKills",
		ability_name: "skeleton_king_hellfire_blast",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_SkeletonKing_SkeletonHeroKills",
	},
	158:
	{	// kKillEaterEventType_DarkWillow_CursedCrownTripleStuns
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_DarkWillow_CursedCrownTripleStuns",
		ability_name: "dark_willow_cursed_crown",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_DarkWillow_CursedCrownTripleStuns",
	},
	159:
	{	// kKillEaterEventType_Dazzle_ShallowGraveSaves
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Dazzle_ShallowGraveSaves",
		ability_name: "dazzle_shallow_grave",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Dazzle_ShallowGraveSaves",
	},
	160:
	{	// kKillEaterEventType_Dazzle_PoisonTouchKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Dazzle_PoisonTouchKills",
		ability_name: "dazzle_poison_touch",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Dazzle_PoisonTouchKills",
	},
	162:
	{	// kKillEaterEventType_Viper_PoisonAttackKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Viper_PoisonAttackKills",
		ability_name: "viper_poison_attack",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Viper_PoisonAttackKills",
	},
	163:
	{	// kKillEaterEventType_Viper_CorrosiveSkinKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Viper_CorrosiveSkinKills",
		ability_name: "viper_corrosive_skin",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Viper_CorrosiveSkinKills",
	},
	165:
	{	// kKillEaterEventType_Viper_KillsDuringViperStrike
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Viper_KillsDuringViperStrike",
		ability_name: "viper_viper_strike",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Viper_KillsDuringViperStrike",
	},
	167:
	{	// kKillEaterEventType_Tiny_TreeThrowKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Tiny_TreeThrowKills",
		ability_name: "tiny_toss_tree",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Tiny_TreeThrowKills",
	},
	168:
	{	// kKillEaterEventType_Riki_BackstabKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Riki_BackstabKills",
		ability_name: "riki_backstab",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Riki_BackstabKills",
	},
	169:
	{	// kKillEaterEventType_Phoenix_ThreeHeroSupernovaStuns
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Phoenix_ThreeHeroSupernovaStuns",
		ability_name: "phoenix_supernova",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Phoenix_ThreeHeroSupernovaStuns",
	},
	170:
	{	// kKillEaterEventType_Terrorblade_MetamorphosisKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Terrorblade_MetamorphosisKills",
		ability_name: "terrorblade_metamorphosis",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Terrorblade_MetamorphosisKills",
	},
	171:
	{	// kKillEaterEventType_Lion_GreatFingerKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Lion_GreatFingerKills",
		ability_name: "lion_finger_of_death",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Lion_GreatFingerKills",
	},
	172:
	{	// kKillEaterEventType_Antimage_SpellsBlockedWithAghanims
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Antimage_SpellsBlockedWithAghanims",
		ability_name: "antimage_blink",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Antimage_SpellsBlockedWithAghanims",
	},
	173:
	{	// kKillEaterEventType_Antimage_ThreeManManaVoids
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Antimage_ThreeManManaVoids",
		ability_name: "antimage_mana_break",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Antimage_ThreeManManaVoids",
	},
	174:
	{	// kKillEaterEventType_ArcWarden_TempestDoubleKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_ArcWarden_TempestDoubleKills",
		ability_name: "arc_warden_tempest_double",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_ArcWarden_TempestDoubleKills",
	},
	175:
	{	// kKillEaterEventType_ArcWarden_SparkWraithKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_ArcWarden_SparkWraithKills",
		ability_name: "arc_warden_spark_wraith",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_ArcWarden_SparkWraithKills",
	},
	176:
	{	// kKillEaterEventType_Bane_BrainSapKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Bane_BrainSapKills",
		ability_name: "bane_brain_sap",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Bane_BrainSapKills",
	},
	177:
	{	// kKillEaterEventType_Bane_FiendsGripKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Bane_FiendsGripKills",
		ability_name: "bane_fiends_grip",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Bane_FiendsGripKills",
	},
	178:
	{	// kKillEaterEventType_Batrider_TripleHeroFlamebreaks
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Batrider_TripleHeroFlamebreaks",
		ability_name: "batrider_firefly",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Batrider_TripleHeroFlamebreaks",
	},
	179:
	{	// kKillEaterEventType_Batrider_DoubleHeroLassoes
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Batrider_DoubleHeroLassoes",
		ability_name: "arc_warden_tempest_double",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Batrider_DoubleHeroLassoes",
	},
	180:
	{	// kKillEaterEventType_Brewmaster_KillsDuringPrimalSplit
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Brewmaster_KillsDuringPrimalSplit",
		ability_name: "brewmaster_primal_split",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Brewmaster_KillsDuringPrimalSplit",
	},
	181:
	{	// kKillEaterEventType_Bristleback_KillsUnderFourQuillStacks
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Bristleback_KillsUnderFourQuillStacks",
		ability_name: "bristleback_quill_spray",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Bristleback_KillsUnderFourQuillStacks",
	},
	182:
	{	// kKillEaterEventType_Bristleback_TripleHeroNasalGoo
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Bristleback_TripleHeroNasalGoo",
		ability_name: "bristleback_viscous_nasal_goo",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Bristleback_TripleHeroNasalGoo",
	},
	183:
	{	// kKillEaterEventType_Broodmother_SpiderlingHeroKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Broodmother_SpiderlingHeroKills",
		ability_name: "broodmother_spawn_spiderlings",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Broodmother_SpiderlingHeroKills",
	},
	184:
	{	// kKillEaterEventType_Broodmother_KillsInsideWeb
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Broodmother_KillsInsideWeb",
		ability_name: "broodmother_spin_web",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Broodmother_KillsInsideWeb",
	},
	185:
	{	// kKillEaterEventType_Centaur_ThreeHeroStampede
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Centaur_ThreeHeroStampede",
		ability_name: "centaur_stampede",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Centaur_ThreeHeroStampede",
	},
	186:
	{	// kKillEaterEventType_ChaosKnight_RealityRiftKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_ChaosKnight_RealityRiftKills",
		ability_name: "chaos_knight_reality_rift",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_ChaosKnight_RealityRiftKills",
	},
	187:
	{	// kKillEaterEventType_Chen_KillsWithPenitence
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Chen_KillsWithPenitence",
		ability_name: "chen_penitence",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Chen_KillsWithPenitence",
	},
	188:
	{	// kKillEaterEventType_CrystalMaiden_TwoHeroCrystalNovas
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_CrystalMaiden_TwoHeroCrystalNovas",
		ability_name: "crystal_maiden_brilliance_aura",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_CrystalMaiden_TwoHeroCrystalNovas",
	},
	189:
	{	// kKillEaterEventType_CrystalMaiden_ThreeHeroFreezingFields
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_CrystalMaiden_ThreeHeroFreezingFields",
		ability_name: "crystal_maiden_freezing_field",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_CrystalMaiden_ThreeHeroFreezingFields",
	},
	190:
	{	// kKillEaterEventType_Dazzle_ShadowWaveKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Dazzle_ShadowWaveKills",
		ability_name: "dazzle_shadow_wave",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Dazzle_ShadowWaveKills",
	},
	191:
	{	// kKillEaterEventType_DeathProphet_SiphonKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_DeathProphet_SiphonKills",
		ability_name: "death_prophet_spirit_siphon",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_DeathProphet_SiphonKills",
	},
	192:
	{	// kKillEaterEventType_DeathProphet_ExorcismKillsDuringEuls
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_DeathProphet_ExorcismKillsDuringEuls",
		ability_name: "death_prophet_exorcism",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_DeathProphet_ExorcismKillsDuringEuls",
	},
	193:
	{	// kKillEaterEventType_Disruptor_ThreeHeroKineticFieldStaticStorm
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Disruptor_ThreeHeroKineticFieldStaticStorm",
		ability_name: "disruptor_kinetic_field",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Disruptor_ThreeHeroKineticFieldStaticStorm",
	},
	194:
	{	// kKillEaterEventType_Doom_InfernalBladeBurnKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Doom_InfernalBladeBurnKills",
		ability_name: "doom_bringer_infernal_blade",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Doom_InfernalBladeBurnKills",
	},
	195:
	{	// kKillEaterEventType_DrowRanger_PrecisionAuraCreepTowerKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_DrowRanger_PrecisionAuraCreepTowerKills",
		ability_name: "drow_ranger_frost_arrows",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_DrowRanger_PrecisionAuraCreepTowerKills",
	},
	196:
	{	// kKillEaterEventType_EmberSpirit_RemnantKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_EmberSpirit_RemnantKills",
		ability_name: "ember_spirit_activate_fire_remnant",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_EmberSpirit_RemnantKills",
	},
	197:
	{	// kKillEaterEventType_EmberSpirit_SleightOfFistKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_EmberSpirit_SleightOfFistKills",
		ability_name: "ember_spirit_sleight_of_fist",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_EmberSpirit_SleightOfFistKills",
	},
	198:
	{	// kKillEaterEventType_Enigma_MidnightPulseBlackHoleCombos
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Enigma_MidnightPulseBlackHoleCombos",
		ability_name: "enigma_black_hole",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Enigma_MidnightPulseBlackHoleCombos",
	},
	199:
	{	// kKillEaterEventType_Enigma_ThreeManBlackHoles
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Enigma_ThreeManBlackHoles",
		ability_name: "enigma_black_hole",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Enigma_ThreeManBlackHoles",
	},
	200:
	{	// kKillEaterEventType_FacelessVoid_MultiHeroTimeDilation
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_FacelessVoid_MultiHeroTimeDilation",
		ability_name: "faceless_void_time_dilation",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_FacelessVoid_MultiHeroTimeDilation",
	},
	201:
	{	// kKillEaterEventType_Gyrocopter_ThreeHeroFlakCannon
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Gyrocopter_ThreeHeroFlakCannon",
		ability_name: "gyrocopter_flak_cannon",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Gyrocopter_ThreeHeroFlakCannon",
	},
	202:
	{	// kKillEaterEventType_Gyrocopter_HomingMissileKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Gyrocopter_HomingMissileKills",
		ability_name: "gyrocopter_homing_missile",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Gyrocopter_HomingMissileKills",
	},
	203:
	{	// kKillEaterEventType_Gyrocopter_RocketBarrageKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Gyrocopter_RocketBarrageKills",
		ability_name: "gyrocopter_rocket_barrage",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Gyrocopter_RocketBarrageKills",
	},
	204:
	{	// kKillEaterEventType_Huskar_KillsDuringLifeBreak
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Huskar_KillsDuringLifeBreak",
		ability_name: "huskar_life_break",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Huskar_KillsDuringLifeBreak",
	},
	205:
	{	// kKillEaterEventType_Huskar_BurningSpearKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Huskar_BurningSpearKills",
		ability_name: "huskar_burning_spear",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Huskar_BurningSpearKills",
	},
	206:
	{	// kKillEaterEventType_Invoker_MultiHeroIceWall
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Invoker_MultiHeroIceWall",
		ability_name: "invoker_ice_wall",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Invoker_MultiHeroIceWall",
	},
	207:
	{	// kKillEaterEventType_Invoker_ThreeHeroEMP
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Invoker_ThreeHeroEMP",
		ability_name: "invoker_emp",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Invoker_ThreeHeroEMP",
	},
	208:
	{	// kKillEaterEventType_Invoker_ThreeHeroDeafeningBlast
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Invoker_ThreeHeroDeafeningBlast",
		ability_name: "invoker_deafening_blast",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Invoker_ThreeHeroDeafeningBlast",
	},
	209:
	{	// kKillEaterEventType_Invoker_MultiHeroChaosMeteor
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Invoker_MultiHeroChaosMeteor",
		ability_name: "invoker_chaos_meteor",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Invoker_MultiHeroChaosMeteor",
	},
	210:
	{	// kKillEaterEventType_Jakiro_MultiHeroDualBreath
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Jakiro_MultiHeroDualBreath",
		ability_name: "jakiro_dual_breath",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Jakiro_MultiHeroDualBreath",
	},
	211:
	{	// kKillEaterEventType_Jakiro_IcePathMacropyreCombos
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Jakiro_IcePathMacropyreCombos",
		ability_name: "jakiro_ice_path",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Jakiro_IcePathMacropyreCombos",
	},
	212:
	{	// kKillEaterEventType_Leshrac_PulseNovaKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Leshrac_PulseNovaKills",
		ability_name: "leshrac_pulse_nova",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Leshrac_PulseNovaKills",
	},
	213:
	{	// kKillEaterEventType_Leshrac_ThreeHeroLightningStorm
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Leshrac_ThreeHeroLightningStorm",
		ability_name: "leshrac_lightning_storm",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Leshrac_ThreeHeroLightningStorm",
	},
	214:
	{	// kKillEaterEventType_Lion_ThreeHeroFingerOfDeath
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Lion_ThreeHeroFingerOfDeath",
		ability_name: "lion_finger_of_death",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Lion_ThreeHeroFingerOfDeath",
	},
	215:
	{	// kKillEaterEventType_Meepo_PoofKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Meepo_PoofKills",
		ability_name: "meepo_poof",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Meepo_PoofKills",
	},
	216:
	{	// kKillEaterEventType_Meepo_MultiHeroEarthbinds
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Meepo_MultiHeroEarthbinds",
		ability_name: "drow_ranger_multishot",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Meepo_MultiHeroEarthbinds",
	},
	217:
	{	// kKillEaterEventType_NightStalker_NighttimeKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_NightStalker_NighttimeKills",
		ability_name: "night_stalker_crippling_fear",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_NightStalker_NighttimeKills",
	},
	218:
	{	// kKillEaterEventType_Morphling_KillsDuringReplicate
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Morphling_KillsDuringReplicate",
		ability_name: "morphling_morph_replicate",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Morphling_KillsDuringReplicate",
	},
	219:
	{	// kKillEaterEventType_OgreMagi_FireblastKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_OgreMagi_FireblastKills",
		ability_name: "ogre_magi_fireblast",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_OgreMagi_FireblastKills",
	},
	220:
	{	// kKillEaterEventType_OgreMagi_IgniteKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_OgreMagi_IgniteKills",
		ability_name: "ogre_magi_ignite",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_OgreMagi_IgniteKills",
	},
	221:
	{	// kKillEaterEventType_DominatingKillStreaks
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_DominatingKillStreaks",
		ability_name: "None",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_DominatingKillStreaks",
	},
	223:
	{	// kKillEaterEventType_Alchemist_AghanimsGiven
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Alchemist_AghanimsGiven",
		ability_name: "alchemist_acid_spray",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Alchemist_AghanimsGiven",
	},
	226:
	{	// kKillEaterEventType_WitchDoctor_MultiHeroCaskStuns
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_WitchDoctor_MultiHeroCaskStuns",
		ability_name: "witch_doctor_paralyzing_cask",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_WitchDoctor_MultiHeroCaskStuns",
	},
	227:
	{	// kKillEaterEventType_Weaver_ShukuchiKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Weaver_ShukuchiKills",
		ability_name: "weaver_shukuchi",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Weaver_ShukuchiKills",
	},
	228:
	{	// kKillEaterEventType_Windrunner_ShackleFocusFireKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Windrunner_ShackleFocusFireKills",
		ability_name: "windrunner_focusfire",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Windrunner_ShackleFocusFireKills",
	},
	229:
	{	// kKillEaterEventType_VengefulSpirit_VengeanceAuraIllusionKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_VengefulSpirit_VengeanceAuraIllusionKills",
		ability_name: "vengefulspirit_command_aura",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_VengefulSpirit_VengeanceAuraIllusionKills",
	},
	230:
	{	// kKillEaterEventType_Tusk_WalrusPunchKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Tusk_WalrusPunchKills",
		ability_name: "tusk_walrus_punch",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Tusk_WalrusPunchKills",
	},
	231:
	{	// kKillEaterEventType_Tinker_TripleHeroLasers
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Tinker_TripleHeroLasers",
		ability_name: "special_bonus_unique_tinker",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Tinker_TripleHeroLasers",
	},
	232:
	{	// kKillEaterEventType_TemplarAssassin_MultiHeroPsiBlades
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_TemplarAssassin_MultiHeroPsiBlades",
		ability_name: "templar_assassin_psi_blades",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_TemplarAssassin_MultiHeroPsiBlades",
	},
	233:
	{	// kKillEaterEventType_Sven_KillsDuringGodsStrength
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Sven_KillsDuringGodsStrength",
		ability_name: "sven_gods_strength",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Sven_KillsDuringGodsStrength",
	},
	234:
	{	// kKillEaterEventType_Sniper_ThreeHeroShrapnels
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Sniper_ThreeHeroShrapnels",
		ability_name: "sniper_assassinate",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Sniper_ThreeHeroShrapnels",
	},
	235:
	{	// kKillEaterEventType_Slark_KillsDuringShadowDance
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Slark_KillsDuringShadowDance",
		ability_name: "slark_shadow_dance",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Slark_KillsDuringShadowDance",
	},
	236:
	{	// kKillEaterEventType_ShadowShaman_MultiHeroEtherShocks
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_ShadowShaman_MultiHeroEtherShocks",
		ability_name: "shadow_shaman_ether_shock",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_ShadowShaman_MultiHeroEtherShocks",
	},
	237:
	{	// kKillEaterEventType_ShadowShaman_SerpentWardShackleKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_ShadowShaman_SerpentWardShackleKills",
		ability_name: "shadow_shaman_mass_serpent_ward",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_ShadowShaman_SerpentWardShackleKills",
	},
	238:
	{	// kKillEaterEventType_Riki_ThreeHeroTricksOfTheTrade
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Riki_ThreeHeroTricksOfTheTrade",
		ability_name: "riki_tricks_of_the_trade",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Riki_ThreeHeroTricksOfTheTrade",
	},
	239:
	{	// kKillEaterEventType_Razor_EyeOfTheStormKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Razor_EyeOfTheStormKills",
		ability_name: "razor_eye_of_the_storm",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Razor_EyeOfTheStormKills",
	},
	240:
	{	// kKillEaterEventType_Pugna_LifeDrainKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Pugna_LifeDrainKills",
		ability_name: "pugna_life_drain",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Pugna_LifeDrainKills",
	},
	241:
	{	// kKillEaterEventType_ObsidianDestroyer_SanitysEclipseKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_ObsidianDestroyer_SanitysEclipseKills",
		ability_name: "obsidian_destroyer_sanity_eclipse",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_ObsidianDestroyer_SanitysEclipseKills",
	},
	242:
	{	// kKillEaterEventType_Oracle_MultiHeroFortunesEnd
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Oracle_MultiHeroFortunesEnd",
		ability_name: "oracle_fortunes_end",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Oracle_MultiHeroFortunesEnd",
	},
	243:
	{	// kKillEaterEventType_Omniknight_PurificationKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Omniknight_PurificationKills",
		ability_name: "omniknight_purification",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Omniknight_PurificationKills",
	},
	244:
	{	// kKillEaterEventType_NightStalker_EnemyMissesUnderCripplingFear
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_NightStalker_EnemyMissesUnderCripplingFear",
		ability_name: "night_stalker_crippling_fear",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_NightStalker_EnemyMissesUnderCripplingFear",
	},
	245:
	{	// kKillEaterEventType_Warlock_ThreeHeroFatalBonds
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Warlock_ThreeHeroFatalBonds",
		ability_name: "warlock_fatal_bonds",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Warlock_ThreeHeroFatalBonds",
	},
	246:
	{	// kKillEaterEventType_Riki_TricksOfTheTradeKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Riki_TricksOfTheTradeKills",
		ability_name: "riki_tricks_of_the_trade",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Riki_TricksOfTheTradeKills",
	},
	247:
	{	// kKillEaterEventType_Earthshaker_AftershockHits10
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Earthshaker_AftershockHits10",
		ability_name: "earthshaker_aftershock",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Earthshaker_AftershockHits10",
	},
	248:
	{	// kKillEaterEventType_Earthshaker_5HeroEchoslams
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Earthshaker_5HeroEchoslams",
		ability_name: "ad_special_bonus_gold_150_l",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Earthshaker_5HeroEchoslams",
	},
	249:
	{	// kKillEaterEventType_Lina_LagunaBladeHeroKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Lina_LagunaBladeHeroKills",
		ability_name: "lina_laguna_blade",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Lina_LagunaBladeHeroKills",
	},
	250:
	{	// kKillEaterEventType_Lina_LightStrikeHeroStuns
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Lina_LightStrikeHeroStuns",
		ability_name: "lina_light_strike_array",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Lina_LightStrikeHeroStuns",
	},
	251:
	{	// kKillEaterEventType_Earthshaker_FissureMultiStuns
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Earthshaker_FissureMultiStuns",
		ability_name: "earthshaker_fissure",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Earthshaker_FissureMultiStuns",
	},
	252:
	{	// kKillEaterEventType_Earthshaker_TotemKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Earthshaker_TotemKills",
		ability_name: "earthshaker_enchant_totem",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Earthshaker_TotemKills",
	},
	253:
	{	// kKillEaterEventType_Pangolier_SwashbuckleKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Pangolier_SwashbuckleKills",
		ability_name: "pangolier_swashbuckle",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Pangolier_SwashbuckleKills",
	},
	254:
	{	// kKillEaterEventType_Furion_EnemyHeroesTrapped
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Furion_EnemyHeroesTrapped",
		ability_name: "furion_sprout",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Furion_EnemyHeroesTrapped",
	},
	255:
	{	// kKillEaterEventType_Pangolier_HeartpiercerKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Pangolier_HeartpiercerKills",
		ability_name: "pangolier_lucky_shot",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Pangolier_HeartpiercerKills",
	},
	256:
	{	// kKillEaterEventType_Medusa_MultiHeroStoneGaze
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Medusa_MultiHeroStoneGaze",
		ability_name: "medusa_stone_gaze",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Medusa_MultiHeroStoneGaze",
	},
	257:
	{	// kKillEaterEventType_Medusa_SplitShotKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Medusa_SplitShotKills",
		ability_name: "medusa_split_shot",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Medusa_SplitShotKills",
	},
	258:
	{	// kKillEaterEventType_Mirana_MultiHeroStarstorm
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Mirana_MultiHeroStarstorm",
		ability_name: "drow_ranger_multishot",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Mirana_MultiHeroStarstorm",
	},
	259:
	{	// kKillEaterEventType_Mirana_KillsFromMoonlightShadow
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Mirana_KillsFromMoonlightShadow",
		ability_name: "courier_dequeue_pickup_from_stash",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Mirana_KillsFromMoonlightShadow",
	},
	260:
	{	// kKillEaterEventType_Magnus_MultiHeroSkewers
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Magnus_MultiHeroSkewers",
		ability_name: "drow_ranger_multishot",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Magnus_MultiHeroSkewers",
	},
	261:
	{	// kKillEaterEventType_Magnus_MultiHeroReversePolarity
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Magnus_MultiHeroReversePolarity",
		ability_name: "magnataur_reverse_polarity",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Magnus_MultiHeroReversePolarity",
	},
	262:
	{	// kKillEaterEventType_Magnus_HeroesSlowedWithShockwave
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Magnus_HeroesSlowedWithShockwave",
		ability_name: "magnataur_shockwave",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Magnus_HeroesSlowedWithShockwave",
	},
	263:
	{	// kKillEaterEventType_NagaSiren_MultiHeroSong
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_NagaSiren_MultiHeroSong",
		ability_name: "naga_siren_song_of_the_siren",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_NagaSiren_MultiHeroSong",
	},
	264:
	{	// kKillEaterEventType_NagaSiren_AlliesHealedBySong
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_NagaSiren_AlliesHealedBySong",
		ability_name: "naga_siren_song_of_the_siren",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_NagaSiren_AlliesHealedBySong",
	},
	265:
	{	// kKillEaterEventType_LoneDruid_MultiHeroRoar
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_LoneDruid_MultiHeroRoar",
		ability_name: "lone_druid_savage_roar",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_LoneDruid_MultiHeroRoar",
	},
	266:
	{	// kKillEaterEventType_LoneDruid_BattleCryKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_LoneDruid_BattleCryKills",
		ability_name: "lone_druid_true_form_battle_cry",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_LoneDruid_BattleCryKills",
	},
	267:
	{	// kKillEaterEventType_WinterWyvern_ThreeHeroCurses
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_WinterWyvern_ThreeHeroCurses",
		ability_name: "special_bonus_unique_winter_wyvern_1",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_WinterWyvern_ThreeHeroCurses",
	},
	268:
	{	// kKillEaterEventType_Antimage_SpellsBlockedWithCounterspell
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Antimage_SpellsBlockedWithCounterspell",
		ability_name: "antimage_counterspell",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Antimage_SpellsBlockedWithCounterspell",
	},
	269:
	{	// kKillEaterEventType_Mars_EnemiesKilledInArena
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Mars_EnemiesKilledInArena",
		ability_name: "mars_arena_of_blood",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Mars_EnemiesKilledInArena",
	},
	270:
	{	// kKillEaterEventType_Mars_MultiHeroGodsRebuke
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Mars_MultiHeroGodsRebuke",
		ability_name: "mars_gods_rebuke",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Mars_MultiHeroGodsRebuke",
	},
	271:
	{	// kKillEaterEventType_Mars_GodsRebukeKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Mars_GodsRebukeKills",
		ability_name: "mars_gods_rebuke",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Mars_GodsRebukeKills",
	},
	272:
	{	// kKillEaterEventType_Snapfire_LizardBlobsKills
		title_loc_token: "#DOTA_mvp2_accolade_title_kKillEaterEventType_Snapfire_LizardBlobsKills",
		ability_name: "big_thunder_lizard_frenzy",
		gradient: "red",
		detail_loc_token: "#DOTA_mvp2_accolade_detail_kKillEaterEventType_Snapfire_LizardBlobsKills",
	},
}

var s_TestNumber = 271;

function TestMVP2Screen() {

	var accolades = [];

	var max_accolade = 276;
	while(accolades.length < 3)
	{
		if (g_MVP_Accolade_TypeMap[s_TestNumber] != undefined)
		{
			accolades.push(s_TestNumber);
		}

		s_TestNumber = (s_TestNumber + 1) % max_accolade;
	}

	var data =
    {
		mvp2:
		{
			mvps: [
				{
					slot: 3,
					accountid: 174054,
					guildid: 4,
					heroname: 'npc_dota_hero_wraithking', // just for display
					// Find hero id in game\dota\scripts\npc\npc_heroes.txt
					overrideheroid: 42,
					// Find econ id in game\dota\scripts\items\items_game.txt
					overrideeconid: 13456,
					was_dire: false,
					accolades: [
						{ type: accolades[0], detail_value: 113 },
						{ type: accolades[1], detail_value: 4 },
						{ type: accolades[2], detail_value: 13 }
					]
				},
				{
					slot: 1,
					accountid: 85501829,
					guildid: 18,
					heroname: 'npc_dota_hero_sven',
					overrideheroid: 18,
					was_dire: false,
					accolades: [
						{ type: 3, detail_value: 32 }
						]
				},
				{
					slot: 2,
                    accountid: 85501006,
					guildid: 4,
					was_dire: true,
					heroname: 'npc_dota_hero_emberspirit',
					overrideheroid: 106,
					accolades: [
						{ type: 127, detail_value: 17 }
						]
				}
            ]
        }
	};

	TestProgressAnimation( data );
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
	}

	TestProgressAnimation( data );
}


function TestAnimatePlayerMatchSurvey()
{
	var data =
	{
		match_id: '0',
		player_match_survey_progress: {}
	}

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
	}));

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
