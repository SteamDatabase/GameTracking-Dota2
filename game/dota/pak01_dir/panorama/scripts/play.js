//@ts-check
/// <reference path="util.js" />

/**
 * @typedef {object} CDOTAFeaturedGamemodeDefinition
 * @property {DOTA_GameMode} eGameMode
 * @property {string | null} sCustomGame
 * @property {number} nShardsPerWin
 * @property {number} nShardsPerLoss
 * @property {string} sLocName
 * @property {string} sLocDescription
 * @property {number} nEndTime
 */

/**
 * @typedef {object} CDOTA_DB_Play_ObjectTemplate
 * @property {() => CDOTAFeaturedGamemodeDefinition | null} GetActiveFeaturedGamemode
 * @property {() => number} GetFeaturedGamemodeProgress
 * @property {() => number} GetFeaturedGamemodeMax
 * @property {() => number} GetSelectedGameModes
 * @property {() => void} UpdateCasualGameModeCheckboxes
 */

/**
 * @returns {Panel & CDOTA_DB_Play_ObjectTemplate}
 */
function GetPlayPanel()
{
    //@ts-ignore
    return $.GetContextPanel();
}

/**
 * @typedef {object} GameMode
 * @prop {DOTA_GameMode} nMode
 * @prop {string} sName
 */

/** @type {GameMode[]} */
const k_GameModes = [
    { nMode: DOTA_GameMode.DOTA_GAMEMODE_AP, sName: "AllPick" },
    { nMode: DOTA_GameMode.DOTA_GAMEMODE_TURBO, sName: "Turbo" },
    { nMode: DOTA_GameMode.DOTA_GAMEMODE_SD, sName: "SingleDraft" },
    { nMode: DOTA_GameMode.DOTA_GAMEMODE_RD, sName: "RandomDraft" },
    { nMode: DOTA_GameMode.DOTA_GAMEMODE_AR, sName: "AllRandom" },
    { nMode: DOTA_GameMode.DOTA_GAMEMODE_ABILITY_DRAFT, sName: "AbilityDraft" },
    { nMode: DOTA_GameMode.DOTA_GAMEMODE_ARDM, sName: "AllRandomDeathMatch" },
    { nMode: DOTA_GameMode.DOTA_GAMEMODE_EVENT, sName: "Event" },
];
const k_GameModesMap = ToMap( k_GameModes, mode => mode.nMode );
const k_StandardModes = [DOTA_GameMode.DOTA_GAMEMODE_AP, DOTA_GameMode.DOTA_GAMEMODE_TURBO];
const k_OtherModes = [DOTA_GameMode.DOTA_GAMEMODE_SD, DOTA_GameMode.DOTA_GAMEMODE_RD, DOTA_GameMode.DOTA_GAMEMODE_AR, DOTA_GameMode.DOTA_GAMEMODE_ABILITY_DRAFT, DOTA_GameMode.DOTA_GAMEMODE_ARDM];

/** @type {CDOTAFeaturedGamemodeDefinition | null} */
let gFeaturedGamemodeDef = null;

function InitUnrankedGameModes()
{
    const pContext = GetPlayPanel();
    gFeaturedGamemodeDef = pContext.GetActiveFeaturedGamemode();

    const pModes = $( "#UnrankedGameModes" );
    if ( pModes )
    {
        pModes.RemoveAndDeleteChildren();
        let bFeaturedModeFound = false;
        k_StandardModes.forEach( nMode =>
        {
            if ( gFeaturedGamemodeDef && nMode == gFeaturedGamemodeDef.eGameMode )
            {
                BuildUnrankedGameModePanel( pModes, nMode, gFeaturedGamemodeDef );
                bFeaturedModeFound = true;
            }
            else
            {
                BuildUnrankedGameModePanel( pModes, nMode );
            }
        } );

        if ( gFeaturedGamemodeDef && !bFeaturedModeFound )
        {
            BuildUnrankedGameModePanel( pModes, gFeaturedGamemodeDef.eGameMode, gFeaturedGamemodeDef );
        }
    }


    const pOtherModes = $( "#UnrankedGameModesOther" );
    if ( pOtherModes )
    {
        pOtherModes.RemoveAndDeleteChildren();
        k_OtherModes.forEach( nMode =>
        {
            const mode = k_GameModesMap[nMode];
            if ( mode && ( gFeaturedGamemodeDef == null || nMode != gFeaturedGamemodeDef.eGameMode ) )
            {
                BuildGameModeToggle( pOtherModes, mode.sName, mode.nMode );
            }
        } );
    }

    if ( gFeaturedGamemodeDef )
    {
        pContext.SetDialogVariableInt( "fgm_loss_shards", gFeaturedGamemodeDef.nShardsPerLoss );
        pContext.SetDialogVariableInt( "fgm_win_bonus_shards", gFeaturedGamemodeDef.nShardsPerWin - gFeaturedGamemodeDef.nShardsPerLoss );
    }

    UpdateUnrankedValues();

    pContext.UpdateCasualGameModeCheckboxes();
}
$.Schedule( 0.0, InitUnrankedGameModes );

function UpdateUnrankedGameModes()
{
    const pContext = GetPlayPanel();
    const pFeaturedGamemodeDef = pContext.GetActiveFeaturedGamemode();
    if ( !BShallowEqual( pFeaturedGamemodeDef, gFeaturedGamemodeDef ) )
    {
        InitUnrankedGameModes();
    }
    else
    {
        UpdateUnrankedValues();
    }
}

