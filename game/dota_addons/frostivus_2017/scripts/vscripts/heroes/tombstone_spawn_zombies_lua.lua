tombstone_spawn_zombies_lua = class({})

function tombstone_spawn_zombies_lua:GetIntrinsicModifierName()
    return "modifier_spawn_zombies"
end

-------------------------------------------------------------------------
LinkLuaModifier("modifier_spawn_zombies", "heroes/tombstone_spawn_zombies_lua.lua", LUA_MODIFIER_MOTION_NONE)

modifier_spawn_zombies = modifier_spawn_zombies or class({})

function modifier_spawn_zombies:IsHidden()
    return true
end

function modifier_spawn_zombies:OnCreated()
    local ability = self:GetAbility()
    local caster = self:GetCaster()

    self.spawn_delay = self:GetAbility():GetSpecialValueFor("spawn_delay")
    self.max_spawned = self:GetAbility():GetSpecialValueFor("max_spawned")
    self.num_to_spawn = ability:GetSpecialValueFor("num_to_spawn")
    self.spawnLocation = caster:GetAbsOrigin()
    self.caster = self:GetCaster()

    self.caster.numSpawned = 0
    self.level = 0

    self:StartIntervalThink(self.spawn_delay)
end

function modifier_spawn_zombies:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local sound = "Hero_Undying.Tombstone"
        local center = caster:GetAbsOrigin()

        if not caster:IsAlive() then
            self:Destroy()
            return
        end

        EmitSoundOn(sound, caster)

        self.level = self.level + 1

        for i=1,self.num_to_spawn do
            self:AttemptToSpawnZombie()
        end
    end
end

function modifier_spawn_zombies:AttemptToSpawnZombie()
    self.caster.numSpawned = self.caster.numSpawned + 1

    if self.caster.numSpawned < self.max_spawned then
        local zombie = CreateUnitByName("custom_creature_zombie", self.spawnLocation, true, nil, nil, DOTA_TEAM_NEUTRALS)
        zombie.spawner = self.caster
        zombie:CreatureLevelUp(self.level)
    end
end