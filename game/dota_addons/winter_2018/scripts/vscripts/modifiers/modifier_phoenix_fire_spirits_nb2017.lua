modifier_phoenix_fire_spirits_nb2017 = class({})

--------------------------------------------------------------------------------

function modifier_phoenix_fire_spirits_nb2017:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_phoenix_fire_spirits_nb2017:OnCreated( kv )
	self.spirit_count = self:GetAbility():GetSpecialValueFor( "spirit_count" )
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_fire_spirits.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self.spirit_count, 0, 0 ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 9, Vector( 1, 0, 0 ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 10, Vector( 1, 0, 0 ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 11, Vector( 1, 0, 0 ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 12, Vector( 1, 0, 0 ) )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )

		self:SetStackCount( self.spirit_count )
	end
end

--------------------------------------------------------------------------------

function modifier_phoenix_fire_spirits_nb2017:OnRefresh( kv )
	self:OnCreated( kv )
end

--------------------------------------------------------------------------------

function modifier_phoenix_fire_spirits_nb2017:OnDestroy()
	if IsServer() then
		self:GetCaster():SwapAbilities( "phoenix_fire_spirits_nb2017", "phoenix_launch_fire_spirit_nb2017", true, false )
		StopSoundOn( "Hero_Phoenix.FireSpirits.Loop", self:GetCaster() )
		ParticleManager:DestroyParticle( self.nFXIndex, true )
	end
end

--------------------------------------------------------------------------------

function modifier_phoenix_fire_spirits_nb2017:OnStackCountChanged( nOldCount )
	if IsServer() then
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) )
		for i = 0,self.spirit_count do
			local bEnabled = self:GetStackCount() > i
			if self.nFXIndex ~= nil then
				local x = 0
				if bEnabled == true then
					x = 1
				end
				ParticleManager:SetParticleControl( self.nFXIndex, i + 9, Vector( x, 0, 0 ) )
			end
		end
	end
end

