
ice_boss_trapping_shards = class({})

--------------------------------------------------------------------------------

function ice_boss_trapping_shards:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function ice_boss_trapping_shards:OnSpellStart()
	if IsServer() then
		self.duration_ticks = self:GetSpecialValueFor( "duration_ticks" )
		self.damage_per_second = self:GetSpecialValueFor( "damage_per_second" )


		if not self:GetCursorTarget() then
			print(" ice_boss_trapping_shards - error: there is no target, returning")
			return
		end

		self:GetCursorTarget():AddNewModifier( self:GetCaster(), self, "modifier_ice_boss_trapping_shards", { damage_per_second = self.damage_per_second, duration_ticks = self.duration_ticks, ice_health = self.ice_health } )
	end
end


