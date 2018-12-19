modifier_kotl_chakra_burn = class({})

function modifier_kotl_chakra_burn:OnCreated()
    if IsServer() then      
        self.hCaster = self:GetCaster()
        self.hAbility = self:GetAbility()
        self.hParent = self:GetParent()

    
        self.bonus_magic_damage = self.hAbility:GetSpecialValueFor("bonus_magic_damage")
        self.total_damage = self.hAbility:GetSpecialValueFor("total_damage")

        self.hSpecialBonus = self.hCaster:FindAbilityByName( "special_bonus_unique_keeper_of_the_light_2" )
        if self.hSpecialBonus and self.hSpecialBonus:GetLevel() > 0 then
               self.total_damage = self.total_damage + self.hSpecialBonus:GetLevelSpecialValueFor( "value", 1 )

        end



        self.debuff_duration = self.hAbility:GetSpecialValueFor("debuff_duration")
        
        self.interval_think = self.hAbility:GetSpecialValueFor("nuke_duration") / 5
        self:StartIntervalThink(self.interval_think)
    end
end

function modifier_kotl_chakra_burn:OnIntervalThink()
    if IsServer() then
        local flDamage = self.total_damage / 5
        local damage = {
            victim = self.hParent,
            attacker = self.hCaster,
            damage = flDamage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self.hAbility
        }
        ApplyDamage( damage )
        EmitSoundOn( "Hero_KeeperOfTheLight.ChakraBurn.Target", self.hParent )

            local kv = 
            {
                duration = self.debuff_duration,
                bonus_magic_damage = self.bonus_magic_damage,
            }
        self.hParent:AddNewModifier( self.hParent, self, "modifier_kotl_chakra_burn_debuff", kv )

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_burn.vpcf", PATTACH_CUSTOMORIGIN, self.hParent)
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self.hParent, PATTACH_ABSORIGIN_FOLLOW, nil, self.hParent:GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        


    end
end
