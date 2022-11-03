
if modifier_roshan_angry == nil then
	modifier_roshan_angry = class( {} ) 
end

----------------------------------------------------------------------------------------

function modifier_roshan_angry:IsHidden()
	return true
end

----------------------------------------------------------------------------------------

function modifier_roshan_angry:IsPurgable()
	return false
end

----------------------------------------------------------------------------------------

function modifier_roshan_angry:GetEffectName()
	return "particles/roshan/roshan_angry/roshan_angry_ambient.vpcf"
end

--------------------------------------------------------------------------------

function modifier_roshan_angry:OnCreated( kv )
	if IsClient() then
		local serverValues = CustomNetTables:GetTableValue( "globals", "values" );
		if serverValues ~= nil then
			local nTargetIndex = serverValues[ "TrickOrTreatTargetEntIndex" ]
			if nTargetIndex ~= nil then
				local hTarget = EntIndexToHScript( nTargetIndex )
				if hTarget ~= nil and hTarget:GetPlayerOwnerID() == GetLocalPlayerID() then
					self.nChaseParticleFX = ParticleManager:CreateParticle( "particles/roshan/roshan_curse/roshan_chase_screen.vpcf", PATTACH_CUSTOMORIGIN, nil )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_roshan_angry:OnDestroy()
	if IsClient() then
		if self.nChaseParticleFX ~= nil then
			ParticleManager:DestroyParticle( self.nChaseParticleFX, false )
			self.nChaseParticleFX = nil
		end
	end
end

--------------------------------------------------------------------------------
