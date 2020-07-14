modifier_bomb_squad_stasis_trap = class({})
--------------------------------------------------------------------------------
function modifier_bomb_squad_stasis_trap:IsHidden()
    return true
end
--------------------------------------------------------------------------------

function modifier_bomb_squad_stasis_trap:OnCreated()
  self.radius = self:GetAbility():GetSpecialValueFor( "detonate_radius" )
  self.activation_delay = self:GetAbility():GetSpecialValueFor( "activation_delay" )
  self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
  self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
  self.bActivated = false
  self.bTriggered = false
  self:StartIntervalThink( self.activation_delay )
end

--------------------------------------------------------------------------------

function modifier_bomb_squad_stasis_trap:OnIntervalThink()
  if IsServer() then
    if self.bActivated == false then
      self.bActivated = true

      EmitSoundOn("Hero_Techies.StasisTrap.Plant", self:GetParent())
      local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_stasis_trap_plant.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
      ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
      ParticleManager:SetParticleControl( nFXIndex, 1, self:GetParent():GetOrigin() )
      ParticleManager:SetParticleControlOrientation( nFXIndex, 1, self:GetParent():GetForwardVector(), self:GetParent():GetRightVector(), self:GetParent():GetUpVector() )
      ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
      ParticleManager:ReleaseParticleIndex( nFXIndex )

      self:StartIntervalThink( 0.1 )
    end

    local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, 0, false )
    if #enemies > 0 then 
      self:Detonate()
    end
  end
end

function modifier_bomb_squad_stasis_trap:Detonate()
  if IsServer() then
    local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_stasis_trap_explode.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
    ParticleManager:SetParticleControl(nFXIndex, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self.radius , 1, 1))
    ParticleManager:SetParticleControl(nFXIndex, 3, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(nFXIndex)

    local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, 0, false )
    if #enemies > 0 then 
      EmitSoundOn("Hero_Techies.StasisTrap.Stun", self:GetParent())
      for _,enemy in pairs(enemies) do
            --apply stun modifier
          if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
            local DamageInfo =
            {
              victim = enemy,
              attacker = self:GetParent(),
              ability = self:GetAbility(),
              damage = self.damage,
              damage_type = DAMAGE_TYPE_MAGICAL,
            }
            ApplyDamage( DamageInfo )
            enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_techies_stasis_trap_stunned", {duration = self.stun_duration})    
          end
        end
    end
    self:Destroy()
  end
end

function modifier_bomb_squad_stasis_trap:OnDeath( params )
  if IsServer() then
    if params.unit == self:GetParent() then
      params.unit:AddEffects( EF_NODRAW )
    end
  end
end

--------------------------------------------------------------------------------
function modifier_bomb_squad_stasis_trap:OnDestroy()
  if IsServer() then
    if self:GetParent() ~= nil and self:GetParent():IsAlive() then
      self:GetParent():ForceKill(false)
    end
  end
end


