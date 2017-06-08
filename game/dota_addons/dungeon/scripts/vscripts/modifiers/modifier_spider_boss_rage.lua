
modifier_spider_boss_rage = class({})

--------------------------------------------------------------------------------

function modifier_spider_boss_rage:OnCreated( kv )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.bonus_movespeed_pct = self:GetAbility():GetSpecialValueFor( "bonus_movespeed_pct" )
	self.lifesteal_pct = self:GetAbility():GetSpecialValueFor( "lifesteal_pct" )

	if IsServer() then
		self:GetParent().bIsEnraged = true

		self:GetParent():SetModelScale( self:GetParent().fOrigModelScale * 1.25 )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_broodmother/broodmother_hunger_buff.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_thorax", self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, false  )

		EmitSoundOn( "Dungeon.SpiderBoss.Rage", self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_spider_boss_rage:OnDestroy()
	StopSoundOn( "Dungeon.SpiderBoss.Rage", self:GetParent() )

	if IsServer() then
		self:GetParent():SetModelScale( self:GetParent().fOrigModelScale )
		self:GetParent().bIsEnraged = false
	end
end

--------------------------------------------------------------------------------

function modifier_spider_boss_rage:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_spider_boss_rage:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end

--------------------------------------------------------------------------------

function modifier_spider_boss_rage:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_movespeed_pct
end

--------------------------------------------------------------------------------

function modifier_spider_boss_rage:OnAttacked( params )
	if IsServer() then
		if params.attacker == self:GetParent() then
			local hTarget = params.target
			if hTarget and hTarget:IsIllusion() == false and hTarget:IsBuilding() == false then
				local fHealAmt = math.min( params.damage, hTarget:GetHealth() ) * self.lifesteal_pct / 100
				--print( "fHealAmt == " .. fHealAmt )
				self:GetCaster():Heal( fHealAmt, self:GetAbility() )
				ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() ) )
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_spider_boss_rage:Tooltip()
	return self.lifesteal_pct
end

--------------------------------------------------------------------------------

