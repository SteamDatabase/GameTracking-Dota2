
aghsfort_pugna_grandmaster_netherblast = class ({})
LinkLuaModifier( "modifier_aghsfort_pugna_grandmaster_netherblast_thinker", "modifiers/creatures/modifier_aghsfort_pugna_grandmaster_netherblast_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function aghsfort_pugna_grandmaster_netherblast:Precache( context )

	PrecacheResource( "particle", "particles/creatures/pugna_grandmaster/pugna_grandmaster_netherblast_preview.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/pugna_grandmaster/pugna_grandmaster_netherblast.vpcf", context )

end

----------------------------------------------------------------------------------------

function aghsfort_pugna_grandmaster_netherblast:OnSpellStart()
	if IsServer() then
		if self:GetCaster() ~= nil then
			self.vTargetLoc = self:GetCursorPosition()
			self.preview_duration = self:GetSpecialValueFor( "preview_duration" )
			self.max_rings = self:GetSpecialValueFor( "max_rings" )
			self.preview_duration = self:GetSpecialValueFor( "preview_duration" )
			self.ring_step = self:GetSpecialValueFor( "ring_step" )
			self.ring_width = self:GetSpecialValueFor( "ring_width" )
			self.damage = self:GetSpecialValueFor( "damage" )


			local kv = {}
			kv[ "duration" ] = self.preview_duration
			kv[ "ring_count" ] = 1
			kv[ "preview_duration" ] = self.preview_duration
			kv[ "max_rings" ] = self.max_rings
			kv[ "ring_step" ] = self.ring_step
			kv[ "ring_width" ] = self.ring_width
			kv[ "damage" ] = self.damage

			self.hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_aghsfort_pugna_grandmaster_netherblast_thinker", kv, self.vTargetLoc, self:GetCaster():GetTeamNumber(), false )
		end
	end
end
