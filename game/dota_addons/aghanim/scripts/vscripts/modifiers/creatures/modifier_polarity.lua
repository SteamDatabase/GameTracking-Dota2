
modifier_polarity = class({})

-----------------------------------------------------------------------------------------

function modifier_polarity:IsHidden()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_polarity:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_polarity:RemoveOnDeath()
	return false
end

-----------------------------------------------------------------------------------------

-- returns 1 or -1
function modifier_polarity:GetPolarity()
	return self.polarity
end

-----------------------------------------------------------------------------------------

function modifier_polarity:SwapPolarity()
	if self.nFXIndex then
		ParticleManager:DestroyParticle( self.nFXIndex, false )
		self.nFXIndex = nil
	end

	self.polarity = self.polarity * -1

	self:CreateFX()
	EmitSoundOn( "Polarity.Swap", self:GetParent() )
end

-----------------------------------------------------------------------------------------

function modifier_polarity:CreateFX()
	local fx_name = nil
	if self.polarity == 1 then
		-- create 1 polarity fx
		fx_name = "particles/polarity/polarity_positive_shield.vpcf"		
	elseif self.polarity == -1 then
		-- create -1 polarity fx
		fx_name = "particles/polarity/polarity_negative_shield.vpcf"
	else
		print( 'ERROR: modifier_polarity created without a 1 or -1 polarity!' )
	end

	if fx_name ~= nil then
		self.nFXIndex = ParticleManager:CreateParticle( fx_name, PATTACH_CUSTOMORIGIN, self:GetParent() ) 
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_ROOTBONE_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, Vector( 0.5, 0.5, 0.5 ) )
		self:AddParticle( self.nFXIndex, false, false, -1, false, true )
	end
end

-----------------------------------------------------------------------------------------

function modifier_polarity:OnCreated( kv )
	if IsServer() then
		self.polarity = kv.polarity
		print( '^^^modifier_polarity:OnCreated( kv ) on ' .. self:GetParent():GetUnitName() .. '. with polarity = ' .. self.polarity )

		self:CreateFX()
	end
end

-----------------------------------------------------------------------------------------

function modifier_polarity:OnDestroy()
	if IsServer() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle( self.nFXIndex, false )
		end
	end
end

-----------------------------------------------------------------------------------------

--[[
function modifier_polarity:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_AVOID_DAMAGE,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_polarity:GetModifierAvoidDamage( params )
	if IsServer() then
		if self:GetParent():IsControllableByAnyPlayer() == false then
			return 0 -- only players get to block damage
		end

		local hAttacker = params.attacker
		local hVictim = params.unit
		if hAttacker ~= nil and hVictim ~= nil and hVictim == self:GetParent() then
			local hAttackerPolarityBuff = hAttacker:FindModifierByName( 'modifier_polarity' )
			local hVictimPolarityBuff = hVictim:FindModifierByName( 'modifier_polarity' )

			if hAttackerPolarityBuff ~= nil and hVictimPolarityBuff ~= nil then
				if hAttackerPolarityBuff:GetPolarity() == hVictimPolarityBuff:GetPolarity() then
					print( '^^^modifier_polarity:GetModifierAvoidDamage( params ) - POLARITIES MATCH! Avoiding this damage!' )
					-- polarities match so we can avoid this damage
					return 1
				end
			end
		end
	end

	return 0
end
]]--
