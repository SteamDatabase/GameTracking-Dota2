// Fall 2021 BP post game logic

function AnimateSpring2021LevelsAction( panel, eventId, bpPointsStart, bpPointsPerLevel, bpPointsAdd )
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
            this.seq.actions.push( 
                new SkippableAction( 
                    new AnimateBattlePointsIncreaseAction( panel, bpToAnimate, bpEarnedOnRow, bpEarned, bpLevel ) 
                    )
                );

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

AnimateSpring2021LevelsAction.prototype = new BaseAction();
AnimateSpring2021LevelsAction.prototype.start = function () {
    return this.seq.start();
}
AnimateSpring2021LevelsAction.prototype.update = function () {
    return this.seq.update();
}
AnimateSpring2021LevelsAction.prototype.finish = function () {
    this.seq.finish();
}


//-----------------------------------------------------------------------------
// Animates spring 2021 subpanel
//-----------------------------------------------------------------------------
function AnimateSpring2021WeeklyProgressSubpanelAction( panel, ownerPanel, data, startingPoints )
{
    this.data = data;
    this.panel = panel;
    this.ownerPanel = ownerPanel;
    this.startingPoints = startingPoints;
    this.total_points = 0;

    panel.AddClass( 'Visible' );
}

function AnimateSpring2021WeeklyProgressIncreaseAction( panel, name, description, nStarsGranted, nProgressAmount, nStartAmount, nMaxAmount )
{
    this.panel = panel;
    this.name = name;
    this.description = description;
    this.nStarsGranted = nStarsGranted;
    this.nProgressAmount = nProgressAmount;
    this.nStartAmount = nStartAmount;
    this.nMaxAmount = nMaxAmount;
}

AnimateSpring2021WeeklyProgressIncreaseAction.prototype = new BaseAction();

AnimateSpring2021WeeklyProgressIncreaseAction.prototype.start = function ()
{
    this.seq = new RunParallelActions();

    var duration = GetBPIncreaseAnimationDuration( this.nProgressAmount ) * 3.0;
    var levelProgressBar = this.panel.FindChildInLayoutFile( 'ProgressBar' );

    var minProgressValue = Math.min( this.nStartAmount, this.nMaxAmount);
    var maxProgressValue = Math.min( this.nStartAmount + this.nProgressAmount, this.nMaxAmount );

    var self = this;
    this.seq.actions.push( new RunFunctionAction( function ()
    {
        levelProgressBar.lowervalue = self.panel.nInitialAmount;
        levelProgressBar.uppervalue = maxProgressValue;
        levelProgressBar.max = self.nMaxAmount;
        $.Msg("setting progress bar values "+self.nStartAmount+" "+self.nProgressAmount+" "+levelProgressBar.max);
        self.panel.SetDialogVariableInt( "progress_max_value", self.nMaxAmount );
        self.panel.SetDialogVariableLocString( "progress_name", self.name);
        self.panel.SetDialogVariable( "progress_description", self.description);

    } ) );
    this.seq.actions.push( new AnimateDialogVariableIntAction( this.panel, 'progress_start_value', minProgressValue, maxProgressValue, duration ) );
    this.seq.actions.push( new AnimateDialogVariableIntAction( this.panel, 'current_level_bp', minProgressValue, maxProgressValue, duration ) );
    this.seq.actions.push( new AnimateProgressBarWithMiddleAction( levelProgressBar, minProgressValue, maxProgressValue, duration ) );
    this.seq.actions.push( new PlaySoundForDurationAction( "XP.Count", duration ) );

    this.seq.start();
}
AnimateSpring2021WeeklyProgressIncreaseAction.prototype.update = function ()
{
    return this.seq.update();
}
AnimateSpring2021WeeklyProgressIncreaseAction.prototype.finish = function ()
{
    var maxProgressValue = Math.min( this.nStartAmount + this.nProgressAmount, this.nMaxAmount );

    var nStarsGranted = this.nStarsGranted;
    if( maxProgressValue == this.nMaxAmount )
    {
        ++nStarsGranted;
    }

    this.panel.SetHasClass( "StarsGranted1", nStarsGranted > 0 );
    this.panel.SetHasClass( "StarsGranted2", nStarsGranted > 1 );
    this.panel.SetHasClass( "StarsGranted3", nStarsGranted > 2 );

    if(  nStarsGranted > this.panel.nStarsGranted )
    { 
        this.panel.AddClass( "StarsGrantedPulse"+nStarsGranted );
        $.DispatchEvent('PlaySoundEffect', "WeeklyQuest.StarGranted");
    }

    this.panel.nStarsGranted = nStarsGranted;

    this.seq.finish();
}


