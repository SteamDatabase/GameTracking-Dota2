// Fall 2021 BP post game logic

// ----------------------------------------------------------------------------
// Weekly Quests
// ----------------------------------------------------------------------------

class AnimateFall2021WeeklyQuestEntryAction extends RunSequentialActions
{
    constructor( questList, pipBar, actionGranted )
    {
        super();

        this.questList = questList;
        this.pipBar = pipBar;
        this.actionGranted = actionGranted;

        this.entryPanel = $.CreatePanel( 'Panel', this.questList, '' );
        this.entryPanel.BLoadLayoutSnippet( 'Fall2021WeeklyQuestEntry' );
        this.entryPanel.SetDialogVariableInt( 'progress_start_value', this.actionGranted.progress_start_value );
        this.entryPanel.SetDialogVariable( 'progress', '' + this.actionGranted.progress );

        var questStars = this.entryPanel.FindChildInLayoutFile( 'Fall2021WeeklyQuestStars' );
        var progressBar = this.entryPanel.FindChildInLayoutFile( 'Fall2021WeeklyProgressBar' );

        var activeThreshold = null;
        for ( var i = 0; i < actionGranted.level_thresholds.length; ++i )
        {
            var levelThreshold = actionGranted.level_thresholds[i];
            if ( activeThreshold == null && this.actionGranted.progress_start_value < levelThreshold.threshold )
            {
                activeThreshold = levelThreshold;
            }

            var tierStar = $.CreatePanel( 'Panel', questStars, 'TierStar' + i );
            tierStar.AddClass( 'Fall2021TierStar' );
            if ( activeThreshold == null )
            {
                tierStar.AddClass( 'StarAchieved' );
            }
        }
        if ( activeThreshold == null )
        {
            activeThreshold = actionGranted.level_thresholds[actionGranted.level_thresholds.length - 1];
        }

        this.entryPanel.SetDialogVariableInt( 'progress_max_value', activeThreshold.threshold );
        this.entryPanel.SetDialogVariableLocString( 'progress_name', activeThreshold.name );
        this.entryPanel.SetDialogVariable( 'progress_description', activeThreshold.description );

        progressBar.lowervalue = this.actionGranted.progress_start_value;
        progressBar.max = activeThreshold.threshold;
    }

    start()
    {
        var questStars = this.entryPanel.FindChildInLayoutFile( 'Fall2021WeeklyQuestStars' );
        var progressBar = this.entryPanel.FindChildInLayoutFile( 'Fall2021WeeklyProgressBar' );
        progressBar.lowervalue = this.actionGranted.progress_start_value;

        this.actions.push( new AddClassAction( this.entryPanel, 'ShowEntry' ) );
        this.actions.push( new WaitAction( 0.2 ) );

        var startValue = this.actionGranted.progress_start_value;
        var finalValue = startValue + this.actionGranted.progress;
        for ( var i = 0; i < this.actionGranted.level_thresholds.length; ++i )
        {
            var levelThreshold = this.actionGranted.level_thresholds[i];
            if ( this.actionGranted.progress_start_value >= levelThreshold.threshold )
                continue;

            // Setup threshold
            this.actions.push( new RunFunctionAction( function( panel, lowerValue, nextThreshold )
            {
                return function()
                {
                    progressBar.max = nextThreshold.threshold;
                    panel.SetDialogVariableInt( 'progress_max_value', nextThreshold.threshold );
                    panel.SetDialogVariableLocString( 'progress_name', nextThreshold.name );
                    panel.SetDialogVariable( 'progress_description', nextThreshold.description );
                };
            }( this.entryPanel, startValue, levelThreshold ) ) );

            // Now animate up to either the end of the threshold, or the final value
            var nextAnimateValue = Math.min( levelThreshold.threshold, finalValue );

            var par = new RunParallelActions();

            var duration = GetBPIncreaseAnimationDuration( nextAnimateValue - startValue ) * 3.0;

            par.actions.push( new AnimateDialogVariableIntAction( this.entryPanel, 'progress_start_value', startValue, nextAnimateValue, duration ) );
            par.actions.push( new AnimateProgressBarWithMiddleAction( progressBar, startValue, nextAnimateValue, duration ) );
            par.actions.push( new PlaySoundForDurationAction( "XP.Count", duration ) );

            this.actions.push( par );

            // Animate the star increasing
            if ( nextAnimateValue == levelThreshold.threshold )
            {
                var tierStar = questStars.GetChild( i );
                this.actions.push( new AddClassAction( tierStar, 'StarAchieved' ) );
                this.actions.push( new PlaySoundAction( 'WeeklyQuest.StarGranted' ) );
                this.actions.push( new RunFunctionAction( function( pipBar )
                {
                    return function()
                    {
                        pipBar.overridecurrentstars += 1;
                    };
                }( this.pipBar ) ) );
                this.actions.push( new WaitAction( 0.4 ) );
            }

            // Are we all done?
            if ( nextAnimateValue == finalValue )
                break;

            startValue = nextAnimateValue;
        }

        super.start();
    }
}

