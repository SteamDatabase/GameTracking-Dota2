boss_visage_grave_chill = class({})


----------------------------------------------------------------------------------------

function boss_visage_grave_chill:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_base_attack.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_visage.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_necrolyte/necrolyte_pulse_enemy.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf", context )
end

--------------------------------------------------------------------------------

function boss_visage_grave_chill:OnAbilityPhaseStart()
	if IsServer() then
		EmitSoundOn( "Hero_Visage.preAttack", self:GetCaster() )
	end
	return true
end

--------------------------------------------------------------------------------

function boss_visage_grave_chill:OnSpellStart()
	if IsServer() then
		self.chill_speed = self:GetSpecialValueFor( "chill_speed" )
		self.chill_radius = self:GetSpecialValueFor( "chill_radius" )
		self.chill_count = self:GetSpecialValueFor( "chill_count" )
		self.chill_damage = self:GetSpecialValueFor( "chill_damage" )

		if self:GetCaster():GetHealthPercent() < 50 then
			self.chill_speed = self.chill_speed * 2
			self.chill_count = self.chill_count + 2
		end

		if self.bStatuesInit == nil then
			--print( "setting statue pairs ")
			--print ( "Num east statues " .. #self:GetCaster().EastStatues )
			--print ( "Num west statues " .. #self:GetCaster().WestStatues )
			for k,v in pairs ( self:GetCaster().EastStatues ) do
				local flShortestDist = 9999999
				local nPairIndex = nil
				for i,j in pairs ( self:GetCaster().WestStatues ) do
					local flDist = ( v:GetAbsOrigin() - j:GetAbsOrigin() ):Length2D()
					if flDist < flShortestDist then
						flShortestDist = flDist
						nPairIndex = i
					end
				end
				--print( "East statue at key " .. k .. " has partner in west at key " .. nPairIndex ) 
				v.nTargetPairIndex = nPairIndex
				self:GetCaster().WestStatues[ nPairIndex ].nTargetPairIndex = k
			end
			self.bStatuesInit = true
		end

		local bEast = true
		local EastStatues = deepcopy( self:GetCaster().EastStatues )
		local WestStatues = deepcopy( self:GetCaster().WestStatues )
		for i=1,self.chill_count do
			local hSource = nil
			local hTarget = nil
			local k = nil
			if bEast then
				k = RandomInt( 1, #EastStatues )
				hSource = EastStatues[ k ]
				hTarget = WestStatues[ hSource.nTargetPairIndex ]
				table.remove( EastStatues, k )
				table.remove( WestStatues, hSource.nTargetPairIndex )
			else
				k = RandomInt( 1, #WestStatues )
				hSource = WestStatues[ k ]
				hTarget = EastStatues[ hSource.nTargetPairIndex ]
				table.remove( WestStatues, k )
				table.remove( EastStatues, hSource.nTargetPairIndex )
			end

			if hTarget ~= nil and hSource ~= nil then
				local vDirection = hTarget:GetAbsOrigin() - hSource:GetAbsOrigin()
				local flDist = vDirection:Length2D()
				vDirection.z = 0.0
				vDirection = vDirection:Normalized()

				local info = 
				{
					EffectName = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf",
					Ability = self,
					vSpawnOrigin = hSource:GetAbsOrigin(), 
					fStartRadius = self.chill_radius,
					fEndRadius = self.chill_radius,
					vVelocity = vDirection * self.chill_speed,
					fDistance = flDist,
					Source = self:GetCaster(),
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
				}

				ProjectileManager:CreateLinearProjectile( info )
				EmitSoundOn( "Hero_Visage.Attack", hSource )
			end
			
			bEast = not bEast
		end
	end
end

--------------------------------------------------------------------------------

function boss_visage_grave_chill:OnProjectileThinkHandle( nProjectileHandle )
	if IsServer() then
		local vLocation = ProjectileManager:GetTrackingProjectileLocation( nProjectileHandle )
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vLocation, nil, self.chill_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )
		if #enemies == 0 then
			return
		end

		
		ProjectileManager:DestroyTrackingProjectile( nProjectileHandle )
	end
end

----------------------------------------------------------------------------------------

function boss_visage_grave_chill:OnProjectileHitHandle( hTarget, vLocation, nProjectileHandle )
	if IsServer() then
		if hTarget and hTarget:IsMagicImmune() == false and hTarget:IsInvulnerable() == false then
			self.chill_duration = self:GetSpecialValueFor( "chill_duration" )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_visage_grave_chill_debuff", { duration = self.chill_duration } )
			EmitSoundOn( "Hero_Visage.GraveChill.Target", hTarget )

			local damage = 
			{
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.chill_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self,
			}

			ApplyDamage( damage )
		end
	end
	return true
end

