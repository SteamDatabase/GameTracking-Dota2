modifier_fireball_machine_gun_thinker = class({})
function modifier_fireball_machine_gun_thinker:OnCreated(kv)
	if IsServer() then
		self.attack_speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )
		self.attack_distance = self:GetAbility():GetSpecialValueFor( "projectile_distance" )
		self.interval = self:GetAbility():GetSpecialValueFor( "attack_interval" )
		self.vDirection = self:GetParent():GetForwardVector()
		self.counter = 0
		self.switch = 1
		self.vStartDirection = self:GetParent():GetForwardVector()
--		self.attack_damage = self:GetSpecialValueFor( "attack_damage" )
--		self.num_spawns = self:GetSpecialValueFor( "num_spawns" )
--		self.max_spawns = self:GetSpecialValueFor( "max_spawns" )
		self:OnIntervalThink()
		self:StartIntervalThink( self.interval )


	end
end



function modifier_fireball_machine_gun_thinker:OnIntervalThink()
	if IsServer() then
		if self:GetCaster():IsNull() then
			self:Destroy()
			return
		end
--		print ("counter = " , self.counter)
		self.counter = self.counter + 1
--		print ("Direction.y = ", self.vDirection.y)
--		print ("Direction.x = ", self.vDirection.x)

		local x = self.vDirection.x
		local y = self.vDirection.y
		local turn = math.rad(2.15)
--		//consider switching directions every 15 shots		
--		if self.counter >= 12 then
--			if self.counter >= 17 then
--				self.counter = 0
--			end
--			return self.interval
--		end

		local swoosh = math.abs(math.atan2(y,x) - math.atan2(self.vStartDirection.y,self.vStartDirection.x))
		if swoosh >= math.rad(50) then
				self.switch = self.switch * (-1)
--				print ("SWITCHING")
		end		
--		print ("swoosh = ", swoosh, "math.rad(50) = ", math.rad(50) )


		x = self.vDirection.x * math.cos(turn) - self.vDirection.y * math.sin(turn) * self.switch; 
		y = self.vDirection.y * math.cos(turn) + self.vDirection.x * math.sin(turn) * self.switch; 


		self.vDirection.x = x
		self.vDirection.y = y

		self.vDirection.z = 0.0
		self.vDirection = self.vDirection:Normalized()

		local angle = VectorToAngles(self.vDirection) 
		angle.y = angle.y + 100
		local nAttachmentID = self:GetCaster():ScriptLookupAttachment( "attach_attack2" )
		for i = 1, 5 do 
			local info = {
				EffectName = "particles/creatures/test/fireball_machine_gun.vpcf",
				Ability = self:GetAbility(),
				vSpawnOrigin = self:GetCaster():GetAttachmentOrigin( nAttachmentID ) + Vector(0, 0, -50), 
				fStartRadius = 50,
				fEndRadius = 50,
				vVelocity = self.vDirection * self.attack_speed,
				fDistance = self.attack_distance,
				Source = self:GetCaster(),
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
			}

			info.vVelocity = ( RotatePosition( Vector( 0, 0, 0 ), angle, Vector( 1, 0, 0 ) ) ) * self.attack_speed

			ProjectileManager:CreateLinearProjectile( info )
			self.last_y = angle.y
			angle.y = self.last_y - (150 / 3)

			EmitSoundOn( "Hero_Techies.Attack", self:GetParent() )
		end
	end
end


function modifier_fireball_machine_gun_thinker:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_ROOTED] = true
	end

	return state
end

function modifier_fireball_machine_gun_thinker:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,
--		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_fireball_machine_gun_thinker:GetOverrideAnimation( params )
	return ACT_DOTA_AW_MAGNETIC_FIELD
end


function modifier_fireball_machine_gun_thinker:GetModifierDisableTurning( params )
	return 1
end



