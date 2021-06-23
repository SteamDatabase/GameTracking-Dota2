if item_meteor_shard == nil then
	item_meteor_shard = class({})
end

require( "nemestice_utility_functions" )
--------------------------------------------------------------------------------

function item_meteor_shard:Precache( context )
	--PrecacheResource( "particle", "particles/candy_score.vpcf", context )
end

--------------------------------------------------------------------------------

function item_meteor_shard:Spawn()
	self.flSpawnTime = GameRules:GetDOTATime( false, true )
end

--------------------------------------------------------------------------------

function item_meteor_shard:OnSpellStart()
	if IsServer() == false then
		return
	end

	if self:GetCurrentCharges() == 0 then
		return
	end

	local nAmount = self:GetCurrentCharges()
	EmitMoonjuiceLastHitFX( nAmount, self:GetCaster(), self:GetCaster() )	
	EmitSoundOn( "Item.PickUpGemShop", self:GetCaster() )
	local flDuration = self.flDieTime
	if flDuration ~= nil then
		flDuration = flDuration - GameRules:GetGameTime()
	end
	GameRules.Nemestice:ChangeMeteorEnergy( self:GetCaster():GetPlayerOwnerID(), nAmount, ( self.szReason or "shard" ), self:GetCaster(), flDuration, self.nTeamNumber )

	local nFXShard = ParticleManager:CreateParticle( "particles/gameplay/spring_meteor_shard_drop/meteor_shard_drop.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( nFXShard, 0, self:GetCaster():GetAbsOrigin())

	self:SetCurrentCharges( 1 )
	self:SpendCharge()
end

--------------------------------------------------------------------------------

function item_meteor_shard:CanUnitPickUp( hUnit )
	if hUnit ~= nil and hUnit:IsNull() == false and hUnit:IsAlive() and ( hUnit:IsRealHero() or ( hUnit:IsOwnedByAnyPlayer() and hUnit:IsCreepHero() ) ) then
		return true
	end

	return false
end

--------------------------------------------------------------------------------