// ----------------------------------------------------------------------------

class AnimateFall2021WeeklyQuestsAction extends RunSequentialActions
{
    constructor( sectionPanel, nEventID, nSeasonID, actionsGranted, nInitialStars )
    {
        super();

        this.sectionPanel = sectionPanel;
        this.nEventID = nEventID;
        this.nSeasonID = nSeasonID;
        this.actionsGranted = actionsGranted;
        this.nInitialStars = nInitialStars;

        var pipBar = this.sectionPanel.FindChildInLayoutFile( 'Fall2021WeeklyQuestsPipBar' );
        pipBar.SetSeasonInfo( this.nEventID, this.nSeasonID );
        pipBar.overridecurrentstars = this.nInitialStars;
    }

    start()
    {
        var questList = this.sectionPanel.FindChildInLayoutFile( 'Fall2021WeeklyQuestsList' );
        var pipBar = this.sectionPanel.FindChildInLayoutFile( 'Fall2021WeeklyQuestsPipBar' );

        this.sectionPanel.AddClass( 'ShowSection' );

        if ( this.actionsGranted != null )
        {
            for ( var i = 0; i < this.actionsGranted.length; ++i )
            {
                this.actions.push( new AnimateFall2021WeeklyQuestEntryAction( questList, pipBar, this.actionsGranted[i] ) );
            }
        }

        super.start();
    }
}

// ----------------------------------------------------------------------------
// Event Game
// ----------------------------------------------------------------------------

class AnimateFall2021EventGameAction extends RunSequentialActions
{
    constructor( sectionPanel, eventGameData )
    {
        super();
        this.sectionPanel = sectionPanel;
        this.eventGameData = eventGameData;
    }

    start()
    {
        this.sectionPanel.SetDialogVariableInt( 'event_game_points_earned', 0 );
        this.sectionPanel.SetDialogVariableInt( 'event_game_fragments_earned', 0 );

        this.sectionPanel.AddClass( 'ShowSection' );

        this.actions.push( new AddClassAction( this.sectionPanel, 'ShowBattlePoints' ) );
        this.actions.push( new WaitAction( 0.2 ) );

        var parBattlePoints = new RunParallelActions();
        var duration = GetBPIncreaseAnimationDuration( this.eventGameData.bp_amount );
        parBattlePoints.actions.push( new AnimateDialogVariableIntAction( this.sectionPanel, 'event_game_points_earned', 0, this.eventGameData.bp_amount, duration ) );
        parBattlePoints.actions.push( new PlaySoundForDurationAction( "XP.Count", duration ) );
        this.actions.push( parBattlePoints );

        this.actions.push( new WaitAction( 0.2 ) );

        this.actions.push( new AddClassAction( this.sectionPanel, 'ShowFragments' ) );
        this.actions.push( new WaitAction( 0.2 ) );

        var parFragments = new RunParallelActions();
        duration = GetBPIncreaseAnimationDuration( this.eventGameData.fragment_amount );
        parFragments.actions.push( new AnimateDialogVariableIntAction( this.sectionPanel, 'event_game_fragments_earned', 0, this.eventGameData.fragment_amount, duration ) );
        parFragments.actions.push( new PlaySoundForDurationAction( "XP.Count", duration ) );
        this.actions.push( parFragments );

        super.start();
    }
}