AnimateSpring2021WeeklyProgressSubpanelAction.prototype = new BaseAction();

function ToStringSafe(v)
{
    if(v == undefined)
    {
        return '[undefined]';
    }

    return v.toString();
}

function AnimateSpring2021WeeklyProgressLevels( panel, nStartValue, nProgress, levelThresholds)
{
    this.seq = new RunSequentialActions();

    var nCurrentProgress = nStartValue;
    var nProgressRemaining = nProgress;

    var nNextThresholdIndex = 0;

    for ( var i in levelThresholds )
    {
        if ( levelThresholds[i].threshold > nCurrentProgress )
        {
            nNextThresholdIndex = i;
            break;
        }
    }

    var bFirst = true;

    while ( nProgressRemaining > 0 )
    {
        var levelThreshold = levelThresholds[nNextThresholdIndex++];

        if ( levelThreshold != undefined )
        {
            var nNextProgressThreshold = levelThreshold.threshold;
            var nProgressToNextLevel = nNextProgressThreshold - nCurrentProgress;

            var nProgressToAnimateThisThreshold = Math.min( nProgressRemaining, nProgressToNextLevel );

            if ( nProgressToAnimateThisThreshold > 0 )
            {
                var nStarsGranted = Math.max( 0, nNextThresholdIndex-1);
                if ( bFirst )
                {
                    // initialize values before the animation plays so we don't get blank dialog variables
                    panel.SetDialogVariable( "progress_description", levelThreshold.description );
                    panel.SetDialogVariableLocString( "progress_name", levelThreshold.name );

                    panel.nStarsGranted = nStarsGranted;
                    panel.nInitialAmount = nStartValue;

                    panel.SetHasClass( "StarsGranted1", nStarsGranted > 0 );
                    panel.SetHasClass( "StarsGranted2", nStarsGranted > 1 );
                    panel.SetHasClass( "StarsGranted3", nStarsGranted > 2 );
                    bFirst = false;
                }
 
                // Build a set of sequences for levelling up to the threshold.
                this.seq.actions.push(
                    new SkippableAction(
                        new AnimateSpring2021WeeklyProgressIncreaseAction(
                            panel,
                            levelThreshold.name,
                            levelThreshold.description,
                            nStarsGranted,
                            nProgressToAnimateThisThreshold,
                            nCurrentProgress,
                            nNextProgressThreshold
                        )
                    )
                );

                nCurrentProgress += nProgressToAnimateThisThreshold;
                nProgressRemaining -= nProgressToAnimateThisThreshold;
            }

            nProgressToNextLevel = nNextProgressThreshold - nCurrentProgress;

            continue;
        }

        // Show the next tier if it exists:
        {
            if(nNextThresholdIndex < levelThresholds.length)
            {
                var nNextProgressThreshold = levelThresholds[Math.min(nNextThresholdIndex, levelThresholds.length-1)].threshold;
                this.seq.actions.push( 
                    new SkippableAction( 
                        new AnimateSpring2021WeeklyProgressIncreaseAction( 
                            panel, 
                            levelThresholds[nNextThresholdIndex].name,
                            levelThresholds[nNextThresholdIndex].description,
                            nNextThresholdIndex,
                            0, 
                            nCurrentProgress,
                            nNextProgressThreshold
                            ) 
                        ) 
                    );
            }
        }
        break;
    }
}

AnimateSpring2021WeeklyProgressLevels.prototype = new BaseAction();
AnimateSpring2021WeeklyProgressLevels.prototype.start = function () {
    return this.seq.start();
}
AnimateSpring2021WeeklyProgressLevels.prototype.update = function () {
    return this.seq.update();
}
AnimateSpring2021WeeklyProgressLevels.prototype.finish = function () {
    this.seq.finish();
}

