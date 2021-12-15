modifier_polarity_swap_projectile_thinker = class({})

--------------------------------------------------------------------------------

function modifier_polarity_swap_projectile_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_polarity_swap_projectile_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_polarity_swap_projectile_thinker:OnCreated( kv )
	if IsServer() then
		--print( 'Polarity swap projectile thinker created! searching for heroes...' )
		local hHeroes = GetVisibleEnemyHeroesInRange( self:GetParent(), 5000 )
		self.Projectiles = {}
		for _, v in pairs( hHeroes ) do
			--print( 'Found a hero! launching projectile at ' .. v:GetUnitName() )
			local vPos = self:GetParent():GetAbsOrigin()

			local projectile =
			{
				Target = v,
				Source = self:GetParent(),
				Ability = self:GetAbility(),
				EffectName = "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf",
				iMoveSpeed = 500,
				vSourceLoc = vPos,
				bDodgeable = false,
				bProvidesVision = false,
			}

			local hProjectile = ProjectileManager:CreateTrackingProjectile( projectile )
			table.insert( self.Projectiles, hProjectile )
		end

		self:StartIntervalThink( 0.5 )
	end
end

--------------------------------------------------------------------------------

function modifier_polarity_swap_projectile_thinker:OnIntervalThink()
	if IsServer() then
		local bRemainingProjectiles = false
		for _,proj in pairs( self.Projectiles ) do
			if ProjectileManager:IsValidProjectile( proj ) then
				--print( 'modifier_polarity_swap_projectile_thinker:OnIntervalThink() - found VALID projectile!' )
				bRemainingProjectiles = true
			end
		end

		if bRemainingProjectiles == false then
			--print( 'modifier_polarity_swap_projectile_thinker:OnIntervalThink() - no VALID projectiles! DESTROYING!' )
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_polarity_swap_projectile_thinker:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill( false )
		UTIL_Remove( self:GetParent() )
	end
end