// ----------------------------------------------------------------------------
// Cavern Crawl
// ----------------------------------------------------------------------------

class AnimateFall2021CavernCrawlAction extends RunSequentialActions
{
    constructor( sectionPanel, cavernCrawlData )
    {
        super();
        this.sectionPanel = sectionPanel;
        this.cavernCrawlData = cavernCrawlData;
    }

    start()
    {
        this.sectionPanel.FindChildInLayoutFile( 'Fall2021CavernCrawlHeroMovie' ).heroid = this.cavernCrawlData.hero_id;
        this.sectionPanel.SetDialogVariableInt( 'cavern_crawl_points_earned', this.cavernCrawlData.bp_amount );

        this.sectionPanel.AddClass( 'ShowSection' );

        this.seq = new RunSequentialActions();
        this.actions.push( new WaitAction( 0.2 ) );

        var par = new RunParallelActions();
        var duration = GetBPIncreaseAnimationDuration( this.cavernCrawlData.bp_amount );
        par.actions.push( new AnimateDialogVariableIntAction( this.sectionPanel, 'cavern_crawl_points_earned', 0, this.cavernCrawlData.bp_amount, duration ) );
        par.actions.push( new PlaySoundForDurationAction( "XP.Count", duration ) );
        this.actions.push( par );

        super.start();
    }
}

// ----------------------------------------------------------------------------
// Drow Arcana Minigame
// ----------------------------------------------------------------------------

class AnimateFall2021DrowArcanaMinigameAction extends RunSequentialActions
{
    constructor( sectionPanel, minigameData )
    {
        super();
        this.sectionPanel = sectionPanel;
        this.minigameData = minigameData;
    }

    start()
    {
        this.sectionPanel.AddClass( 'ShowSection' );

        this.seq = new RunSequentialActions();

        this.actions.push( new WaitAction( 0.4 ) );
        this.actions.push( new AddClassAction( this.sectionPanel, 'ShowMysteryBoxIcon' ) );

        super.start();
    }
}

// ----------------------------------------------------------------------------
// Progress Screen
// ----------------------------------------------------------------------------

class AnimateFall2021ScreenAction extends RunSequentialActions
{
    constructor( data )
    {
        super();
        this.data = data;
    }

    start()
    {
        // Create the screen and do a bunch of initial setup
        var panel = StartNewScreen( 'Fall2021ProgressScreen' );
        panel.BLoadLayoutSnippet( "Fall2021Progress" );
        panel.SetDialogVariableInt( 'active_week', this.data.fall_2021_progress.active_season_id );

        var levelShield = panel.FindChildInLayoutFile( 'Fall2021LevelShield' );
        levelShield.SetEventPoints( this.data.fall_2021_progress.battle_points_event_id, this.data.fall_2021_progress.battle_points_start );

        // Setup the sequence of actions to animate the screen
        this.seq = new RunSequentialActions();
        this.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
        this.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
        this.actions.push( new AddScreenLinkAction( panel, 'Fall2021Progress', '#DOTA_BattlePassPostGame_Progress' ) );

        this.actions.push( new SkippableAction( new AnimateFall2021WeeklyQuestsAction(
            panel.FindChildInLayoutFile( 'Fall2021WeeklyQuests' ),
            this.data.fall_2021_progress.battle_points_event_id,
            this.data.fall_2021_progress.active_season_id,
            this.data.fall_2021_progress.actions_granted,
            this.data.fall_2021_progress.weekly_quest_initial_stars ) ) );
        this.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

        if ( this.data.fall_2021_progress.event_game_rewards != null )
        {
            var section = panel.FindChildInLayoutFile( 'Fall2021EventGameProgress' );
            section.AddClass( 'SectionHasData' );
            this.actions.push( new SkippableAction( new AnimateFall2021EventGameAction( section, this.data.fall_2021_progress.event_game_rewards ) ) );
            this.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
        }

        if ( this.data.fall_2021_progress.cavern_crawl != null )
        {
            var section = panel.FindChildInLayoutFile( 'Fall2021CavernCrawlProgress' );
            section.AddClass( 'SectionHasData' );
            this.actions.push( new SkippableAction( new AnimateFall2021CavernCrawlAction( section, this.data.fall_2021_progress.cavern_crawl ) ) );
            this.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
        }

        if ( this.data.fall_2021_progress.drow_arcana_minigame != null )
        {
            var section = panel.FindChildInLayoutFile( 'Fall2021DrowArcanaProgress' );
            section.AddClass( 'SectionHasData' );
            this.actions.push( new SkippableAction( new AnimateFall2021DrowArcanaMinigameAction( section, this.data.fall_2021_progress.drow_arcana_minigame ) ) );
            this.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
        }

        this.actions.push( new WaitAction( 0.2 ) );
        this.actions.push( new StopSkippingAheadAction() );
        this.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
        this.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
        this.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );

