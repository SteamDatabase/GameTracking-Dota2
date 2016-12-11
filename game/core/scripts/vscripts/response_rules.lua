--
-- Response Rules 2
--


-- Criterion
--
-- A Criterion object is created from an array, valid syntax is:
--   criteria = [
--              [ "FactName == 1"   ],
--              [ "FactName != 1"   ],
--              [ "FactName <  1"   ],
--              [ "FactName <= 1"   ],
--              [ "FactName >  1"   ],
--              [ "FactName >= 1"   ],
--              [ "FactName == Bob" ],
--              [ "FactName != Rob" ],
--       ]
--
-- Functor criteria must always be functions taking (query) where 'query' is a table of facts,
--         and returning true (if the criterion passes) or false (if the criterion fails).
-- [NOTE: Squirrel functions incur a 3 microsecond overhead to call, in addition to the work the function itself does.
--        A rule must match all of its static criteria before the function criteria are even tested, so the more narrowly
--        constrained your rule, the less of an impact the functions will have on performance ]
--
-- Example syntax for using a named functor criterion:
--   function ExampleFunctorCriterion( query ) { return ( "foo" in query ) }
--   criteria = [ [ ExampleFunctorCriterion ] ]
--
-- Example syntax for using an anonymous inline functor criterion:
--   criteria = [ [ @(query) return ( "foo" in query ) ] ]
--
-- Criterion modifiers may be supplied via a table added to the end of the array (applies to all the above cases), for example:
--   criteria = [ [ "FactName < 10", { score = 2 } ] ]
-- Modifiers:
--  - score             = this value is added to the rule's score when this criterion passes (default: 1)
--  - optional  = this criterion needn't pass for the rule to pass (if it fails it will not increase the rule's score)
--  - context   = set to 'world' to derive this criterion from world context ("speaker" is the default)
--
-- RR1->RR2 PORTING NOTES:
--  - in RR1, all criteria were optional by default, with 'required' to override...
--    in RR2, all criteria are  required by default, with 'optional' to override!
--  - RR1 'weight' renamed to 'score' to avoid confusion with response weight (also more clearly aligns with rule matching score)
--  - in RR1, world context criteria had their name prefixed with 'world',
--    in RR2, you specify a modifier:  context = "world"

Criterion = class(
{
    -- properties
    key = nil,
    operation = nil,
    value = nil,
    func = nil,
    modifiers = nil
}, {}, nil)

