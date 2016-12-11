--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- Scripted animation sequences
--
--=============================================================================


-- @TODO: Automate this
AnimFramework:CreateCppClassProxy( "CVScriptSequence" )


-------------------------------------------------------------------------------
-- Scripted Sequence Base class, derive all scripted sequence classes from this
-------------------------------------------------------------------------------
SBaseSequence = class(
	{
		-- per-instance variables defined here
		m_hModel = nil;
	},
	{
		-- per-class (static) variables defined here
	},
		-- Optional base class, NOTE: To use with a C++ base class, call AnimFramework:CreateCppClassProxy as above
	AnimClasses.CVScriptSequence
)


-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function SBaseSequence:constructor( hModel, sSeqName )
    if not sSeqName then 
        Log_Error( "You need to give the sequence a name" )
		return
    end

	-- print( " * SBaseSequence:CTOR Seq \"" .. sSeqName .. "\"" )

	self.m_hModel = hModel
	if not self.m_hModel:AddSequence( self, getclass( self ), sSeqName ) then
        Log_Error( "AddSequence failed for sequence " .. sSeqName )
		return
	end

end


-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
function SBaseSequence:DoAnimation( animationBucket, flCycle, flWeight )
	flCycle = flCycle or 0
	flWeight = flWeight or 1
	-- print( "SBaseSequence:DoAnimation() Seq:" .. self:GetName() .. " " .. " Cycle:" .. flCycle .. " Weight:" .. flWeight  );
end


-------------------------------------------------------------------------------
-- A simple implementation of a 1:1 sequence playing a single animation
-------------------------------------------------------------------------------
SSingleAnimationSequence = class(
	{
		-- per-instance variables defined here
		m_nAnimation = -1
	},
	{
		-- per-class (static) variables defined here
	},
		-- Must derive from SBaseSequence or something derived from SBaseSequence
	SBaseSequence
)


-------------------------------------------------------------------------------
-- A constructor can take whatever args are necessary but the base class
-- constructor calls must be chained like they are here
-------------------------------------------------------------------------------
function SSingleAnimationSequence:constructor( hModel, sSeqName, sAnimName )
	-- Chain the call to the base class constructor, is sSeqName is not defined then an error was raised
	-- Cannot chain call using : syntax because self isn't the right variable
	getbase( self ).constructor( self, hModel, sSeqName )

	if not sAnimName then
        error( "!!!ERROR!!!: Animation name not specified" .. "\n" )
		return
	end

	local nAnimCheck = hModel:LookupAnimation( sAnimName )
	if nAnimCheck < 0 then 
		error( "!!!ERROR!!!: Cannot find animation named: " .. sAnimName .. " on model " .. hModel:GetModelName() .. "\n" )
		return
	end

	self.m_nAnimation = nAnimCheck
	
	self:RefAnimation( self.m_nAnimation )
end


-------------------------------------------------------------------------------
-- Override DoAnimation member function
-------------------------------------------------------------------------------
function SSingleAnimationSequence:DoAnimation( baseResult, flCycle, flWeight )
	flCycle = flCycle or 0
	flWeight = flWeight or 1

	-- print( "SSingleAnimationSequence:DoAnimation() Seq:" .. self:GetName() .. " " .. " Cycle:" .. flCycle .. " Weight:" .. flWeight  );

	if flWeight == 1.0 then
		baseResult:FetchCycle( self.m_nAnimation, flCycle )
	else
		local tmpResult = self:TempAnimationBucket( baseResult )
		tmpResult:FetchCycle( self.m_nAnimation, flCycle )
		baseResult:Slerp( tmpResult, 0, flWeight )
	end
end
