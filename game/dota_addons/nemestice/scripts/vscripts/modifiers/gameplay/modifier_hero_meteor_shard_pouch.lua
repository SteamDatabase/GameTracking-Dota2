
if modifier_hero_meteor_shard_pouch == nil then
	modifier_hero_meteor_shard_pouch = class({})
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch:IsPurgable()
	return false
end


--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch:OnCreated( kv )
	if IsServer() == true then
		return
	end

	self.nPrevCount = 0
	self.nParticleFX = -1
	local fInterval = 0.01
	self:StartIntervalThink( fInterval )
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch:OnRefresh( kv )
	if IsServer() == true then
		return
	end

	if self.nParticleFX == nil then
		self.nParticleFX = -1
	end
	local fInterval = 0.01
	self:StartIntervalThink( fInterval )
end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch:OnIntervalThink()
	if IsServer() == true then
		return
	end
	
	if self:GetCaster():IsHero() == false and ( self:GetCaster():IsCreepHero() == false or self:GetCaster():IsOwnedByAnyPlayer() == false ) then
		return
	end

	local nCandy = self:GetStackCount()
	if nCandy == 0 then
		if self.nParticleFX ~= -1 then
			ParticleManager:DestroyParticle( self.nParticleFX, true )
			self.nParticleFX = -1
		end
	else
		local nStack = math.mod( nCandy, 10 )
		local nTensStack = math.floor( nCandy / 10 ) 
		if self.nParticleFX == -1 then
			self.nParticleFX = ParticleManager:CreateParticle( "particles/gameplay/moon_juice_overhead/moon_juice_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
			--printf( "candy count: %d; created overhead particle", nCandy )
			--self:AddParticle( self.nParticleFX, false, false, 10, true, true )
		end
		ParticleManager:SetParticleControl( self.nParticleFX, 2, Vector( nTensStack, nStack, 0 ) )
		ParticleManager:SetParticleControl( self.nParticleFX, 3, Vector( NEMESTICE_EMBERCHARGE_COUNTER_TEXT_COLOR_R, NEMESTICE_EMBERCHARGE_COUNTER_TEXT_COLOR_G, NEMESTICE_EMBERCHARGE_COUNTER_TEXT_COLOR_B ) )
	end

	self.nPrevCount = nCandy

end

--------------------------------------------------------------------------------

function modifier_hero_meteor_shard_pouch:OnDestroy()
	if IsServer() == true then
		return
	end

	if self.nParticleFX ~= -1 then
		ParticleManager:DestroyParticle( self.nParticleFX, true )
		self.nParticleFX = -1
	end
end

--------------------------------------------------------------------------------
