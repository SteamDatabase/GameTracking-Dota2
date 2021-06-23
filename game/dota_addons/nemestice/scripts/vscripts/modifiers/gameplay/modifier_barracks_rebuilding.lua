
if modifier_barracks_rebuilding == nil then
	modifier_barracks_rebuilding = class( {} )
end

-----------------------------------------------------------------------------

function modifier_barracks_rebuilding:IsPurgable()
	return false
end

-----------------------------------------------------------------------------

function modifier_barracks_rebuilding:OnCreated( kv )
	if IsServer() then
		local hParent = self:GetParent()
		if hParent then 
	        local nFXIndex = ParticleManager:CreateParticle( "particles/items5_fx/repair_kit.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent );
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetOrigin(), true  )
			EmitSoundOn( "DOTA_Item.RepairKit.Target", hParent )
	        self:AddParticle( nFXIndex, false, false, -1, false, false )
			self.m_nFXIndex = nFXIndex
			hParent:SetHealth( 1 )
			self:StartIntervalThink( 0.1 )

			if kv.particlefx == 1 then
				local nFXGlyph = ParticleManager:CreateParticle( "particles/items_fx/glyph.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent )
				ParticleManager:SetParticleControl( nFXGlyph, 1, Vector( hParent:GetModelRadius(), 0, 0 ) )
				self:AddParticle( nFXGlyph, false, false, -1, false, false )
			end
		end
	end
end

-----------------------------------------------------------------------------

function modifier_barracks_rebuilding:CheckState()
	local state =
	{
		[ MODIFIER_STATE_INVULNERABLE ] = true,
		[ MODIFIER_STATE_DISARMED ] = true,
		--[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
		--[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true,
	}

	return state
end

function modifier_barracks_rebuilding:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle( self.m_nFXIndex, false )

		local hParent = self:GetParent()
		if hParent then 
			hParent:SetHealth( hParent:GetMaxHealth() )
		end

		if self.nFXTimer ~= nil then
			ParticleManager:DestroyParticle( self.nFXTimer, true )
		end
	end
end

		
-----------------------------------------------------------------------------

function modifier_barracks_rebuilding:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		if hParent then 
			local flHPFraction = self:GetElapsedTime() / self:GetDuration()
			hParent:SetHealth( flHPFraction * hParent:GetMaxHealth() )
		end
	end
end