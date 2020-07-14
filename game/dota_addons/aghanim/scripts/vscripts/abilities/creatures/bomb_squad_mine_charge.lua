
bomb_squad_mine_charge = class({})
LinkLuaModifier( "modifier_bomb_squad_mine_charge", "modifiers/creatures/modifier_bomb_squad_mine_charge", LUA_MODIFIER_MOTION_HORIZONTAL ) 

----------------------------------------------------------------------------------------

function bomb_squad_mine_charge:Precache( context )

end


--------------------------------------------------------------------------------

function bomb_squad_mine_charge:OnAbilityPhaseStart()
	if IsServer() then
		self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_2 )
	end

	return true
end

--------------------------------------------------------------------------------

function bomb_squad_mine_charge:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveGesture( ACT_DOTA_CAST_ABILITY_2 )
	end
end

--------------------------------------------------------------------------------

function bomb_squad_mine_charge:OnSpellStart()
	if IsServer() then
		local vTarget = self:GetCursorPosition()
		local flDist = (vTarget - self:GetCaster():GetOrigin()):Length2D()
		self.speed = self:GetSpecialValueFor( "speed" ) 
		local flDuration = flDist / self.speed

		local kv =
		{
			vLocX = vTarget.x,
			vLocY = vTarget.y,
			vLocZ = vTarget.z,
			duration = flDuration
		}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_bomb_squad_mine_charge", kv )
		EmitSoundOn( "OgreTank.Grunt", self:GetCaster() )
	end
end


