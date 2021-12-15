
tinker_turret_ground_blasts = class({})

LinkLuaModifier( "modifier_tinker_turret_ground_blast", "modifiers/creatures/modifier_tinker_turret_ground_blast", LUA_MODIFIER_MOTION_BOTH )

--------------------------------------------------------------------------------

function tinker_turret_ground_blasts:Precache( context )
	PrecacheResource( "particle", "particles/creatures/tinker_turret/tinker_turret_sun_strike.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", context )
end

--------------------------------------------------------------------------------

function tinker_turret_ground_blasts:OnSpellStart()
	if IsServer() then
		self.blast_count = self:GetSpecialValueFor( "blast_count" )
		self.delay = self:GetSpecialValueFor( "delay" )
		self.extra_delay_per_blast = self:GetSpecialValueFor( "extra_delay_per_blast" )
		self.min_random_offset = self:GetSpecialValueFor( "min_random_offset" )
		self.max_random_offset = self:GetSpecialValueFor( "max_random_offset" )

		local hTarget = self:GetCursorTarget()
		if hTarget == nil then
			return
		end

		for i = 1, self.blast_count do
			local vOffset = 0

			if i == 1 then
				-- leave vOffset unchanged
			elseif i == 2 then
				vOffset = hTarget:GetForwardVector() * 300
			else
				vOffset = RandomVector( RandomFloat( self.min_random_offset, self.max_random_offset ) )
			end

			local vPos = hTarget:GetOrigin() + vOffset

			local fStartDelay = self.extra_delay_per_blast * i
			local fDelay = self.delay + fStartDelay
			local kv = { duration = fDelay, start_delay = fStartDelay }
			CreateModifierThinker( self:GetCaster(), self, "modifier_tinker_turret_ground_blast", kv, vPos, self:GetCaster():GetTeamNumber(), false )
		end
	end
end

--------------------------------------------------------------------------------
