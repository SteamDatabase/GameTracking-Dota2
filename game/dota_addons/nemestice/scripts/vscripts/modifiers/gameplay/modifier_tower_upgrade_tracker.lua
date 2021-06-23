
if modifier_tower_upgrade_tracker == nil then
	modifier_tower_upgrade_tracker = class({})
end

--------------------------------------------------------------------------------

function modifier_tower_upgrade_tracker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_tower_upgrade_tracker:IsPurgable()
	return false
end


--------------------------------------------------------------------------------

function modifier_tower_upgrade_tracker:OnCreated( kv )
	if IsServer() == false then
		return
	end

	self.nPrevCount = 0
	self.nParticleFX = -1
	local fInterval = 0.5
	self:StartIntervalThink( fInterval )
end

--------------------------------------------------------------------------------

function modifier_tower_upgrade_tracker:OnIntervalThink()
	if IsServer() == false then
		return
	end
	
	local nUpgrades = self:GetParent().nNumUpgrades or 0
	if nUpgrades == 0 then
		if self.nParticleFX ~= -1 then
			ParticleManager:DestroyParticle( self.nParticleFX, true )
			self.nParticleFX = -1
		end
	else
		local nStack = math.mod( nUpgrades, 10 )
		local nTensStack = math.floor( nUpgrades / 10 ) 
		if self.nParticleFX == -1 then
			self.nParticleFX = ParticleManager:CreateParticle( "particles/gameplay/tower_upgrade_overhead/tower_upgrade_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleShouldCheckFoW( self.nParticleFX, false )
			--printf( "candy count: %d; created overhead particle", nUpgrades )
			--self:AddParticle( self.nParticleFX, false, false, 10, true, true )
		end
		ParticleManager:SetParticleControl( self.nParticleFX, 2, Vector( nTensStack, nStack, 0 ) )
		ParticleManager:SetParticleControl( self.nParticleFX, 3, Vector( NEMESTICE_EMBERCHARGE_COUNTER_TEXT_COLOR_R, NEMESTICE_EMBERCHARGE_COUNTER_TEXT_COLOR_G, NEMESTICE_EMBERCHARGE_COUNTER_TEXT_COLOR_B ) )
	end

	self.nPrevCount = nUpgrades

end

--------------------------------------------------------------------------------

function modifier_tower_upgrade_tracker:OnDestroy()
	if IsServer() == false then
		return
	end

	if self.nParticleFX ~= -1 then
		ParticleManager:DestroyParticle( self.nParticleFX, true )
		self.nParticleFX = -1
	end
end

--------------------------------------------------------------------------------
