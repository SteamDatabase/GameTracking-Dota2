modifier_wind = class({})

--------------------------------------------------------------------------------

function modifier_wind:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_wind:IsHidden()
	return false;
end

function modifier_wind:RemoveOnDeath()
	return false
end


--------------------------------------------------------------------------------
function modifier_wind:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_wind:OnCreated( kv )
	if IsServer() then
		printf("creating wind modifier on %s with caster %s", self:GetParent(), GLOBAL_WIND_THINKER )
		--local vx = self:GetAbility():GetSpecialValueFor( "vx" )
		--if vx == nil then
		--vx = kv["vx"]
		--end
		--local vz = self:GetAbility():GetSpecialValueFor( "vz" )
		--if vz == nil then
		--vz = kv["vz"]
		--end
		--self.vDirection = Vector(vx,0,vz):Normalized()
		--self.flSpeed = self:GetAbility():GetSpecialValueFor("speed")
		--if self.flSpeed == nil then
		--self.flSpeed = kv["speed"]
		--end
	end
end

--------------------------------------------------------------------------------

function modifier_wind:GetModifierMoveSpeedBonus_Constant( params )

	local vWindDirection = GLOBAL_WIND_THINKER.vWindDirection
	local flWindSpeed = GLOBAL_WIND_THINKER.flWindSpeed

	if self:GetParent() and self:GetParent().GetForwardVector then
		local vForward = self:GetParent():GetForwardVector()
		local flDot = vForward:Dot(vWindDirection)
		--printf("vforward %s, vDirection %s speedbonus %s", vForward, vWindDirection, flDot*flWindSpeed)
		return flDot * flWindSpeed
	end
	return 0
end
