
require( "utility_functions" )

modifier_penguin_sledding_round = class({})

--------------------------------------------------------------------------------

function modifier_penguin_sledding_round:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_penguin_sledding_round:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_penguin_sledding_round:OnCreated( kv )
	if IsServer() then
		self.fInitialIntervalThink = 0.1
		self.fLaterIntervalThink = 0.75
		self.fIntervalThink = self.fInitialIntervalThink

		self.initial_pinatas = self:GetAbility():GetSpecialValueFor( "initial_pinatas" )
		self.total_pinatas = self:GetAbility():GetSpecialValueFor( "total_pinatas" )

		local CoinSpawnEnts = Entities:FindAllByName( "round5_coin_spawn" )
		self.vCoinSpawnPositions = { }
		for index, hCoinSpawnEnt in pairs( CoinSpawnEnts ) do
			table.insert( self.vCoinSpawnPositions, hCoinSpawnEnt:GetOrigin() )
		end

		self.vCoinSpawnPositions = ShuffledList( self.vCoinSpawnPositions )

		self.nPinatasCreated = 0

		self:StartIntervalThink( self.fIntervalThink )
	end
end

--------------------------------------------------------------------------------

function modifier_penguin_sledding_round:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_penguin_sledding_round:OnIntervalThink()
	if IsServer() then
		-- Create a large pinata once every 10 spawns
		local nRemainder = math.fmod( self.nPinatasCreated, 10 )
		if nRemainder == 9 then
			self:CreateLargePinata( self.vCoinSpawnPositions[ #self.vCoinSpawnPositions ] )
		else
			self:CreatePinata( self.vCoinSpawnPositions[ #self.vCoinSpawnPositions ] )
		end

		if self.nPinatasCreated >= self.total_pinatas then
			print( string.format( "Placed enough pinatas (%d), destroy modifier_penguin_sledding_round modifier and remove its parent (a dummy)", self.nPinatasCreated ) )
			self:Destroy()
		end

		if self.fIntervalThink == self.fInitialIntervalThink and self.nPinatasCreated >= self.initial_pinatas then
			self.fIntervalThink = self.fLaterIntervalThink
			self:StartIntervalThink( self.fIntervalThink )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_penguin_sledding_round:CreatePinata( vStartPos )
	if IsServer() then
		--print( string.format( "CreatePinata; time is: %.2f", GameRules:GetGameTime() ) )
		local hPinata = CreateUnitByName( "npc_dota_coin_pinata", vStartPos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hPinata ~= nil then
			self.nPinatasCreated = self.nPinatasCreated + 1

			table.remove( self.vCoinSpawnPositions, #self.vCoinSpawnPositions )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_penguin_sledding_round:CreateLargePinata( vStartPos )
	if IsServer() then
		--print( string.format( "CreateLargePinata; time is: %.2f", GameRules:GetGameTime() ) )
		local hPinata = CreateUnitByName( "npc_dota_large_coin_pinata", vStartPos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hPinata ~= nil then
			self.nPinatasCreated = self.nPinatasCreated + 1

			table.remove( self.vCoinSpawnPositions, #self.vCoinSpawnPositions )
		end
	end
end

--------------------------------------------------------------------------------