        super.start();
    }
}

//----------------------------------

function TestAnimateFall2021()
{
    var data =
    {
        hero_id: 87,

        fall_2021_progress:
        {
            active_season_id: 2,
            battle_points_event_id: 33,
            battle_points_start: 74850,
            battle_points_per_level: 1000,

            weekly_quest_initial_stars: 2,
            actions_granted: [
                {
                    // Cross a tier
                    progress_start_value: 1,
                    progress: 40,
                    level_thresholds: [
                        {
                            name: "#DOTA_Fall2021_Quest_Plays_Name",
                            description: 'Win <span class="ScoreTierCurrent">3</span> Matches',
                            threshold: 3
                        },
                        {
                            name: "#DOTA_Fall2021_Quest_Plays_Name",
                            description: 'Win <span class="ScoreTierCurrent">10</span> Matches',
                            threshold: 10
                        },
                        {
                            name: "#DOTA_Fall2021_Quest_Plays_Name",
                            description: 'Win <span class="ScoreTierCurrent">30</span> Matches',
                            threshold: 30
                        },
                    ]
                },
                {
                    // Cross past max tier
                    progress_start_value: 141,
                    progress: 10,
                    level_thresholds: [
                        {
                            name: "#DOTA_Fall2021_Quest_Wins_Name",
                            description: 'Win <span class="ScoreTierCurrent">10</span> Matches',
                            threshold: 10
                        },
                        {
                            name: "#DOTA_Fall2021_Quest_Wins_Name",
                            description: 'Win <span class="ScoreTierCurrent">50</span> Matches',
                            threshold: 50
                        },
                        {
                            name: "#DOTA_Fall2021_Quest_Wins_Name",
                            description: 'Win <span class="ScoreTierCurrent">150</span> Matches',
                            threshold: 150
                        },
                    ]
                },
                {
                    // Minor increment
                    progress_start_value: 0,
                    progress: 4,
                    level_thresholds: [
                        {
                            name: "Beat Aghanim Bosses",
                            description: 'Beat <span class="ScoreTierCurrent">1</span> Boss',
                            threshold: 1
                        },
                        {
                            name: "Beat Aghanim Bosses",
                            description: 'Beat <span class="ScoreTierCurrent">2</span> Bosses',
                            threshold: 2
                        },
                        {
                            name: "Beat Aghanim Bosses",
                            description: 'Beat <span class="ScoreTierCurrent">3</span> Bosses',
                            threshold: 3
                        },
                        {
                            name: "Beat Aghanim Bosses",
                            description: 'Beat <span class="ScoreTierCurrent">4</span> Bosses',
                            threshold: 4
                        },
                        {
                            name: "Beat Aghanim Bosses",
                            description: 'Beat <span class="ScoreTierCurrent">5</span> Bosses',
                            threshold: 5
                        },
                        {
                            name: "Beat Aghanim Bosses",
                            description: 'Beat <span class="ScoreTierCurrent">6</span> Bosses',
                            threshold: 6
                        },
                        {
                            name: "Beat Aghanim Bosses",
                            description: 'Beat <span class="ScoreTierCurrent">7</span> Bosses',
                            threshold: 7
                        },
                    ]
                },
            ],

            event_game_rewards:
            {
                bp_amount: 1234,
                fragment_amount: 336,
            },

            cavern_crawl:
            {
                hero_id: 87,
                bp_amount: 375,
            },

            drow_arcana_minigame:
            {
                mystery_box_earned: true
            }
        }
    };

    TestProgressAnimation( data );
}
