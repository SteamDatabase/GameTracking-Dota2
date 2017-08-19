
bear_cleave = class({})

--------------------------------------------------------------------------------

function bear_cleave:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function bear_cleave:OnSpellStart()
	if IsServer() then
		-- self.cleave_radius = self:GetSpecialValueFor( "cleave_radius" )
		self.base_damage = self:GetSpecialValueFor("base_damage")
		self.cleave_damage = self:GetSpecialValueFor("cleave_damage")
		self.starting_width = self:GetSpecialValueFor("starting_width")
		self.ending_width = self:GetSpecialValueFor("ending_width")
		self.distance = self:GetSpecialValueFor("distance")
		self.effect_name = "particles/units/heroes/hero_ursa/ursa_fury_swipes.vpcf"
 		-- float fDamage, float flStartingWidth, float flEndingWidth, float flDistance, const char *pszEffectName 

 		local aggroTarget = self:GetCursorTarget()
 		if aggroTarget == nil then
 			print("bear_cleave could not get aggro target, getting first available")
 			return
 		end

		local damageInfo = 
		{
			victim = aggroTarget,
			attacker = self:GetCaster(),
			damage = self.base_damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self,
		}

		print("bear_cleave target_damage: " .. self.base_damage .. " cleave_damage: " .. self.cleave_damage)
		ApplyDamage( damageInfo )

		DoCleaveAttack(self:GetCaster(), aggroTarget, self, self.cleave_damage, self.starting_width, self.ending_width, self.distance, self.effect_name)
	end
end
