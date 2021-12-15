
item_purification_potion = class({})
LinkLuaModifier( "modifier_item_purification_potion", "modifiers/modifier_item_purification_potion", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_purification_potion:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf", context )
end

--------------------------------------------------------------------------------

function item_purification_potion:OnSpellStart()
	if IsServer() then
		local hTarget = self:GetCursorTarget() 
		if hTarget then
			self.heal = math.min(self:GetSpecialValueFor( "heal"), (hTarget:GetMaxHealth()  - hTarget:GetHealth()))
			self.radius = self:GetSpecialValueFor( "radius" )
			--print( 'item_purification_potion:OnSpellStart() - radius is ' .. self.radius )
			local kv =
			{
				duration = 0.1,
			}

			self:HealAlly( hTarget )

			self:SpendCharge()
		end
		
	end
end

--------------------------------------------------------------------------------

function item_purification_potion:HealAlly( hAlliedHero )
	if IsServer() then
		hAlliedHero:Heal( self.heal, self )

		SendOverheadEventMessage( self:GetCaster():GetPlayerOwner(), OVERHEAD_ALERT_HEAL, hAlliedHero, self.heal, nil )

		-- blessing adds a dispel on the target
		local hBuff = self:GetCaster():FindModifierByName( "modifier_blessing_potion_purification" )
		if hBuff ~= nil then
			--print( "item_purification_potion:HealAlly - purging the target because we've got modifier_blessing_potion_purification!" )
			--				   PositiveBuffs, NegativeBuffs, FrameOnly, RemoveStuns, RemoveExceptions
			hAlliedHero:Purge( false,		  true,			 false,		true,		 false )
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_CUSTOMORIGIN, hAlliedHero )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, hAlliedHero, PATTACH_ABSORIGIN_FOLLOW, nil, hAlliedHero:GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, self.radius, self.radius ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "PurificationPotion.Activate", hAlliedHero )

		local enemies = FindUnitsInRadius( hAlliedHero:GetTeamNumber(), hAlliedHero:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		for _, enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false and enemy:IsMagicImmune() == false then
				local damageInfo = 
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.heal,
					damage_type = self:GetAbilityDamageType(),
					ability = self,
				}
				ApplyDamage( damageInfo )

				local nFXIndex3 = ParticleManager:CreateParticle( "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy )
				ParticleManager:SetParticleControlEnt( nFXIndex3, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex3 )
			end
		end
	end
end

--------------------------------------------------------------------------------