var AddNewWeeklyProgressPanelSpring2021 = function(seq, parentPanel, i, data)
{
    var panel = $.CreatePanel( 'Panel', parentPanel, 'WeeklyProgress' + i );
    panel.BLoadLayoutSnippet( 'Spring2021WeeklyProgressEntry' );
    panel.SetDialogVariableInt( "progress_start_value", data.progress_start_value );
    panel.SetDialogVariableInt( "progress_max_value", data.progress_start_value );
    panel.SetDialogVariable( "progress", data.progress);

    seq.actions.push( new AnimateSpring2021WeeklyProgressLevels( panel,
        data.progress_start_value,
        data.progress,
        data.level_thresholds
        )
    );
}

AnimateSpring2021WeeklyProgressSubpanelAction.prototype.start = function ()
{
    this.seq = new RunSequentialActions();
    this.seq.actions.push( new AddClassAction( this.panel, 'BecomeVisible' ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( g_DelayAfterStart ) ) );

    this.seq.actions.push( new AddClassAction( this.panel, 'ShowMap' ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

    this.seq.actions.push( new AddClassAction( this.panel, 'ShowCompleted' ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( g_SubElementDelay ) ) );

    var panel = this.panel;

    var weeklyProgressPanelParent = panel.FindChildInLayoutFile( "Spring2021WeeklyProgressTypeDetails" );

    for(var i = 0; i < this.data.length; ++i)
    {
        var data = this.data[i];
        AddNewWeeklyProgressPanelSpring2021( this.seq, weeklyProgressPanelParent, i, data );
    }

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
AnimateSpring2021WeeklyProgressSubpanelAction.prototype.update = function ()
{
    return this.seq.update();
}
AnimateSpring2021WeeklyProgressSubpanelAction.prototype.finish = function ()
{
    this.seq.finish();
}


// Spring2021 BP Progress
function AnimateSpring2021ScreenAction( data )
{
    this.data = data;
}

AnimateSpring2021ScreenAction.prototype = new BaseAction();

AnimateSpring2021ScreenAction.prototype.start = function ()
{
    // Create the screen and do a bunch of initial setup
    var panel = StartNewScreen( 'Spring2021ProgressScreen' );
    panel.BLoadLayoutSnippet( "Spring2021Progress" );

    panel.SetDialogVariableInt('points_available', this.data.spring_2021_progress.points_available);
    panel.SetDialogVariableInt( 'active_week', this.data.spring_2021_progress.active_season_id );

    panel.FindChildInLayoutFile( 'WeeklyQuestProgressPipBar' ).SetLocalUserSeasonInfo( 
        this.data.spring_2021_progress.battle_points_event_id, 
        this.data.spring_2021_progress.active_season_id );

    panel.SetDialogVariableInt( 'total_points_gained', 0 );

    // Setup the sequence of actions to animate the screen
    this.seq = new RunSequentialActions();
    this.seq.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

    this.seq.actions.push( new AddScreenLinkAction( panel, 'Spring2021Progress', '#DOTA_PlusPostGame_Spring2021Progress', function ()
    {
        panel.SwitchClass( 'current_screen', 'ShowSpring2021Progress' );
    } ) );
    this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', 'ShowSpring2021Progress' ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

    var subPanelActions = new RunSkippableStaggeredActions( .3 );

    var startingPointsToAdd = 0;
    var panelCount = 0;
    var kMaxPanels = 6;

    if ( this.data.spring_2021_progress.actions_granted != null )
    {
        var progressPanel = panel.FindChildInLayoutFile( "Spring2021WeeklyProgress" );
        var subpanelAction = new AnimateSpring2021WeeklyProgressSubpanelAction( 
            progressPanel, 
            panel, 
            this.data.spring_2021_progress.actions_granted, 
            startingPointsToAdd 
        );
        startingPointsToAdd += subpanelAction.total_points;
        subPanelActions.actions.push( subpanelAction );
        if ( ++panelCount > kMaxPanels )
            progressPanel.RemoveClass( 'Visible' );
    }

    if ( this.data.spring_2021_progress.event_game_nemestice != null )
    {
        var progressPanel = panel.FindChildInLayoutFile( "Spring2021EventGameNemesticeProgress" );
        var subpanelAction = new AnimateEventGameNemesticeSubpanelAction(
            progressPanel,
            panel,
            this.data.spring_2021_progress.event_game_nemestice,
            startingPointsToAdd );
        startingPointsToAdd += subpanelAction.total_points;
        subPanelActions.actions.push( subpanelAction );
        if ( ++panelCount > kMaxPanels )
            eventPanel.RemoveClass( 'Visible' );
    }

    if ( this.data.spring_2021_progress.cavern_crawl != null )
    {
        var cavernPanel = panel.FindChildInLayoutFile( "Spring2021CavernCrawlProgress" );
        var subpanelAction = new AnimateCavernCrawlSubpanelAction( cavernPanel, panel, this.data.spring_2021_progress.cavern_crawl, startingPointsToAdd );
        startingPointsToAdd += subpanelAction.total_points;
        subPanelActions.actions.push( subpanelAction );
        if ( ++panelCount > kMaxPanels )
            cavernPanel.RemoveClass( 'Visible' );
    }

    this.seq.actions.push( subPanelActions );

    this.seq.actions.push( new AnimateSpring2021LevelsAction( panel,
        this.data.spring_2021_progress.battle_points_event_id,
        this.data.spring_2021_progress.battle_points_start,
        this.data.spring_2021_progress.battle_points_per_level,
        startingPointsToAdd ) );

    this.seq.actions.push( new WaitAction( 0.2 ) );

    this.seq.actions.push( new StopSkippingAheadAction() );
    this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
    this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
    this.seq.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

    this.seq.start();
}
AnimateSpring2021ScreenAction.prototype.update = function ()
{
    return this.seq.update();
}
AnimateSpring2021ScreenAction.prototype.finish = function ()
{
    this.seq.finish();
}

//----------------------------------

function TestAnimateSpring2021()
{
    var data =
    {
        hero_id: 87,

        spring_2021_progress:
        {
            active_season_id: 1,
            battle_points_event_id: 32,
            battle_points_start: 74850,
            battle_points_per_level: 1000,
            points_available: 1000,

            actions_granted: [
                    {
                        // Cross a tier
                        progress_start_value : 1,
                        progress : 40,
                        level_thresholds : [
                            {
                                name: "#DOTA_Spring2021_Quest_Plays_Name",
                                description: 'Win <span class="ScoreTierCurrent">3</span> Matches',
                                threshold: 3
                            },
                            {
                                name: "#DOTA_Spring2021_Quest_Plays_Name",
                                description: 'Win <span class="ScoreTierCurrent">10</span> Matches',
                                threshold: 10
                            },
                            {
                                name: "#DOTA_Spring2021_Quest_Plays_Name",
                                description: 'Win <span class="ScoreTierCurrent">30</span> Matches',
                                threshold: 30
                            },
                            ]
                    },
                    {
                        // Cross past max tier
                        progress_start_value : 141,
                        progress : 10,
                        level_thresholds : [
                            {
                                name: "#DOTA_Spring2021_Quest_Wins_Name",
                                description: 'Win <span class="ScoreTierCurrent">10</span> Matches',
                                threshold: 10
                            },
                            {
                                name: "#DOTA_Spring2021_Quest_Wins_Name",
                                description: 'Win <span class="ScoreTierCurrent">50</span> Matches',
                                threshold: 50
                            },
                            {
                                name: "#DOTA_Spring2021_Quest_Wins_Name",
                                description: 'Win <span class="ScoreTierCurrent">150</span> Matches',
                                threshold: 150
                            },
                            ]
                    },
                    {
                        // Minor increment
                        progress_start_value : 0,
                        progress : 0.5,
                        level_thresholds : [
                            {
                                name: "#DOTA_Spring2021_Quest_Kills_Name",
                                description: 'Win <span class="ScoreTierCurrent">10</span> Matches',
                                threshold: 10
                            },
                            {
                                name: "#DOTA_Spring2021_Quest_Kills_Name",
                                description: 'Win <span class="ScoreTierCurrent">50</span> Matches',
                                threshold: 50
                            },
                            {
                                name: "#DOTA_Spring2021_Quest_Kills_Name",
                                description: 'Win <span class="ScoreTierCurrent">150</span> Matches',
                                threshold: 150
                            },
                            ]
                    },
            ],

            cavern_crawl:
            {
                hero_id: 87,
                bp_amount: 375,
            },

            event_game_nemestice:
            {
                bp_amount: 225,
                bp_start: 50,
                bp_max: 2000,
            }
        }
    };

    TestProgressAnimation( data );
}