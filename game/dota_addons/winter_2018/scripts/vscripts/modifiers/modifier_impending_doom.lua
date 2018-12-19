modifier_impending_doom = class({})

--------------------------------------------------------------------------------

function modifier_impending_doom:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_impending_doom:IsHidden()
	return false;
end

--------------------------------------------------------------------------------
function modifier_impending_doom:DeclareFunctions()
	local funcs = {
	}
	return funcs
end

function modifier_impending_doom:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 0.5 )
	end
end


function modifier_impending_doom:GetTexture()
	return "forged_spirit_melting_strike"
end

--------------------------------------------------------------------------------

function modifier_impending_doom:OnStackCountChanged( nOldStackCount )
	if IsServer() then
		if not self.nFXStackIndex then
			self:CreateOverheadStackParticle()
		else
			self:UpdateOverheadStackParticle()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_impending_doom:CreateOverheadStackParticle()
	if IsServer() then
		local fStack = self:GetStackCount() / 10.0
		self.nFXIndex = ParticleManager:CreateParticle( "particles/status_fx/status_effect_stickynapalm.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( 1, fStack, -1 ) )
		self:AddParticle( self.nFXIndex, false, true, 13, false, false )

		self.nFXStackIndex = ParticleManager:CreateParticle( "particles/creatures/doomling/impending_doom_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		local fStackCount = math.fmod( self:GetStackCount(), 10.0 )
		local nTensDigit = math.floor( fStack )
		ParticleManager:SetParticleControl( self.nFXStackIndex, 1, Vector( nTensDigit, fStackCount, 0 ) )
		self:AddParticle( self.nFXStackIndex, false, false, -1, false, true )
	end
end

--------------------------------------------------------------------------------

function modifier_impending_doom:UpdateOverheadStackParticle()
	if IsServer() then
		local fStack = self:GetStackCount() / 10.0
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( 1, fStack, -1 ) )

		local fStackCount = math.fmod( self:GetStackCount(), 10.0 )
		local nTensDigit = math.floor( fStack )
		ParticleManager:SetParticleControl( self.nFXStackIndex, 1, Vector( nTensDigit, fStackCount, 0 ) )
	end
end


function modifier_impending_doom:OnIntervalThink()
	if IsServer() then
		hRealDoom = self:GetParent():FindModifierByName("modifier_doom_bringer_doom")
		if hRealDoom then 
			self:Destroy()
		end
	end
end


function modifier_impending_doom:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nFXStackIndex, false )
		ParticleManager:DestroyParticle( self.nFXIndex, false )
	end
end