function Criterion:constructor(criterion) 
    if type(criterion) ~= "table" then 
        error(("Invalid type for criterion: " .. type(criterion)))
    end
    
    -- Additional criterion modifiers may be added as a table at the end of the array
    self.modifiers = (type(criterion[#criterion]) == "table") and table.remove(criterion) or nil
    
    -- TODO: make Criterion & Context take tables as inputs, to match RuleParams and Response - this is more
    --       uniform/extensible, and will allow using a simple schema binding to transfer the data over to C++
    if #criterion ~= 1 then 
        error(("Invalid criterion: " .. DeepToString(criterion)))
    end
    
    if type(criterion[1]) == "string" then 
        -- See syntax examples above (the values of the 3 tokens will be error-checked in C++)
        local tokens = vlua.split(criterion[1], " ")
        if #tokens ~= 3 then 
            error(("Invalid criterion: " .. DeepToString(criterion)))
        end
        self.key = tokens[1]
        self.operation = tokens[2]
        self.value = tokens[3]

    elseif type(criterion[1]) == "function" then
        self.func = criterion[1]
    else 
        error(("Invalid criterion: " .. DeepToString(criterion)))
    end
end

function Criterion:Describe() 
    local description
    if self.func then 
        description = "Criterion functor " .. tostring(self.func)
    else 
        description = "Criterion " .. self.key .. " " .. self.operation .. " " .. self.value
    end

    if self.modifiers then 
        for k, v in pairs(self.modifiers) do
            description = description .. ", " .. k .. ":" .. v
        end
    end
    print(description)
end


-- Context
--
-- A Rule may contain one or more Context objects which, when the rule is triggered, will modify the 'context' of a
-- given entity by adding/changing a Fact, thus (via Criteria) affecting which Rules are triggered in the future.
-- These changes are typically temporary, and usually apply to either the 'speaker' entity (the entity who is
-- speaking a Response for the current Rule) or to the global world entity.
--
-- A Context object is constructed from an array, valid syntax is:
--      context_speaker = [
--        [ "SaidFriendlyFire = 1",     { duration = 2.5 } ], // Set SaidFriendlyFire to 1, persists for 2.5 seconds
--        [ "SaidFriendlyFire = 1"                         ], // Set SaidFriendlyFire to 1, persists indefinitely
--        [ "SaidFriendlyFire += 1"                        ], // Add 1 to SaidFriendlyFire (sets to +1 if not already present), persists indefinitely
--        [ "SaidFriendlyFire -= 2"                        ], // Subtract 2 from SaidFriendlyFire (sets to -2 if not already present), persists indefinitely
--        [ "SaidFriendlyFire = !SaidFriendlyFire"         ], // Negates SaidFriendlyFire (0->1, nonzero->0, sets to 1 if not already present), persists indefinitely
--        [ "SaidFriendlyFire = Ellis"                     ], // [TODO] Sets SaidFriendlyFire to the string "Ellis", persists indefinitely
--        [ "SaidFriendlyFire = null",                     ], // [TODO] Removes SaidFriendlyFire from the context immediately
--  ]
--
-- Context modifiers may be supplied via a table added to the end of the array (applies to all the above cases),
-- for example the 'duration' example above.
-- Modifiers:
--  - duration  = how many seconds the given Criterion should remain in the entity's context (default: indefinitely)
--
-- RR1->RR2 PORTING NOTES:
--  - to test a world context Criterion, instead of prefixing the Criterion name with 'world', you use a modifier like this:
--      [ "SaidFriendlyFire", "1", { context = "world" } ]
--    If omitted, the default context is "speaker". We may add other context sources in the future.
Context = class(
{
    -- properties
    key = nil,
    operation = nil,
    value = nil,
    modifiers = nil -- NOTE: squirrel quirk: if this were set to {} here all instances would share the same table!
}, {}, nil)

function Context:constructor(context) 
    if type(context) ~= "table" then 
        error(("Invalid type for Context: " .. type(context)))
    end
    
    -- Additional context modifiers may be added as a table at the end of the array
    self.modifiers = (type(context[#context]) == "table") and table.remove(context) or nil
    
    if (#context ~= 1) or (type(context[1]) ~= "string") then 
        error(("Invalid context: " .. DeepToString(context)))
    end

    -- See syntax examples above (the values of the 3 tokens will be error-checked in C++)
    local tokens = vlua.split(context[1], " ")
    if #tokens ~= 3 then 
        error(("Invalid context: " .. DeepToString(context)))
    end

    self.key = tokens[1]
    self.operation = tokens[2]
    self.value = tokens[3]
end

function Context:Describe() 
    local description = "Context " .. self.key .. " " .. self.operation .. " " .. self.value
    if self.modifiers then 
        for k, v in pairs(self.modifiers) do
            description = description .. ", " .. k .. ":" .. v
        end
    end
    print(description)
end


-- ResponseKind
--
-- The different kinds of available response
--
-- !!! THIS MUST EXACTLY MATCH ResponseType_t IN CODE !!!
-- TODO: automatically verify this on startup, or move the enum value determination into C++
ResponseKind = 
{
    none = 0, -- invalid type
    speak = 1, -- it's an entry in sounds.txt
    sentence = 2, -- it's a sentence name from sentences.txt
    scene = 3, -- it's a .vcd file
    response = 4, -- it's a reference to another response group by name
    print = 5, -- print the text in developer 2 (for placeholder responses)
    entityio = 6, -- poke an input on an entity
    script = 7 -- call a script function
}


-- Followup
--
-- A followup event like the old response 'then'. Describes a followup response to be triggered later.
--
-- Constructed from a sub-table of the Response table, valid syntax is:
--      responses = [
--              {       scenename = "scenes/Gambler/MoveOn01.vcd",
--                      followup = { target = "self", concept = "TestFollowup", delay = 1.23, context = [ "toggle = 1" ] } },
--      ]
--
-- Mandatory parameters:
--  - target      = The speaker(s) for whom to trigger the followup response query. Valid values:
--    'all'       :  all speakers within range may respond
--    'any'       :  one speaker within range may respond (the one with the 'best' matching response will be chosen)
--    'self'      :  the current speaker will respond to himself
--    <character> :  the specific named character (e.g "coach") will respond
--    'from'      :  [TODO] send the followup back to the speaker that this response came from (assumes that this response is itself a followup)
--    'subject'   :  [TODO] this is the character the current response is talking about (e.g the injured player we are healing)
--  - concept     = the response concept to trigger
--  - delay       = how long to wait before the followup response is triggered
--                  positive values start counting at the end of the current response
--                  negative values start counting immediately
--                  [TODO] fix the positive-value case (negative values were a workaround because the scene-length code wasn't working)
-- Optional parameters:
--  - context     = an array of additional context values to be attached to the followup query (each value is an array; see Context docs)
--
-- RR1->RR2 PORTING NOTES:
--  - new syntax aside, followups currently work the same as in RR1
Followup = class(
{
    -- properties
    target = nil,
    concept = nil,
    delay = nil,
    context = nil
}, {}, nil)

function Followup:constructor(followup) 
    if type(followup) ~= "table" then 
        error(("Invalid type for Followup: " .. type(followup)))
    end
    
    -- TODO: context entries here do not support modify operations, only assignment
    if vlua.contains(followup, "context") then 
        self.context = vlua.map(followup.context, (function (context) return Context(context) end))
    end
    
    self.target = followup.target
    self.concept = followup.concept
    self.delay = followup.delay
end


-- Response
--
-- Emulates a single Response object from RR1, which is eg an individual 'speak' or 'sentence' etc.
-- Parameters are extracted from an input table:
--  - kind              = the kind of response (see ResponseKind above)
--                Right now the decision of ResponseKind type is made by whether there is a func param or a scenename param.
--  - target    = a string like "foo.vcd", describes the response action to perform (specified in the rule syntax as: scenename = "blah.vcd")
--  - rule              = the containing RRule
--  - func              = an optional script function to call before performing 'target'. This function may be specified by name, or
--                as an anonymous inline @ function. When called, the function gets a bound environment so that every key in
--                                the response table gets seen as a local variable in the function. It is called with params (speaker,query):
--                                   speaker:  the 'speaker' param as an entity
--                                   query:    the entire fact array passed to the matching system
--  - followup  = an optional response followup, constructed from a sub-table (see Followup)
--  Optional parameters (which have reasonable defaults if omitted):
--  - delay    [lo,hi]  = an additional delay based on a random sample from the interval AFTER speaking
--  - predelay [lo,hi]  = an additional delay based on a random sample from the interval BEFORE speaking
--  - noscene                   = For an NPC, play the sound immediately using EmitSound, don't play it through the scene system. Good for playing sounds on dying or dead NPCs.
--  - chance                    = scales the chance that this response is selected from the rule's response list (default 100; equal chance for all responses)
--  - followup                  = a followup specifier (fires a followup concept+target w/ a delay, as in RR1), see Followup docs
--  - onfinish                  = [TODO] like 'func', but will be called when the response FINISHES instead of before it starts
--
-- Example syntax for using a named script function response:
--   function ExampleScriptFunctionResponse( speaker, query ) { speaker.SetContext( "1", 2, 3 ) }
--   responses = [ { func = ExampleScriptFunctionResponse } ]
--
-- Example syntax for using an anonymous inline script function response:
--   responses = [ { func = @(speaker,query) speaker.SetContext( "1", 2, 3 ) ]
--
-- RR1->RR2 PORTING NOTES:
--  - soundlevel, nodelay, defaultdelay, weapondelay, displayfirst, displaylast... were all removed (unused)
--  - odds was renamed to chance (old meaning was misdocumented in response_rules.txt)
--  - weight was removed in favour of chance (was odds)
--  - fire was removed in favour of func/onfinish
--  - speakonce was removed in favour of norepeat in group_params
--  - respeakdelay was moved to group_params, scoped per-rule instead of per-response
--    (old-style .txt response rules still use the old pattern, which as implemented in
--     CAI_Expresser::CanSpeakConcept is actually a per-character-per-concept timeout)
Response = class(
{
    -- properties
    kind = nil, -- one of the ResponseKind enumerations
    target = nil, -- will be a string or a function
    func = nil,
    params = nil, -- will be a table
    rule = nil, -- reference back to the rule to which I belong
    chance = nil,
    followup = nil,
    cpp_visitor = nil -- a field for the C++ code to store whatever opaque info it needs in this object.
}, {}, nil)

function Response:constructor(response) 
    if type(response) ~= "table" then 
        error(("Invalid type for Response: " .. type(response)))
    end
    
    -- TODO: support or remove the other ResponseKinds
    self.kind = ResponseKind.none
    if vlua.contains(response, "scenename") then 
        self.target = response.scenename
        self.kind = ResponseKind.scene

    elseif vlua.contains(response, "func") then
        self.func = response.func
        self.kind = ResponseKind.script

    else 
        print("Invalid response: ")
        response:Describe()
        error(("Invalid response" .. DeepToString(response)))
    end
    
    if vlua.contains(response, "followup") then 
        -- This response has a followup... marvellous.
        self.followup = Followup(response.followup)
    end
    
    -- chance defaults to 1.0 unless overridden:
    self.chance = vlua.contains(self.params, "chance") and (self.params["chance"] / 100.0) or 1.0
    
    -- TODO: target/func/chance/followup are redundantly present in the params table... possibly confusing? (certainly inefficient)
    self.params = response
end

function Response:Describe() 
    print("Response:")
    print("\tkind " .. self.kind)
    if self.target then
    	print("\ttarget " .. self.target)
    end
    for k, v in pairs(self.params) do
        print("\t" .. k .. ":")
	if type(v) == "table" then
		DeepPrintTable(v)
	else
		print(v)
	end
    end
end



-- RuleParams
--
-- Emulates a defined response group from RR1 (rule in RR2), which consists of several optional parameters
-- you pass in a table of configuration variables affecting how entries in the rule's responses array are selected:
--  - permitrepeats             = optional parameter, by default we visit all responses in group before repeating any
--  - sequential                = optional parameter, by default we randomly choose responses, but with this we walk through the list starting at the first and going to the last
--  - norepeat                  = Once we've run through each of the responses once, disable the response group
--                                                [TODO: not fully implemented; need to hook up Disable()]
--  - respeakdelay              = how long to wait before this RULE can trigger a response again
--                                                [TODO: not fully implemented; needs to become a criterion to avoid hiding OTHER rules]
--
-- RR1->RR2 PORTING NOTES:
--  - matchonce was removed (unused), basically redundant with norepeat
RuleParams = class(
{
    -- properties
    permitrepeats = false,
    sequential = false,
    norepeat = false,
    respeakdelay = 0
}, {}, nil)

function RuleParams:constructor(parms, rulename) 
    parms = parms or {}
    rulename = rulename or ""
    if vlua.contains(parms, "permitrepeats") then 
        self.permitrepeats = parms.permitrepeats
    end
    if vlua.contains(parms, "sequential") then 
        self.sequential = parms.sequential
    end
    if vlua.contains(parms, "norepeat") then 
        self.norepeat = parms.norepeat
    end
    if vlua.contains(parms, "respeakdelay") then 
        self.respeakdelay = parms.respeakdelay
    end
    if self.permitrepeats and self.norepeat then 
        print("WARNING: rule " .. rulename .. " has both permitrepeats and norepeat, which are mututally exclusive - ignoring norepeat")
        self.norepeat = false
    end
end

function RuleParams:Describe() 
    print("Group Params:")
    if self.permitrepeats then
    	print("\tpermitrepeats " .. tostring(self.permitrepeats))
    end
    if self.sequential then
    	print("\tsequential " .. tostring(self.sequential))
    end
    if self.norepeat then
    	print("\tnorepeat " .. tostring(self.norepeat))
    end
    if self.respeakdelay then
    	print("\trespeakdelay " .. self.respeakdelay)
    end
end


-- RRule
--
-- Represents an individual rule as sent from script to C++
-- See Criterion, Response, Context and RuleParams above for docs/examples
RRule = class(
{
    
    -- properties
    rulename = nil,
    criteria = {},
    responses = {},
    context_speaker = {},
    context_world = {},
    group_params = nil,
    
    -- handles the persistent 'response group' state which is
    -- used to pick the next response in sequence, etc
    selection_state = 
    {
        nextseq = 0, -- next response to play if 'sequential' is true
        unplayedresponses = nil, -- an array of unplayed responses, used to handle 'norepeats' (ignored if 'permitrepeats' or 'sequential' are set)
        lastresponsetime = 0 -- the last time a response was spoken for this rule
    }
}, {}, nil)

function RRule:constructor(name, crits, _responses, _context_speaker, _context_world, _group_params) 
    self.rulename = name
    self.criteria = crits
    self.responses = _responses
    self.context_speaker = _context_speaker
    self.context_world = _context_world
    self.group_params = _group_params
    
    -- sanity-check
    assert( next(self.criteria) ~= nil )
    assert( next(self.responses) ~= nil )
    
    -- make a shallow copy of selection_state to avoid overwriting shared state
    -- (otherwise changes made in one instance will affect all others)
    self.selection_state = vlua.clone(self.selection_state)
    
    -- make an array of as-yet-unplayed responses, if needed
    if not self.group_params.sequential and not self.group_params.permitrepeats then 
        self.selection_state.unplayedresponses = vlua.clone(self.responses)
    end
end


function RRule:Describe(verbose) 
    if verbose == nil then verbose = true end
    print(self.rulename .. "\n" .. #self.criteria .. " crits, " .. #self.responses .. " responses")
    if verbose then 
        for _, crit in ipairs(self.criteria) do
            crit:Describe()
        end
        for _, resp in ipairs(self.responses) do
            resp:Describe()
        end
        for _, ctxt in ipairs(self.context_speaker) do
            ctxt:Describe()
        end
        for _, ctxt in ipairs(self.context_world) do
            ctxt:Describe()
        end
        self.group_params:Describe()
        print("selection_state:")
        for k, v in pairs(self.selection_state) do
    		if type(v) == "table" then			
    			print("\t" .. k .. " : " )
    			for _, up in pairs( v ) do
    				print("\t\t" .. up.params.scenename )
    			end
    		else
    			print("\t" .. k .. " : " .. v)
    		end
        end
        print()
    end
end


function RRule:ChooseRandomFromWeightedArray(arr) 
    local totalweight = 0.0
    for _, response in ipairs(arr) do
        totalweight = totalweight + response.chance
    end
    local rand = RandomFloat(0, totalweight)
    local result = 0 -- Failsafe (accounts for edge case due to float rounding errors)
    for i, response in ipairs(arr) do
        if rand <= response.chance then 
            result = i
            break
        end
        rand = rand - response.chance
    end
    return result
end


-- When a rule matches, call this to pick a response.
function RRule:SelectResponse() 
    if Convars:GetFloat("rr_debugresponses") > 0 then 
        print("Matched rule: ")
		local verbose = ( Convars:GetFloat("rr_debugresponses") == 3 )
        self:Describe(verbose)
    end
    
    -- TODO: plumb disablement into the RR system so that this rule is no longer checked in FindBestMatch!
    if self.selection_state.nextseq == -1 then 
        print("FIXME: Response not picked because rule is already disabled!")
        return
    end
    -- TODO: respeakdelay should be implemented as a Criterion in FindBestMatch; currently this timeout hides all other matching rules!
    if (Time() - self.selection_state.lastresponsetime) < self.group_params.respeakdelay then 
        if Convars:GetFloat("rr_debugresponses") > 0 then 
            print("Response not picked because respeakdelay has not elapsed since last response.")
        end
        return
    end
    self.selection_state.lastresponsetime = Time()
    
    local R = nil
    if self.group_params.sequential then 
        -- Simply return the responses one after each other, in their given order
        R = self.responses[self.selection_state.nextseq + 1]
        self.selection_state.nextseq = (self.selection_state.nextseq + 1) % #self.responses -- advance sequential counter
        if (self.selection_state.nextseq == 0) and self.group_params.norepeat then 
            -- All responses have been spoken, turn this rule off
            self:Disable()
        end

    elseif self.group_params.permitrepeats then
        -- Randomly pick a response (repeats are ok)
        R = self.responses[self:ChooseRandomFromWeightedArray(self.responses)]

    else 
        -- Randomly take a response from the list of responses that haven't played yet
        local idx = self:ChooseRandomFromWeightedArray(self.selection_state.unplayedresponses)
        R = self.selection_state.unplayedresponses[idx]
        table.remove(self.selection_state.unplayedresponses, idx)
        if #self.selection_state.unplayedresponses == 0 then 
            if self.group_params.norepeat then 
                -- All responses have been spoken, turn this rule off
                self:Disable()
            else 
                -- Start over again
                self.selection_state.unplayedresponses = vlua.clone(self.responses)
            end
        end
    end
    
    if Convars:GetFloat("rr_debugresponses") > 0 then 
        print("Matched ")
        R:Describe()
    end
    return R
end


function RRule:Disable() 
    if Convars:GetFloat("rr_debugresponses") > 0 then 
        print("Rule " .. self.rulename .. " disabling itself.")
    end
    self.selection_state.nextseq = -1
end


-- rr_ProcessRules
--
-- Process an array of response rule descriptors, converting the raw squirrel data into RRule objects and adding them to the RR database.
function rr_ProcessRules(rulesarray) 
    local debug_rules_arr = {}
    for _, _rule in ipairs(rulesarray) do
        local context_speaker = vlua.contains(_rule, "context_speaker") and _rule.context_speaker or {}
        local context_world = vlua.contains(_rule, "context_world") and _rule.context_world or {}
        
        local rule = RRule(_rule.name, vlua.map(_rule.criteria, function (criterion) return Criterion(criterion) end), vlua.map(_rule.responses, function (response) return Response(response) end), vlua.map(context_speaker, function (context) return Context(context) end), vlua.map(context_world, function (context) return Context(context) end), RuleParams(_rule.group_params, _rule.name))
        -- Point each response back at the containing rule
        for _, r in ipairs(rule.responses) do
            r.rule = rule
        end
        
        if not rr_AddDecisionRule(rule) then 
            error("Failed to add rule to response rules database: " .. DeepToString(_rule))
        end
        if Convars:GetFloat("rr_debugresponses") >= 3 then 
            print("-- ADDED RULE--")
            rule:Describe()
        end
        table.insert(debug_rules_arr, rule)
    end
end



-- ------------------------------------------------------------------------------------------------
-- |              Here follow example rules, demonstrating syntax and functionality               |
-- ------------------------------------------------------------------------------------------------
--
-- Each individual rule descriptor has:
--  - name string
--  - criteria array                  (see Criterion above)
--  - response array                  (see Response above)
--  - optional speaker context array  (see Context above)
--  - optional world context array    (see Context above)
--  - group_params table              (see RuleParams above)

-- If you want to share a criterion between many rules, you can declare it as its own variable like this:
CriterionIsNotCoughing = {"Coughing != 1"}
CriterionIsc6m3_port = {"map == c6m3_port"} -- use for the moveon example below to scope the rule change
CriterionIsAwardProtector = {"awardname == Protector"}


-- FooCriterion is a criterion functor defined ahead of time and referenced by name
-- (as compared with the anonymous '@' functions defined inline in the rules below):
function CriterionFoo(self, query) 
    return query.GameTime > 10
end



-- DemoScriptFollowupFunction is an example of a 'script function' response,
-- with an example of how to pass-through a query to the speaker entity:
function ResponseDemoScriptFollowupFunction(self, speaker, query) 
    print("DemoScriptFollowupFunction called with speaker = " .. speaker .. " query = " .. query)
    -- Submit this query to the speaker, doing the usual response-lookup (NOTE: this is not a realistic example,
    -- it merely emulates what the builtin 'followup' mechanism does, *MUCH* more efficiently than this!)
    local response = {}
    if rr_QueryBestResponse(speaker, query, response) then  -- <- send a query to this entity and look for the best matching response.
        rr_CommitAIResponse(speaker, response) -- <- if a response was found, have this entity speak it.
    end
end


-- DemoWritingContextToCharacter is a script function response which reads a
-- value from the speaking character's context, modifies it and sets it again:
function ResponseDemoWritingContextToCharacter(self, speaker, query) 
    local value = vlua.contains(query, "bananas") and (query["bananas"] + 1) or 1
    DeepPrintTable(query)
    speaker:SetContext("bananas", tostring(value), 500)
end


-- ResponseSetAwardSpeech is a script function response which sets context on a player, and CriterionSubjectAward is a
-- functor criterion which checks it. This allows setting up a pair of rules that check to see if a player just received
-- an award protecting a player - if they did, don't have the protected player play any friendly fire lines.
function ResponseSetAwardSpeech(self, speaker, query) 
    -- [ELAN: Commented out to remove current odd case bug]
    local ProtectedDude = rr_GetResponseTargets()[query.subject]
    ProtectedDude:SetContext("AwardSpeech", query.who, 10)
end

function CriterionSubjectAward(self, query) 
    return (vlua.contains(query, "AwardSpeech")) and (query["AwardSpeech"] == query["subject"])
end


g_exampledecisionrules = 
{
    
    {
        -- This rule shows how a response can trigger a direct script function call and trigger an indirect 'followup' response
        name = "PlayerMoveOnGambler",
        criteria = 
        {
            {"concept == PlayerMoveOn"},
            {"Who == Gambler"},
            CriterionIsNotCoughing,
            CriterionIsc6m3_port
        },
        responses = 
        {
            -- This response dispatches a "DemonstrateScriptFollowup" followup concept back to self
            
            {
                scenename = "scenes/Gambler/MoveOn01.vcd",
                followup = 
                {
                    target = "self",
                    concept = "DemonstrateScriptFollowup",
                    delay = 1.23,
                    context = {{"followupcrit = 1"}}
                },
                func = ResponseDemoWritingContextToCharacter
            }
        },
        -- A second response (simple scene response)
        group_params = 
        {
            permitrepeats = true,
            sequential = false,
            norepeat = false
        }
    },
    
    {
        -- The followup rule for PlayerMoveOnGambler, this demonstrates how a followup can be an arbitrary script function
        name = "TestScriptFollowupGambler",
        criteria = 
        {
            {"concept == DemonstrateScriptFollowup"},
            {"Who == Gambler"},
            CriterionIsc6m3_port,
            {"followupcrit == 1"}
        },
        responses = 
        {
            {func = ResponseDemoScriptFollowupFunction} -- Script function response
        },
        group_params = 
        {
            permitrepeats = true,
            sequential = false,
            norepeat = false
        }
    },
    
    {
        -- This rule sets context on the speaker via a response function and the 'speaker_context' array...
        name = "PlayerAward",
        criteria = 
        {
            {"concept == Award"},
            CriterionIsAwardProtector
        },
        responses = 
        {
            {func = ResponseSetAwardSpeech}
        },
        context_speaker = {
        {
            "AllowProtectedFriendlyFire = 1",
            {duration = 2.5}
        }}, -- Set AllowProtectedFriendlyFire to 1, for 2.5 seconds
        group_params = 
        {
            permitrepeats = true,
            sequential = false,
            norepeat = false
        }
    },
    
    {
        -- ...and this rule has criteria which check for the contexts set on the speaker by PlayerAwardProtect.
        name = "ProtectedFriendlyFire",
        criteria = 
        {
            {"concept == PlayerFriendlyFire"},
            {"AllowProtectedFriendlyFire == 1"},
            {"PermaDisableFriendlyFire < 10"}, -- Disable this rule after it has fired 10 times
            {CriterionSubjectAward} -- Function criterion; CriterionSubjectAward is called each time this criterion is evaluated
        },
        responses = 
        {
            {func = ResponseDemoScriptFollowupFunction}
        },
        context_speaker = 
        {
            {"AllowProtectedFriendlyFire = 0"}, -- Clear AllowProtectedFriendlyFire to 0, indefinitely
            {"PermaDisableFriendlyFire += 1"} -- Increment PermaDisableFriendlyFire, permanently
        },
        group_params = 
        {
            permitrepeats = true,
            sequential = false,
            norepeat = false
        }
    }
}

-- TODO: this example is not actually valid code, move all its features into the above examples so it can be run
-- {
--      name = "CoachSeeSmoker",
--      criteria = [
--                                      [ CriterionFoo ],
--                                      [ @(query) (query.GameTime) < 30 ],     // inline anonymous functions are ok too
--                              ],
--      responses = [
--                                      {       scenename = "coach_see_smoker_1.vcd",                                           // if a 'scenename' key is present, this is expected to be a 'scene' response
--                                              onfinish = @(speaker,query) speaker.smokersSeen += 1 },         // expected to be a function, called when the scene finishes playing
--                                      {       func = ZombieFreakout },                                                                        // if a 'func' key is present, this is expected to be a 'call script function' response
--                                      {       func = @(speaker,query) speaker.PointAt( query.enemy ) },       // anonymous functions are ok too
--                                      {       scenename = "coach_see_smoker_2.vcd",
--                                              onfinish = @(speaker,query) speaker.smokersSeen += 1 },
--                              ],
--      group_params = { permitrepeats = false, sequential = true, norepeat = false },
-- },
rr_ProcessRules(g_exampledecisionrules)


DoIncludeScript("responserules/all_mod_responserules", getfenv(1))
