if roshan_go_to_sleep == nil then
	roshan_go_to_sleep = class({})
end

--------------------------------------------------------------------------------

function roshan_go_to_sleep:Precache( context )
	PrecacheResource( "particle", "particles/hw_fx/roshan_sleep_z.vpcf", context )
end

--------------------------------------------------------------------------------

function roshan_go_to_sleep:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function roshan_go_to_sleep:IsRefreshable()
	return false
end

--------------------------------------------------------------------------------

function roshan_go_to_sleep:IsStealable()
	return false
end

--------------------------------------------------------------------------------

function roshan_go_to_sleep:OnAbilityPhaseStart()
    if not IsServer() then return end

	if self:GetCaster() and GameRules.Winter2022.hRoshanPitCenter then
				
		--print( 'FACING TOWARDS PIT CENTER!' )
		--DebugDrawSphere( GameRules.Winter2022.hRoshanPitCenter:GetAbsOrigin(), Vector(255,0,0), 0.8, 150, false, 0.75 )
		self:GetCaster():FaceTowards( GameRules.Winter2022.hRoshanPitCenter:GetAbsOrigin() )
	end
end
--------------------------------------------------------------------------------
function roshan_go_to_sleep:OnChannelFinish()
    if not IsServer() then return end
		--print( 'STOP SLEEPING' )
    if self.nPreviewFX ~= nil then
        ParticleManager:DestroyParticle( self.nPreviewFX, false )
        self.nPreviewFX = nil
    end
end
--------------------------------------------------------------------------------

function roshan_go_to_sleep:OnSpellStart()
    if not IsServer() then return end
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/hw_fx/roshan_sleep_z.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 1, self:GetCaster(), PATTACH_OVERHEAD_FOLLOW, nil, self:GetCaster():GetOrigin(), true )

end