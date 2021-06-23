
if modifier_ability_building == nil then
	modifier_ability_building = class( {} )
end

-----------------------------------------------------------------------------

function modifier_ability_building:IsPurgable()
	return false
end


-----------------------------------------------------------------------------

function modifier_ability_building:IsHidden()
    return true
end

--------------------------------------------------------------------------------

function modifier_ability_building:CheckState()
	local state = {}
	
	state[MODIFIER_STATE_NO_HEALTH_BAR] = true
	state[MODIFIER_STATE_BLIND] = true
	state[MODIFIER_STATE_SPECIALLY_DENIABLE] = true

    state[MODIFIER_STATE_INVULNERABLE] = ( self.bIsReady == false )
    state[MODIFIER_STATE_UNTARGETABLE] = ( self.bIsReady == false )

	return state
end

-----------------------------------------------------------------------------

function modifier_ability_building:OnCreated( kv )
    if IsServer() == false then
        return
    end

    self.hBuildingAbility = self:GetParent():FindAbilityByName( kv.ability_name )
    self.hBuildingAbility:StartCooldown( -1 )
    self.bIsReady = false

    self.szMaterialGroup = nil
    self.nReadyFX = nil
    self:StartIntervalThink( 0.2 )
end

-----------------------------------------------------------------------------

function modifier_ability_building:OnIntervalThink()
	if IsServer() == false or self.hBuildingAbility == nil then
        return
    end

    local szMaterialGroup = "0"
    local bReady = true
    if self.hBuildingAbility:IsFullyCastable() then
        self.bIsReady = true
        szMaterialGroup = self:GetParent():GetTeamNumber() == DOTA_TEAM_GOODGUYS and "1" or "2"
    else
        self.bIsReady = false
    end
    if szMaterialGroup ~= self.szMaterialGroup then
        self.szMaterialGroup = szMaterialGroup

        self:GetParent():SetMaterialGroup( szMaterialGroup )
        if szMaterialGroup ~= "0" then
            self:GetParent():StartGesture( ACT_DOTA_CHANNEL_ABILITY_1 )
            if self.nReadyFX == nil and self.hBuildingAbility.CreateAbilityReadyParticle then
                self.nReadyFX = self.hBuildingAbility:CreateAbilityReadyParticle( self:GetParent() )
            end
        else
            self:GetParent():RemoveGesture( ACT_DOTA_CHANNEL_ABILITY_1 )
            if self.nReadyFX ~= nil then
                ParticleManager:DestroyParticle( self.nReadyFX, false )
                self.nReadyFX = nil
            end
        end
    end
end
