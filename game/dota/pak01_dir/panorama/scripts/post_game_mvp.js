// MVP v2 in a tab

function AnimateMVP2TabAction( data )
{
	this.data = data;
}

AnimateMVP2TabAction.prototype = new BaseAction();

AnimateMVP2TabAction.prototype.init = function( mvp2ScreenPanel )
{
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
		var accolade_id = accoladeObject.type;
		var accolade = g_MVP_Accolade_TypeMap[accolade_id];
		if (accolade == undefined)
		{
			$.Msg('No accolade of type ' + accolade_id.toString());
			return null;
		}

		var accolade_panel = $.CreatePanel( 'Panel', accoladeContainer, '' );
		accolade_panel.BLoadLayoutSnippet('MVPAccolade');

		var accolade_value = accoladeObject.detail_value;

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
	
	if ( this.data.bProgressVersion )
	{
		this.seq.actions.push( new AddScreenLinkAction( mvp2ScreenPanel, 'MVPProgress', '#DOTAMVP2_TitleLink' ) );
		this.seq.actions.push( new AddClassAction( mvp2ScreenPanel, 'ShowScreen' ) );
	}

	// Wait for map to load
	this.seq.actions.push( new WaitForClassAction( map, 'SceneLoaded' ) );

	var match_id = this.data.match_id;

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
					map.SpawnHeroInScenePanelByPlayerSlot( match_id, mvpDetails.slot, "featured_hero" );
				}
				else
				{
					var econId = mvpDetails.overrideeconid;
					if(econId == undefined)
					{
						econId = -1;
					}

					map.SpawnHeroInScenePanelByHeroId( mvpDetails.overrideheroid, "featured_hero", econId );
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
					model.SetScenePanelToPlayerHero(match_id, honorableMentionData.slot);
				}
				else
				{
					model.SetScenePanelToLocalHero(honorableMentionData.overrideheroid);
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

	if ( this.data.bProgressVersion )
		this.seq.actions.push( new SkippableAction( new WaitAction(0.5)));
	else
		this.seq.actions.push( new WaitAction(0.5));
	var honorableMentionsContainer = mvp2ScreenPanel.FindChildInLayoutFile('HonorableMentionsContainer');
	this.seq.actions.push( new AddClassAction( honorableMentionsContainer, 'HMAnimateIn') );
	if ( this.data.bProgressVersion )
		this.seq.actions.push( new SkippableAction( new WaitAction(0.5)));
	else
		this.seq.actions.push( new WaitAction(0.5));
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

	if ( this.data.bProgressVersion )
	{
		this.seq.actions.push( new SkippableAction( new WaitAction(0.5)));

		this.seq.actions.push( new StopSkippingAheadAction() );
		this.seq.actions.push( new SkippableAction( new WaitAction( 1.5 ) ) );
		this.seq.actions.push( new SwitchClassAction( mvp2ScreenPanel, 'current_screen', '' ) );
		this.seq.actions.push( new SkippableAction( new WaitAction( 7.0 ) ) );
	}

	this.seq.start();
}

AnimateMVP2TabAction.prototype.start = function ()
{
	// Create the screen and do a bunch of initial setup
	var mvp2ScreenPanel = $.GetContextPanel().FindPanelInLayoutFile( 'DetailsMVPInner' );

	this.init( mvp2ScreenPanel );
}

AnimateMVP2TabAction.prototype.update = function ()
{
	return this.seq.update();
}

AnimateMVP2TabAction.prototype.finish = function ()
{
	this.seq.finish();
}

// ------------------------

function InitMVPTab( data )
{
	if ( data.mvp2 != null )
	{
		var seq = new RunSequentialActions();
		seq.actions.push( new AnimateMVP2TabAction( data ) );
		RunSingleAction( seq );
	}
}