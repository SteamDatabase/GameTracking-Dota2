
if modifier_bucket_soldier_attack_fear == nil then
	modifier_bucket_soldier_attack_fear = class( {} ) 
end

----------------------------------------------------------------------------------------

function modifier_bucket_soldier_attack_fear:IsDebuff()
	return true
end

-----------------------------------------------------------------------------

function modifier_bucket_soldier_attack_fear:GetEffectName()
	return "particles/hw_fx/golem_terror_debuff.vpcf"
end

-----------------------------------------------------------------------------

function modifier_bucket_soldier_attack_fear:GetStatusEffectName()
	return "particles/hw_fx/golem_terror_status_effect.vpcf"
end

-----------------------------------------------------------------------------

function modifier_bucket_soldier_attack_fear:StatusEffectPriority()
	return 35
end

-----------------------------------------------------------------------------

function modifier_bucket_soldier_attack_fear:OnCreated( kv )
	if IsServer() then
		if kv.run_from_bucket == true then
			-- Issue command to travel towards home bucket
			self.vTargetDir = nil

			local hBuildings = FindUnitsInRadius( self:GetParent():GetTeamNumber(), Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
			for _, hBuilding in ipairs( hBuildings ) do
				if hBuilding:GetUnitName() == "candy_bucket" then
					self.vTargetDir = hBuilding:GetOrigin()
					--printf( "Found well at pos %f, %f, %f", self.vTargetDir.x, self.vTargetDir.y, self.vTargetDir.z )
					break
				end
			end

			if self.vTargetDir == nil then
				self.vTargetDir = Vector( 0, 0, 0 )
			else
				self.vTargetDir = self:GetParent():GetAbsOrigin() - self.vTargetDir
				self.vTargetDir.z = 0
			end

			local flDist = ( self:GetParent():GetAbsOrigin() - self.vTargetDir ):Length2D()
			self.vTargetDir = self.vTargetDir / flDist
		else
			-- use supplied run direction
			self.vTargetDir = Vector( kv.run_direction_x, kv.run_direction_y, kv.run_direction_z )
			--printf( "Fear Run direction = %f, %f, %f", self.vTargetDir.x, self.vTargetDir.y, self.vTargetDir.z )
		end

		self:StartIntervalThink( 0.1 )
		self:OnIntervalThink()

		EmitSoundOn( "BucketSoldier.Fear", self:GetParent() )
	end
end

-----------------------------------------------------------------------------
function modifier_bucket_soldier_attack_fear:OnIntervalThink()
	if IsServer() == false then
		return
	end

	local vDestination = self:GetParent():GetAbsOrigin() + self.vTargetDir * 400
	
	--printf( "Ordered to go to dir %f, %f, %f", vDestination.x, vDestination.y, vDestination.z )

	self:GetParent():OnCommandMoveToDirection( vDestination )
end

-----------------------------------------------------------------------------

function modifier_bucket_soldier_attack_fear:CheckState()
	local state =
	{
		[ MODIFIER_STATE_FEARED ] = true,
		[ MODIFIER_STATE_COMMAND_RESTRICTED ] = true,
		[ MODIFIER_STATE_DISARMED ] = true,
		[ MODIFIER_STATE_SILENCED ] = true,
		[ MODIFIER_STATE_MUTED ] = true,
		[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
	}

	return state
end

-----------------------------------------------------------------------------