function UpdateUnrankedValues()
{
    const pContext = GetPlayPanel();
    pContext.SetDialogVariableInt( "fgm_shards_earned", pContext.GetFeaturedGamemodeProgress() );
    pContext.SetDialogVariableInt( "fgm_shards_max", pContext.GetFeaturedGamemodeMax() );
    
        const pSection = $( "#GameModeSection" );
        const pModesPanel = $( "#UnrankedGameModes" );
        const pModesOtherPanel = $( "#UnrankedGameModesOther" );
        if ( pSection && pModesPanel && pModesOtherPanel )
        {
            if ( pContext.BHasClass( "SectionVisible_Normal" ) )
            {
                const bShowAll = pSection.BHasClass( "ShowAll" );
                pSection.style.height = `${88 * pModesPanel.GetChildCount() + ( bShowAll ? 25 * pModesOtherPanel.GetChildCount() : 0 ) + 80}px`;
            }
            else
            {
                pSection.style.height = null;
            }
        }

    if ( gFeaturedGamemodeDef )
        pContext.SetDialogVariableTime( "ends_in_time", gFeaturedGamemodeDef.nEndTime -  Game.Time() );

    const pShowAllCount = pContext.FindChildInLayoutFile( "GameMode_ShowAll_Count" );
    if ( pShowAllCount )
    {
        const nSelectedGameModes = pContext.GetSelectedGameModes();
        let nSelectedOtherGameModeCount = 0;
        k_OtherModes.forEach( mode => 
        {
            const bSelected = ( 1 << mode ) & nSelectedGameModes;
            if ( bSelected && ( gFeaturedGamemodeDef == null || gFeaturedGamemodeDef.eGameMode != mode ) )
                nSelectedOtherGameModeCount++;
        } );
        pShowAllCount.SetDialogVariableInt( "unranked_other_selected_count", nSelectedOtherGameModeCount );
        pShowAllCount.SetHasClass( "NoneSelected", nSelectedOtherGameModeCount == 0 );
    }
}

/**
 * @param {any} pObj1 
 * @param {any} pObj2 
 * @returns {boolean}
 */
function BShallowEqual( pObj1, pObj2 )
{
    if ( pObj1 == null && pObj2 == null ) return true;
    if ( pObj1 == null || pObj2 == null ) return false;
    for ( const prop in pObj1 )
        if ( pObj1[prop] !== pObj2[prop] )
            return false;
    return true;
}

/**
 * @param {Panel} pParent
 * @param {string} sName
 * @param {DOTA_GameMode} nMode
 * @param {string?} [sLocText]
 * @param {string?} [sLocTooltip]
 * @returns {ToggleButton}
 */
function BuildGameModeToggle( pParent, sName, nMode, sLocText, sLocTooltip )
{
    if ( !sLocText )
        sLocText = `#game_mode_${nMode}`;
    if ( !sLocTooltip )
        sLocTooltip = `#game_mode_${nMode}_desc`;

    const pToggleButton = $.CreatePanelWithProperties( "ToggleButton", pParent, `GameMode_${sName}`, { class: "GameModeCheckBox", text: sLocText } );
    pToggleButton.SetPanelEvent( "onmouseover", () => $.DispatchEvent( "UIShowTextTooltipStyled", pToggleButton, sLocTooltip, "GameModeTooltip" ) );
    pToggleButton.SetPanelEvent( "onmouseout", () => $.DispatchEvent( "UIHideTextTooltip", pToggleButton ) );
    pToggleButton.SetPanelEvent( "onactivate", () => $.DispatchEvent( "DOTAGameModeToggled", pToggleButton, "false" ) );
    return pToggleButton;
}

/**
 * @param {Panel} pParent
 * @param {boolean} bFilled
 * @returns {Panel}
 */
function BuildFeaturedGameModeDot( pParent, bFilled )
{
    let className = "FeaturedGameModeDot";
    if ( bFilled )
        className += " Filled";
    return $.CreatePanelWithProperties( "Panel", pParent, undefined, { class: className } );
}

/**
 * @param {Panel} pParent
 * @param {DOTA_GameMode} nMode
 * @param {CDOTAFeaturedGamemodeDefinition?} [pFeaturedGamemodeDef]
 * @returns {Panel | null}
 */
function BuildUnrankedGameModePanel( pParent, nMode, pFeaturedGamemodeDef )
{
    const mode = k_GameModesMap[nMode];
    if ( !mode )
        return null;

    const pGameModeContainer = $.CreatePanel( "Panel", pParent, `GameModeContainer_${mode.sName}` );
    pGameModeContainer.BLoadLayoutSnippet( "UnrankedGameModeContainer" );
    if ( pFeaturedGamemodeDef )
    {
        pGameModeContainer.AddClass( "FeaturedGameMode" );
        if ( pFeaturedGamemodeDef.sCustomGame )
        {
            pGameModeContainer.AddClass( pFeaturedGamemodeDef.sCustomGame );
        }
    }

    const pFeaturedGameModeHeader = pGameModeContainer.FindChildInLayoutFile( "FeaturedGameModeHeader" );
    if ( pFeaturedGameModeHeader )
    {
        let pGameModeToggle;
        if ( pFeaturedGamemodeDef )
            pGameModeToggle = BuildGameModeToggle( pGameModeContainer, mode.sName, mode.nMode, pFeaturedGamemodeDef.sLocName, pFeaturedGamemodeDef.sLocDescription );
        else
            pGameModeToggle = BuildGameModeToggle( pGameModeContainer, mode.sName, mode.nMode );
        pGameModeContainer.MoveChildAfter( pGameModeToggle, pFeaturedGameModeHeader );
    }

    return pGameModeContainer;
}