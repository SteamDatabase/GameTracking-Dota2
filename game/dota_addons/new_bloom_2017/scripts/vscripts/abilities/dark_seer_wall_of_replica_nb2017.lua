dark_seer_wall_of_replica_nb2017 = class({})
LinkLuaModifier( "modifier_dark_seer_wall_of_replica_nb2017", "modifiers/modifier_dark_seer_wall_of_replica_nb2017", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function dark_seer_wall_of_replica_nb2017:OnSpellStart()	
	local vWallDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
	vWallDirection = vWallDirection:Normalized();

	local kv =
	{
		duration = self:GetSpecialValueFor( "duration" ),
		dir_x = vWallDirection.x,
		dir_y = vWallDirection.y,
		dir_z = vWallDirection.z
	}

	CreateModifierThinker( self:GetCaster(), self, "modifier_dark_seer_wall_of_replica_nb2017", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end

--------------------------------------------------------------------------------
