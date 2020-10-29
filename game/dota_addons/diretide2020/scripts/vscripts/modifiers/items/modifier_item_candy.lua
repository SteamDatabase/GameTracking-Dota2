if modifier_item_candy == nil then
modifier_item_candy = class({})
end

------------------------------------------------------------------------------

function modifier_item_candy:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_candy:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_candy:OnCreated( kv )
	self.fCandyScoreDistance = 600.0
	if IsServer() then
		self:StartIntervalThink( 0.5 )
	end
end

--------------------------------------------------------------------------------

function modifier_item_candy:OnIntervalThink()
	if IsServer() then
		self:CandyScoreCheck()
	end
end

--------------------------------------------------------------------------------

function modifier_item_candy:CandyScoreCheck()
	local hParent = self:GetParent()

	if hParent ~= nil and hParent:IsAlive() and hParent:IsNull() == false then
		local hCandyBuckets = GameRules.Diretide:GetCandyBuckets( hParent:GetTeamNumber() )
		for _, hCandyBucket in pairs ( hCandyBuckets ) do
			if hCandyBucket ~= nil and hCandyBucket:IsNull() == false and hCandyBucket:IsAlive() then
				if ( hParent:GetOrigin() - hCandyBucket:GetOrigin() ):Length2D() <= self.fCandyScoreDistance then
					self:ScoreCandy()
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_item_candy:CheckState()
	local state =
	{
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_item_candy:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_MODIFIER_ADDED,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_candy:OnModifierAdded( params )
	if IsServer() then
		local hParent = self:GetParent()
		if params.unit ~= hParent then
			return
		end
		self:CandyScoreCheck()
	end
	return
end

--------------------------------------------------------------------------------

function modifier_item_candy:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetCaster() then
			self:DropCandy()
		end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_item_candy:DropCandy()
	local hCandy = self:GetParent():FindItemInInventory( "item_candy" )
	if hCandy == nil then
		--print( 'ERROR: Trying to DROP candy from a hero while modifier_item_candy was on them but they have no candy!' )
		return
	end

	local nNumCandy = hCandy:GetCurrentCharges()
	local nNumBigBags = math.floor( nNumCandy / _G.DIRETIDE_CANDY_COUNT_IN_CANDY_BAG )
	if nNumBigBags > 0 then
		nNumCandy = nNumCandy - nNumBigBags * _G.DIRETIDE_CANDY_COUNT_IN_CANDY_BAG
		for i = 1, nNumBigBags do
			GameRules.Diretide:DropCandyAtPosition( self:GetParent():GetAbsOrigin(), self:GetParent(), nil, true, 1.0 )
		end
	end
	for i = 1, nNumCandy do
		GameRules.Diretide:DropCandyAtPosition( self:GetParent():GetAbsOrigin(), self:GetParent(), nil, false, 1.0 )
	end

	self:GetParent():RemoveItem( hCandy )
end

--------------------------------------------------------------------------------

function modifier_item_candy:ScoreCandy()
	local hCandy = self:GetParent():FindItemInInventory( "item_candy" )
	if hCandy == nil then
		--print( 'ERROR: Trying to SCORE candy from a hero while modifier_item_candy was on them but they have no candy!' )
		return
	end

	local nNumCandy = hCandy:GetCurrentCharges()
	GameRules.Diretide:ScoreCandy( self:GetParent():GetTeamNumber(), self:GetParent(), nNumCandy )
	self:GetParent():RemoveItem( hCandy )
end
