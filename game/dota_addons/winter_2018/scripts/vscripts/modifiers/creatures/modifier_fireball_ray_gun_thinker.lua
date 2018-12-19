modifier_fireball_ray_gun_thinker = class({})
function modifier_fireball_ray_gun_thinker:OnCreated(kv)
	if IsServer() then
		self.attack_speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )
		self.attack_distance = self:GetAbility():GetSpecialValueFor( "projectile_distance" )
		self.interval = self:GetAbility():GetSpecialValueFor( "attack_interval" )
		self.vDirection = self:GetParent():GetForwardVector()
		self.counter = 0
		self.switch = 1
--		self.attack_damage = self:GetSpecialValueFor( "attack_damage" )
--		self.num_spawns = self:GetSpecialValueFor( "num_spawns" )
--		self.max_spawns = self:GetSpecialValueFor( "max_spawns" )
		self:OnIntervalThink()
		self:StartIntervalThink( self.interval )


	end
end



function modifier_fireball_ray_gun_thinker:OnIntervalThink()
	if IsServer() then
		if self:GetCaster():IsNull() then
			self:Destroy()
			return
		end
--		print ("counter = " , self.counter)

			local info = {
				EffectName = "particles/econ/items/puck/puck_alliance_set/puck_illusory_orb_aproset.vpcf",

				Ability = self:GetAbility(),
				vSpawnOrigin = self:GetCaster():GetOrigin() + Vector(0, 0, 150), 
				fStartRadius = 100,
				fEndRadius = 100,
				vVelocity = self:GetCaster():GetForwardVector() * self.attack_speed,
				fDistance = self.attack_distance,
				Source = self:GetCaster(),
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
			}

			ProjectileManager:CreateLinearProjectile( info )


			EmitSoundOn( "Hero_ArcWarden.Flux.Target", self:GetParent() )

	end
end


function modifier_fireball_ray_gun_thinker:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_ROOTED] = true
		state[MODIFIER_STATE_FLYING] = true
		
	end

	return state
end

function modifier_fireball_ray_gun_thinker:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}

	return funcs
end


function modifier_fireball_ray_gun_thinker:GetModifierTurnRate_Percentage( params )
	return -50
end

function modifier_fireball_ray_gun_thinker:GetBonusVisionPercentage( params )
	return 5000
end

function modifier_fireball_ray_gun_thinker:GetVisualZDelta( params )
	return 0
end


